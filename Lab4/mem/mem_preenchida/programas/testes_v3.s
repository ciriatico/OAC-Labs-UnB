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
