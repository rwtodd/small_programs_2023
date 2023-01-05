// testGDI.cpp : Defines the entry point for the application.
//

#include "framework.h"
#include "testGDI.h"

#define MAX_LOADSTRING 100

// Global Variables:
HINSTANCE hInst;                                // current instance
WCHAR szTitle[MAX_LOADSTRING];                  // The title bar text
WCHAR szWindowClass[MAX_LOADSTRING];            // the main window class name

#define FPS 30    // frames per second for the timer

HBITMAP mainBitmap; // the bitmap we will be blitting, from CreateDIBSection
BYTE *bitmapBits; // the pixels of our DIBitmap.
constexpr BYTE palette[] = { 
    0x00,0x00,0x00,  0x00,0x00,0xaa,  0x00,0xaa,0x00,  0x00,0xaa,0xaa,
    0xaa,0x00,0x00,  0xaa,0x00,0xaa,  0xaa,0x55,0x00,  0xaa,0xaa,0xaa,
    0x55,0x55,0x55,  0x55,0x55,0xff,  0x55,0xff,0x55,  0x55,0xff,0xff,
    0xff,0x55,0x55,  0xff,0x55,0xff,  0xff,0xff,0x55,  0xff,0xff,0xff
}; // the EGA palette

UINT_PTR timer_ptr = 0;  // the timer we use to update our screen

// Forward declarations of functions included in this code module:
ATOM                MyRegisterClass(HINSTANCE hInstance);
HWND                InitInstance(HINSTANCE, int);
LRESULT CALLBACK    WndProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK    About(HWND, UINT, WPARAM, LPARAM);

int APIENTRY wWinMain(_In_ HINSTANCE hInstance,
                     _In_opt_ HINSTANCE hPrevInstance,
                     _In_ LPWSTR    lpCmdLine,
                     _In_ int       nCmdShow)
{
    UNREFERENCED_PARAMETER(hPrevInstance);
    UNREFERENCED_PARAMETER(lpCmdLine);

    // Initialize global strings
    LoadStringW(hInstance, IDS_APP_TITLE, szTitle, MAX_LOADSTRING);
    LoadStringW(hInstance, IDC_TESTGDI, szWindowClass, MAX_LOADSTRING);
    MyRegisterClass(hInstance);

    // Perform application initialization:
    HWND hwnd = InitInstance(hInstance, nCmdShow);
    if (!hwnd)
    {
        return FALSE;
    }

    HACCEL hAccelTable = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDC_TESTGDI));
    
    MSG msg;

    // Main message loop:
    while (GetMessage(&msg, nullptr, 0, 0))
    {
        if (!TranslateAccelerator(msg.hwnd, hAccelTable, &msg))
        {
            TranslateMessage(&msg);
            DispatchMessage(&msg);
        }
    }

    return (int) msg.wParam;
}

// FUNCTION CreateTheBitmap() ... create the DIBSection...
void CreateTheBitmap(HWND hwnd) {
    HDC hdc = GetDC(hwnd);
    BITMAPINFO pbmi;
    BITMAPINFOHEADER *bmih = &(pbmi.bmiHeader);
    bmih->biSize = sizeof(BITMAPINFOHEADER);
    bmih->biWidth = 160;
    bmih->biHeight = 200;
    bmih->biPlanes = 1;
    bmih->biBitCount = 24;
    bmih->biCompression = BI_RGB;
    bmih->biSizeImage = 0;
    bmih->biXPelsPerMeter = 0;
    bmih->biYPelsPerMeter = 0;
    bmih->biClrUsed = 0;
    bmih->biClrImportant = 0;
    mainBitmap = CreateDIBSection(hdc, &pbmi, 0, (void**) & bitmapBits, NULL, 0);
    ReleaseDC(hwnd, hdc);
}

// draw a diagonal pattern on the bitmap, of all EGA colors...
void UpdateTheBitmap() {
    static int paletteOffset = 0;

    int ip = paletteOffset;
    int ib = 0;
    const int end = 160 * 200 * 3;
    for(int y = 0; y < 200; ++y) {
        for (int x = 0; x < (160 * 3); ++x) {
            bitmapBits[ib++] = palette[ip++];
            if (ip >= sizeof(palette)) ip = 0;
        }
        ip += 3;
        if (ip >= sizeof(palette)) ip = 0;
    }

    paletteOffset += 3;
    if (paletteOffset >= sizeof(palette)) paletteOffset = 0;
}

