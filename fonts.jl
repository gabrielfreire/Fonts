Base.eval(:(have_color=true))
module Font

    export fonts_list
    include("api.jl")
    # Get Wind Handler
    const hwdn = GetDesktopWindow()
    # Get Wind Handler Context
    const hdc = GetDC(hwdn)
    fontnames = []

    function enum_callback(lplf::Ptr{ENUMLOGFONTA}, lpntm::Ptr{NEWTEXTMETRICA}, font_type::DWORD, afont_count::LPARAM)
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


    function decode_str(encoded::NTuple)::String
        firstnull = findfirst(c->c==0, encoded)
        transcode(String, collect(encoded[1:(firstnull !== nothing ? firstnull-1 : end)]))
    end

    function fonts_list(;debug::Bool=false)::Vector{String}
        
        # List available fonts
        lp_enum_fam_callback = @cfunction(enum_callback, Cint, (Ptr{ENUMLOGFONTA}, Ptr{NEWTEXTMETRICA}, DWORD, LPARAM))
        
        res = EnumFontFamiliesW(hdc, Ptr{UInt16}(C_NULL), lp_enum_fam_callback, Ptr{Cint}(0))
        
        res == 0 && error("Something terrible has happened")
        
        # display only 5
        fonts = Vector{String}()
        
        for f in fontnames
            if debug
                fontname = decode_str(f["fullName"])
                facename = decode_str(f["faceName"])
                style = decode_str(f["style"])
                fonttype = haskey(FontType, f["fontType"]) && FontType[f["fontType"]]
                weight = haskey(FontWeight, f["weight"]) && FontWeight[f["weight"]]
                println("-----------------------------------------")
                printstyled(" - $fontname - $facename - $fonttype - $style - $weight\n", color=:light_green)
            else
                facename = decode_str(f["faceName"])
                if !(facename in fonts)
                    push!(fonts, facename)
                end
            end
        end

        empty(fontnames)

        return fonts
    end

end
