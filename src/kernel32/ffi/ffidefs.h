typedef void *HMODULE;
typedef const char *LPCSTR;
typedef unsigned long DWORD;
typedef int BOOL;
typedef unsigned int UINT;

typedef void *HGLOBAL;
typedef unsigned short WCHAR;
typedef WCHAR *LPWSTR;
typedef const WCHAR *LPCWCH;

HMODULE GetModuleHandleA(LPCSTR lpModuleName);

DWORD GetLastError(void);
DWORD FormatMessageA(DWORD dwFlags, const void *lpSource,
                     DWORD dwMessageId, DWORD dwLanguageId, 
                     char *lpBuffer, DWORD nSize, void *Arguments);

void Sleep(DWORD dwMilliseconds);

BOOL SetConsoleOutputCP(UINT wCodePageID);

/* Global memory (winbase.h) */

HGLOBAL GlobalAlloc(UINT uFlags, size_t dwBytes);
HGLOBAL GlobalFree(HGLOBAL hMem);
void *GlobalLock(HGLOBAL hMem);
BOOL GlobalUnlock(HGLOBAL hMem);
size_t GlobalSize(HGLOBAL hMem);

/* String conversion (stringapiset.h) */

int MultiByteToWideChar(UINT CodePage, DWORD dwFlags, const char *lpMultiByteStr,
                        int cbMultiByte, WCHAR *lpWideCharStr, int cchWideChar);

int WideCharToMultiByte(UINT CodePage, DWORD dwFlags, const WCHAR *lpWideCharStr,
                        int cchWideChar, char *lpMultiByteStr, int cbMultiByte,
                        const char *lpDefaultChar, BOOL *lpUsedDefaultChar);
