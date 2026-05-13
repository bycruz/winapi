local ffi = require("ffi")

ffi.cdef([[#embed "wgl/ffi/ffidefs.h"]])

---@class winapi.wgl.Fns
---@field wglGetProcAddress fun(name: string): ffi.cdata*
---@field wglCreateContext fun(hdc: winapi.wgl.ffi.HDC): winapi.wgl.ffi.HGLRC?
---@field wglMakeCurrent fun(hdc: winapi.wgl.ffi.HDC, hglrc: winapi.wgl.ffi.HGLRC): number
---@field wglDeleteContext fun(hglrc: winapi.wgl.ffi.HGLRC): number
local C = ffi.load("opengl32")

---@class winapi.wgl: winapi.wgl.Enums
local wgl = {}

local enums = require("winapi.wgl.ffi.enums")(wgl)
for k, v in pairs(enums) do
	wgl[k] = v
end

wgl.getProcAddress = C.wglGetProcAddress
wgl.createContext = C.wglCreateContext

---@param hdc winapi.wgl.ffi.HDC
---@param hglrc winapi.wgl.ffi.HGLRC
---@return boolean
function wgl.makeCurrent(hdc, hglrc)
	return C.wglMakeCurrent(hdc, hglrc) ~= 0
end

---@param hglrc winapi.wgl.ffi.HGLRC
---@return boolean
function wgl.deleteContext(hglrc)
	return C.wglDeleteContext(hglrc) ~= 0
end

wgl.swapIntervalEXT = ffi.cast(
	"int(*)(int)",
	wgl.getProcAddress("wglSwapIntervalEXT")
)

return wgl
