module Libraries

include("libraries/kernel32.jl")
include("libraries/psapi.jl")
include("libraries/user32.jl")
include("libraries/gdi32.jl")
include("libraries/Ws2_32.jl")

export Kernel32, Psapi, User32, Gdi32, Ws2_32

end # module