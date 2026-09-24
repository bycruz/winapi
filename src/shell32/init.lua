local ffi = require("ffi")
local kernel32 = require("winapi.kernel32")

ffi.cdef([[#embed "shell32/ffi/ffidefs.h"]])

---@class winapi.shell32.Fns
---@field DragAcceptFiles fun(hWnd: winapi.shell32.ffi.HWND, fAccept: number): nil
---@field DragQueryFileA fun(hDrop: winapi.shell32.ffi.HDROP, iFile: number, lpszFile: ffi.cdata*, cch: number): number
---@field DragQueryFileW fun(hDrop: winapi.shell32.ffi.HDROP, iFile: number, lpszFile: winapi.shell32.ffi.WCHAR?, cch: number): number
---@field DragQueryPoint fun(hDrop: winapi.shell32.ffi.HDROP, ppt: winapi.shell32.ffi.POINT): number
---@field DragFinish fun(hDrop: winapi.shell32.ffi.HDROP): nil
local C = ffi.load("shell32")

---@class winapi.shell32: winapi.shell32.Enums
local shell32 = {}

local enums = require("winapi.shell32.ffi.enums")
for k, v in pairs(enums) do
	shell32[k] = v
end

shell32.dragQueryFileA = C.DragQueryFileA
shell32.dragQueryFileW = C.DragQueryFileW

--- Register (or unregister) `hwnd` as a recipient of files dropped from Explorer:
--- this sets the WS_EX_ACCEPTFILES extended style on the window, which then
--- receives winapi.shell32.WM.DROPFILES with the HDROP in wParam.
---@param hwnd winapi.shell32.ffi.HWND
---@param accept boolean
function shell32.dragAcceptFiles(hwnd, accept)
	C.DragAcceptFiles(hwnd, accept and 1 or 0)
end

--- The number of files in the dropped file list (0 when the handle is invalid).
---@param hDrop winapi.shell32.ffi.HDROP
---@return number
function shell32.dragQueryFileCount(hDrop)
	return tonumber(C.DragQueryFileW(hDrop, 0xFFFFFFFF, nil, 0))
end

--- The full path, as a UTF-8 Lua string, of the dropped file at `index`
--- (zero-based). Returns an empty string for an out of range index.
---@param hDrop winapi.shell32.ffi.HDROP
---@param index number
---@return string
function shell32.dragQueryFile(hDrop, index)
	-- With a NULL buffer the function returns the required size, in characters,
	-- not including the terminating null character; 0 means "no such index".
	local len = C.DragQueryFileW(hDrop, index, nil, 0)
	if len == 0 then
		return ""
	end

	-- One extra code unit for the terminating NUL the function writes.
	local buffer = ffi.new("WCHAR[?]", len + 1) ---@diagnostic disable-line # ffi.new isn't typed properly

	-- When the name is copied the function returns its length in characters,
	-- excluding the terminating NUL, which is exactly what wideToUtf8 wants.
	local copied = C.DragQueryFileW(hDrop, index, buffer, len + 1)
	if copied == 0 then
		return ""
	end

	return kernel32.wideToUtf8(buffer, copied)
end

--- Read the point at which the files were dropped into `point`. Returns true
--- when the drop happened in the client area of the window.
---@param hDrop winapi.shell32.ffi.HDROP
---@param point winapi.shell32.ffi.POINT
---@return boolean
function shell32.dragQueryPoint(hDrop, point)
	return C.DragQueryPoint(hDrop, point) ~= 0
end

--- Free the dropped file list. The handle must not be used afterwards, and it
--- must not be freed again with kernel32.globalFree.
---@param hDrop winapi.shell32.ffi.HDROP
function shell32.dragFinish(hDrop)
	C.DragFinish(hDrop)
end

---@type fun(): winapi.shell32.ffi.POINT
shell32.Point = ffi.typeof("POINT") ---@diagnostic disable-line # ffi.typeof isn't typed properly

---@type fun(): winapi.shell32.ffi.DROPFILES
shell32.DropFiles = ffi.typeof("DROPFILES") ---@diagnostic disable-line # ffi.typeof isn't typed properly

return shell32
