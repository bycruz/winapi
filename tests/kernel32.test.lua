local test = require("lde-test")
local ffi = require("ffi")
local winapi = require("winapi")

test.it("should get module handle", function()
	local handle = winapi.kernel32.getModuleHandle(nil)
	test.notEqual(handle, nil)
end)

test.it("should get last error message", function()
	local msg = winapi.kernel32.getLastErrorMessage()
	test.equal(type(msg), "string")
	test.notEqual(#msg, 0)
end)

--- The number of UTF-16 code units before the terminating NUL of a wide buffer.
---@param w winapi.kernel32.ffi.WCHAR
---@return number
local function wideLength(w)
	local units = 0
	while w[units] ~= 0 do
		units = units + 1
	end
	return units
end

test.it("should convert UTF-8 into a NUL-terminated wide buffer", function()
	local wide = winapi.kernel32.utf8ToWide("hello")
	test.notEqual(wide, nil)
	test.equal(wideLength(wide), 5)
	test.equal(wide[0], string.byte("h"))
	test.equal(wide[4], string.byte("o"))
end)

test.it("should convert the empty string into a lone terminator", function()
	local wide = winapi.kernel32.utf8ToWide("")
	test.notEqual(wide, nil)
	test.equal(wideLength(wide), 0)
end)

test.it("should count code units, not code points", function()
	-- 10 code points, 10 UTF-16 code units: "héllo — 世界".
	local wide = winapi.kernel32.utf8ToWide("héllo — 世界")
	test.equal(wideLength(wide), 10)

	-- A single code point outside the BMP takes two UTF-16 code units.
	local emoji = winapi.kernel32.utf8ToWide("🚀")
	test.equal(wideLength(emoji), 2)
end)

test.it("should round trip UTF-8 through UTF-16", function()
	local samples = {
		"hello",
		"héllo — 世界",
		"emoji 🚀 outside the BMP",
		"line\nbreak\ttab",
	}

	for _, sample in ipairs(samples) do
		test.equal(winapi.kernel32.wideToUtf8(winapi.kernel32.utf8ToWide(sample)), sample)
	end
end)

test.it("should round trip the empty string", function()
	test.equal(winapi.kernel32.wideToUtf8(winapi.kernel32.utf8ToWide("")), "")
end)

test.it("should honor an explicit code unit count", function()
	local wide = winapi.kernel32.utf8ToWide("abcdef")
	test.equal(winapi.kernel32.wideToUtf8(wide, 3), "abc")
	test.equal(winapi.kernel32.wideToUtf8(wide, 0), "")
end)

test.it("should return an empty string for a NULL buffer", function()
	test.equal(winapi.kernel32.wideToUtf8(nil), "")
end)

test.it("should allocate, lock and free moveable global memory", function()
	local hMem = winapi.kernel32.globalAlloc(winapi.kernel32.GMEM.MOVEABLE, 32)
	test.notEqual(hMem, nil)

	-- The block may be larger than the requested size.
	test.greaterEqual(tonumber(winapi.kernel32.globalSize(hMem)), 32)

	local ptr = winapi.kernel32.globalLock(hMem)
	test.notEqual(ptr, nil)
	ffi.cast("char*", ptr)[0] = 0x41
	test.equal(ffi.cast("char*", ptr)[0], 65)

	-- GlobalUnlock returns zero once the block is fully unlocked, which is the
	-- documented success case here, so its return value is not asserted.
	winapi.kernel32.globalUnlock(hMem)

	-- GlobalFree returns NULL on success.
	test.equal(winapi.kernel32.globalFree(hMem), nil)
end)
