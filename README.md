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
using Windows
println(Windows.gethostname()) 
# "yourhostname"
```
# Using the Utility functions

## list fonts
```shell
julia> using Windows
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
130-element Array{Windows.Process,1}:
 Windows.Process(1056, "nvcontainer.exe")
 Windows.Process(9856, "nvcontainer.exe")
 Windows.Process(8520, "svchost.exe")
 Windows.Process(11828, "sihost.exe")
 Windows.Process(11016, "svchost.exe")
 Windows.Process(3168, "taskhostw.exe")
 Windows.Process(10700, "Explorer.EXE")
 Windows.Process(7116, "svchost.exe")
 Windows.Process(7768, "DllHost.exe")
 Windows.Process(13504, "StartMenuExperienceHost.exe")
 Windows.Process(16440, "RuntimeBroker.exe")
 Windows.Process(1248, "SearchUI.exe")
 Windows.Process(15432, "RuntimeBroker.exe")
 Windows.Process(5368, "NVIDIA Web Helper.exe")
 Windows.Process(14184, "conhost.exe")
 Windows.Process(1360, "SkypeBackgroundHost.exe")
 Windows.Process(6828, "SettingSyncHost.exe")
 ⋮

 julia> Windows.processIsRunning("chrome.exe") # Is Chrome running ?
true
julia> Windows.processGetById(1056) # get a process by it's ID
Windows.Process(1056, "nvcontainer.exe")
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

function processGetById(procId::Int)::Process
    pn = ""
    _procId = convert(Types.DWORD, procId)
    hProcess = Kernel32.OpenProcess(_procId)
    if hProcess != C_NULL
        hProcess, hMod = Psapi.EnumProcessModules(hProcess)
        len, processName = Psapi.GetModuleBaseNameW(hProcess, hMod)
        if len > 0
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
        process = processGetById( procId )
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
    
    # Get Wind Handler
    const hwdn = User32.GetDesktopWindow()

    # Get Wind Handler Context
    const hdc = User32.GetDC(hwdn)

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