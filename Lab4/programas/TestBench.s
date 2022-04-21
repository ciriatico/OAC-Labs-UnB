.text
	auipc t0,0		# teste de auipc: t0 = 0x400000 (endereço 1 da memória)
	lui t1,0x400		# t1 = 0x400000
	auipc a1,0		# t0 (0x400000) == t1 (0x4000000)? RIGHT:ERROR
	jal CHECK
	
	addi t0,zero,0		# teste de jal:
	addi t1,zero,1
	jal T_JAL		# t1 (1) = zero + 0 = 0
	auipc a1,0		# t0 (0) == t1 (0)? RIGHT:ERROR
	jal CHECK
	
	auipc t2,0		# teste de jalr
	jalr zero,t2,12
	addi t1,zero,1		# se jalr não pula adequadamente, t1 = 1
	auipc a1,0		# t0 (0) == t1 (0)? RIGHT:ERROR
	jal CHECK

	auipc ra,0		# teste de beq:
	addi ra,ra,12
	beq t0,t1,T_BRANCH	# se t0 (0) == t1 (0), t1 = -1
	addi t1,t1,1		# se t0 (0) == t1 (0), t1 = -1 + 1 = 0
	auipc a1,0		# t0 (0) == t1 (0)? RIGHT:ERROR
	jal CHECK
	
	addi t2,zero,4		# teste de bge:
	auipc ra,0
	addi ra,ra,12
	bge t2,t1,T_BRANCH	# se t2 (4) >= t1 (0), t1 = -1
	addi t1,t1,1		# se t2 (4) >= t1 (0), t1 = -1 + 1 = 0
	auipc a1,0		# t0 (0) == t1 (0)? RIGHT:ERROR
	jal CHECK
	
	addi t2,zero,-1		# teste de bgeu:
	auipc ra,0
	addi ra,ra,12
	bgeu t2,t1,T_BRANCH	# se |t2| (-1||) >= |t1| (|0|), t1 = -1
	addi t1,t1,1		# se |t2| (|-1|) >= |t1| (|0|), t1 = -1 + 1 = 0
	auipc a1,0		# t0 (0) == t1 (0)? RIGHT:ERROR
	jal CHECK
	
	auipc ra,0		# teste de blt
	addi ra,ra,12
	blt t2,zero,T_BRANCH	# se t2 (-1) < zero (0), t1 = -1
	addi t1,t1,1		# se t2 (-1) < zero (0), t1 = -1 + 1 = 0
	auipc a1,0		# t0 (0) == t1 (0)? RIGHT:ERROR
	jal CHECK
	
	auipc ra,0		# teste de bltu
	addi ra,ra,12
	bltu zero,t2,T_BRANCH	# se |zero| (|0|) < |t2| (|-1|), t1 = -1
	addi t1,t1,1		# se |zero| (|0|) < |t2| (|-1|), t1 = -1 + 1 = 0
	auipc a1,0		# t0 (0) == t1 (0)? RIGHT:ERROR
	jal CHECK
	
	auipc ra,0		# teste de bne
	addi ra,ra,12
	bne t2,zero,T_BRANCH	# se zero (0) != t2 (-1), t1 = -1
	addi t1,t1,1		# se zero (0) != t2 (-1), t1 = -1
	auipc a1,0		# t0 (0) == t1 (0)? RIGHT:ERROR
	jal CHECK

	addi t0,zero,2		# teste de addi: t1=2+0 == 2? RIGHT:ERROR
	addi t1,zero,2
	auipc a1,0
	jal CHECK

	lui t0,0		# teste de add: t1 = t1 (2) + t2 (-2) == 0? RIGHT:ERROR
	addi t2,zero,-2
	add t1,t1,t2
	auipc a1,0
	jal CHECK

	addi t1,zero,1 		# teste de sub: t1 (1) - t2 (1) == 0? RIGHT:ERROR
	addi t2,zero,1
	sub t1,t1,t2
	auipc a1,0
	jal CHECK

	addi t0,zero,-1 	# teste de and: t1 (-1) & t2 (-1) == -1? RIGHT: ERROR
	addi t1,zero,-1
	addi t2,zero,-1
	and t1,t1,t2
	auipc a1,0
	jal CHECK

	lui t0,0		# teste de andi: t1 (-1) & imm (0) == 0? RIGHT:ERROR
	andi t1,t1,0
	auipc a1,0
	jal CHECK

	addi t0,zero,-1		# teste de or: t1 (0) | t0 (-1) == -1? RIGHT:ERROR
	lui t1,0
	or t1,t1,t0
	auipc a1,0
	jal CHECK

	lui t1,0		# teste de ori: t1 (0) | imm (-1) == -1? RIGHT:ERROR
	ori t1,t1,-1
	auipc a1,0
	jal CHECK

	addi t0,zero,4		# teste de sll: t1 (1) << t2 (2) == 4? RIGHT:ERROR
	addi t1,zero,1
	addi t2,zero,2
	sll t1,t1,t2
	auipc a1,0
	jal CHECK

	addi t0,zero,8		# teste de slli: t1 (1) << imm (3) == 8? RIGHT:ERROR
	addi t1,zero,1
	slli t1,t1,3
	auipc a1,0
	jal CHECK

	addi t0,zero,1 		# teste de slt: t2 (-1) < t1 (0) == 1? RIGHT:ERROR
	lui t1,0
	addi t2,zero,-1
	slt t1,t2,t1
	auipc a1,0
	jal CHECK

	lui t0,0		# teste de slti: t1 (0) < imm (0) == 0? RIGHT:ERROR
	lui t1,0
	slti t1,t1,0
	auipc a1,0
	jal CHECK

	addi t0,zero,1 		# teste de sltiu: t1 (0) < |imm| (|-1|) == 1? RIGHT:ERROR
	sltiu t1,t1,-1
	auipc a1,0
	jal CHECK

	lui t0,0		# teste de sltu: |t1| (|-1|) < |t2| (|-2|) == 0? RIGHT:ERROR
	addi t1,zero,-1
	addi t2,zero,-2
	sltu t1,t1,t2
	auipc a1,0
	jal CHECK

	li t2,0x10010000 	# testa sw e lw
	addi t0,zero,-1		# M = -1
	addi t1,zero,-1		# t1 = M (-1)
	sw t1,0(t2)		# t1 (-1) == -1? RIGHT:ERROR
	lw t1,0(t2)
	auipc a1,0
	jal CHECK
	li a0,0xCCCCCCCC

EXIT:
	jal EXIT	

ERROR:
	li a0,0xEEEEEEEE
	jal EXIT

CHECK:
	beq t0,t1,RIGHT
	jal ERROR

RIGHT:
	jalr zero,ra,0
	
T_JAL:
	addi t1,zero,0
	jalr zero,ra,0

T_BRANCH:
	addi t1,zero,-1
	jalr zero,ra,0
