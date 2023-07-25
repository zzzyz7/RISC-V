.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 is the pointer to the array
#	a1 is the # of elements in the array
# Returns:
#	None
# ==============================================================================
relu:
    # Prologue
    add t0 x0 x0 # t0->index

loop_start:
    bge t0 a1 loop_end # while(i<a1(# element))
    add t2 t0 x0 # t2->i
    slli t2 t2 2 # t2->i*4
    add t2 a0 t2 # t2=a0+4i
    lw t1 0(t2) # t1=arr[i]

    bge t1 x0  loop_continue # if(a[i]>0)
    sw x0 0(t2) # arr[i]=0
loop_continue:
    addi t0 t0 1 # i++
    j loop_start

loop_end:


    # Epilogue

    
	ret
