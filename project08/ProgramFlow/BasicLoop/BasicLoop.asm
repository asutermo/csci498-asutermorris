@0
D=A
@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M
@13
M=D
@0
D=A
@13
M=M+D
@SP
M=M-1
A=M
D=M
@13
A=M
M=D
($label)
@ARG
D=M
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@SP
M=M-1
A=M
D=M
@SP
A=M-1
M=M+D
@LCL
D=M
@13
M=D
@0
D=A
@13
M=M+D
@SP
M=M-1
A=M
D=M
@13
A=M
M=D
@ARG
D=M
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@1
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP
M=M-1
A=M
D=M
@SP
A=M-1
M=M-D
@ARG
D=M
@13
M=D
@0
D=A
@13
M=M+D
@SP
M=M-1
A=M
D=M
@13
A=M
M=D
@ARG
D=M
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@SP
M=M-1
A=M
D=M
@$if-goto
D;JNE
@LCL
D=M
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
