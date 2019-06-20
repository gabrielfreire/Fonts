Base.eval(:(have_color=true))

module Utils

include("../libraries/Libraries.jl")

import .Libraries: Kernel32, Psapi, User32, Gdi32, Types

include("fonts.jl")

export getProcesses, isProcessRunning, fonts_list

struct Process
    id::Int
    name::String
end

function decode_str(encoded::Vector{Cwchar_t})::String
    firstnull = findfirst(c->c==0, encoded)
    transcode(String, collect(encoded[1:(firstnull !== nothing ? firstnull-1 : end)]))
end

processes = Process[]

function _getProcessName(processId::Types.DWORD)::Process
    pn = ""

    hProcess = Kernel32.OpenProcess(processId)
    if hProcess != C_NULL
        hProcess, hMod = Psapi.EnumProcessModules(hProcess)
        len, processName = Psapi.GetModuleBaseNameW(hProcess, hMod)
        if len > 0
            pn = decode_str(processName)
        end
    end
    Kernel32.CloseHandle(hProcess)

    return Process(processId, pn)
end


function getProcesses()::Vector{Process}
    global processes
    aProcesses = Psapi.EnumProcesses()
    for proc in aProcesses
        process = _getProcessName( proc )
        if !isempty(process.name)
            push!(processes, process)
        end
        
    end
    return processes
end

function isProcessRunning(pName::String)::Bool
    _processes = [p.name for p in getProcesses()]
    if findfirst(x -> x==pName, _processes) != nothing
        return true
    end
    return false
end

end # module