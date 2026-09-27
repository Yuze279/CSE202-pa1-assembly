.global area
# a in %edi, b in %esi, c in %edx; result in %eax
area:
    movl   %edi, %eax 
    addl   %esi, %eax
    addl   %edx, %eax         # eax = a + b + c
    movl   %eax, %ecx
    shrl   $31, %ecx          # ecx = 1 if the sum is negative
    addl   %ecx, %eax         # bias so the shift rounds toward zero like C
    sarl   $1, %eax           # p = (a + b + c) / 2

    movl   %eax, %ecx         # ecx = running product, starts as p
    movl   %eax, %r8d
    subl   %edi, %r8d         # r8d = p - a
    imull  %r8d, %ecx         # ecx = p * (p-a)
    movl   %eax, %r8d
    subl   %esi, %r8d         # r8d = p - b
    imull  %r8d, %ecx         # ecx *= (p-b)
    movl   %eax, %r8d
    subl   %edx, %r8d         # r8d = p - c
    imull  %r8d, %ecx         # ecx *= (p-c)

    movl   %ecx, %edi         # argument for r_sqrt
    subq   $8, %rsp           # keep stack 16-byte aligned for the call
    call   r_sqrt             # eax = r_sqrt(p)
    addq   $8, %rsp
    retq

# recursive integer square root; x in %edi, result in %eax
r_sqrt:
    testl  %edi, %edi         # if (x < 0) return -1
    jns    .Lnonneg
    movl   $-1, %eax
    retq
.Lnonneg:
    cmpl   $2, %edi           # if (x < 2) return x
    jge    .Lrec
    movl   %edi, %eax
    retq
.Lrec:
    pushq  %rbx               # save callee-saved rbx (also aligns stack)
    movl   %edi, %ebx         # ebx = x, preserved across the call
    sarl   $2, %edi           # edi = x >> 2
    call   r_sqrt             # eax = r_sqrt(x >> 2)
    shll   $1, %eax           # small_cand = r_sqrt(x >> 2) << 1
    movl   %eax, %ecx
    incl   %ecx               # large_cand = small_cand + 1
    movl   %ecx, %edx
    imull  %edx, %edx         # edx = large_cand * large_cand
    cmpl   %ebx, %edx         # if (large*large > x)
    jg     .Ldone             #     return small_cand (already in eax)
    movl   %ecx, %eax         # else return large_cand
.Ldone:
    popq   %rbx               # restore rbx before returning
    retq


# int area(int a, int b, int c){
#     int p = (a + b + c)/2;
#     p = p * (p-a) * (p-b) * (p-c);
#     return sqrt(p);
# }
# calculate recursively the square root of an int (in C)
# int r_sqrt(int x){
#    if(x < 0)
#        return -1;
#    if (x < 2)
#        return x;
#   /* recursive call */
#    int small_cand = r_sqrt(x >> 2) << 1;
#    int large_cand = small_cand + 1;
#    if (large_cand * large_cand > x)
#        return small_cand;
#    else
#        return large_cand;
# }
