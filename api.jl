include("types.jl")
# Get Wind Handler
GetDesktopWindow()::HANDLE = ccall((:GetDesktopWindow, "User32"), HANDLE, ())

# Get Wind Handler Context
GetDC(hwdn::HANDLE)::HDC = ccall((:GetDC, "User32"), HANDLE, (HANDLE,), hwdn)

function EnumFontFamiliesW(hdc::HDC, lpcstr::LPCSTR, callback::EnumFontProc, lparam::LPARAM)::Cint
    ccall((:EnumFontFamiliesW, "Gdi32"), stdcall, Cint, 
        (HDC, LPCSTR, EnumFontProc, LPARAM), 
        hdc, lpcstr, callback, lparam)
end

dereference(ptr::Ptr, idx::Int) = unsafe_load(ptr, idx)
dereference(T::DataType, ptr::Ptr, idx::Int) = unsafe_load(Ptr{T}(ptr), idx)
Base.:*(ptr::Ptr, idx::Int) = dereference(ptr, idx)
Base.:*(T::DataType, ptr::Ptr, idx::Int) = dereference(T, ptr, idx)