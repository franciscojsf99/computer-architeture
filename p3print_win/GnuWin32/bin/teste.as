orig 0000h

	MOV R1, 'A'
	MOV M[FFFEh], R1
	MOV R1, 'B'
	MOV M[FFFEh], R1

	MOV R1, FFFFh
	MOV M[FFFCh], R1

	MOV R1, 'A'
	MOV M[FFFEh], R1
	MOV R1, 'B'
	MOV M[FFFEh], R1
	
	
	
