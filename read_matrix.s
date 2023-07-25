.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory
# ==============================================================================
read_matrix:
    # Prologue
    addi sp sp -52
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
    sw s10 44(sp)
    sw s11 48(sp)
    

    # open file
    mv s0 a0 # save file name
    mv s1 a1 # s1 save rows to s1
    mv s2 a2 # s2 save columns to s2 
    
    # sava file descriptor
    mv a1 s0 # pointer to the string
    li a2 0 # permissions 0 =read
    jal fopen # return a0 contains descriptor
    mv s3 a0 # save file descriptor to s3 

    # mv a1 s3 # save s3 to a1 as file descriptor
    
    # read row pointer
    # li a0 4 # a0 is num bytes for malloc
    # jal malloc # return a0
    # mv s4 a0 # s3 holds buffer for rows

    # mv s11 a0 # s11 holds buffer
    
    mv a1 s3 # save file descriptor to a1
    mv a2 s1 # save buffer as argument (rows) (pointer)
    li a3 4 # num of bytes 
    jal fread # returns a0 stores num bytes actually read
    # mv s4 a0
     li t1 4 
     bne a0 t1 eof_or_error

    # read column pointer
    # li a0 4 # a0 is mun bytes for malloc
    # jal malloc # return a0
    # mv s5 a0 # s5 holds buffer for columns

    mv a1 s3 # sava fild decriptor to a1
    mv a2 s2 # save buffer as argument (columns) (pointer)
    li a3 4 # num of bytess
    jal fread # returns a0
    # mv s5 a0 
     li t2 4
     bne a0 t2 eof_or_error

    lw s6 0(s1) # rows
    lw s7 0(s2) # columns
   
    # create the matrix
    # int array = malloc(*row * *column *4)
    mul a0 s6 s7 # rows x col 
    slli a0 a0 2 # mul a0 by 4
    mv s6 a0 # total size of mat array
    jal malloc # return buffer in a0
    
    mv s8 a0 # save buffer to s8 (pointer)
    mv a1 s3 # a1 = s3 (file descriptor)
    mv a2 s8 # a2 = buffer
    mv a3 s6 # total dimensions 
    jal fread
    mv a0, s8

 
    mv a1 s3 # use file decriptor to close the file
    jal fclose
    li t0 -1
    beq a0 t0 eof_or_error # error check 0 success otherwise -1


    mv a0 s8 # pointer
    # mv a1 s1 # pointer to rows
    # mv a2 s2 # pointer to columns
    
    
    # Epilogue
    
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
    lw s10 44(sp)
    lw s11 48(sp)
    addi sp sp 52

    ret

eof_or_error:
    li a1 1
    jal exit2
