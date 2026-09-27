.global sum
# pointer to list head in %rdi; result in %rax
# --> LIST IS IN %rdi & RESULT IS IN %rax
# struct ll { char *name; long value; struct ll *next; }
#   offset 0  : name
#   offset 8  : value
#   offset 16 : next
# rax rax the first regisster
sum:
    xorq  %rax, %rax   # total = 0 

.Listloop: #while loop
    testq %rdi, %rdi    # is ptr == NULL? 
    je .Done            # if so, leave the loop 
    addq 8(%rdi), %rax  # total += ptr->value ()
    movq 16(%rdi), %rdi # RESET ptr = ptr->next 
    jmp .Listloop 
.Done: 
    retq                #return total (%rax)

# sum of the elements of a linkedlist in C
# long sum(struct ll *list){
#    long total = 0;            //INITIALIZE TO ZERO
#    struct ll *ptr = list;
#    while(ptr){
#        total += ptr->value;
#        ptr = ptr->next; 
#    }
#    return total;
# }
