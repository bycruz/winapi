typedef void *HWND;
typedef const char *LPCSTR;
typedef unsigned int UINT;
typedef int BOOL;
typedef unsigned short ATOM;
typedef uintptr_t WPARAM;
typedef intptr_t LPARAM;
typedef long LONG;
typedef unsigned long DWORD;
typedef struct {
  LONG x;
  LONG y;
} POINT;
typedef intptr_t LRESULT;
typedef void VOID;
typedef void *HCURSOR;
typedef void *HMODULE;
typedef void *HDC;
typedef void *HICON;
typedef void *HBRUSH;
typedef void *HINSTANCE;
typedef void *HMENU;

typedef struct {
  HWND hwnd;
  UINT message;
  WPARAM wParam;
  LPARAM lParam;
  DWORD time;
  POINT pt;
  DWORD lPrivate;
} MSG;
typedef MSG *LPMSG;

typedef LRESULT(__stdcall *WNDPROC)(HWND hwnd, UINT uMsg, WPARAM wParam,
                                    LPARAM lParam);

typedef struct {
  UINT cbSize;
  UINT style;
  WNDPROC lpfnWndProc;
  int cbClsExtra;
  int cbWndExtra;
  HINSTANCE hInstance;
  HICON hIcon;
  HCURSOR hCursor;
  HBRUSH hbrBackground;
  LPCSTR lpszMenuName;
  LPCSTR lpszClassName;
  HICON hIconSm;
} WNDCLASSEXA;

HWND CreateWindowExA(DWORD dwExStyle, LPCSTR lpClassName, LPCSTR lpWindowName,
                     UINT dwStyle, int X, int Y, int nWidth, int nHeight,
                     HWND hWndParent, HMENU hMenu, HINSTANCE hInstance,
                     void *lpParam);

typedef struct {
  LONG left;
  LONG top;
  LONG right;
  LONG bottom;
} RECT;

BOOL AdjustWindowRect(RECT *lpRect, DWORD dwStyle, BOOL bMenu);

// Window Creation
BOOL DestroyWindow(HWND hWnd);
BOOL ShowWindow(HWND hWnd, int nCmdShow);
BOOL UpdateWindow(HWND hWnd);
BOOL SetWindowTextA(HWND hWnd, LPCSTR lpString);
ATOM RegisterClassExA(const WNDCLASSEXA *lpWndClass);
BOOL UnregisterClassA(LPCSTR lpClassName, HINSTANCE hInstance);
BOOL IsWindow(HWND hWnd);
BOOL GetClientRect(HWND hWnd, RECT *lpRect);
BOOL ValidateRect(HWND hWnd, const RECT *lpRect);
int GetWindowTextA(HWND hWnd, char *lpString, int nMaxCount);
BOOL IsWindowVisible(HWND hWnd);

/* Cursor */
HCURSOR SetCursor(HCURSOR hCursor);
HCURSOR LoadCursorA(HMODULE hInstance, LPCSTR lpCursorName);

/* Event Loop */
BOOL PeekMessageA(MSG *lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax,
                  UINT wRemoveMsg);
BOOL GetMessageA(MSG *lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax);
BOOL TranslateMessage(const MSG *lpMsg);
LRESULT DispatchMessageA(const MSG *lpMsg);
VOID PostQuitMessage(int nExitCode);
LRESULT DefWindowProcA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);

/* Misc */
HDC GetDC(HWND hWnd);
HICON LoadIconA(HMODULE hInstance, LPCSTR lpIconName);
HBRUSH GetSysColorBrush(int nIndex);

/* Input */
short GetKeyState(int nVirtKey);
short GetAsyncKeyState(int vKey);
BOOL GetCursorPos(POINT *lpPoint);
BOOL SetCursorPos(int X, int Y);
int ShowCursor(BOOL bShow);
HWND SetCapture(HWND hWnd);
BOOL ReleaseCapture(void);

/* Window Long */
intptr_t SetWindowLongPtrA(HWND hWnd, int nIndex, intptr_t dwNewLong);
