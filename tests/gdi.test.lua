local test = require("lde-test")
local winapi = require("winapi")

test.it("should create initialized PFD", function()
	local pfd = winapi.gdi.NewPFD()
	test.equal(pfd.nVersion, 1)
	test.equal(pfd.cColorBits, 32)
	test.equal(pfd.cDepthBits, 24)
	test.equal(pfd.cStencilBits, 8)
end)

test.it("should set PFD fields", function()
	local pfd = winapi.gdi.PixelFormatDescriptor()
	pfd.nVersion = 1
	pfd.cColorBits = 24
	pfd.cDepthBits = 16

	test.equal(pfd.nVersion, 1)
	test.equal(pfd.cColorBits, 24)
	test.equal(pfd.cDepthBits, 16)
end)
