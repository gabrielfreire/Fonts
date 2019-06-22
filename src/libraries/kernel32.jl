module Kernel32

using Windows.Types

export CloseHandle, OpenProcess

function CloseHandle(hProcess::Types.HANDLE)::Int
    closed = ccall((:CloseHandle, "Kernel32"), stdcall, Cint, (Types.HANDLE,), hProcess);
end

function OpenProcess(processId::Types.DWORD)::Types.HANDLE
    hProcess = ccall((:OpenProcess, "Kernel32"), stdcall, Types.HANDLE, 
                (Types.DWORD, Types.BOOL, Types.DWORD), 
                Types.PROCESS_QUERY_INFORMATION | Types.PROCESS_VM_READ, false, processId)
    return hProcess
end

end # module