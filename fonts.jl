Base.eval(:(have_color=true))
module Font

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
            "quality"=>deref.elfLogFont.lfQuality, 
            "weight"=>deref.elfLogFont.lfWeight,
            "fontPitchAndFamily"=>deref.elfLogFont.lfPitchAndFamily,
            "charSet"=>deref.elfLogFont.lfCharSet,
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
                println("-----------------------------------------")
                printstyled(" - $fontname - $(haskey(FontType, f["fontType"]) && FontType[f["fontType"]])\n", color=:light_green)
                @show fontname
                @show decode_str(f["style"])
                @show decode_str(f["faceName"])
                haskey(FontPitchAndFamily, f["fontPitchAndFamily"]) && @show FontPitchAndFamily[f["fontPitchAndFamily"]]
                haskey(FontQuality, f["quality"])                   && @show FontQuality[f["quality"]]
                haskey(FontCharSet, f["charSet"])                   && @show FontCharSet[f["charSet"]]
                haskey(FontWeight, f["weight"])                     && @show FontWeight[f["weight"]]
            else
                fontname = decode_str(f["fullName"])
                if !(fontname in fonts)
                    push!(fonts, fontname)
                end
            end
        end

        empty(fontnames)

        return fonts
    end

end
