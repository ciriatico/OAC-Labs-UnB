.data
COLORS: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
PRE_KEY: 0,0,0,0
KEY: 0,0,0,0
TRIES: 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
BLACK_PINS: 0
WHITE_PINS: 0

BREAK_LINE: .string "\n"
ENTRADA: .string "Insira a próxima cor\n"
BLANK: .string " "

.text
MAIN:
li a7 5
ecall
li s0 5
add s0 s0 a0 # N -> difficult

li a7 4
la a0 BREAK_LINE
ecall

li t4 0
li s1 0x10 # color
la t0 COLORS
GEN_COLOR:
	sw s1, 0(t0) # store color in color list
	addi s1 s1 2 # next color
	addi t0 t0 4 # next word in color array
	addi t4 t4 1 # increment main counter
	blt t4 s0 GEN_COLOR

la t0 PRE_KEY
li t4 4 # max counter
li t3 0 # counter
li a7 42  
mv a1 s0
GEN_PRE_KEY:
	ecall
	la t2 PRE_KEY 
	li t5 0 #subcounter
	
	CHECK_UNICITY:
		lw s2 0(t2) # carregar prox prekey em s2
		beq a0 s2 GEN_PRE_KEY # if a0 in PRE_KEYS: gen new index
		addi t5 t5 1
		addi t2 t2 4
		blt t5 s0 CHECK_UNICITY # if a0 not in PRE_KEYS: store index in PRE_KEY
	sw a0 0(t0)
	addi t0 t0 4
	addi t3 t3 1
	blt t3 t4 GEN_PRE_KEY
	
la t0 KEY
la t1 PRE_KEY
li t3 0 # main conter
li t5 4 # subcounter max
GEN_KEY:
	la t2 COLORS
	li t4 0 #subcounter
	lw s2 0(t1) # carregar prox prekey em s2
	# find next color with pre_key and add to key -> KEY.append(COLOR[PRE_KEY])
	COLOR_TO_KEY:
		beq t4 s2 STORE_KEY
		addi t4 t4 1
		blt t4 s0 COLOR_TO_KEY
	_STORE:
	addi t3 t3 1
	addi t1 t1 4
	blt t3 t5 GEN_KEY
	j END_GEN_KEY

STORE_KEY:
	slli t4 t4 2 # index * 4
	add t2 t2 t4
	lw t2 0(t2) # load COLOR[INDEX]
	sw t2 0(t0) # append to KEY
	li a7 1
	mv a0 t2
	ecall
	li a7 4
	la a0 BREAK_LINE
	ecall
	addi t0 t0 4
	j _STORE

END_GEN_KEY:
	li a7 4
	la a0 BREAK_LINE
	ecall
	
	# ------------------
	# GAME LOGIC
	# ------------------
	
	li s1 0 # general counter
	li s10 10 # max_tries
	li s9 0 # num tries
	
	MASTERMIND:
		# show all colors
		la s1 COLORS
		li t0 0 # contador
		MOSTRAR_CORES:
			li a7 1
			lw a0 0(s1)
			ecall
			li a7 4
			la a0 BLANK
			ecall
			addi s1 s1 4
			addi t0 t0 1
			blt t0 s0 MOSTRAR_CORES
		
		
		li a7 4
		la a0 BREAK_LINE
		ecall
		
		# receber 4 entradas e retornar os "pinos
		# pino branco: cor certa lugar errado
		# pino preto: cor certa lugar certo
		
		li t0 0
		li t1 4
		li t2 0
		TRY_LOOP:
			la a0 ENTRADA
			li a7 4
			ecall
			li a7 5
			ecall
			la s1 TRIES
			CHECK_UNICITY_TRY:
				lw s2 0(s1) # carregar prox prekey em s2
				beq a0 s2 TRY_LOOP # if a0 in PRE_KEYS: gen new index
				addi t5 t5 1
				addi s1 s1 4
				blt t5 s0 CHECK_UNICITY_TRY # if a0 not in PRE_KEYS: store index in PRE_KEY
			la s1 TRIES
			add s1 s1 t2
			sw a0 0(s1)
			
			# Check if guess matches
			la s3 BLACK_PINS
			la s4 WHITE_PINS
			CHECK_TRY:
				la s5 KEY
				add t3 s5 t2
				lw t3 0(t3)
				bne t3 a0 CHECK_WHITE_PIN
				lw t4 0(s3)
				addi t4 t4 1
				sw t4 0(s3)
				j INCREMENT
			CHECK_WHITE_PIN:
				li t3 0
				li t4 0
				li t5 4
				la s5 KEY
				CHECK_LOOP:
					lw t5 0(s5)
					beq a0 t5 ADD_WHITE_PIN
					addi t3 t3 1
					addi s5 s5 4
					blt t3 t5 CHECK_LOOP
					j INCREMENT
			ADD_WHITE_PIN:
				lw t3 0(s4)
				addi t3 t3 1
				sw t3 0(s4)
			INCREMENT:
			addi t0 t0 1
			addi t2 t2 4
			blt t0 t1 TRY_LOOP
		
		# Gerar pinos pretos e brancos
		# Mostrar pinos
		li a7 1
		la t0 BLACK_PINS
		lw a0 0(t0)
		ecall
		
		la a0 BLANK
		li a7 4
		ecall
		
		li a7 1
		la t0 WHITE_PINS
		lw a0 0(t0)
		ecall
		
		la a0 BREAK_LINE
		li a7 4
		ecall
		
		# Mostra as tentativas
		la s1 TRIES
		li t0 0 # contador
		li t1 40
		MOSTRAR_TRIES:
			li a7 1
			lw a0 0(s1)
			ecall
			li a7 4
			la a0 BLANK
			ecall
			addi s1 s1 4
			addi t0 t0 1
			blt t0 t1 MOSTRAR_TRIES
		la a0 BREAK_LINE
		li a7 4
		ecall
		
		addi s9 s9 1
		addi s11 s11 1
		blt s9 s10 MASTERMIND
	
	
	li a7,10
	ecall
