module User32

using Windows.Types

export GetDesktopWindow, GetDC

const ProcCallback = Ptr{Cvoid} # callback foreach_window(hwnd::HANDLE, lParam::LPARAM)

# Get Wind Handler
GetDesktopWindow()::Types.HANDLE = ccall((:GetDesktopWindow, "User32"), Types.HANDLE, ())

# Get Wind Handler Context
GetDC(hwdn::Types.HANDLE)::Types.HDC = ccall((:GetDC, "User32"), Types.HANDLE, (Types.HANDLE,), hwdn)

# Windowns API Method
EnumWindows(callback::ProcCallback, lparam::Types.LPARAM) = 
    ccall((:EnumWindows, "User32"), stdcall, Cint, (ProcCallback, Types.LPARAM), callback, lparam)

# Windowns API Method
GetWindowTextW(hwnd::Types.HANDLE, buffer::Types.LPCWSTR, len::Cint) = 
    ccall((:GetWindowTextW, "User32"), stdcall, Cint, (Types.HANDLE, Types.LPCWSTR, Cint), hwnd, buffer, len + 1)

# Windowns API Method
GetWindowTextLengthW(hwnd::Types.HANDLE) = ccall((:GetWindowTextLengthW, "User32"), stdcall, Cint, (Types.HANDLE,), hwnd)

# Windowns API Method
IsWindowVisible(hwnd::Types.HANDLE) = ccall((:IsWindowVisible, "User32"), stdcall, Cint, (Types.HANDLE,), hwnd)
end # module