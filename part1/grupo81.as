  SP_INICIAL EQU FDFFh
 ORIG 8000h
CS TAB 1
Jogada  TAB 1
Semelhanca TAB 1
IO EQU FFFEh
NL EQU 000Ah
Mascara EQU 1000000000010111b
Valor EQU 1001000101010011b
Frase	STR	'Jogada Seguinte: @'
Fim_Frase	EQU	'@'

ORIG 0000h
JMP Inicio
GerarAleatorio:	MOV R5, M[CS] ; Permitiria gerar um segundo valor aleatório caso este programa não fosse apenas de uma jogada
				MOV R5, M[SP + 2] ; Mover para R5 o valor inicial antes guardado na pilha
				AND R5, 1h ; Isola o ultimo bit do valor anterior
 				CMP R5, R0
 				BR.NZ Salta ; Se o ultimo bit é 1, salta
 				MOV R6, M[SP + 2]
 				SHR R6, 1 ; gera um novo valor 
 				MOV M[SP + 2], R6
 				BR VerificarValor 

GerarAleatorio1: MOV R5, M[CS] ; gerar novo aleatório caso o anterior nao cumpra os requesitos
 				AND R5, 1h
 				CMP R5, R0
 				BR.NZ Salta
 				MOV R6, Valor
 				SHR R6, 1
 				MOV M[CS], R6
 				BR VerificarValor

Salta:  MOV R5, M[SP + 3] ; fazer XOR enre o Valor inicial e a Mascara
		MOV R6, M[SP + 2]
		XOR R6, R5
		MOV M[SP + 2], R6
 		BR VerificarValor

VerificarValor: AND R6, 000fh ; Esta retina VerificarValor serve para ver se cada algarismo da Sequencia Secreta está entre 1 e 6. Não estando, geraria outro
				CMP R6, R0
				BR.Z GerarAleatorio1
				CMP R6, 0006h
				BR.P GerarAleatorio1
				MOV R6, M[SP + 2]
				AND R6, 00f0h
				CMP R6, R0
				JMP.Z GerarAleatorio1
				CMP R6, 0060h
				JMP.P GerarAleatorio1
				MOV R6, M[SP + 2]
				AND R6, 0f00h
				CMP R6, R0
				JMP.Z GerarAleatorio1
				CMP R6, 0600h
				JMP.P GerarAleatorio1
				MOV R6, M[SP + 2]
				AND R6, f000h
				CMP R6, R0
				JMP.Z GerarAleatorio1
				CMP R6, 6000h
				JMP.P GerarAleatorio1
				RET	

VerificarValor1:MOV R6, R2 ; Esta retina VerificarValor1 serve para ver se cada algarismo da Sequencia introduzida pelo jogador está entre 1 e 6. Não estando, volta para a retia NovoValorR2 enquanto espera um novo input
				AND R6, 000fh
				CMP R6, R0
				JMP.Z NovoValorR2
				CMP R6, 0006h
				JMP.P NovoValorR2
				MOV R6, M[SP + 2]
				AND R6, 00f0h
				CMP R6, R0
				JMP.Z NovoValorR2
				CMP R6, 0060h
				JMP.P NovoValorR2
				MOV R6, M[SP + 2]
				AND R6, 0f00h
				CMP R6, R0
				JMP.Z NovoValorR2
				CMP R6, 0600h
				JMP.P NovoValorR2
				MOV R6, M[SP + 2]
				AND R6, f000h
				CMP R6, R0
				JMP.Z NovoValorR2
				CMP R6, 6000h
				JMP.P NovoValorR2
				RET	

Inicio1: MOV R6, R2 ; Mover para a pilha cada algarismo individual de ambas as sequencias.
		AND R6, 000fh
		SHR R2, 4
		CMP R6, R0
		BR.Z ReporRegistos
		MOV R4, SP 
		DEC R7
		ADD R4, R7
		MOV M[R4], R6
		MOV R5, R1
		AND R5, 000fh
		SHR R1, 4
		MOV R4, SP 
		INC R3
		ADD R4, R3
		MOV M[R4], R5
		Br Inicio1



ReporRegistos:  MOV R1, R0
				MOV R2, R0
				MOV R3, R0
				MOV R4, R0
				MOV R5, R0
				MOV R6, R0
				MOV R7, R0
				RET

