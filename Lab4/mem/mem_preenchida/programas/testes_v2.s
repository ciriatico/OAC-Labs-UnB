.text
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
	
T_BRANCH:
	addi t1,zero,-1
	jalr zero,ra,0