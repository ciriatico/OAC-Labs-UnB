.data
COLORS: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
PRE_KEY: .word 0,0,0,0
KEY: .word 0,0,0,0
TRIES: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
BLACK_PINS: .word 0
WHITE_PINS: .word 0
NUM_TRIES: .word 0
LEVEL: 5
INPUT: .word 0

#Bridge
TAMANHO: 44
NOTAS: .word 77,130,76,130,73,130,72,130,73,130,72,130,71,130,73,130,72,391,67,391,67,130,72,130,77,130,76,130,73,130,72,130,71,130,69,130,79,130,77,130,76,261,77,261,79,261,79,130,82,130,83,130,82,130,79,130,77,130,79,130,77,130,79,130,82,130,79,391,72,391,72,130,74,130,76,391,77,391,81,261,79,261,74,261,73,261,67,261


.eqv MMIO_add 0xff200004 # Data (ASCII value)
.eqv MMIO_set 0xff200000 # Control (boolean)


.text

GAME_START:
	# add lvl by 1
    la t0 LEVEL
    lw t1 0(t0)
    addi t1 t1 1
    sw t1 0(t0)

DEFEAT:

    # Clear vectors

    # NUM_TRIES
    la t0 NUM_TRIES
    lw t1 0(t0)
    li t2 0
    sw t2 0(t0)

    # pre_key and key
    li t0 0
    li t1 4
    la t2 KEY
    la t3 PRE_KEY
    CLEAR_KEYS:
        sw zero 0(t2)
        sw zero 0(t3)
        addi t2 t2 4
        addi t3 t3 4
        addi t0 t0 1
        blt t0 t1 CLEAR_KEYS

    # Clear tries
    li t0 0
    li t1 40
    la t2 TRIES
    li t3 -1
    CLEAR_TRIES:
        sw t3 0(t2)
        addi t2 t2 4
        addi t0 t0 1
        blt t0 t1 CLEAR_TRIES

    # --------------------------------------------------
    # generate keys
    # --------------------------------------------------
    la s0 LEVEL
    lw s0 0(s0)
    li t4 0
    li s1 0x010 # color
    la t0 COLORS
    GEN_COLOR:
        sw s1, 0(t0) # store color in color list
        addi s1 s1 4 # next color
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
        addi t2 t2 -20
        sw t2 0(t0) # append to KEY
        mv a0 t2
        li a7 1
        #ecall
        addi t0 t0 4
        j _STORE

    END_GEN_KEY:

    # render map
    li a2 0
    la a1 table
    call RENDER

    # render colors over map
    li s3 0
    la a1 COLORS
    call RENDER_COLORS
AFTER_RENDER:

GAME_LOOP:
	li s0 0
INPUT_LOOP:
    li t0, MMIO_set # ready bit MMIO
	lb t1,(t0)
	beqz t1 INPUT_LOOP # wait time enquanto ready bit == 0
	li a0, MMIO_add # Data address MMIO
	lw a0,(a0) # Recupera o valor de MMIO

	# check if input == enter
	li t2 10
	beq a0 t2 SKIP_NUM_GEN
	
	# check if inputis valid:
	li t4 48
	blt a0 t4 INPUT_LOOP
	li t4 57
	bgt a0 t4 INPUT_LOOP
	
	# generate number:
	addi a0 a0 -48
	
	mul s0 s0 t2
	add s0 s0 a0
	
	j INPUT_LOOP