EscreverX:		MOV R1, SP ; compara o primeiro/ segundo/ terceiro/ quarto digito de cada sequencia
				DEC R7
				ADD R1, R7
				MOV R6, M[R1]
				MOV R4, SP 
				INC R3
				ADD R4, R3
				MOV R5, M[R4]
				CMP R5, R0
				BR.Z EscreverO ; Quando todos os digitos tiverem sido comparados, o programa sai desta rotina
				CMP R5, R6
				BR.Z ValorCertoPosicaoCerta ; Caso os digitos sejam iguais, salta para a rotina ValorCertoPosicaoCerta, onde adicionará um 2 ao valor de R3.
				BR EscreverX

EscreverO:		MOV R3, 3d ; Esta retina começará a comparar o primeiro digito de cada sequencia.
				MOV R4, R0
				MOV R1, R0
				MOV R7, 11d
				MOV R5, M[SP + 3]
				MOV R6, M[SP + 11]
				CMP R5, R6
				JMP.Z ValorCertoPosicaoErrada
				JMP ReporSeqComputador


ValorCertoPosicaoCerta: 	MOV M[R1], R0 ; Esta rotina anula "elimina" da pilha os valores iguais e adiciona 2 ao valor de R3. (Defenimos 2, como o valor certo na posição certa para representar R3)
							MOV M[R4], R0
							PUSH R3
							MOV R3, M[Semelhanca]
							SHL R3, 4 ;  passar ao bit Seguinte
							ADD R3, 2h
							MOV M[Semelhanca], R3
							POP R3
							JMP EscreverX

ValorCertoPosicaoErrada: 	CMP R6, R0 ; Nesta rotina, adiciona-se 1 ao valor de R3. (Defenimos 2, como o valor certo na posição certa para representar R3)
							MOV M[R4], R0
							BR.Z Comparacao
							PUSH R3
							MOV R3, M[Semelhanca]
							SHL R3, 4 ; passar ao bit Seguinte
							ADD R3, 1h
							MOV M[Semelhanca], R3
							POP R3
							BR Comparacao

ReporSeqComputador:	INC R3 ; Esta retina permitirá comparar um algarismo da sequencia do jogador, com cada algarismo da sequencia do computador. Caso sejam iguais, saltará para a retina ValorCertoPosicaoErrada
					MOV R4, SP
					ADD R4, R3
					MOV R5, M[R4]
					CMP R3, 7
					BR.Z Comparacao
					CMP R5, R6
					BR.Z ValorCertoPosicaoErrada			
					BR ReporSeqComputador

Comparacao:		MOV R3, 2d ; Nesta retina passar-se-á para o algarimos seguinte da sequencia do jogador, e vai-se comparar aos algarimos da sequencia secreta através a retina ReporSeqComputador
				INC R3
				MOV R4, SP
				ADD R4, R3
				MOV R5, M[R4]
				DEC R7
				MOV R1, SP
				ADD R1, R7
				MOV R6, M[R1]
				CMP R7, 7 ; quando R7 atinge o valor 7, já se fizeram todas as comparações, pelo que o se tem de sair desta rotina
				JMP.Z NovaJogada
				CMP R5, R6
				JMP.Z ValorCertoPosicaoErrada			
				JMP ReporSeqComputador

NovaJogada: RETN 14 ; retira da pilha todos os valores inseridos

JogadaSeguinte:	MOV R5, M[80f8h]
				CMP R5, 11 ; Verifica se já chegamos à ultima jogada possivel
				JMP.Z Fim ; Se sim, o programa chega ao fim
				INC R5 ; se não, passamos à jogada seguinte
				MOV M[80f8h], R5
NovoValorR2:	MOV R2, M[Jogada] ; devolve-se a R2 o valor incialmente introduzido pelo jogador
				JMP Pausa

Inicio:	MOV M[Jogada], R2 ; guarda a jogada introduzida pelo jogador
		MOV R7, SP_INICIAL
		MOV SP, R7
		MOV R5, Valor
		MOV M[CS], R5 ; guarda o valor inicial na memoria 
		MOV R6, Mascara
		PUSH R0
		PUSH R6 ; por na pilha o valor da mascara e o Valor inicial, respetivamente
		PUSH R5
		CALL GerarAleatorio
		POP R1 ; remover da pilha a sequencia inicial
		MOV M[CS], R1 ; guardar em memoria a sequencia inicial

