module User32

include("types.jl")

export GetDesktopWindow, GetDC

# Get Wind Handler
GetDesktopWindow()::Types.HANDLE = ccall((:GetDesktopWindow, "User32"), Types.HANDLE, ())

# Get Wind Handler Context
GetDC(hwdn::Types.HANDLE)::Types.HDC = ccall((:GetDC, "User32"), Types.HANDLE, (Types.HANDLE,), hwdn)

end # module