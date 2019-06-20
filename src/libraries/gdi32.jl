module Gdi32

include("types.jl")

export EnumFontFamiliesW

function EnumFontFamiliesW(hdc::Types.HDC, lpcstr::Types.LPCSTR, callback::Types.EnumFontProc, lparam::Types.LPARAM)::Cint
    ccall((:EnumFontFamiliesW, "Gdi32"), stdcall, Cint, 
        (Types.HDC, Types.LPCSTR, Types.EnumFontProc, Types.LPARAM), 
        hdc, lpcstr, callback, lparam)
end

end # module