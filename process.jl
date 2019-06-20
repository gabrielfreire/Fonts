Base.eval(:(have_color=true))
include("types.jl")
struct Proc
    name::String
end

function decode_str(encoded::Vector{Cwchar_t})::String
    firstnull = findfirst(c->c==0, encoded)
    transcode(String, collect(encoded[1:(firstnull !== nothing ? firstnull-1 : end)]))
end

const PROC_SIZE = 1024
const MAX_PATH = 260
const PROCESS_QUERY_INFORMATION = 0x0400
const PROCESS_VM_READ = 0x0010
EnumProcesses(lpidProcess::Ptr{DWORD}, cb::DWORD, lpcbNeeded::Ptr{DWORD}) = ccall((:EnumProcesses, "Psapi"), stdcall, Cint, (Ptr{DWORD}, DWORD, Ptr{DWORD}), lpidProcess, cb, lpcbNeeded)
processes = Proc[]
function getProcesses()::Vector{Proc}
    global processes
    aProcesses  = Vector{DWORD}(undef, PROC_SIZE)
    # aProcesses  = Vector{DWORD}(undef, PROC_SIZE)
    cbNeeded    = [zero(DWORD)]
    res = ccall((:EnumProcesses, "Psapi"), stdcall, Cint, (Ptr{DWORD}, DWORD, LPDWORD), aProcesses, sizeof(aProcesses), cbNeeded)
    println("success > $res")

    res == 0 && error("Something is wrong")
    # ap = unsafe_load(aProcesses)
    for p in aProcesses
        # _p = unsafe_load(p)
        if p > 0
            # @show p
            hProcess = ccall((:OpenProcess, "Kernel32"), stdcall, HANDLE, (DWORD, BOOL, DWORD), PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, false, p)
            if hProcess != C_NULL
                # println("hProcess > $proc")
                @show hProcess
                cbNeeded    = Vector{DWORD}(undef, sizeof(DWORD));
                hMod        = Vector{HMODULE}(undef, sizeof(HMODULE));
                # cbNeeded = [DWORD]
                # hMod = [HMODULE]
                # println(typeof(hMod))
                # cbNeeded = [zero(DWORD)]
                # hMod = [zero(DWORD)]
                
                enum = ccall((:EnumProcessModulesEx, "Psapi"), stdcall, Cint, (HANDLE, HMODULE, DWORD, LPDWORD, DWORD), 
                                                                            hProcess, hMod, sizeof(hMod), 
                                                                            cbNeeded, 0x0)

                # enum == 0 && error("Failed to Enumerate process modules")
                # println("enum success ? $enum")
                if enum == 1
                    processName = Vector{Cwchar_t}(undef, MAX_PATH)
                    len = ccall((:GetModuleBaseNameA, "Psapi"), stdcall, DWORD, (HANDLE, HMODULE, LPCSTR, DWORD), 
                                                                                            hProcess, hMod, processName, 
                                                                                            sizeof(processName)/sizeof(Cwchar_t))
                    if len > 0
                        println("process name $(decode_str(processName)) of length $len")
                    end
                end
                # break
            end

            closed = ccall((:CloseHandle, "Kernel32"), stdcall, Cint, (HANDLE,), hProcess);
            # println("closed ? $closed")
        end
    end
    println(length(aProcesses))
    
    # list = String(read(`tasklist`))
    # list = split(list, "\n")
    # list = [split(strip(l), " ")[1] for l in list]
    # for l in list
    #     # preprocess
    #     if isempty(l) || occursin("=", l)
    #         continue
    #     end
    #     push!(processes, Proc(l))
    # end
    
    return processes
end

function isRunning(pName::String)::Bool
    global processes
    if isempty(processes)
        processes = getProcesses()
    end
    _processes = [p.name for p in processes]
    if findfirst(x -> x==pName, _processes) != nothing
        return true
    end
    return false
end