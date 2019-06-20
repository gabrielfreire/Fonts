module Psapi

include("types.jl")

export EnumProcessModules, EnumProcesses, GetModuleBaseNameW

const HMODULE = Ptr{Types.HANDLE}

function EnumProcesses()::Vector{Types.DWORD}
    result      = Types.DWORD[]
    aProcesses  = Vector{Types.DWORD}(undef, Types.PROC_SIZE)
    cbNeeded    = [zero(Types.DWORD)]
    res         = ccall((:EnumProcesses, "Psapi"), stdcall, Cint, 
                    (Ptr{Types.DWORD}, Types.DWORD, Types.LPDWORD), 
                    aProcesses, sizeof(aProcesses), cbNeeded)
    
    res == 0 && error("Error @ EnumProcesses")

    size        = Int(cbNeeded[1] / sizeof(Types.DWORD))
    
    for i in 1:size
        if aProcesses[i] > 0
            push!(result, aProcesses[i])
        end
    end
    return result
end

function EnumProcessModules(hProcess::Types.HANDLE)::Tuple{Types.HANDLE, Vector{Types.HANDLE}}
    cbNeeded    = [zero(Types.DWORD)] # LPDWORD <=> *DWORD
    hMod        = [C_NULL]      # HMODULE <=> *HANDLE
    
    enum = ccall((:EnumProcessModules, "Psapi"), stdcall, Cint, 
                            (Types.HANDLE, HMODULE, Types.DWORD, Types.LPDWORD), 
                            hProcess, hMod, sizeof(hMod), cbNeeded)

    enum == 0 && error("Error @ EnumProcessModules")
    return (hProcess, hMod)
end

function GetModuleBaseNameW(hProcess::Types.HANDLE, hMod::Vector{Types.HANDLE})::Tuple{Int, Vector{Cwchar_t}}
    processName = Vector{Cwchar_t}(undef, Types.MAX_PATH)
    len         = ccall((:GetModuleBaseNameW, "Psapi"), stdcall, Types.DWORD, 
                    (Types.HANDLE, HMODULE, Types.LPCSTR, Types.DWORD), 
                    hProcess, hMod[1], processName, 
                    Clong(sizeof(processName)/sizeof(Cwchar_t)))
    return (len, processName)
end

end # module