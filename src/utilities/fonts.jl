using Windows
using Windows.Libraries: Kernel32, Psapi, User32, Gdi32

# Get Wind Handler
const hwdn = User32.GetDesktopWindow()

# Get Wind Handler Context
const hdc = User32.GetDC(hwdn)

fontnames = []
function enum_callback(lplf::Ptr{Types.ENUMLOGFONTA}, lpntm::Ptr{Types.NEWTEXTMETRICA}, font_type::Types.DWORD, afont_count::Types.LPARAM)
    # Store true type fonts
    deref = unsafe_load(lplf)
    font = Dict(
        "fullName"=>deref.elfFullName,
        "style"=>deref.elfStyle,
        "faceName"=>deref.elfLogFont.lfFaceName,
        "weight"=>deref.elfLogFont.lfWeight,
        "fontType"=>font_type
    )
    push!(fontnames, font)
    return convert(Cint, 1)::Cint
end

function fontsList(;debug::Bool=false)::Vector{String}
    
    # List available fonts
    lp_enum_fam_callback = @cfunction(enum_callback, Cint, (Ptr{Types.ENUMLOGFONTA}, Ptr{Types.NEWTEXTMETRICA}, Types.DWORD, Types.LPARAM))
    
    res = Gdi32.EnumFontFamiliesW(hdc, Ptr{UInt16}(C_NULL), lp_enum_fam_callback, Ptr{Cint}(0))
    
    res == 0 && error("Something terrible has happened")
    
    # display only 5
    fonts = Vector{String}()
    
    for f in fontnames
        if debug
            fontname = Utils.decode_str(f["fullName"])
            facename = Utils.decode_str(f["faceName"])
            style = Utils.decode_str(f["style"])
            fonttype = haskey(Types.FontType, f["fontType"]) && Types.FontType[f["fontType"]]
            weight = haskey(Types.FontWeight, f["weight"]) && Types.FontWeight[f["weight"]]
            println("-----------------------------------------")
            printstyled(" - $fontname - $facename - $fonttype - $style - $weight\n", color=:light_green)
        else
            facename = Utils.decode_str(f["faceName"])
            if !(facename in fonts)
                push!(fonts, facename)
            end
        end
    end

    empty(fontnames)

    return fonts
end

