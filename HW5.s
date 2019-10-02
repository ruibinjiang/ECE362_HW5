.cpu cortex-m0
.thumb
.syntax unified
.fpu softvfp

.equ RCC,       0x40021000
.equ GPIOA,     0x48000000
.equ GPIOC,     0x48000800
.equ AHBENR,    0x14
.equ APB2ENR,   0x18
.equ APB1ENR,   0x1c
.equ IOPAEN,    0x20000
.equ IOPCEN,    0x80000
.equ SYSCFGCOMPEN, 1
.equ TIM3EN,    2
.equ MODER,     0x00
.equ OSPEEDR,   0x08
.equ PUPDR,     0x0c
.equ IDR,       0x10
.equ ODR,       0x14
.equ BSRR,      0x18
.equ BRR,       0x28
.equ PC8,       0x100

// SYSCFG control registers
.equ SYSCFG,    0x40010000
.equ EXTICR2,   0x0c

// NVIC control registers
.equ NVIC,      0xe000e000
.equ ISER,      0x100

// External interrupt control registers
.equ EXTI,      0x40010400
.equ IMR,       0
.equ RTSR,      0x8
.equ PR,        0x14

.equ TIM3,      0x40000400
.equ TIMCR1,    0x00
.equ DIER,      0x0c
.equ TIMSR,     0x10
.equ PSC,       0x28
.equ ARR,       0x2c

// Iinterrupt number for EXTI4_15 is 7.
.equ EXTI4_15_IRQn,  7
// Interrupt number for Timer 3 is 16.
.equ TIM3_IRQn,  16

//=====================================================================
// Q1
//=====================================================================
.global euclidean
euclidean:
push {lr}
ife1:
cmp r0,r1
beq ende

ife2:
cmp r0,r1
bhi returneb

returnec:
subs r1,r0
bl euclidean
b ende


returneb:
subs r0,r1
bl euclidean

ende:
pop {pc}

