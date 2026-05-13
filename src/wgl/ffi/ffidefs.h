typedef void *HDC;
typedef void *HGLRC;
typedef void *HWND;
typedef int BOOL;
typedef unsigned short WORD;
typedef unsigned long DWORD;
typedef unsigned char BYTE;

void *wglGetProcAddress(const char *name);

HGLRC wglCreateContext(HDC hdc);
BOOL wglMakeCurrent(HDC hdc, HGLRC hglrc);
BOOL wglDeleteContext(HGLRC hglrc);

BOOL wglSwapIntervalEXT(int interval);
