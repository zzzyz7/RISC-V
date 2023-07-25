.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	a1 is the # of rows (height) of m0
#	a2 is the # of columns (width) of m0
#	a3 is the pointer to the start of m1
# 	a4 is the # of rows (height) of m1
#	a5 is the # of columns (width) of m1
#	a6 is the pointer to the the start of d
# Returns:
#	None, sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error if mismatched dimensions
    bne a2 a4 mismatched_dimensions

    # Prologue
    addi sp sp -44
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)
    sw s6 28(sp)
    sw s7 32(sp)
    sw s8 36(sp)
    sw s9 40(sp)

    # Save argument
    mv s0 a0 # pointer to the start of m0
    mv s1 a1 # number of rows of m0
    mv s2 a2 # number of columns of m0
    mv s3 a3 # pointer to the start of m1
    mv s4 a4 # number of rows of m1
    mv s5 a5 # number of columns of m1
    mv s6 a6 # start of d
    mv s9 a6 # save a0 to s9

    li s7 0 # for outer_loop count
    li s8 0 # for inner_loop count

outer_loop_start: 
   bge s7 s1 outer_loop_end # i = row of m0 end
   j inner_loop_start



inner_loop_start:
   bge s8 s5 inner_loop_end # j = column of m1 end

   li t0 4 
   mul t0 s2 t0 # column of m0*4
   mul t0 s7 t0 # outer count*4
   add a0 s0 t0 

   li t0 4
   mul t0 t0 s8 # inner count*4
   add a1 s3 t0

   mv a2 s2 
   li a3 1
   mv a4 a5


   jal ra dot

   sw a0 0(s6)
   addi s6 s6 4

   addi s8 s8 1 # j++ 
   j inner_loop_start


inner_loop_end: 
    li s8 0

    addi s7 s7 1 # i++
    j outer_loop_start


outer_loop_end:


    # Epilogue
    mv a6 s9  
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    lw s5 24(sp)
    lw s6 28(sp)
    lw s7 32(sp)
    lw s8 36(sp)
    lw s9 40(sp)
    addi sp sp 44
    
    ret


mismatched_dimensions:
    li a1 2
    jal exit2
