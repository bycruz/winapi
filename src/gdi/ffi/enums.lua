local ffi = require("ffi")

---@param gdi winapi.gdi
return function(gdi)
	---@class winapi.gdi.Enums
	local enums = {}

	---@enum winapi.gdi.PEN_STYLE
	enums.PEN_STYLE = {
		SOLID = 0,
		DASH = 1,
		DOT = 2,
		DASHDOT = 3,
		DASHDOTDOT = 4,
		NULL = 5,
		INSIDEFRAME = 6,
		USERSTYLE = 7,
		ALTERNATE = 8
	}

	---@enum winapi.gdi.STOCK_OBJECT
	enums.STOCK_OBJECT = {
		WHITE_BRUSH = 0,
		LTGRAY_BRUSH = 1,
		GRAY_BRUSH = 2,
		DKGRAY_BRUSH = 3,
		BLACK_BRUSH = 4,
		NULL_BRUSH = 5,
		WHITE_PEN = 6,
		BLACK_PEN = 7,
		NULL_PEN = 8,
		OEM_FIXED_FONT = 10,
		ANSI_FIXED_FONT = 11,
		ANSI_VAR_FONT = 12,
		SYSTEM_FONT = 13,
		DEVICE_DEFAULT_FONT = 14,
		DEFAULT_PALETTE = 15,
		SYSTEM_FIXED_FONT = 16,
		DEFAULT_GUI_FONT = 17,
		DC_BRUSH = 18,
		DC_PEN = 19
	}

	---@enum winapi.gdi.BKG_MODE
	enums.BKG_MODE = {
		TRANSPARENT = 1,
		OPAQUE = 2
	}

	---@enum winapi.gdi.PFD_FLAGS
	enums.PFD_FLAGS = {
		DRAW_TO_WINDOW = 0x00000004,
		DRAW_TO_BITMAP = 0x00000008,
		SUPPORT_GDI = 0x00000010,
		SUPPORT_OPENGL = 0x00000020,
		GENERIC_ACCELERATED = 0x00001000,
		GENERIC_FORMAT = 0x00000040,
		NEED_PALETTE = 0x00000080,
		NEED_SYSTEM_PALETTE = 0x00000100,
		DOUBLEBUFFER = 0x00000001,
		STEREO = 0x00000002,
		SWAP_LAYER_BUFFERS = 0x00000800
	}

	---@enum winapi.gdi.PFD_PIXEL_TYPE
	enums.PFD_PIXEL_TYPE = {
		RGBA = 0,
		COLORINDEX = 1
	}

	---@enum winapi.gdi.PFD_LAYER_TYPE
	enums.PFD_LAYER_TYPE = {
		MAIN_PLANE = 0,
		OVERLAY_PLANE = 1,
		UNDERLAY_PLANE = -1
	}

	-- Convenient combined flags
	enums.PFD_DRAW_TO_WINDOW = 0x00000004
	enums.PFD_SUPPORT_OPENGL = 0x00000020
	enums.PFD_TYPE_RGBA = 0
	enums.PFD_MAIN_PLANE = 0

	return enums
end