//=====================================================================
// Q2
//=====================================================================
.global enable_porta
enable_porta:
push {lr}
ldr r0, =RCC
ldr r1,[r0,#AHBENR]
ldr r2, =IOPAEN
orrs r1,r2
str r1,[r0,#AHBENR]
pop {pc}

//=====================================================================
// Q3
//=====================================================================
.global enable_portc
enable_portc:
push {lr}
ldr r0, =RCC
ldr r1,[r0,#AHBENR]
ldr r2, =IOPCEN
orrs r1,r2
str r1,[r0,#AHBENR]
pop {pc}

//=====================================================================
// Q4
//=====================================================================
.global setup_pa4
setup_pa4:
push {lr}
ldr r0, =GPIOA
ldr r1,[r0,#MODER]
ldr r2, =0x300
bics r1,r2
str r1,[r0,#MODER]

ldr r1,[r0,#PUPDR]
bics r1,r2
ldr r2, =0x100
orrs r1,r2
str r1,[r0,#PUPDR]

pop {pc}

//=====================================================================
// Q5
//=====================================================================
.global setup_pa5
setup_pa5:
push {lr}
ldr r0, =GPIOA
ldr r1,[r0,#MODER]
ldr r2, =0xC00
bics r1,r2
str r1,[r0,#MODER]

ldr r1,[r0,#PUPDR]
bics r1,r2
ldr r2, =0x800
orrs r1,r2
str r1,[r0,#PUPDR]

pop {pc}

//=====================================================================
// Q6
//=====================================================================
.global setup_pc8
setup_pc8:
push {lr}
ldr r0, =GPIOC
ldr r1,[r0,#MODER]
ldr r2, =0x30000
bics r1,r2
ldr r2, =0x10000
orrs r1,r2
str r1,[r0,#MODER]

ldr r1,[r0,#OSPEEDR]
ldr r2, =0x30000
bics r1,r2
ldr r2, =0x30000
orrs r1,r2
str r1,[r0,#OSPEEDR]

pop {pc}

//=====================================================================
// Q7
//=====================================================================
.global setup_pc9
setup_pc9:
push {lr}
ldr r0, =GPIOC
ldr r1,[r0,#MODER]
ldr r2, =0xC0000
bics r1,r2
ldr r2, =0x40000
orrs r1,r2
str r1,[r0,#MODER]

ldr r1,[r0,#OSPEEDR]
ldr r2, =0xC0000
bics r1,r2
ldr r2, =0x40000
orrs r1,r2
str r1,[r0,#OSPEEDR]

pop {pc}

//=====================================================================
// Q8
//=====================================================================
.global action8
action8:
push {lr}
ldr r0, =GPIOA
ldr r1, =0b10000

ldr r2, [r0,#IDR]
ands r2,r1
cmp r2,r1
bne end81

ldr r2, [r0,#IDR]
ldr r1, =0b100000
ands r2,r1
cmp r2,#0
bne end81


end80:
ldr r0, =GPIOC
ldr r1, [r0,#ODR]
ldr r2, =PC8
bics r1,r2
str r1, [r0,#ODR]
b end8

end81:
ldr r0, =GPIOC
ldr r1, [r0,#ODR]
ldr r2, =PC8
orrs r1,r2
str r1, [r0,#ODR]
end8:
pop {pc}


//=====================================================================
// Q9
//=====================================================================
.global action9
action9:
push {lr}
ldr r0, =GPIOA
ldr r1, =0b10000

ldr r2, [r0,#IDR]
ands r2,r1
cmp r2,#0
bne end91

ldr r2, [r0,#IDR]
ldr r1, =0b100000
ands r2,r1
cmp r2,r1
bne end91


end90:
ldr r0, =GPIOC
ldr r1, [r0,#ODR]
ldr r2, =PC8
lsls r2,#1
bics r1,r2
str r1, [r0,#ODR]
b end9

end91:
ldr r0, =GPIOC
ldr r1, [r0,#ODR]
ldr r2, =PC8
lsls r2,#1
orrs r1,r2
str r1, [r0,#ODR]
end9:

pop {pc}

//=====================================================================
// Q10
//=====================================================================
.type EXTI4_15_IRQHandler, %function
.global EXTI4_15_IRQHandler
EXTI4_15_IRQHandler:
push {lr}
ldr r0,=EXTI
ldr r1,[r0,#PR]
ldr r2,=0b10000
orrs r1,r2
str r1,[r0,#PR]

ldr r0, =counter
ldr r1,[r0]
adds r1,#1
str r1,[r0]

pop {pc}

//=====================================================================
// Q11
//=====================================================================
.global enable_exti4
enable_exti4:
push {lr}
	ldr r0,=RCC
	ldr r1,=SYSCFGCOMPEN
	str r1,[r0,#APB2ENR]

	movs r1,#0xf
	ldr r0,=SYSCFG
	ldr r2,[r0,#EXTICR2]
	bics r2,r1
	str r2,[r0,#EXTICR2]

	ldr r0,=RCC
	ldr r1,=IOPAEN
	str r1,[r0,#AHBENR]




	ldr r0, =EXTI
	ldr r1,[r0,#RTSR]
	ldr r2,=0b10000
	orrs r1, r2
	str r1,[r0,#RTSR]

	ldr r0, =EXTI
	ldr r1,[r0,#IMR]
	ldr r2,=0b10000
	orrs r1, r2
	str r1,[r0,#IMR]

	ldr r0,=NVIC
	movs r1,#1
	lsls r1,#EXTI4_15_IRQn
	ldr r2,=ISER
	ldr r3,[r2]
	str r1,[r0,r2]

pop {pc}

//=====================================================================
// Q12
//=====================================================================
.type TIM3_IRQHandler, %function
.global TIM3_IRQHandler
TIM3_IRQHandler:
	ldr r0, =GPIOC
	ldr r1, [r0,#ODR]
	ldr r2, =PC8
	lsls r2,#1
	eors r1,r2
	str r1, [r0,#ODR]

	ldr r0,=TIM3
	ldr r1,[r0,#TIMSR]
	movs r2,#1
	bics r1,r2
	str r1,[r0,#TIMSR]

	bx lr
//=====================================================================
// Q13
//=====================================================================
.global enable_tim3
enable_tim3:
	push {lr}
	ldr r0, =RCC
	ldr r1, [r0, #APB1ENR]
	ldr r2, =0x2
	orrs r1, r2
	str r1, [r0, #APB1ENR]

	ldr r0, =TIM3
	ldr r1, =47
	str r1, [r0, #PSC]
	ldr r1, =1999999
	str r1, [r0, #ARR]

	ldr r1, [r0, #DIER]
	movs r2, #1
	orrs r1, r2
	str r1, [r0, #DIER]

	ldr r1, [r0, #TIMCR1]
	movs r2, #1
	orrs r1, r2
	str r1, [r0, #TIMCR1]

	ldr r0, =NVIC
	ldr r1, =ISER
	ldr r2, =(1<<TIM3_IRQn)
	str r2, [r0, r1]
	pop {pc}
