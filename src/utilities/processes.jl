# Process
struct Process
    id::Int
    name::String
end

Integer = Union{Int, Int32, Int64}
function processGetById(procId::Integer)::Process
    pn = ""
    _procId = convert(Windows.Types.DWORD, procId)
    hProcess = Windows.Libraries.Kernel32.OpenProcess(_procId)
    if hProcess != C_NULL
        hProcess, hMod = Windows.Libraries.Psapi.EnumProcessModules(hProcess)
        len, processName = Windows.Libraries.Psapi.GetModuleBaseNameW(hProcess, hMod)
        if len > 0
            pn = Windows.Utils.decode_str(processName)
        end
    end
    Windows.Libraries.Kernel32.CloseHandle(hProcess)

    return Process(procId, pn)
end


function processGetCurrent()::Vector{Process}
    processes = Process[]
    aProcesses = Windows.Libraries.Psapi.EnumProcesses()
    for procId::Windows.Types.DWORD in aProcesses
        process = processGetById( procId )
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
function processIsRunning(p::Process)::Bool
    _processes = [p.name for p in processGetCurrent()]
    if findfirst(x -> x==p.name, _processes) != nothing
        return true
    end
    return false
end