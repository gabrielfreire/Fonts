
fontnames = Dict[]
function enum_callback(lplf::Ptr{Windows.Types.ENUMLOGFONTA}, lpntm::Ptr{Windows.Types.NEWTEXTMETRICA}, font_type::Windows.Types.DWORD, afont_count::Windows.Types.LPARAM)
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
    # Get Wind Handler
    hwdn = Windows.Libraries.User32.GetDesktopWindow()

    # Get Wind Handler Context
    hdc = Windows.Libraries.User32.GetDC(hwdn)
    # List available fonts
    lp_enum_fam_callback = @cfunction(enum_callback, Cint, (Ptr{Windows.Types.ENUMLOGFONTA}, Ptr{Windows.Types.NEWTEXTMETRICA}, Windows.Types.DWORD, Windows.Types.LPARAM))

    res = Windows.Libraries.Gdi32.EnumFontFamiliesW(hdc, nothing, lp_enum_fam_callback, 0)
    
    res == 0 && error("Something terrible has happened")
    
    # display only 5
    fonts = Vector{String}()
    
    for f in fontnames
        if debug
            fontname = Windows.Utils.decode_str(f["fullName"])
            facename = Windows.Utils.decode_str(f["faceName"])
            style = Windows.Utils.decode_str(f["style"])
            fonttype = haskey(Windows.Types.FontType, f["fontType"]) && Windows.Types.FontType[f["fontType"]]
            weight = haskey(Windows.Types.FontWeight, f["weight"]) && Windows.Types.FontWeight[f["weight"]]
            println("-----------------------------------------")
            printstyled(" - $fontname - $facename - $fonttype - $style - $weight\n", color=:light_green)
        else
            facename = Windows.Utils.decode_str(f["faceName"])
            if !(facename in fonts)
                push!(fonts, facename)
            end
        end
    end

    empty(fontnames)

    return fonts
end

