module Gdi32

using Windows.Types

export EnumFontFamiliesW

function EnumFontFamiliesW(hdc::Types.HDC, lpcstr::Union{Nothing,String}, callback::Types.EnumFontProc, lparam::Int)::Cint
    _lpcstr = lpcstr != nothing ? transcode(UInt16, lpcstr) : C_NULL
    _lpcstr = typeof(_lpcstr) == UInt16 ? pointer(_lpcstr) : C_NULL
    
    _lparam = convert(Types.LPARAM, lparam)
    
    ccall((:EnumFontFamiliesW, "Gdi32"), stdcall, Cint, 
        (Types.HDC, Types.LPCSTR, Types.EnumFontProc, Types.LPARAM), 
        hdc, _lpcstr, 
        callback, _lparam)
end

end # module