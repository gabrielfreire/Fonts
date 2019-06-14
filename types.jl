const HANDLE = Ptr{Cvoid}
const EnumFontProc = HANDLE
const HWND = HANDLE
const HDC = HANDLE
const WORD = Cushort
const DWORD = Culong
const WPARAM = Cint
const LPARAM = Ptr{Cint}
const LPCWSTR = Ptr{UInt16}
const LPCSTR = LPCWSTR
const LF_FACESIZE = 32
const LF_FULLFACESIZE = 64

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

const FontType = Dict(
    1 => "Unknown",
    2 => "PostScript",
    4 => "TrueType",
)

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
    lfFaceName::NTuple{LF_FACESIZE, Cwchar_t}
end

struct ENUMLOGFONTA
    elfLogFont::LOGFONTA
    elfFullName::NTuple{LF_FULLFACESIZE, Cwchar_t}
    elfStyle::NTuple{LF_FACESIZE, Cwchar_t}
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