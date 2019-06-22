module Utils

using Windows.Types

export init

# Empty Pointer type initialization
"""
    init(t::Type)
    cbNeeded    = init(DWORD)
    hModule     = init(HMODULE)
    lpDword     = init(LPDWORD)
    ccall((:EnumProcessModules, "Psapi"), stdcall, Cint, 
                                (HANDLE, HMODULE, DWORD, LPDWORD), handle, hModule, sizeof(hModule), lpDword)
    hModule_result = hModule[1] # this will result in a Vector that has the HMODULE instance inside
Initialize an empty pointer representation to a TYPE, this pointer can be passed
as arguments in ccall functions that requires it.

"""
init(t::Type{Types.LPDWORD}) = [zero(Types.DWORD)]
init(t::Type{Types.DWORD}) = [zero(Types.DWORD)]
init(t::Type{Types.HMODULE}) = [C_NULL]

function decode_str(encoded::Vector{Cwchar_t})::String
    firstnull = findfirst(c->c==0, encoded)
    transcode(String, collect(encoded[1:(firstnull !== nothing ? firstnull-1 : end)]))
end

function decode_str(encoded::NTuple)::String
    firstnull = findfirst(c->c==0, encoded)
    transcode(String, collect(encoded[1:(firstnull !== nothing ? firstnull-1 : end)]))
end
end # module