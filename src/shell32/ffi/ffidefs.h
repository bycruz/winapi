typedef void *HWND;
typedef int BOOL;
typedef unsigned int UINT;
typedef unsigned long DWORD;
typedef long LONG;
typedef unsigned short WCHAR;

typedef struct {
  LONG x;
  LONG y;
} POINT;

typedef void *HDROP;

/* Defines the CF_HDROP clipboard format: the data that follows this header is a
   double null-terminated list of file names. */
typedef struct {
  DWORD pFiles;
  POINT pt;
  BOOL fNC;
  BOOL fWide;
} DROPFILES;

/* Drag and drop (shellapi.h) */

void DragAcceptFiles(HWND hWnd, BOOL fAccept);
UINT DragQueryFileA(HDROP hDrop, UINT iFile, char *lpszFile, UINT cch);
UINT DragQueryFileW(HDROP hDrop, UINT iFile, WCHAR *lpszFile, UINT cch);
BOOL DragQueryPoint(HDROP hDrop, POINT *ppt);
void DragFinish(HDROP hDrop);
