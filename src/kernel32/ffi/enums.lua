---@class winapi.kernel32.Enums
local enums = {}

---@enum winapi.kernel32.FormatMessage
enums.FormatMessage = {
	FROM_SYSTEM = 0x00001000,
	IGNORE_INSERTS = 0x00000200,
	FROM_HMODULE = 0x00000800,
	FROM_STRING = 0x00000400,
	ALLOCATE_BUFFER = 0x00000100,
	ARGUMENT_ARRAY = 0x00002000,
}

---@enum winapi.kernel32.ConsoleCP
enums.ConsoleCP = {
	US_ASCII = 20127,
	DOS_US = 437,
	DOS_MULTILINGUAL = 850,
	WINDOWS_WESTERN = 1252,
	UTF8 = 65001,
}

--- GlobalAlloc flags (winbase.h)
---@enum winapi.kernel32.GMEM
enums.GMEM = {
	FIXED = 0x0000,
	MOVEABLE = 0x0002,
	ZEROINIT = 0x0040,
}

--- Code page identifiers accepted by MultiByteToWideChar/WideCharToMultiByte (winnls.h)
---@enum winapi.kernel32.CP
enums.CP = {
	ACP = 0,
	OEMCP = 1,
	UTF7 = 65000,
	UTF8 = 65001,
	--- Code page identifier of UTF-16LE. It is documented as available only to
	--- managed applications, so MultiByteToWideChar/WideCharToMultiByte reject it
	--- with ERROR_INVALID_PARAMETER: UTF-16 buffers are used directly instead
	--- (see kernel32.utf8ToWide and kernel32.wideToUtf8).
	UTF16LE = 1200,
}

--- MultiByteToWideChar flags (winnls.h)
---@enum winapi.kernel32.MB
enums.MB = {
	PRECOMPOSED = 0x00000001,
	COMPOSITE = 0x00000002,
	USEGLYPHCHARS = 0x00000004,
	ERR_INVALID_CHARS = 0x00000008,
}

--- WideCharToMultiByte flags (winnls.h)
---@enum winapi.kernel32.WC
enums.WC = {
	DISCARDNS = 0x00000010,
	SEPCHARS = 0x00000020,
	DEFAULTCHAR = 0x00000040,
	ERR_INVALID_CHARS = 0x00000080,
	COMPOSITECHECK = 0x00000200,
	NO_BEST_FIT_CHARS = 0x00000400,
}

return enums
