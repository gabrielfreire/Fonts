# [W.I.P] Windows Julia Interface
Series of Julia Interfaces for Windows APIs like User32.dll, Gdi32.dll, Kernel32.dll and Psapi.dll.

# Usage

## list fonts
```julia
julia> include("src\\Windows.jl")
julia> Windows.Utils.fonts_list()
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
 "Rockwell Condensed"               
 "Rockwell"                         
 "Rockwell Extra Bold"              
 "Script MT Bold"                   
 "Showcard Gothic"                  
 "Snap ITC"                         
 "Stencil"                          
 "Tw Cen MT"                        
 "Tw Cen MT Condensed"              
 "Tw Cen MT Condensed Extra Bold"   
 "Tempus Sans ITC"                  
 "Viner Hand ITC"                   
 "Vivaldi"                          
 "Vladimir Script"                  
 "Wingdings 2"                      
 "Wingdings 3"                      
 "MT Extra"       
```

## List current processes
```julia
julia> Windows.Utils.getCurrentProcesses()
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
 Main.Windows.Utils.Process(9992, "chrome.exe")
 Main.Windows.Utils.Process(1068, "chrome.exe")
 Main.Windows.Utils.Process(9040, "chrome.exe")
 Main.Windows.Utils.Process(6296, "chrome.exe")
 Main.Windows.Utils.Process(11212, "python.exe")
 Main.Windows.Utils.Process(17308, "smartscreen.exe")
 Main.Windows.Utils.Process(18340, "Code.exe")
 Main.Windows.Utils.Process(12572, "Code.exe")
 Main.Windows.Utils.Process(17632, "Code.exe")
 Main.Windows.Utils.Process(12820, "Code.exe")
 Main.Windows.Utils.Process(12624, "Code.exe")
 Main.Windows.Utils.Process(10600, "CodeHelper.exe")
 Main.Windows.Utils.Process(7144, "conhost.exe")
 Main.Windows.Utils.Process(15432, "Code.exe")
 Main.Windows.Utils.Process(16368, "julia.exe")
 Main.Windows.Utils.Process(2268, "conhost.exe")
 Main.Windows.Utils.Process(17848, "julia.exe")
```