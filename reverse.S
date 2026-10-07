.global reverse
# list in %rdi (array of char*), n in %esi
reverse:
    movl  %esi, %edx
    shrl  $1, %edx            # edx = n / 2 (logical shift: n is unsigned)
    xorl  %ecx, %ecx          # i = 0
.Lloop:
    cmpl  %edx, %ecx          # while (i < n/2)
    jae   .Ldone              # jae = unsigned >=, since i and n are unsigned
    movl  %esi, %r8d
    subl  %ecx, %r8d
    subl  $1, %r8d            # r8 = n - i - 1
    movq  (%rdi,%rcx,8), %r9  # temp = list[i]          (x8: pointers are 8 bytes)
    movq  (%rdi,%r8,8), %r10  # r10 = list[n-i-1]
    movq  %r10, (%rdi,%rcx,8) # list[i] = list[n-i-1]
    movq  %r9, (%rdi,%r8,8)   # list[n-i-1] = temp
    incl  %ecx                # i++
    jmp   .Lloop
.Ldone:
    retq



# void reverse(char **list, unsigned n){
#     unsigned i = 0;
#     while (i < n/2){
#      char *temp = list[i];
#      list[i] = list[n-i-1];
#      list[n-i-1] = temp;
#      i++;
#     }
# }
