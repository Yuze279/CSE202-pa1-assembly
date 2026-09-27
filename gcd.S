.global gcd
# a in %edi, b in %esi; result in %eax
gcd:
    testl %esi, %esi # if (b == 0)
    jne .Recurse
    movl %edi, %eax # return a 
    retq

.Recurse: 
    movl %edi, %rax #rax = a 
    cqto      #sign-extend into rdx:rax 
    movslq %esi, %rcx #rcx = b 
    idivq  %rcx  # rax = a / b, rdx = a % b
    movl   %esi, %edi # new a = b      (before esi is overwritten)
    movl   %edx, %esi # new b = a % b
    subq   $8, %rsp   # keep stack 16-byte aligned for the call
    call   gcd        # eax = gcd(b, a % b)
    addq   $8, %rsp   # undo alignment
    retq      # result eax






# greatest common divisor via Euclid's algorithm (recursive)
# int gcd(int a, int b){
#     if(b == 0)
#         return a;
#     /* recursive call */
#     return gcd(b, a % b);
# }
