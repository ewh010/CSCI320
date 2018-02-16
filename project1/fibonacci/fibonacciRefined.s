.global __start     # export start symbol
.text

__start:            # define entry point for gcc

li 		$sp, 0x7ffffffc
li 		$a0, 10 # this number represents the nth fibonacci number - e.g. f(10) = 55
nop			#upon compile, the nop will follow the jal to fill the branch delay slot.
jal 	fibonacci

# print the value
add	$a0, $v0, $zero #Move fibonacci's return value to the argument.
li	$v0, 1		# set for print integer syscall.
syscall

# end the program
li 		$v0, 10
syscall

fibonacci:
	addi 	$sp, $sp, -12
	sw		$ra, 8($sp)
	sw		$s0, 4($sp)
	sw		$s1, 0($sp)

	add 	$s0, $a0, $zero
	li 		$v0, 1 			# return the value of base case
	li 		$t2, 3
	li 		$t3, 1
	slt 	$t4, $s0, $t2  	# base case
	beq 	$t4, $t3, fibonacciTerminate
	nop			#compile automatically adds nop after beq, so this is probably extraneous

	addi 	$a0, $s0, -1 	# fibonacci(n-1)
	nop			#nop again, because of the compile.
	jal 	fibonacci

	add 	$s1, $v0, $zero   # store result of fibonacci(n-1) to s1

	addi 	$a0, $s0, -2 	# fibonacci(n-2)
	nop
	jal 	fibonacci
	add 	$v0, $s1, $v0 	# fibonacci(n-1) + fibonacci(n-2)

fibonacciTerminate:
	lw 		$ra, 8($sp)
	lw 		$s0, 4($sp)
	lw 		$s1, 0($sp)
	addi	$sp, $sp, 12
	nop
	jr 		$ra
