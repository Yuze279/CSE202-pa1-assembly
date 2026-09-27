.global binsearch
# arr in %rdi, n in %esi, target in %edx
binsearch:
    xorl   %eax, %eax         # lo = 0
    movl   %esi, %ecx
    decl   %ecx               # hi = (int)n - 1
.Lloop:
    cmpl   %ecx, %eax         # while (lo <= hi)
    jg     .Lnotfound
    movl   %ecx, %r8d
    subl   %eax, %r8d         # r8d = hi - lo
    sarl   $1, %r8d           # (hi - lo) / 2
    addl   %eax, %r8d         # mid = lo + (hi - lo) / 2
    movslq %r8d, %r9          # sign-extend mid for 64-bit indexing
    movl   (%rdi,%r9,4), %r10d # r10d = arr[mid]   (x4: each int is 4 bytes)
    cmpl   %edx, %r10d
    je     .Lfound            # arr[mid] == target
    jl     .Lgoright          # arr[mid] <  target
    movl   %r8d, %ecx
    decl   %ecx               # else hi = mid - 1
    jmp    .Lloop
.Lgoright:
    movl   %r8d, %eax
    incl   %eax               # lo = mid + 1
    jmp    .Lloop
.Lfound:
    movl   %r8d, %eax         # return mid
    ret
.Lnotfound:
    movl   $-1, %eax          # return -1
    ret


# binary search over a sorted int array; returns the index of target, or -1
# int binsearch(int *arr, unsigned n, int target){
#     int lo = 0;
#     int hi = (int)n - 1;
#     while(lo <= hi){
#         int mid = lo + (hi - lo) / 2;
#         if(arr[mid] == target)
#             return mid;
#         else if(arr[mid] < target)
#             lo = mid + 1;
#         else
#             hi = mid - 1;
#     }
#     return -1;
# }
