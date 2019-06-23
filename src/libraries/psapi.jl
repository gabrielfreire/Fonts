module Psapi

using Windows.Types
using Windows.Utils

export EnumProcessModules, EnumProcesses, GetModuleBaseNameW

DWORD = Types.DWORD
LPDWORD = Types.LPDWORD
HANDLE = Types.HANDLE
HMODULE = Types.HMODULE
LPCSTR = Types.LPCSTR
MAX_PATH = Types.MAX_PATH
PROC_SIZE = Types.PROC_SIZE
# const HMODULE = Ptr{Types.HANDLE}

function EnumProcesses()::Vector{DWORD}
    result      = DWORD[]
    aProcesses  = Vector{DWORD}(undef, PROC_SIZE)
    cbNeeded    = LPDWORD(0)
    res         = ccall((:EnumProcesses, "Psapi"), stdcall, Cint, 
                    (Ptr{DWORD}, DWORD, LPDWORD), 
                    aProcesses, sizeof(aProcesses), cbNeeded)
    
    res == 0 && error("Error @ EnumProcesses")

    size        = Int(cbNeeded[] / sizeof(DWORD))
    
    for i in 1:size
        if aProcesses[i] > 0
            push!(result, aProcesses[i])
        end
    end
    return result
end

function EnumProcessModules(hProcess::HANDLE)::Tuple{HANDLE, HMODULE}
    cbNeeded    = LPDWORD(0)     # LPDWORD <=> *DWORD
    hMod        = Ref{HMODULE}(0)      # HMODULE <=> *HANDLE
    
    enum = ccall((:EnumProcessModules, "Psapi"), stdcall, Cint, 
                            (HANDLE, Ref{HMODULE}, DWORD, LPDWORD), 
                            hProcess, hMod, sizeof(hMod), cbNeeded)

    enum == 0 && error("Error @ EnumProcessModules")
    return (hProcess, hMod[])
end

function GetModuleBaseNameW(hProcess::HANDLE, hMod::HMODULE)::Tuple{Int, Vector{Cwchar_t}}
    processName = Vector{Cwchar_t}(undef, MAX_PATH)
    len         = ccall((:GetModuleBaseNameW, "Psapi"), stdcall, DWORD, 
                    (HANDLE, HMODULE, LPCSTR, DWORD), 
                    hProcess, hMod, processName, 
                    Clong(sizeof(processName)/sizeof(Cwchar_t)))
    return (len, processName)
end

end # module