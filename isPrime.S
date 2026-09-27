.global isPrime
# n in %edi; result in %eax (1 = prime, 0 = not prime)

isPrime:
    cmpl   $2, %edi           # if (n < 2) return 0
    jl     .Lnotprime
    testl  $1, %edi           # lowest bit 0 -> n is even
    jnz    .Lodd
    xorl   %eax, %eax         # even: return n == 2
    cmpl   $2, %edi
    sete   %al                # al = 1 if n == 2, else 0
    ret
.Lodd:
    movl   $3, %ecx           # i = 3
.Lloop:
    movl   %ecx, %eax
    imull  %ecx, %eax         # eax = i * i
    cmpl   %edi, %eax         # while (i * i <= n)
    jg     .Lprime
    movslq %edi, %rax         # rax = n (64-bit)
    cqto                      # sign-extend rax into rdx:rax
    idivq  %rcx               # rdx = n % i  (upper half of rcx is 0 from movl)
    testl  %edx, %edx         # if (n % i == 0) return 0
    je     .Lnotprime
    addl   $2, %ecx           # i += 2 (odd divisors only)
    jmp    .Lloop
.Lprime:
    movl   $1, %eax           # return 1
    ret
.Lnotprime:
    xorl   %eax, %eax         # return 0
    ret


# int isPrime(int n){
#     if(n < 2)
#         return 0;
#     if(n % 2 == 0)
#         return n == 2;
#     /* only test odd divisors i while i*i <= n */
#     for(int i = 3; i * i <= n; i += 2){
#         if(n % i == 0)
#             return 0;
#     }
#     return 1;
# }
