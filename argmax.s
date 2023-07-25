.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 is the pointer to the start of the vector
#	a1 is the # of elements in the vector
# Returns:
#	a0 is the first index of the largest element
# =================================================================
argmax:

    # Prologue
    li t0, 0 # int index = 0
    li t2, 0 # int max_index = 0
    li t3, 0 # t3 =max_value


loop_start:
    beq t0 , a1 loop_end # while(i<n)
    lw t1, 0(a0) # t1 = arr[i]
    bge t1, t3 loop_continue # if(a[i]>=max_value(t3)) true condition 
    
    addi a0,a0,4 # a0+4
    addi t0,t0,1 # i++
    j loop_start

    
loop_continue:
    # a[i]>max_value true condition
    mv t3, t1 # save the a[i] to max_value (max_value = a[i]) 
    mv t2, t0 # save the i to max_index (max_index = i)
    addi, a0, a0, 4 # a0+4
    addi, t0, t0, 1 # i++
    j loop_start 

   
   
loop_end:
    mv a0, t2 # save the max index to a0
   

    
    # Epilogue
    



    ret
