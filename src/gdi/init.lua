local ffi = require("ffi")

ffi.cdef([[#embed "gdi/ffi/ffidefs.h"]])

---@class winapi.gdi.Fns
---@field ChoosePixelFormat fun(hdc: winapi.gdi.ffi.HDC, ppfd: winapi.gdi.ffi.PIXELFORMATDESCRIPTOR): number
---@field SetPixelFormat fun(hdc: winapi.gdi.ffi.HDC, iPixelFormat: number, ppfd: winapi.gdi.ffi.PIXELFORMATDESCRIPTOR): number
---@field SwapBuffers fun(hdc: winapi.gdi.ffi.HDC): nil
---@field BeginPaint fun(hWnd: ffi.cdata*, lpPaint: winapi.gdi.ffi.PAINTSTRUCT): winapi.gdi.ffi.HDC
---@field EndPaint fun(hWnd: ffi.cdata*, lpPaint: winapi.gdi.ffi.PAINTSTRUCT): number
---@field CreateSolidBrush fun(color: number): ffi.cdata*
---@field FillRect fun(hDC: winapi.gdi.ffi.HDC, lprc: winapi.gdi.ffi.RECT, hbr: ffi.cdata*): number
---@field DeleteObject fun(ho: ffi.cdata*): number
---@field SelectObject fun(hdc: winapi.gdi.ffi.HDC, h: ffi.cdata*): ffi.cdata*
---@field CreatePen fun(fnPenStyle: number, nWidth: number, color: number): ffi.cdata*
---@field GetStockObject fun(fnObject: number): ffi.cdata*
---@field Rectangle fun(hdc: winapi.gdi.ffi.HDC, left: number, top: number, right: number, bottom: number): number
---@field MoveToEx fun(hdc: winapi.gdi.ffi.HDC, x: number, y: number, lppt: winapi.gdi.ffi.POINT): number
---@field LineTo fun(hdc: winapi.gdi.ffi.HDC, x: number, y: number): number
---@field SetTextColor fun(hdc: winapi.gdi.ffi.HDC, color: number): number
---@field SetBkColor fun(hdc: winapi.gdi.ffi.HDC, color: number): number
---@field SetBkMode fun(hdc: winapi.gdi.ffi.HDC, mode: number): number
---@field TextOutA fun(hdc: winapi.gdi.ffi.HDC, x: number, y: number, lpString: string, cchString: number): number
local C = ffi.load("gdi32")

---@class winapi.gdi: winapi.gdi.Enums
local gdi = {}

local enums = require("winapi.gdi.ffi.enums")(gdi)
for k, v in pairs(enums) do
	gdi[k] = v
end

gdi.choosePixelFormat = C.ChoosePixelFormat
gdi.swapBuffers = C.SwapBuffers

---@param hdc winapi.gdi.ffi.HDC
---@param iPixelFormat number
---@param ppfd winapi.gdi.ffi.PIXELFORMATDESCRIPTOR
---@return boolean
function gdi.setPixelFormat(hdc, iPixelFormat, ppfd)
	return C.SetPixelFormat(hdc, iPixelFormat, ppfd) ~= 0
end

---@type fun(): winapi.gdi.ffi.PIXELFORMATDESCRIPTOR
gdi.PixelFormatDescriptor = ffi.typeof("PIXELFORMATDESCRIPTOR") ---@diagnostic disable-line # ffi.typeof isn't typed properly

---@param hWnd winapi.user32.ffi.HWND
---@param ps winapi.gdi.ffi.PAINTSTRUCT
---@return winapi.gdi.ffi.HDC
function gdi.beginPaint(hWnd, ps)
	return C.BeginPaint(hWnd, ps)
end

---@param hWnd winapi.user32.ffi.HWND
---@param ps winapi.gdi.ffi.PAINTSTRUCT
---@return boolean
function gdi.endPaint(hWnd, ps)
	return C.EndPaint(hWnd, ps) ~= 0
end

---@param color number
---@return ffi.cdata*
function gdi.createSolidBrush(color)
	return C.CreateSolidBrush(color)
end

---@param hdc winapi.gdi.ffi.HDC
---@param rect winapi.gdi.ffi.RECT
---@param brush ffi.cdata*
---@return boolean
function gdi.fillRect(hdc, rect, brush)
	return C.FillRect(hdc, rect, brush) ~= 0
end

---@param obj ffi.cdata*
---@return boolean
function gdi.deleteObject(obj)
	return C.DeleteObject(obj) ~= 0
end

---@type fun(): winapi.gdi.ffi.PAINTSTRUCT
gdi.PaintStruct = ffi.typeof("PAINTSTRUCT") ---@diagnostic disable-line # ffi.typeof isn't typed properly

---@type fun(): winapi.gdi.ffi.RECT
gdi.Rect = ffi.typeof("RECT") ---@diagnostic disable-line # ffi.typeof isn't typed properly

---@type fun(): winapi.gdi.ffi.POINT
gdi.Point = ffi.typeof("POINT") ---@diagnostic disable-line # ffi.typeof isn't typed properly

gdi.selectObject = C.SelectObject
gdi.createPen = C.CreatePen
gdi.getStockObject = C.GetStockObject
gdi.rectangle = C.Rectangle
gdi.setTextColor = C.SetTextColor
gdi.setBkColor = C.SetBkColor
gdi.setBkMode = C.SetBkMode
gdi.textOut = C.TextOutA

---@param hdc winapi.gdi.ffi.HDC
---@param x number
---@param y number
---@param lppt? winapi.gdi.ffi.POINT
---@return boolean, winapi.gdi.ffi.POINT?
function gdi.moveToEx(hdc, x, y, lppt)
	local pt = lppt or ffi.new("POINT") ---@diagnostic disable-line # ffi.new isn't typed properly
	local ok = C.MoveToEx(hdc, x, y, pt) ~= 0
	if lppt == nil then
		return ok, pt ---@diagnostic disable-line # return type mismatch
	end
	return ok
end

---@param hdc winapi.gdi.ffi.HDC
---@param x number
---@param y number
---@return boolean
function gdi.lineTo(hdc, x, y)
	return C.LineTo(hdc, x, y) ~= 0
end

---@return winapi.gdi.ffi.PIXELFORMATDESCRIPTOR
function gdi.PixelFormatDescriptor()
	return ffi.new("PIXELFORMATDESCRIPTOR", {
		nSize = ffi.sizeof("PIXELFORMATDESCRIPTOR"),
		nVersion = 1,
		dwFlags = gdi.PFD_DRAW_TO_WINDOW + gdi.PFD_SUPPORT_OPENGL,
		iPixelType = gdi.PFD_TYPE_RGBA,
		cColorBits = 32,
		cDepthBits = 24,
		cStencilBits = 8,
		iLayerType = gdi.PFD_MAIN_PLANE
	}) ---@diagnostic disable-line # ffi.new isn't typed properly
end ---@diagnostic disable-line # missing return value

---@deprecated use gdi.PixelFormatDescriptor instead
gdi.NewPFD = gdi.PixelFormatDescriptor

return gdi
