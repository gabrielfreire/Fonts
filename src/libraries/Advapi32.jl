module Advapi32

include("../Types.jl")

const SERVICE_STATUS_HANDLE = Types.HANDLE
const LPHANDLER_FUNCTION = Types.HANDLE
const LPSERVICE_MAIN_FUNCTIONA = Types.HANDLE

struct SERVICE_TABLE_ENTRYA
    lpServiceName::Types.LPSTR
    lpServiceMain::LPSERVICE_MAIN_FUNCTIONA # callback function cb(DWORD, *LPSTR)
end

baremodule ServiceType
    SERVICE_KERNEL_DRIVER=0x00000001
    SERVICE_FILE_SYSTEM_DRIVER=0x00000002
    SERVICE_USER_SHARE_PROCESS=0x00000060
    SERVICE_USER_OWN_PROCESS=0x00000050
    SERVICE_WIN32_SHARE_PROCESS=0x00000020
    SERVICE_WIN32_OWN_PROCESS=0x00000010
    SERVICE_INTERACTIVE_PROCESS=0x00000100
end
baremodule ServiceStatus
    SERVICE_PAUSED=0x00000007
    SERVICE_STOPPED=0x00000001
    SERVICE_START_PENDING=0x00000002
    SERVICE_STOP_PENDING=0x00000003
    SERVICE_PAUSE_PENDING=0x00000006
    SERVICE_CONTINUE_PENDING=0x00000005
    SERVICE_RUNNING=0x00000004
end
struct SERVICE_STATUS
    dwServiceType::Types.DWORD
    dwCurrentState::Types.DWORD
    dwControlsAccepted::Types.DWORD
    dwWin32ExitCode::Types.DWORD
    dwServiceSpecificExitCode::Types.DWORD
    dwCheckPoint::Types.DWORD
    dwWaitHint::Types.DWORD
end

const LPSERVICE_STATUS = Ptr{SERVICE_STATUS}


function StartServiceCtrlDispatcherA(lpServiceStartTable::SERVICE_TABLE_ENTRYA)::Bool
    result = ccall((:StartServiceCtrlDispatcherA, "Advapi32"), stdcall, Cint, 
                (SERVICE_TABLE_ENTRYA,), 
                lpServiceStartTable)
    result == 0 && error("Error @ StartServiceCtrlDispatcherA")
    return result == 1
end

"""
    # This is the control handler, method that listens for control code/events and performs tasks
    function _callback(dwControl::DWORD)::Nothing
        # ...
    end
    callback = @cfunction(_callback, Cvoid, (DWORD,))
    RegisterServiceCtrlHandlerA("ServiceName", callback)
"""
function RegisterServiceCtrlHandlerA(lpServiceName::String, callback::LPHANDLER_FUNCTION)::SERVICE_STATUS_HANDLE
    sn = transcode(UInt16, lpServiceName)
    service_status_handle = ccall((:RegisterServiceCtrlHandlerA, "Advapi32"), stdcall, SERVICE_STATUS_HANDLE, 
                                (Types.LPCSTR, LPHANDLER_FUNCTION), 
                                pointer(sn), callback)
    service_status_handle == C_NULL && error("Error @ RegisterServiceCtrlHandlerA")
    return service_status_handle
end

function SetServiceStatus(hServiceStatus::SERVICE_STATUS_HANDLE, lpServiceStatus::LPSERVICE_STATUS)::Bool
    result = ccall((:SetServiceStatus, "Advapi32"), stdcall, Cint, (SERVICE_STATUS_HANDLE, LPSERVICE_STATUS), hServiceStatus, lpServiceStatus)
    result == 0 && error("Error @ SetServiceStatus")
    return result == 1
end

end # module