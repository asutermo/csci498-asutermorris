@PRE
  0;JMP
  @0
  D=A
  @R0
  M=D
  @2
  D=A
  @R1
  M=D
(PRE)
  @0
  D=A
  @R2
  M=D
(LO)
  @R0            
  D=M
  @OVR
  D;JLE //if < 0, jump to OVR
  @R0          
  M=M-1 //decrement R0
  @R1             
  D=M
  @R2
  M=M+D //Add R1 to R2
  @LO         
  0;JMP //Goto LO
(OVR)
  @OVR	
  0;JMP	//INF Loop once done