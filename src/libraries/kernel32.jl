module Kernel32

using Windows.Types

export CloseHandle, OpenProcess, CreateEvent, SetEvent, WaitResult, WaitForSingleObject, GetLastError

function CloseHandle(hProcess::Types.HANDLE)::Int
    closed = ccall((:CloseHandle, "Kernel32"), stdcall, Cint, (Types.HANDLE,), hProcess);
end

function OpenProcess(processId::Types.DWORD)::Types.HANDLE
    hProcess = ccall((:OpenProcess, "Kernel32"), stdcall, Types.HANDLE, 
                (Types.DWORD, Types.BOOL, Types.DWORD), 
                Types.PROCESS_QUERY_INFORMATION | Types.PROCESS_VM_READ, false, processId)
    return hProcess
end

function CreateEvent(manualReset::Bool, initialState::Bool)::Types.HANDLE
    _manualReset = convert(Types.BOOL, manualReset)
    _initialState = convert(Types.BOOL, initialState)
    event_handle = ccall((:CreateEventA, "Kernel32"), stdcall, Types.HANDLE, 
                                (Ptr{Types.SECURITY_ATTRIBUTES}, Types.BOOL, Types.BOOL, Types.LPCSTR), 
                                C_NULL, _manualReset, _initialState, C_NULL)
    event_handle == C_NULL && error("Error @ CreateEvent")
    return event_handle
end

function SetEvent(event_handle::Types.HANDLE)::Bool
    result = ccall((:SetEvent, "Kernel32"), stdcall, Cint, (Types.HANDLE,), event_handle)
    result == 0 && error("Error @ SetEvent")
    return result == 1
end

baremodule WaitResult
    WAIT_ABANDONED=0x00000080
    WAIT_OBJECT_0=0x00000000
    WAIT_TIMEOUT=0x00000102
    WAIT_FAILED=0xFFFFFFFF
end
function WaitForSingleObject(handle::Types.HANDLE, milliseconds::Int)::Types.DWORD
    dwMilliseconds = convert(Types.DWORD, milliseconds)
    result = ccall((:WaitForSingleObject, "Kernel32"), stdcall, Types.DWORD, 
                                    (Types.HANDLE, Types.DWORD), 
                                    handle, dwMilliseconds)
    return result    

end

function GetLastError()::Types.DWORD
    ccall((:GetLastError,"Kernel32"), stdcall, Types.DWORD, ())
end

end # module