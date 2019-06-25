include("../IRGen.jl")
using .IRGen
function dostuffs(n::Int)
    iter = (x for x in 1:10)
    res = []
    for i in iter
        n = rand(10,10)
        n *= i
        push!(res, n)
    end
    return res
end
@jlrun dostuffs(1)

bindir = joinpath(abspath(Sys.BINDIR, ".."), "tools")
libdir = joinpath(abspath(Sys.BINDIR, ".."), "lib")

cmd = `$bindir/clang -o dostuffs libdostuffs.o -L$(@__DIR__) -L$libdir -Wl,--unresolved-symbols=ignore-in-object-files -Wl,-rpath,'.' -Wl,-rpath,$libdir -ljulia -ldSFMT -lopenblas64_ -ldostuffs`
run(cmd)
