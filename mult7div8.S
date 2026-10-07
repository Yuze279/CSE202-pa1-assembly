.global mult7div8
# a in %dil (signed char), overflow pointer in %rsi; result in %eax
mult7div8:
    movb  %dil, %al
    shlb  $3, %al             # al = a * 8   (8-bit, wraps like a char)
    subb  %dil, %al           # mult = 8a - a = 7a   (shift + sub only)
    movb  $0, (%rsi)          # *overflow = 0 by default
    testb %dil, %dil
    jg    .Lapos              # a > 0
    jl    .Laneg              # a < 0
    jmp   .Ldiv               # a == 0: no overflow
.Lapos:
    testb %al, %al
    jge   .Ldiv               # a > 0 and mult >= 0: ok
    jmp   .Lovf               # a > 0 and mult < 0: overflow
.Laneg:
    testb %al, %al
    jle   .Ldiv               # a < 0 and mult <= 0: ok
.Lovf:
    movb  $1, (%rsi)          # *overflow = 1
.Ldiv:
    movsbl %al, %eax          # sign-extend mult (char) to 32 bits
    testl %eax, %eax
    jge   .Lshift
    addl  $7, %eax            # negative: add 7 so the shift rounds toward zero like C
.Lshift:
    sarl  $3, %eax            # mult / 8   (arithmetic shift keeps the sign)
    ret



# char mult7div8(char a, char *overflow){
#     char mult = (7 * a);
#     if(a > 0 && mult < 0 || a < 0 && mult > 0)
#       *overflow = 1;
#     else
#       *overflow = 0;
#     return mult/8;
# }
