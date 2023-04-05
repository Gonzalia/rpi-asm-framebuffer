
.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32


.globl main
main:
	// X0 contiene la direccion base del framebuffer
 	mov x20, x0	// Save framebuffer base address to x20	
	//---------------- CODE HERE ------------------------------------
	
	movz x10, 0xC7, lsl 16
	movk x10, 0x1585, lsl 00

	mov x2, SCREEN_HEIGH         // Y Size 
loop1:
	mov x1, SCREEN_WIDTH         // X Size
loop0:
	stur w10,[x0]	   // Set color of pixel N
	add x0,x0,4	   // Next pixel
	sub x1,x1,1	   // decrement X counter
	cbnz x1,loop0	   // If not end row jump
	sub x2,x2,1	   // Decrement Y counter
	cbnz x2,loop1	   // if not last row, jump

	//---------------------------------------------------------------
	// Infinite Loop 

InfLoop: 
	b InfLoop

/*
 The map proc stores the memory address of pixel (x, y) in x0.

    Inputs (x3, x4) as coordinates (x, y)
    Uses and modifies registers x21 and x15
    Does not modify x3 and x4
    Output x0 points to pixel (x3, x4) in the main FrameBuffer
*/

map:
    sub sp, sp, #8    
    str x30, [sp]

    mov x21, #4               
    mov x0, x20               
    mov x15, 2560              
    madd x0, x15, x4, x0 	    
    madd x0, x21, x3, x0     

    ldr x30, [sp]
    add sp, sp, #8
    br x30

/*
    squared_background:
    
    This function draws a squared background on the screen with
    alternating colors. The background consists of squares of 
    size 8x8 pixels with two different colors.
    
    Inputs:

    x0: the memory address where the drawing starts
    x1: the screen width
    x2: the screen height
    
    Registers usage:

    x8, x10, x11: temporary registers for the function
    x30: link register
    sp: stack pointer
    
*/

 squared_background:
    sub sp, sp, #32
    stur x0, [sp, #24]
    stur x1, [sp, #16]
    stur x2, [sp, #8]
    stur X30,[SP]

    mov x0, x20
    
    add x8, x0, #4                    
    mov x2, SCREEN_HEIGH             
squared_background_loop1:
    mov x1, SCREEN_WIDTH         
squared_background_loop0:
    stur w10, [x0]           
    stur w11, [x8]           
    add x8, x8, 8            
    add x0, x0, 8            
    sub x1, x1, 2	         
    cbnz x1, squared_background_loop0         
    eor x0, x0, x8
    eor x8, x0, x8
    eor x0, x0, x8
    sub x2, x2, 1  
    cbnz x2, squared_background_loop1

    ldur x0, [sp, #24]
    ldur x1, [sp, #16]
    ldur x2, [sp, #8]
    ldur x30,[sp]
    add sp, sp, #32