SKIP_NUM_GEN:

	# turn input into color index
    #mv s0 a0
    li t0 -192
	beq s0 t0 GAME_LOOP
    slli s0 s0 2

	# Check if it's a new sequence
	la t0 NUM_TRIES
	lw t0 0(t0)
	li t1 4
	rem t0 t0 t1
	
	bnez t0 SKIP_CLEAR_TRIES
	# Clear pins
	la t0 BLACK_PINS
	sw zero 0(t0)
	la t0 WHITE_PINS
	sw zero 0(t0)
	
	# Clear tries
    li t0 0
    li t1 40
    la t2 TRIES
    li t3 -1
    CLEAR_TRIES_LOOP:
        sw t3 0(t2)
        addi t2 t2 4
        addi t0 t0 1
        blt t0 t1 CLEAR_TRIES_LOOP
	
	SKIP_CLEAR_TRIES:
	
	la t0 INPUT
	sw s0 0(t0)
	
    # if color matches and is unique: add to tries and increment num_tries 
    la t0 TRIES
    li t1 0
    li t2 40
    CHECK_UNICITY_TRY:
        lw t3 0(t0) # carregar prox trie em t3
        beq s0 t3 GAME_LOOP # if s0 already in tries: gen new index
        addi t1 t1 1
        addi t0 t0 4
        blt t1 t2 CHECK_UNICITY_TRY # if a0 not in TRIES: store trie in TRIES
    la t0 TRIES
    la t1 NUM_TRIES
    lw t2 0(t1)
    addi t3 t2 1 # increment num_tries
    sw t3 0(t1) # store num_tries
    slli t2 t2 2
    add t0 t0 t2
    sw s0 0(t0)
    
    # Check if guess matches
    la t2 NUM_TRIES
    lw t2 0(t2)
    addi t2 t2 -1
    li t0 4
    rem t2 t2 t0
    slli t2 t2 2
    
    la s3 BLACK_PINS
    la s4 WHITE_PINS
    CHECK_TRY:
        la s5 KEY
        add t3 s5 t2
        lw t3 0(t3)       
        bne t3 s0 CHECK_WHITE_PIN
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
            lw t6 0(s5)
            beq s0 t6 ADD_WHITE_PIN
            addi t3 t3 1
            addi s5 s5 4
            blt t3 t5 CHECK_LOOP
            j INCREMENT
    ADD_WHITE_PIN:
        lw t3 0(s4)
        addi t3 t3 1
        sw t3 0(s4)

	#SKIP
	INCREMENT:
	la a0 WHITE_PINS
	lw a0 0(a0)
	li a7 1
	#ecall


    # change ball color
    mv t0 s0 # colors[index]    
    addi t0 t0 16
    
    la t1 circle
    lw t2 0(t1)
    mul t3 t2 t2 # num pixels
    addi t1 t1 8
    li t2 0
    li t4 -1
    li t5 -57
    
    CHANGE_COLOR_CIRCLE:
        lb t6 0(t1)
        beq t6 t5 SKIP_PIXEL_PAINT 
        beq t6 t4 SKIP_PIXEL_PAINT 
        sb t0 0(t1)
    SKIP_PIXEL_PAINT:
        addi t1 t1 1
        addi t2 t2 1
        blt t2 t3 CHANGE_COLOR_CIRCLE

    # render circles
    li t0 32
    la t3 NUM_TRIES
    lw t3 0(t3)
    li a2 4
    addi t3 t3 -1
    mv t4 t3
    rem t3 t3 a2
    addi t3 t3 1
    mul t3 t3 t0
    li t0 320
    mul t3 t3 t0
    
    li a2 0
    
    srli t4 t4 2
    
    li t2 16
    
    mul t2 t2 t4
    add a2 t3 t2
    
    addi a2 a2 80
    
    li t0 15360
    add a2 a2 t0 # adjust starting point
    la a1 circle
    call RENDER
    
    # -----------
    # Check PINS
    # -----------
    la t3 NUM_TRIES
    lw t3 0(t3)
    li t2 4
    rem t3 t3 t2
    li a2 12240
    bnez t3 SKIP_PINS_RENDER
    la t3 NUM_TRIES
	lw t3 0(t3)
	li t4 4
	div t3 t3 t4
	addi t3 t3 -1
	li t4 16
	mul t3 t3 t4	
	add a2 a2 t3
   	PINS_RENDER_LOOP:
    li s5 0 # contador de pins -> geral   
    # soma start, soma 8, soma 5120-8, soma 8 
    # render black_pin
    li s4 0 # contador de pins pretos
	RENDER_BLACK_PINS_LOOP:
	la t0 BLACK_PINS
	lw t0 0(t0)
	addi s4 s4 1
	bgt s4 t0 END_BLACK_PINS_RENDER
	addi s5 s5 1
	li t0 2
	bne s5 t0 BLP_NEXT1
	addi a2 a2 8
	BLP_NEXT1:
	li t0 3
	bne s5 t0 BLP_NEXT2
	li t1 5112
	add a2 a2 t1
	BLP_NEXT2:
	li t0 4
	bne s5 t0 RENDER_BLACK_PINS_START
	addi a2 a2 8	
