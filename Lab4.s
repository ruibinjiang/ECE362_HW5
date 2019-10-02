.cpu cortex-m0
.thumb
.syntax unified
.fpu softvfp

// External interrupt for pins 0 and 1 is IRQ 5.
.equ EXTI0_1_IRQn,5

// RCC registers
.equ RCC, 0x40021000
.equ AHBENR, 0x14
.equ GPIOAEN, 0x00020000
.equ GPIOBEN, 0x00040000
.equ GPIOCEN, 0x00080000
.equ APB2ENR, 0x18
.equ SYSCFGCOMPEN, 1

// SYSCFG constrol registers
.equ SYSCFG, 0x40010000
.equ EXTICR1, 0x8
.equ EXTICR2, 0xc
.equ EXTICR3, 0x10
.equ EXTICR4, 0x14

// External interrupt control registers
.equ EXTI, 0x40010400
.equ IMR, 0
.equ EMR, 0x4
.equ RTSR, 0x8
.equ FTSR, 0xc
.equ SWIER, 0x10
.equ PR, 0x14

// Variables to register things for pin 0
.equ EXTI_RTSR_TR0, 1
.equ EXTI_IMR_MR0, 1
.equ EXTI_PR_PR0, 1

// NVIC control registers...
.equ NVIC, 0xe000e000
.equ ISER, 0x100
.equ ICER, 0x180
.equ ISPR, 0x200
.equ ICPR, 0x280

// SysTick counter variables...
.equ SYST, 0xe000e000
.equ CSR, 0x10
.equ RVR, 0x14
.equ CVR, 0x18

//=======================================================
// Your translation of
// unsigned int slow_division(unsigned int numer, unsigned int denom)
// {
//    if (denom == 0)
//        return 0;
//    int quotient;
//    for(quotient = 0; numer >= denom; quotient++)
//        numer = numer - denom;
//    return quotient;
// }
//
.global slow_division
slow_division:
	// Student code goes here.
		push {lr}
		movs r2,#0
		cmp r1,r2
		beq endfordiv
		for_div:
			cmp r1,r0
			bls dodiv
			b endfordiv
		dodiv:
			subs r0,r1
		nextdiv:
			adds r2,#1
			b for_div
		endfordiv:
			movs r0,r2

        pop {pc}
	// End of student code.

//=======================================================
// Initialize the SysTick counter.
// You should set the SYST_RVR (reset value register)
// so an exception occurs once per second.
//
// Then set the SYST_CSR (control status register) so
// that it uses the CPU clock as the clock source, enable
// the SysTick exception request, and enable the counter.
//
//=======================================================
// Initialize the SysTick counter.
// You should set the SYST_RVR (reset value register)
// so an exception occurs once per 100 milliseconds.
//
// Then set the SYST_CSR (control status register) so
// that it uses the CPU clock as the clock source, enable
// the SysTick exception request, and enable the counter.
//
.global init_systick
init_systick:
        push {lr}
        // Student code goes here.
		ldr r3, =SYST
		ldr r0, =480000
		str r0, [r3, #RVR]// reset
		movs r0, #7
		str r0, [r3, #CSR]// Enable
	// End of student code.
        pop {pc}

//=======================================================
// Your implementation of a SysTick interrupt handler.
// This is an interrupt service routine.
// Increment the value of the global variable tick_counter
// Display that value with a call to display_led().
//
.type SysTick_Handler, %function
.global SysTick_Handler
SysTick_Handler:
        push {lr}
        // Student code goes here.
		ldr r1,=tick_counter
		ldr r2,[r1]
		adds r2,#1
		str r2,[r1]
		//movs r3,#0xf
		//iftic:
		//	ands r2,r3
		//	cmp r2,r3
		//	bne endiftic
		//thentic:
		//	ldr r1,=seconds
		//	ldr r0,[r1]
		//	adds r0,#1
		//	str r0,[r1]
		movs r0,r2
			bl display_led
		endiftic:

	// End of student code.
	pop {pc}

//=======================================================
// The interrupt handler for Pins 0 and 1.
// The handler should increment the global variable named
// 'button_presses' and call display_led with that value.
// Then it should write EXTI_PR_PR0 to the EXTI_PR register to
// clear the interrupt.
//
// Optionally, you may also call micro_wait() for a
// while to debounce the button press.
//
.type EXTI0_1_IRQHandler, %function
.global EXTI0_1_IRQHandler
EXTI0_1_IRQHandler:
        push {lr}
        // Student code goes here.
	ldr r0, =button_presses
	ldr r1, [r0]
	adds r1, #1
	str r1, [r0]
	movs r0,r1
	//bl display_led

	ldr r3, =SYST
	ldr r0, [r3, #CSR]
	movs r1, #1
	bics r0,r1
	str r0, [r3, #CSR]// Enable

	ldr r0, =EXTI_PR_PR0
	ldr r2, =EXTI
	str r0,[r2,#PR]
	// End of student code.
	pop {pc}

//=======================================================
// OR the value EXTI_RTSR_TR0 into the EXTI_RTSR
// (rising trigger selection register).
// This will tell the EXTI system to flag an interrupt
// on the rising edge of Pin 0.
//
.global init_rtsr
init_rtsr:
        push {lr}
        // Student code goes here.
	ldr r0, =EXTI
	ldr r1,[r0,#RTSR]
	ldr r2,=EXTI_RTSR_TR0
	orrs r1, r2
	str r1,[r0,#RTSR]
	// End of student code.
	pop {pc}

//=======================================================
// OR the value EXTI_IMR_MR0 into EXTI_IMR
// (Interrupt mask register).
// This will unmask the external interrupt for Pin 0.
//
.global init_imr
init_imr:
        push {lr}
        // Student code goes here.
	ldr r0, =EXTI
	ldr r1,[r0,#IMR]
	ldr r2,=EXTI_IMR_MR0
	orrs r1, r2
	str r1,[r0,#IMR]
	// End of student code.
	pop {pc}

//=======================================================
// Write (1 << EXTI0_1_IRQn) into the NVIC_ISER
// (Interrupt set enable register).
// (This value is '1' shifted left by EXTI0_1_IRQn bits.)
// This action will enable the external interrupt for pins 0 and 1.
//
.global init_iser
init_iser:
        push {lr}
        // Student code goes here.
	ldr r0,=NVIC
	movs r1,#1
	lsls r1,#EXTI0_1_IRQn
	ldr r2,=ISER
	ldr r3,[r2]
	str r1,[r0,r2]
	// End of student code.
	pop {pc}


//=======================================================
// Set the SYSCFGCOMPEN bit in the RCC APB2ENR.
// SYSCFG_EXTICR1 &= ~0xf
// SYSCFG_EXTICR1 |= 1
// Set GPIOBEN in the RCC AHBENR.
//
.global enable_pb0
enable_pb0:
        push {lr}
        // Student code goes here.
	ldr r0,=RCC

	ldr r1,=SYSCFGCOMPEN
	str r1,[r0,#APB2ENR]

	movs r1,#0xf
	ldr r0,=SYSCFG
	ldr r2,[r0,#EXTICR1]
	bics r2,r1
	movs r1,#1
	orrs r2,r1
	str r2,[r0,#EXTICR1]

	ldr r0,=RCC
	ldr r1,=GPIOBEN
	str r1,[r0,#AHBENR]
	// End of student code.
	pop {pc}
