local test = require("lde-test")
local ffi = require("ffi")
local winapi = require("winapi")

-- These tests take over the clipboard: they empty it and leave the CF_UNICODETEXT
-- sample that ran last on it.
local kernel32 = winapi.kernel32
local user32 = winapi.user32

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

--- Open the clipboard, retrying while another window holds it open. Returns
--- false when the clipboard stayed busy.
---@return boolean
local function openClipboard()
	for _ = 1, 20 do
		if user32.openClipboard(nil) then
			return true
		end
		kernel32.sleep(10)
	end
	return false
end

--- Run `fn` with the clipboard open and close it afterwards, whatever `fn`
--- does. Returns false when the clipboard could not be opened.
---@param fn fun()
---@return boolean
local function withClipboard(fn)
	if not openClipboard() then
		return false
	end

	local ok, err = pcall(fn)
	user32.closeClipboard()
	if not ok then
		error(err, 0)
	end

	return true
end

--- Place `text` on the clipboard as CF_UNICODETEXT.
---@param text string
---@return boolean
local function setClipboardText(text)
	local wide = kernel32.utf8ToWide(text)

	-- The clipboard requires moveable memory holding the terminating NUL too.
	local bytes = (wideLength(wide) + 1) * 2
	local hMem = kernel32.globalAlloc(kernel32.GMEM.MOVEABLE, bytes)
	if hMem == nil then
		return false
	end

	local ptr = kernel32.globalLock(hMem)
	if ptr == nil then
		kernel32.globalFree(hMem)
		return false
	end

	ffi.copy(ffi.cast("char*", ptr), wide, bytes)
	kernel32.globalUnlock(hMem)

	local set = false
	withClipboard(function()
		user32.emptyClipboard()
		set = user32.setClipboardData(user32.CF.UNICODETEXT, hMem)
	end)

	if not set then
		-- Only a successful call hands ownership over to the system.
		kernel32.globalFree(hMem)
	end

	return set
end

--- Read CF_UNICODETEXT back, or nil when the format is not on the clipboard.
---@return string?
local function getClipboardText()
	local text = nil

	withClipboard(function()
		if not user32.isClipboardFormatAvailable(user32.CF.UNICODETEXT) then
			return
		end

		local hMem = user32.getClipboardData(user32.CF.UNICODETEXT)
		if hMem == nil then
			return
		end

		local ptr = kernel32.globalLock(hMem)
		if ptr == nil then
			return
		end

		text = kernel32.wideToUtf8(ffi.cast("WCHAR*", ptr))
		kernel32.globalUnlock(hMem)
	end)

	return text
end

test.it("should round trip CF_UNICODETEXT through the clipboard", function()
	test.truthy(setClipboardText("hello, clipboard"), "could not place CF_UNICODETEXT on the clipboard")
	test.equal(getClipboardText(), "hello, clipboard")
end)

test.it("should round trip non-ASCII text", function()
	local text = "héllo — 世界"
	test.truthy(setClipboardText(text), "could not place CF_UNICODETEXT on the clipboard")
	test.equal(getClipboardText(), text)
end)

test.it("should round trip an empty string", function()
	test.truthy(setClipboardText(""), "could not place CF_UNICODETEXT on the clipboard")
	test.equal(getClipboardText(), "")
end)

test.it("should report CF_UNICODETEXT as available once it is set", function()
	test.truthy(setClipboardText("available"), "could not place CF_UNICODETEXT on the clipboard")

	local available = false
	test.truthy(withClipboard(function()
		available = user32.isClipboardFormatAvailable(user32.CF.UNICODETEXT)
	end), "clipboard is busy")

	test.equal(available, true)
end)

test.it("should reuse the identifier of an already registered format", function()
	local first = user32.registerClipboardFormat("winapi.test.clipboard")
	test.greater(first, 0)
	test.equal(user32.registerClipboardFormat("winapi.test.clipboard"), first)
end)
