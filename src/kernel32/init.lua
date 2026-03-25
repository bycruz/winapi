local ffi = require("ffi")

ffi.cdef([[#embed "kernel32/ffi/ffidefs.h"]])

---@class winapi.kernel32.Fns
---@field GetModuleHandleA fun(lpModuleName: string?): winapi.kernel32.ffi.HMODULE?
---@field GetLastError fun(): number
---@field FormatMessageA fun(dwFlags: number, lpSource: ffi.cdata*, dwMessageId: number, dwLanguageId: number, lpBuffer: ffi.cdata*, nSize: number, Arguments: ffi.cdata*): number
---@field Sleep fun(dwMilliseconds: number): nil
---@field SetConsoleOutputCP fun(wCodePageID: number): number
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

---@type fun(s: string?): winapi.kernel32.ffi.LPCSTR
kernel32.LPCSTR = ffi.typeof("LPCSTR") ---@diagnostic disable-line # ffi.typeof isn't typed properly

return kernel32
