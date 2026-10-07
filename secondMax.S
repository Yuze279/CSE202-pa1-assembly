.global secondMax
# v1 in %di, v2 in %si, v3 in %dx, v4 in %cx  (signed 16-bit); result in %ax
secondMax:
    # %ax = first, %r8w = second   ("w" = 16 bits = short)
    cmpw  %si, %di            # if (v1 >= v2)
    jl    .Lv2first
    movw  %di, %ax            #     first = v1
    movw  %si, %r8w           #     second = v2
    jmp   .Lcheckv3
.Lv2first:
    movw  %si, %ax            # else first = v2
    movw  %di, %r8w           #      second = v1
.Lcheckv3:
    cmpw  %ax, %dx            # if (v3 > first)
    jle   .Lv3second
    movw  %ax, %r8w           #     second = first
    movw  %dx, %ax            #     first = v3
    jmp   .Lcheckv4
.Lv3second:
    cmpw  %r8w, %dx           # else if (v3 > second)
    jle   .Lcheckv4
    movw  %dx, %r8w           #     second = v3
.Lcheckv4:
    cmpw  %ax, %cx            # if (v4 > first)
    jle   .Lv4second
    movw  %ax, %r8w           #     second = first
    movw  %cx, %ax            #     first = v4
    jmp   .Ldone
.Lv4second:
    cmpw  %r8w, %cx           # else if (v4 > second)
    jle   .Ldone
    movw  %cx, %r8w           #     second = v4
.Ldone:
    movw  %r8w, %ax           # return second (short is returned in %ax)
    retq


# short secondMax(short v1, short v2, short v3, short v4){
#     short first, second;
#     if(v1 >= v2){ first = v1; second = v2; }
#     else        { first = v2; second = v1; }
#     if(v3 > first)       { second = first; first = v3; }
#     else if(v3 > second) { second = v3; }
#     if(v4 > first)       { second = first; first = v4; }
#     else if(v4 > second) { second = v4; }
#     return second;
# }
