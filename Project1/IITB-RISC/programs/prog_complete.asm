org 0x0
lhi r0, 0x2;
lm r0, 0b11111110; Dont load R0

org 0x200
call:
	adc r3,r3,r4; Give ffff in r3
	jlr r2,r1; Branch back to r1

org 0x50
lm_jump: ; lm will turn up here
	add r1,r1,r2; Should set carry and zero 
	ndc r1,r3,r4; Should execute, and put ffff in r1, reset zero
	
	adz r1,r5,r6; Shouldn't execute
	ndu r2,r1,r2; Should set zero
	adz r1,r5,r6; Should set carry and reset zero

	jal r1,#call

	lw r5,r0,0x8; Load 0 and set zero 
	beq r4,r5,0x3

	adi r0,r0,0x08
	sm r0,0b11111111
	sw r5,r0, 0x10
	db 0xffff

org 0x100
data:
	db 0x2
	db 0x0001
	db 0xffff
	db 0x5555
	db 0xaaaa
	db 0xe371
	db 0x2c8e
	db 0x004f
	db 0xaaaa