//
//  FUNCTION: MyRegisterClass()
//
//  PURPOSE: Registers the window class.
//
ATOM MyRegisterClass(HINSTANCE hInstance)
{
    WNDCLASSEXW wcex;

    wcex.cbSize = sizeof(WNDCLASSEX);

    wcex.style          = CS_HREDRAW | CS_VREDRAW;
    wcex.lpfnWndProc    = WndProc;
    wcex.cbClsExtra     = 0;
    wcex.cbWndExtra     = 0;
    wcex.hInstance      = hInstance;
    wcex.hIcon          = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_TESTGDI));
    wcex.hCursor        = LoadCursor(nullptr, IDC_ARROW);
    wcex.hbrBackground  = (HBRUSH)(GetStockObject(BLACK_BRUSH));
    wcex.lpszMenuName   = MAKEINTRESOURCEW(IDC_TESTGDI);
    wcex.lpszClassName  = szWindowClass;
    wcex.hIconSm        = LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_SMALL));

    return RegisterClassExW(&wcex);
}

//
//   FUNCTION: InitInstance(HINSTANCE, int)
//
//   PURPOSE: Saves instance handle and creates main window
//
//   COMMENTS:
//
//        In this function, we save the instance handle in a global variable and
//        create and display the main program window.
//
HWND InitInstance(HINSTANCE hInstance, int nCmdShow)
{
   hInst = hInstance; // Store instance handle in our global variable

   HWND hWND = CreateWindowW(szWindowClass, szTitle, WS_OVERLAPPEDWINDOW,
      CW_USEDEFAULT, 0, CW_USEDEFAULT, 0, nullptr, nullptr, hInstance, nullptr);

   if (!hWND)
   {
      return NULL;
   }
   
   ShowWindow(hWND, nCmdShow);
   UpdateWindow(hWND);

   return hWND;
}

//
//  FUNCTION: WndProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE: Processes messages for the main window.
//
//  WM_COMMAND  - process the application menu
//  WM_PAINT    - Paint the main window
//  WM_DESTROY  - post a quit message and return
//
//
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
    switch (message)
    {
    case WM_CREATE:
        {
            CreateTheBitmap(hWnd);
            UpdateTheBitmap();
            timer_ptr = SetTimer(hWnd, 2, 1000 / FPS, NULL);
        }
        break;
    case WM_COMMAND:
        {
            int wmId = LOWORD(wParam);
            // Parse the menu selections:
            switch (wmId)
            {
            case ID_FILE_STOPTIMER:
                if (timer_ptr > 0) { KillTimer(hWnd, timer_ptr); timer_ptr = 0; }
                else { timer_ptr = SetTimer(hWnd, 2, 1000 / FPS, NULL);  }
                break;
            case IDM_ABOUT:
                DialogBox(hInst, MAKEINTRESOURCE(IDD_ABOUTBOX), hWnd, About);
                break;
            case IDM_EXIT:
                DestroyWindow(hWnd);
                break;
            default:
                return DefWindowProc(hWnd, message, wParam, lParam);
            }
        }
        break;
    case WM_TIMER:
        UpdateTheBitmap();
        InvalidateRect(hWnd, NULL, FALSE); 
        break;
    case WM_PAINT:
        {
            PAINTSTRUCT ps;
            RECT crect;
            HDC hdc = BeginPaint(hWnd, &ps);
            GetClientRect(hWnd, &crect);
            HDC srcHDC = CreateCompatibleDC(hdc);
            HBITMAP oldBmp = (HBITMAP)SelectObject(srcHDC, mainBitmap);
            StretchBlt(hdc, 0, 0, crect.right - crect.left, crect.bottom - crect.top, srcHDC, 0, 0, 160, 200, SRCCOPY);
            SelectObject(srcHDC, oldBmp);
            DeleteDC(srcHDC);
            EndPaint(hWnd, &ps);
        }
        break;
    case WM_DESTROY:
        PostQuitMessage(0);
        break;
    default:
        return DefWindowProc(hWnd, message, wParam, lParam);
    }
    return 0;
}

// Message handler for about box.
INT_PTR CALLBACK About(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
    UNREFERENCED_PARAMETER(lParam);
    switch (message)
    {
    case WM_INITDIALOG:
        return (INT_PTR)TRUE;

    case WM_COMMAND:
        if (LOWORD(wParam) == IDOK || LOWORD(wParam) == IDCANCEL)
        {
            EndDialog(hDlg, LOWORD(wParam));
            return (INT_PTR)TRUE;
        }
        break;
    }
    return (INT_PTR)FALSE;
}
