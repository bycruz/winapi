typedef void *HMODULE;
typedef const char *LPCSTR;
typedef unsigned long DWORD;
typedef int BOOL;
typedef unsigned int UINT;

HMODULE GetModuleHandleA(LPCSTR lpModuleName);

DWORD GetLastError(void);
DWORD FormatMessageA(DWORD dwFlags, const void *lpSource,
                     DWORD dwMessageId, DWORD dwLanguageId, 
                     char *lpBuffer, DWORD nSize, void *Arguments);

void Sleep(DWORD dwMilliseconds);

BOOL SetConsoleOutputCP(UINT wCodePageID);