RENDER_BLACK_PINS_START:
    la a1 black_pin
    call RENDER
   
   	la t0 BLACK_PINS
   	lw t0 0(t0)
   	blt s4 t0 RENDER_BLACK_PINS_LOOP
	END_BLACK_PINS_RENDER:
    
    #render white_pin
        li s4 0 # contador de pins pretos
	RENDER_WHITE_PINS_LOOP:
	la t0 WHITE_PINS
	lw t0 0(t0)
	addi s4 s4 1
	bgt s4 t0 END_WHITE_PINS_RENDER
	addi s5 s5 1
	li t0 2
	bne s5 t0 WHP_NEXT1
	addi a2 a2 8
	WHP_NEXT1:
	li t0 3
	bne s5 t0 WHP_NEXT2
	li t1 5112
	add a2 a2 t1
	WHP_NEXT2:
	li t0 4
	bne s5 t0 RENDER_WHITE_PINS_START
	addi a2 a2 8	
RENDER_WHITE_PINS_START:
    la a1 white_pin
    call RENDER
   
   	la t0 WHITE_PINS
   	lw t0 0(t0)
   	blt s4 t0 RENDER_WHITE_PINS_LOOP
	END_WHITE_PINS_RENDER:
SKIP_PINS_RENDER:

	# Color sound
	la s0 INPUT
	lw a0 0(s0)
	addi a0 a0 12
	li a1 500
	mv a2 s0
	li a2 7
	li a3 100
	li a7 33
	ecall


    # ----------
    # Check WIN
    # ----------    
    la t0 BLACK_PINS
		lw t1 0(t0)
		li t2 4		
		beq t1 t2 WIN
    
    la t3 NUM_TRIES
    lw t3 0(t3)
    li t4 40    
    blt t3 t4 GAME_LOOP
	beq t3 t4 DEFEAT

WIN:
	
	# Victory music
	li a2 7
	li a3 60
	li t0 10
	li t1 0
	la t2 NOTAS
	li a7 33
	LOOP_MUSICA:
	lw a0 0(t2)
	lw a1 4(t2)
	addi t2 t2 8
	addi t1 t1 1
	ecall
	blt t1 t0 LOOP_MUSICA
	
    j GAME_START

# render image
# image label ->a0

RENDER_CIRCLES:


RENDER_COLORS:
    la a1 COLORS
    la a3 block2
    # contadores s3 e s4
    li t4 0
    slli s2 s3 2
    add a1 a1 s2
    lw t0 0(a1)
    lw t1 0(a3)
    lw t2 4(a3)
    addi a3 a3 8
    mul t3 t1 t2
    CHANGE_COLOR:
        sb t0 0(a3)
        addi a3 a3 1
        addi t4 t4 1
    blt t4 t3 CHANGE_COLOR

    srli t2 s3 1
    li t0 320
    li t1 8
    mul t2 t1 t2
    mul a2 t0 t2
    addi a2 a2 32
    A2_LOGIC:
        li t0 2
        rem t0 s3 t0
        beqz t0 SKIP_A2
        addi a2 a2 8

    SKIP_A2:
    # pass block as argument and call render
    la a1 block2
    call RENDER
    addi s3 s3 1

    # check if counter is equal to level
    la t0 LEVEL
    lw t0 0(t0)
    blt s3 t0 RENDER_COLORS
    j AFTER_RENDER

RENDER:
lw t0 0(a1) # x
lw t1 0(a1) # y
mul s2 t1 t0 # area
addi a1 a1 8
li t3 0
li t4 0
li s0 0xFF000000
add s0 s0 a2
RENDER_LOOP:
    lw t5 0(a1)
    sw t5 0(s0)
    addi a1 a1 4
    addi s0 s0 4
    addi t3 t3 4
    addi t4 t4 4
    bge t4 t0 NEW_LINE
AFTER_NEW_LINE:
    blt t3 s2 RENDER_LOOP
END_RENDER:
    ret
NEW_LINE:
    li t4 320
    sub t4 t4 t0
    add s0 s0 t4
    li t4 0
    j AFTER_NEW_LINE

EXIT:
    li a7 10
    ecall

.data
.include "./assets/table.s"
.include "./assets/circle.s"
.include "./assets/black_pin.s"
.include "./assets/white_pin.s"
.include "./assets/block2.s"
