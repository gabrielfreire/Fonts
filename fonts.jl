const HANDLE = Ptr{Cvoid}
const HWND = HANDLE
const HDC = HANDLE
const WORD = Cushort
const DWORD = Culong
const WPARAM = Cint
const LPARAM = Ptr{Cint}
const LPCSTR = Ptr{Cstring}

const FontPitchAndFamily = Dict(
    0 => "DEFAULT_PITCH",
    1 => "FIXED_PITCH",
    2 => "VARIABLE_PITCH",
    (0<<4) =>"FF_DONTCARE",
    (1<<4) =>"FF_ROMAN",
    (2<<4) =>"FF_SWISS",
    (3<<4) =>"FF_MODERN",
    (4<<4) =>"FF_SCRIPT",
    (5<<4) =>"FF_DECORATIVE"
)

const FontWeight = Dict(   
    0 => "FW_DONTCARE",
    100 => "FW_THIN",
    200 => "FW_EXTRALIGHT",
    300 => "FW_LIGHT",
    400 => "FW_NORMAL",
    500 => "FW_MEDIUM",
    600 => "FW_SEMIBOLD",
    700 => "FW_BOLD",
    800 => "FW_EXTRABOLD",
    900 => "FW_HEAVY",
)

baremodule FontType
    Unknown = 1
    TrueType = 4
    PostScript = 2
end

const FontQuality = Dict(
    0 => "DEFAULT_QUALITY",
    1 => "DRAFT_QUALITY",
    2 => "PROOF_QUALITY",
    3 => "NONANTIALIASED_QUALITY",
    4 => "ANTIALIASED_QUALITY",
    5 => "CLEARTYPE_QUALITY",
    6 => "CLEARTYPE_NATURAL_QUALITY"
)

const FontCharSet = Dict(
     0=>"ANSI_CHARSET",
     1=>"DEFAULT_CHARSET",
     2=>"SYMBOL_CHARSET",
     128=>"SHIFTJIS_CHARSET",
     129=>"HANGEUL_CHARSET",
     129=>"HANGUL_CHARSET",
     134=>"GB2312_CHARSET",
     136=>"CHINESEBIG5_CHARSET",
     255=>"OEM_CHARSET",
     130=>"JOHAB_CHARSET",
     177=>"HEBREW_CHARSET",
     178=>"ARABIC_CHARSET",
     161=>"GREEK_CHARSET",
     162=>"TURKISH_CHARSET",
     163=>"VIETNAMESE_CHARSET",
     222=>"THAI_CHARSET",
     238=>"EASTEUROPE_CHARSET",
     204=>"RUSSIAN_CHARSET",
     77=>"MAC_CHARSET",
     186=>"BALTIC_CHARSET"
)

struct LOGFONTA
    lfHeight::Clong
    lfWidth::Clong
    lfEscapement::Clong
    lfOrientation::Clong
    lfWeight::Clong
    lfItalic::UInt8
    lfUnderline::UInt8
    lfStrikeOut::UInt8
    lfCharSet::UInt8
    lfOutPrecision::UInt8
    lfClipPrecision::UInt8
    lfQuality::UInt8
    lfPitchAndFamily::UInt8
    lfFaceName::Cstring
end

struct ENUMLOGFONTA
    elfLogFont::LOGFONTA
    elfFullName::Cstring
    elfStyle::Cstring
end

struct NEWTEXTMETRICA
    tmHeight::Clong
    tmAscent::Clong
    tmDescent::Clong
    tmInternalLeading::Clong
    tmExternalLeading::Clong
    tmAveCharWidth::Clong
    tmMaxCharWidth::Clong
    tmWeight::Clong
    tmOverhang::Clong
    tmDigitizedAspectX::Clong
    tmDigitizedAspectY::Clong
    tmFirstChar::UInt8
    tmLastChar::UInt8
    tmDefaultChar::UInt8
    tmBreakChar::UInt8
    tmItalic::UInt8
    tmUnderlined::UInt8
    tmStruckOut::UInt8
    tmPitchAndFamily::UInt8
    tmCharSet::UInt8
    ntmFlags::DWORD
    ntmSizeEM::Cuint
    ntmCellHeight::Cuint
    ntmAvgWidth::Cuint
end

dereference(ptr::Ptr) = unsafe_load(ptr)
dereference(T::DataType, ptr::Ptr) = unsafe_load(Ptr{T}(ptr))
Base.:*(ptr::Ptr) = dereference(ptr)
Base.:*(T::DataType, ptr::Ptr) = dereference(T, ptr)

fontnames = []
function enum_fam_callback(lplf::Ptr{ENUMLOGFONTA}, lpntm::Ptr{NEWTEXTMETRICA}, font_type::DWORD, afont_count::LPARAM)
    # Store true type fonts
    if Int32(font_type) == FontType.TrueType
        if lplf != C_NULL
            deref = unsafe_load(lplf)
            println("$(deref.elfFullName) == $(deref.elfFullName) ?")
            @show fieldoffset(ENUMLOGFONTA, 2) # out: 0x0000000000000028
            fullname = unsafe_load(lplf, 2) # 2 is index for elfFullName | out: the whole ENUMLOGFONTA object without having loaded elfFullName
            font = Dict(
                "name"=>deref.elfFullName, 
                "quality"=>deref.elfLogFont.lfQuality, 
                "weight"=>deref.elfLogFont.lfWeight,
                "faceName"=>deref.elfLogFont.lfFaceName,
                "fontPitchAndFamily"=>deref.elfLogFont.lfPitchAndFamily,
                "charSet"=>deref.elfLogFont.lfCharSet
            )
            push!(fontnames, font)
        end
    end
    # dump(lplf)
    return convert(Cint, 1)::Cint
end


# Get Wind Handler
hwdn = ccall((:GetDesktopWindow, "User32"), HANDLE, ())

# Get Wind Handler Context
hdc = ccall((:GetDC, "User32"), HANDLE, (HANDLE,), hwdn)

# List available fonts
lp_enum_fam_callback = @cfunction(enum_fam_callback, Cint, (Ptr{ENUMLOGFONTA}, Ptr{NEWTEXTMETRICA}, DWORD, LPARAM))
res = ccall((:EnumFontFamiliesW, "Gdi32"), stdcall, Cint, (HANDLE, LPCSTR, HANDLE, LPARAM), hdc, C_NULL, lp_enum_fam_callback, [0,0,0])

res == 0 && error("Something terrible has happened")

println("Found $(length(fontnames)) fonts")

function display_fonts(n::Int)
    # display only 5
    c = 1
    for f in fontnames
        if c <= n
            println("-----------------------------------------")
            @show f["name"]
            haskey(FontPitchAndFamily, f["fontPitchAndFamily"]) && @show FontPitchAndFamily[f["fontPitchAndFamily"]]
            haskey(FontQuality, f["quality"])                   && @show FontQuality[f["quality"]]
            haskey(FontCharSet, f["charSet"])                   && @show FontCharSet[f["charSet"]]
            haskey(FontWeight, f["weight"])                     && @show FontWeight[f["weight"]]
        end
        c += 1
    end
end

display_fonts(5)
