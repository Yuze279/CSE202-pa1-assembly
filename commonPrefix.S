.global commonPrefix
# a in %rdi, b in %rsi; result (prefix length) in %eax
# Both are pointers so 64 bit 


commonPrefix:
  xorl %eax %eax # n=0  

.While: 
  movzbl (%rdi, %rax), %ecx # ecx = a[n]
  testb %cl, %cl           # is a[n] == '\0' test if END OF STRING 
  je  .Done                # STOP 
  cmpb (%rsi, %rax), %cl   #compare a[n] with b[n]
  jne .Done                # if !== 
  incl %eax                # n++ 
  jmp .While               # CHECK NEXT CHARACTER

.Done: 
  retq


# length of the longest common prefix of two null-terminated strings
# int commonPrefix(char *a, char *b){ #ecx 
#     int n = 0; 
#     while(a[n] && a[n] == b[n])
#         n++;
#     return n; #eax or #rax?? 
# }
