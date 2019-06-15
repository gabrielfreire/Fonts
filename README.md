# Windows Fonts
List installed fonts on a Windows OS by calling `Gdi32.dll` and `User32.dll`.

# Usage
```julia
julia> include("fonts.jl")
Main.Font

julia> Font.fonts_list()
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
 ⋮                                       
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

julia> Font.fonts_list(debug=true)    # just print  
.
.
.
-----------------------------------------
 - Footlight MT Light - Footlight MT Light - TrueType - Regular - FW_LIGHT
-----------------------------------------
 - Garamond - Garamond - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Gigi - Gigi - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Gill Sans MT - Gill Sans MT - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Gill Sans MT Condensed - Gill Sans MT Condensed - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Gill Sans Ultra Bold Condensed - Gill Sans Ultra Bold Condensed - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Gill Sans Ultra Bold - Gill Sans Ultra Bold - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Gloucester MT Extra Condensed - Gloucester MT Extra Condensed - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Gill Sans MT Ext Condensed Bold - Gill Sans MT Ext Condensed Bold - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Century Gothic - Century Gothic - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Goudy Old Style - Goudy Old Style - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Goudy Stout - Goudy Stout - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Harlow Solid Italic - Harlow Solid Italic - TrueType - Italic - FW_NORMAL
-----------------------------------------
 - Harrington - Harrington - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Haettenschweiler - Haettenschweiler - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - High Tower Text - High Tower Text - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Imprint MT Shadow - Imprint MT Shadow - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Informal Roman - Informal Roman - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Blackadder ITC - Blackadder ITC - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Edwardian Script ITC - Edwardian Script ITC - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Kristen ITC - Kristen ITC - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Jokerman - Jokerman - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Juice ITC - Juice ITC - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Kunstler Script - Kunstler Script - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Wide Latin - Wide Latin - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Lucida Bright - Lucida Bright - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Lucida Calligraphy Italic - Lucida Calligraphy - TrueType - Italic - FW_NORMAL
-----------------------------------------
 - Leelawadee - Leelawadee - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Lucida Fax Regular - Lucida Fax - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Lucida Handwriting Italic - Lucida Handwriting - TrueType - Italic - FW_NORMAL
-----------------------------------------
 - Lucida Sans Regular - Lucida Sans - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Lucida Sans Typewriter Regular - Lucida Sans Typewriter - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Magneto Bold - Magneto - TrueType - Bold - FW_BOLD
-----------------------------------------
 - Maiandra GD - Maiandra GD - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Matura MT Script Capitals - Matura MT Script Capitals - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Mistral - Mistral - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Modern No. 20 - Modern No. 20 - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Microsoft Uighur - Microsoft Uighur - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Monotype Corsiva - Monotype Corsiva - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Niagara Engraved - Niagara Engraved - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Niagara Solid - Niagara Solid - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - OCR A Extended - OCR A Extended - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Old English Text MT - Old English Text MT - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Onyx - Onyx - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - MS Outlook - MS Outlook - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Palace Script MT - Palace Script MT - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Papyrus - Papyrus - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Parchment - Parchment - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Perpetua - Perpetua - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Perpetua Titling MT Light - Perpetua Titling MT - TrueType - Light - FW_LIGHT
-----------------------------------------
 - Playbill - Playbill - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Poor Richard - Poor Richard - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Pristina - Pristina - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Rage Italic - Rage Italic - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Ravie - Ravie - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - MS Reference Sans Serif - MS Reference Sans Serif - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - MS Reference Specialty - MS Reference Specialty - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Rockwell Condensed - Rockwell Condensed - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Rockwell - Rockwell - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Rockwell Extra Bold - Rockwell Extra Bold - TrueType - Regular - FW_EXTRABOLD
-----------------------------------------
 - Script MT Bold - Script MT Bold - TrueType - Regular - FW_BOLD
-----------------------------------------
 - Showcard Gothic - Showcard Gothic - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Snap ITC - Snap ITC - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Stencil - Stencil - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Tw Cen MT - Tw Cen MT - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Tw Cen MT Condensed - Tw Cen MT Condensed - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Tw Cen MT Condensed Extra Bold - Tw Cen MT Condensed Extra Bold - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Tempus Sans ITC - Tempus Sans ITC - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Viner Hand ITC - Viner Hand ITC - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Vivaldi Italic - Vivaldi - TrueType - Italic - FW_NORMAL
-----------------------------------------
 - Vladimir Script - Vladimir Script - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Wingdings 2 - Wingdings 2 - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - Wingdings 3 - Wingdings 3 - TrueType - Regular - FW_NORMAL
-----------------------------------------
 - MT Extra - MT Extra - TrueType - Regular - FW_NORMAL                           
```