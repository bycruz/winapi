local ffi = require("ffi")

ffi.cdef([[#embed "kernel32/ffi/ffidefs.h"]])

---@class winapi.kernel32.Fns
---@field GetModuleHandleA fun(lpModuleName: string?): winapi.kernel32.ffi.HMODULE?
---@field GetLastError fun(): number
---@field FormatMessageA fun(dwFlags: number, lpSource: ffi.cdata*, dwMessageId: number, dwLanguageId: number, lpBuffer: ffi.cdata*, nSize: number, Arguments: ffi.cdata*): number
---@field Sleep fun(dwMilliseconds: number): nil
---@field SetConsoleOutputCP fun(wCodePageID: number): number
---@field GlobalAlloc fun(uFlags: number, dwBytes: number): winapi.kernel32.ffi.HGLOBAL?
---@field GlobalFree fun(hMem: winapi.kernel32.ffi.HGLOBAL): winapi.kernel32.ffi.HGLOBAL?
---@field GlobalLock fun(hMem: winapi.kernel32.ffi.HGLOBAL): ffi.cdata*?
---@field GlobalUnlock fun(hMem: winapi.kernel32.ffi.HGLOBAL): number
---@field GlobalSize fun(hMem: winapi.kernel32.ffi.HGLOBAL): number
---@field MultiByteToWideChar fun(CodePage: number, dwFlags: number, lpMultiByteStr: string, cbMultiByte: number, lpWideCharStr: winapi.kernel32.ffi.LPWSTR?, cchWideChar: number): number
---@field WideCharToMultiByte fun(CodePage: number, dwFlags: number, lpWideCharStr: winapi.kernel32.ffi.LPCWCH, cchWideChar: number, lpMultiByteStr: string?, cbMultiByte: number, lpDefaultChar: string?, lpUsedDefaultChar: ffi.cdata*): number
local C = ffi.load("kernel32")

---@class winapi.kernel32: winapi.kernel32.Enums
local kernel32 = {}

local enums = require("winapi.kernel32.ffi.enums")
for k, v in pairs(enums) do
	kernel32[k] = v
end

kernel32.getModuleHandle = C.GetModuleHandleA
kernel32.getLastError = C.GetLastError
kernel32.sleep = C.Sleep
kernel32.setConsoleOutputCP = C.SetConsoleOutputCP

kernel32.globalAlloc = C.GlobalAlloc

--- GlobalLock returns the address of the block, or NULL when it fails.
---@type fun(hMem: winapi.kernel32.ffi.HGLOBAL): ffi.cdata*?
kernel32.globalLock = C.GlobalLock

--- GlobalUnlock returns zero both when the block became unlocked (the usual
--- success case, with GetLastError reporting NO_ERROR) and when it fails, so its
--- return value cannot be used as a plain success flag.
---@type fun(hMem: winapi.kernel32.ffi.HGLOBAL): number
kernel32.globalUnlock = C.GlobalUnlock

--- GlobalFree returns NULL on success and the (still valid) handle on failure.
---@type fun(hMem: winapi.kernel32.ffi.HGLOBAL): winapi.kernel32.ffi.HGLOBAL?
kernel32.globalFree = C.GlobalFree

--- GlobalSize returns a SIZE_T, which is a cdata on 64-bit targets: call
--- tonumber() on it to get a plain Lua number.
---@type fun(hMem: winapi.kernel32.ffi.HGLOBAL): number
kernel32.globalSize = C.GlobalSize

kernel32.multiByteToWideChar = C.MultiByteToWideChar
kernel32.wideCharToMultiByte = C.WideCharToMultiByte

---@return string
function kernel32.getLastErrorMessage()
	local buffer = ffi.new("char[256]")

	local msgLen = C.FormatMessageA(
		kernel32.FormatMessage.FROM_SYSTEM,
		nil,
		C.GetLastError(),
		0,
		buffer,
		ffi.sizeof(buffer),
		nil
	)

	if msgLen == 0 then
		return "Unknown error"
	end

	return ffi.string(buffer, msgLen)
end

--- Convert a UTF-8 Lua string into a NUL-terminated UTF-16 buffer owned by the
--- Lua GC (no matching free is needed). The returned buffer doubles as a
--- winapi.kernel32.ffi.LPWSTR.
---
--- Returns nil if the conversion fails.
---@param s string
---@return winapi.kernel32.ffi.LPWSTR?
function kernel32.utf8ToWide(s)
	-- MultiByteToWideChar fails when cbMultiByte is zero, so an empty string is
	-- a buffer holding just the terminator.
	if #s == 0 then
		return ffi.new("WCHAR[?]", 1) ---@diagnostic disable-line # ffi.new isn't typed properly
	end

	-- Size probe: with cchWideChar set to 0 the function returns the number of
	-- characters needed, and the lpWideCharStr buffer is not touched.
	local len = C.MultiByteToWideChar(kernel32.CP.UTF8, 0, s, #s, nil, 0)
	if len <= 0 then
		return nil
	end

	-- An explicit (non -1) byte count converts exactly #s bytes and writes no
	-- terminator, so one extra code unit is reserved and zeroed by hand below.
	local buffer = ffi.new("WCHAR[?]", len + 1) ---@diagnostic disable-line # ffi.new isn't typed properly

	local written = C.MultiByteToWideChar(kernel32.CP.UTF8, 0, s, #s, buffer, len)
	if written <= 0 then
		return nil
	end

	buffer[written] = 0

	return buffer
end

--- Convert a UTF-16 buffer into a UTF-8 Lua string.
---
--- `units` is a length in UTF-16 code units; when it is omitted the buffer must
--- be NUL-terminated. Returns an empty string for a NULL buffer, for no input
--- units and for an empty string.
---
--- The buffer is read as code units whatever it was declared as, because the one
--- a caller has is often the untyped pointer GlobalLock hands back rather than a
--- buffer of its own: a `void *` is a pointer to nothing in particular, and what
--- makes it one is the reader.
---@param w winapi.kernel32.ffi.LPCWCH
---@param units number?
---@return string
function kernel32.wideToUtf8(w, units)
	if w == nil then
		return ""
	end

	w = ffi.cast("const WCHAR *", w)

	if units == nil then
		-- The terminating NUL is located by hand rather than by passing -1,
		-- because with -1 the API also converts the NUL and counts it in its
		-- return value.
		units = 0
		while w[units] ~= 0 do
			units = units + 1
		end
	end

	if units <= 0 then
		return ""
	end

	-- Size probe: with cbMultiByte set to 0 the function returns the number of
	-- bytes needed. For CP_UTF8 both lpDefaultChar and lpUsedDefaultChar must be
	-- NULL, and dwFlags is left at 0 for the exactly-specified-length behaviour.
	local len = C.WideCharToMultiByte(kernel32.CP.UTF8, 0, w, units, nil, 0, nil, nil)
	if len <= 0 then
		return ""
	end

	local buffer = ffi.new("char[?]", len + 1)
	local written = C.WideCharToMultiByte(kernel32.CP.UTF8, 0, w, units, buffer, len + 1, nil, nil)
	if written <= 0 then
		return ""
	end

	-- The conversion above processes exactly `units` characters, so its return
	-- value is the byte count; clamped defensively to the probed length.
	if written > len then
		written = len
	end

	return ffi.string(buffer, written)
end

---@type fun(s: string?): winapi.kernel32.ffi.LPCSTR
kernel32.LPCSTR = ffi.typeof("LPCSTR") ---@diagnostic disable-line # ffi.typeof isn't typed properly

return kernel32
