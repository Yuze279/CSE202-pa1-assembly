.global product
# a in %rdi, b in %rsi, c in %rdx, size in %ecx
product:
    xorl  %r8d, %r8d          # i = 0
.Lloop:
    cmpl  %ecx, %r8d          # i < size   (size is unsigned)
    jae   .Ldone
    movss (%rdi,%r8,4), %xmm0 # xmm0 = a[i]    (x4: a float is 4 bytes)
    mulss (%rsi,%r8,4), %xmm0 # xmm0 = a[i] * b[i]
    movss %xmm0, (%rdx,%r8,4) # c[i] = xmm0
    incl  %r8d                # i++
    jmp   .Lloop
.Ldone:
    ret


# Product of two vectors in C
# void product(float *a, float *b, float *c, unsigned size){
#    for(int i=0; i<size; i++){
#        c[i] = a[i] * b[i];
#    }
# }
