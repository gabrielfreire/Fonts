module Utils

using Windows.Types

function decode_str(encoded::Vector{Cwchar_t})::String
    firstnull = findfirst(c->c==0, encoded)
    transcode(String, collect(encoded[1:(firstnull !== nothing ? firstnull-1 : end)]))
end

function decode_str(encoded::NTuple)::String
    firstnull = findfirst(c->c==0, encoded)
    transcode(String, collect(encoded[1:(firstnull !== nothing ? firstnull-1 : end)]))
end
end # module