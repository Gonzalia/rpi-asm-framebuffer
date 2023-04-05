
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
    The draw_chunk2 function draws an 8x8 pixel block in the main FrameBuffer.

    Inputs: (x3, x4) <- initial direction upper left corner
    w12 <- color

    Uses and does not modify registers x3, x4, x0, x2

    Modifies registers x8 and x9 in addition to using them

    Uses the map function
*/

draw_chunk:
    sub sp, sp, #40
    str x2, [sp, #32]
    str x3, [sp, #24]
    str x4, [sp, #16]
    str x0, [sp, #8]
    str x30, [sp]

    bl map
    mov x2, #8
draw_chunk_loop1:
    mov x8, #8
draw_chunk_loop2:
    str w12, [x0]
    add x0, x0, #4
    sub x8, x8, #1
    cbnz x8, draw_chunk_loop2
    add x4, x4, 0x1
    bl map2
    sub x2, x2, #1
    cbnz x2, draw_chunk_loop1

    ldr x2, [sp, #32]
    ldr x3, [sp, #24]
    ldr x4, [sp, #16]
    ldr x0, [sp, #8]
    ldr x30, [sp]
    add sp, sp, #40
    br x30
