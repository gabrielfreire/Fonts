# [W.I.P] Windows Julia Interface
Series of Julia Interfaces for Windows APIs like 
- User32.dll (incomplete)
- Gdi32.dll (incomplete)
- Kernel32.dll (incomplete)
- Psapi.dll. (incomplete)
- Advapi32.dll. (incomplete)

# Available capabilities
- List installed fonts
- List current process
- check if a process is running by name
- get hostname

# Get hostname
```julia
using Windows.Libraries: Ws2_32
println(Ws2_32.gethostname()) # out "hostname"
```
# Using the Utility functions

## list fonts
```shell
julia> include("src\\Windows.jl")
julia> Windows.fontsList()
277-element Array{String,1}:        
 "System"                           
 "Terminal"                         
 "Fixedsys"                         
 "Modern"                           
 "Roman"                            
 "Script"                           
 "Courier"                          
 "MS Serif"                         
 "MS Sans Serif"                    
 "Small Fonts"                      
 "Marlett"                          
 "Arial"                            
 "Arabic Transparent"               
 "Arial Baltic"                     
 "Arial CE"                         
 "Arial CYR"                        
 "Arial Greek"                      
 "Arial TUR"                        
 ⋮                    
```

## List current processes
```julia
julia> Windows.processGetCurrent()
118-element Array{Main.Windows.Utils.Process,1}:
 Main.Windows.Utils.Process(6532, "nvcontainer.exe")
 Main.Windows.Utils.Process(8448, "nvcontainer.exe")
 Main.Windows.Utils.Process(9860, "svchost.exe")
 Main.Windows.Utils.Process(1524, "svchost.exe")
 Main.Windows.Utils.Process(10040, "sihost.exe")
 Main.Windows.Utils.Process(14976, "taskhostw.exe")
 Main.Windows.Utils.Process(9952, "Explorer.EXE")
 Main.Windows.Utils.Process(16904, "svchost.exe")
 Main.Windows.Utils.Process(12316, "DllHost.exe")
 Main.Windows.Utils.Process(7704, "StartMenuExperienceHost.exe")
 Main.Windows.Utils.Process(6408, "RuntimeBroker.exe")
 Main.Windows.Utils.Process(636, "SearchUI.exe")
 Main.Windows.Utils.Process(10912, "RuntimeBroker.exe")
 Main.Windows.Utils.Process(14464, "NVIDIA Web Helper.exe")
 Main.Windows.Utils.Process(8300, "conhost.exe")
 Main.Windows.Utils.Process(1436, "SettingSyncHost.exe")
 Main.Windows.Utils.Process(7248, "RuntimeBroker.exe")
 Main.Windows.Utils.Process(2728, "SkypeBackgroundHost.exe")
 ⋮
# Is Chrome running ?
 julia> Windows.processIsRunning("chrome.exe")
true
```

# Create a function to List Windows running processes yourself

```julia
using Windows
using Windows.Libraries: Kernel32, Psapi, User32, Gdi32


# Process
struct Process
    id::Int
    name::String
end

function _processById(procId::Types.DWORD)::Process
    pn = ""

    hProcess = Kernel32.OpenProcess(procId)
    if hProcess != C_NULL
        hProcess, hModule = Psapi.EnumProcessModules(hProcess)
        nameLength, processName = Psapi.GetModuleBaseNameW(hProcess, hModule)
        if nameLength > 0
            pn = Utils.decode_str(processName)
        end
    end
    Kernel32.CloseHandle(hProcess)

    return Process(procId, pn)
end

function processGetCurrent()::Vector{Process}
    processes = Process[]
    aProcesses = Psapi.EnumProcesses()
    for procId in aProcesses
        process = _processById( procId )
        if !isempty(process.name)
            push!(processes, process)
        end
        
    end
    return processes
end
```

# Create a script to list fonts yourself
```julia
using Windows
using Windows.Libraries: Kernel32, Psapi, User32, Gdi32

# Get Wind Handler
const hwdn = User32.GetDesktopWindow()

# Get Wind Handler Context
const hdc = User32.GetDC(hwdn)

# array to store the font names
fontnames = []

# Callback to get font information
# this callback is called by EnumFontFamiliesW for each font installed
function enum_callback(lplf::Ptr{Types.ENUMLOGFONTA}, lpntm::Ptr{Types.NEWTEXTMETRICA}, font_type::Types.DWORD, afont_count::Types.LPARAM)
    # Store true type fonts
    deref = unsafe_load(lplf)
    font = Dict(
        "fullName"=>deref.elfFullName,
        "style"=>deref.elfStyle,
        "faceName"=>deref.elfLogFont.lfFaceName,
        "weight"=>deref.elfLogFont.lfWeight,
        "fontType"=>font_type
    )
    push!(fontnames, font)
    return convert(Cint, 1)::Cint
end

function fontsList(;debug::Bool=false)::Vector{String}
    
    # callback
    lp_enum_fam_callback = @cfunction(enum_callback, Cint, (Ptr{Types.ENUMLOGFONTA}, Ptr{Types.NEWTEXTMETRICA}, Types.DWORD, Types.LPARAM))
    
    # call enumfontFamilies and pass the callback
    res = Gdi32.EnumFontFamiliesW(hdc, Ptr{UInt16}(C_NULL), lp_enum_fam_callback, Ptr{Cint}(0))
    
    res == 0 && error("Something terrible has happened @ fontslist()")
    
    # print all font names
    for f in fontnames
        facename = Utils.decode_str(f["faceName"])
        println("- $facename")
    end

    return fonts
end
```