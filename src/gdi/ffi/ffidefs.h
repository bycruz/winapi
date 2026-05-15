typedef unsigned short WORD;
typedef unsigned long DWORD;
typedef unsigned char BYTE;
typedef void *HDC;
typedef int BOOL;
typedef struct {
  WORD nSize;
  WORD nVersion;
  DWORD dwFlags;
  BYTE iPixelType;
  BYTE cColorBits;
  BYTE cRedBits;
  BYTE cRedShift;
  BYTE cGreenBits;
  BYTE cGreenShift;
  BYTE cBlueBits;
  BYTE cBlueShift;
  BYTE cAlphaBits;
  BYTE cAlphaShift;
  BYTE cAccumBits;
  BYTE cAccumRedBits;
  BYTE cAccumGreenBits;
  BYTE cAccumBlueBits;
  BYTE cAccumAlphaBits;
  BYTE cDepthBits;
  BYTE cStencilBits;
  BYTE cAuxBuffers;
  BYTE iLayerType;
  BYTE bReserved;
  DWORD dwLayerMask;
  DWORD dwVisibleMask;
  DWORD dwDamageMask;
} PIXELFORMATDESCRIPTOR;

int ChoosePixelFormat(HDC hdc, const PIXELFORMATDESCRIPTOR *ppfd);
BOOL SetPixelFormat(HDC hdc, int iPixelFormat,
                    const PIXELFORMATDESCRIPTOR *ppfd);
void SwapBuffers(HDC hdc);

typedef void *HWND;
typedef long LONG;
typedef void *HGDIOBJ;
typedef void *HBRUSH;
typedef unsigned long COLORREF;

typedef struct {
  LONG left;
  LONG top;
  LONG right;
  LONG bottom;
} RECT;

typedef struct {
  HDC  hdc;
  int  fErase;
  RECT rcPaint;
  int  fRestore;
  int  fIncUpdate;
  char reserved[32];
} PAINTSTRUCT;

HDC   BeginPaint(HWND hWnd, PAINTSTRUCT *lpPaint);
BOOL  EndPaint(HWND hWnd, const PAINTSTRUCT *lpPaint);
HBRUSH CreateSolidBrush(COLORREF color);
BOOL  FillRect(HDC hDC, const RECT *lprc, HBRUSH hbr);
BOOL  DeleteObject(HGDIOBJ ho);

typedef struct {
  LONG x;
  LONG y;
} POINT;

typedef void *HPEN;
typedef void *HFONT;
typedef void *HPALETTE;
typedef void *HRGN;
typedef void *HBITMAP;

HGDIOBJ SelectObject(HDC hdc, HGDIOBJ h);
HPEN   CreatePen(int fnPenStyle, int nWidth, COLORREF color);
HGDIOBJ GetStockObject(int fnObject);
BOOL   Rectangle(HDC hdc, int left, int top, int right, int bottom);
BOOL   MoveToEx(HDC hdc, int x, int y, POINT *lppt);
BOOL   LineTo(HDC hdc, int x, int y);
COLORREF SetTextColor(HDC hdc, COLORREF color);
COLORREF SetBkColor(HDC hdc, COLORREF color);
int    SetBkMode(HDC hdc, int mode);
BOOL   TextOutA(HDC hdc, int x, int y, const char *lpString, int cchString);
