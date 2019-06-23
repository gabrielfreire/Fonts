# using Cxx

# cxx"""
# #include <windows.h>
# #include <stdio.h>
# #include <tchar.h>
# #include <psapi.h>
# #include <iostream>
# #include <vector>

# std::vector<DWORD> processes (void) {
#     // Get the list of process identifiers.
    
#     DWORD aProcesses[1024], cbNeeded, cProcesses;
#     unsigned int i;
#     std::vector<DWORD> res(0,0);
    
#     if ( !EnumProcesses( aProcesses, sizeof(aProcesses), &cbNeeded ) )
#     {
#         return res;
#     }
    
#     // Calculate how many process identifiers were returned.
    
#     cProcesses = cbNeeded / sizeof(DWORD);

#     for ( i = 0; i < cProcesses; i++ )
#     {
#         if( aProcesses[i] != 0 )
#         {
#             res.push_back(aProcesses[i]);
#             std::cout << aProcesses[i] << std::endl;
#         }
#     }
    
#     return res;
# }
# """


# function EnumProcesses()
#     _getProcesses() = @cxx processes()
#     res = _getProcesses()
#     arr = unsafe_wrap(Array, res, 1024)
#     println(arr)
#     # return processes
# end
# EnumProcesses()
using Cxx

cxx"""
#include <iostream>
#include <vector>

std::vector<int> compute_sum(const std::vector<std::vector<int>> &input)
{
  std::vector<int> result(input.size(), 0);
  for (std::size_t i = 0; i != input.size(); ++i)
  {
    for (std::size_t j = 0; j != input[i].size(); ++j)
    {
      result[i] += input[i][j];
    }
  }
  return result;
}
"""

cxx_v = icxx"std::vector<std::vector<int>>{{1,2},{1,2,3}};"
println("Input vectors:")
for v in cxx_v
  println("  ", collect(v))
end

cxx_sum = icxx"compute_sum($cxx_v);"
println("Cxx sums: $(collect(cxx_sum))")