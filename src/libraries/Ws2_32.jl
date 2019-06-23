module Ws2_32

function gethostname()::String
    hostname = Vector{Cchar}(undef, 128)
    ccall((:gethostname, "Ws2_32"), Int32,
          (Ptr{Cchar}, Cint),
          hostname, sizeof(hostname))
    hostname[end] = 0; # ensure null-termination
    return unsafe_string(pointer(hostname))
end

end # module