SequenciaSeguinte:	PUSH R0 ; arranjar espaço na pilha para os algarismos de cada sequencia
					PUSH R0
					PUSH R0
					PUSH R0
					PUSH R0
					PUSH R0
					PUSH R0
					PUSH R0
					PUSH R0
					PUSH R0
					PUSH R0
					PUSH R2 ; introduzir na pilha o valor introuzido pelo jogador
					CALL VerificarValor1 ; verificar se o valor introduzido pelo jogaador é valido
					MOV R5,	Frase
 					MOV R6, NL
					MOV M[IO], R6
					CALL EsceverJogadaSeguinte ; escrever na janela de texto jogada Seguinte
					MOV R7, 12d ; contador que servirá para por na pilha a sequencia introduzida pelo jogador
					MOV R3, 2d ; contador que servira para por na pilha a sequencia secreta
					MOV R1, M[CS] ; Move para R1 a sequencia Secreta
					CALL Igual
					CALL Inicio1
					MOV R7, 12d ; repor o contador ao seu valor inicial
					MOV R3, 2d ; report o contador ao seu valor inicial
					CALL EscreverX
					MOV R1, M[CS]
					MOV R3, M[Semelhanca]
					MOV R5, R3
					AND R5, f000h ; Vai se escrever os respetivos "o" e "x" a partir do valor de R3. Se em R3 estiver 2, escrever-se-há o "x" de posição ValorCertoPosicaoCerta, Se em R3 estiver 1, escrever-se-há o "o" de posição ValorCertoPosicaoErrada. O 0 corresponde ao numero errado.
					CMP R5, 2000h
					BR.NZ 3
					MOV R5, 'x'
					MOV M[IO], R5
					CMP R5, 1000h
					BR.NZ 3
					MOV R5, 'o'
					MOV M[IO], R5
					MOV R5, R3
					AND R5, 0f00h
					CMP R5, 200h
					BR.NZ 3
					MOV R5, 'x'
					MOV M[IO], R5
					CMP R5, 100h
					BR.NZ 3
					MOV R5, 'o'
					MOV M[IO], R5
					MOV R5, R3
					AND R5, 00f0h
					CMP R5, 20h
					BR.NZ 3
					MOV R5, 'x'
					MOV M[IO], R5
					CMP R5, 10h
					BR.NZ 3
					MOV R5, 'o'
					MOV M[IO], R5
					MOV R5, R3
					AND R5, 000fh
					CMP R5, 2h
					BR.NZ 3
					MOV R5, 'x'
					MOV M[IO], R5
					CMP R5, 1h
					BR.NZ 3
					MOV R5, 'o'
					MOV M[IO], R5
					MOV M[Semelhanca], R0
					JMP JogadaSeguinte

EsceverJogadaSeguinte:	MOV R6, M[R5] ; escrever na janela de texto "Jogada Seguinte:"
						CMP R6, Fim_Frase
						BR.Z 5
						MOV M[IO], R6
						ADD R5, 1
						BR EsceverJogadaSeguinte
						MOV R6, M[80f8h]
						MOV M[IO], R6
						MOV R6, NL
						MOV M[IO], R6
						RET

Pausa:	CMP R2, M[Jogada] ; o programa ficará aqui preso até ser introduzido um novo valor de R2.
		BR.Z Pausa
		MOV M[Jogada], R2
		JMP SequenciaSeguinte

Igual:	CMP R2, R1 ; Se a sequencia do jogador for igual a sequencia secreta, o jogo acaba
		BR.Z 1
		RET
		MOV R5, 11 ; O jogo acaba ou quando for acertada a sequencia secreta, ou quando houver 12 jogadas sem sucesso, pelo que igualando este valor a 11, estamos a dizer que o jogo acabou. (iguala-se a 11 porque o contador começa no 0)
		MOV M[80f8h], R5
		RET

Fim:	Br Fim

; Projeto realizado por João Marques 89473 e Francisco Figueiredo 89443