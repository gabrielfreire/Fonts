using Windows
using Windows.Libraries: Kernel32, Psapi, User32, Gdi32

function _processById(procId::Types.DWORD)::Types.Process
    pn = ""

    hProcess = Kernel32.OpenProcess(procId)
    if hProcess != C_NULL
        hProcess, hMod = Psapi.EnumProcessModules(hProcess)
        len, processName = Psapi.GetModuleBaseNameW(hProcess, hMod)
        if len > 0
            pn = Utils.decode_str(processName)
        end
    end
    Kernel32.CloseHandle(hProcess)

    return Types.Process(procId, pn)
end


function processGetCurrent()::Vector{Types.Process}
    processes = Types.Process[]
    aProcesses = Psapi.EnumProcesses()
    for procId::Types.DWORD in aProcesses
        process = _processById( procId )
        if !isempty(process.name)
            push!(processes, process)
        end
        
    end
    return processes
end

function processIsRunning(pName::String)::Bool
    _processes = [p.name for p in processGetCurrent()]
    if findfirst(x -> x==pName, _processes) != nothing
        return true
    end
    return false
end
function processIsRunning(p::Types.Process)::Bool
    _processes = [p.name for p in processGetCurrent()]
    if findfirst(x -> x==p.name, _processes) != nothing
        return true
    end
    return false
end