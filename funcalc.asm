;;Jia Wei Hu Lab B2 Oct 29, 2020 This program evaluates an expression
;;and the outputs the result
STR:	DC	"+11*2+1 5\0"
SPTR:	DD	STR

	addi	a0, x0, SPTR		;;pointer to string
	ld	t2, a0, 0		;;get string adress

	
	jal	ra, funCalc		;;goTo funcalc
	ecall	x0, s0, 0		;;print answer
	ebreak	x0, x0, 0
				;;a0 --> s
				;;t0 --> '0' or '+' or '*'
				;;t1 --> '9'
				;;t2 --> *s
				;;t3 --> c
				;;t4 --> 10
				;;
				;;s0 --> res
				;;s1 --> temporay storage of first s0 from recursive call
	
eatblanks:
	addi	t3, x0, 0			;;c = 0
	addi	a4, x0, ' '			;;a4 = ' '
	lb	t3, 0(t2) 			;;c = (*s)[0]	
	addi	t4, x0, 10			;;t4 = 10
eatLoop:
	bne	t3, a4, exitBlank			;;if c != ' ' goTo exitBlank
	addi	t2, t2, 1			;;*s ++
	lb	t3, 0(t2)			;;c = (*s)[0]	
	jal	x0, eatLoop			;;goTo eatLoop
exitBlank:
	jalr	x0, 0(ra)			;;return to ra

funCalc:
	addi	t3, x0, 0			;;c = 0
	addi	s0, x0, 0 			;;res = 0
	addi	t0, x0, '0'			;;t0 ='0'
	addi	t1, x0, '9'			;;t1 ='9'
	
	addi	sp, sp, -8			;;make room in stack
	sd	ra,0(sp)			;;save ra
	jal	ra, eatblanks			;;goTo eatblanks
	ld	ra,0(sp)			;;restore ra
	addi	sp, sp, 8			;;pop stack
	lb	t3, 0(t2) 			;;c = (*s)[0]
	blt	t3, t0, notNum			;;if c < '0' ||
	blt	t1, t3, notNum			;;c > '9' goTo notNum
	addi	s0, x0, 0 			;;res = 0			
numLoop:
	blt	t3, t0, exitNum			;;if c < '0' ||
	blt	t1, t3, exitNum			;;c > '9' goTo notNum
	mul	s0, s0, t4			;;res = res * 10
	add	s0, s0, t3			;;res += c
	sub	s0, s0, t0			;;res -= '0'
	addi	t2, t2, 1			;;*s ++
	lb	t3, 0(t2)			;;c = (*s)[0]
	jal	x0, numLoop			;;goTo numLoop
	
exitNum:
	jalr	x0, 0(ra)			;;goTo ra
notNum:
	addi	t0, x0, '+'			;;t0 = '+'
	bne	t0, t3, notAdd			;;if '+' != c goTo notAdd
	addi	t2, t2, 1			;;*s ++
	addi	sp, sp, -8			;;make room in stack
	sd	ra, 0(sp)			;;store ra
	jal	ra, funCalc			;;goTo funCalc
	ld	ra, 0(sp)			;;restore ra
	addi	sp, sp, 8			;;pop stack
	addi	sp, sp, -16			;;make room in stack
	sd	ra, 0(sp)			;;store ra
	sd	s0, 8(sp)			;;store res
	jal	ra, funCalc			;;goTo funCalc
	ld	s1, 8(sp)			;;s1 = plevious res
	ld	ra,0(sp)			;;restore ra
	addi	sp, sp, 16			;;pop stack
	add	s0, s0, s1			;;res = res + s1
	jalr	x0, 0(ra)			;;goTo ra
notAdd:
	addi	t0, x0, '*'			;;t0 = '*'
	bne	t0, t3, notMul			;;if '*' != c goTo notMul
	addi	t2, t2, 1			;;*s ++
	addi	sp, sp, -8			;;make room in stack
	sd	ra, 0(sp)			;;store ra
	jal	ra, funCalc			;;goTo funCalc
	ld	ra, 0(sp)			;;restore ra
	addi	sp, sp, 8			;;pop stack
	addi	sp, sp, -16			;;make room in stack
	sd	ra, 0(sp)			;;store ra
	sd	s0, 8(sp)			;;store res
	jal	ra, funCalc			;;goTo funCalc
	ld	s1, 8(sp)			;;s1 = previous res
	ld	ra,0(sp)			;;restore ra
	addi	sp, sp, 16			;;pop stack
	mul	s0, s0, s1			;;res = s1 * res
	jalr	x0, 0(ra)			;;goTo ra
notMul:
	addi	s0, x0, -1			;;res = -1
	jalr	x0, 0(ra)			;;goTo ra
	
	