.import ../read_matrix.s
.import ../write_matrix.s
.import ../matmul.s
.import ../dot.s
.import ../relu.s
.import ../argmax.s
.import ../utils.s

.data
output_step1: .asciiz "\n**Step 1: hidden_layer = matmul(m0, input)**\n"
output_step2: .asciiz "\n**Step 2: NONLINEAR LAYER: ReLU(hidden_layer)** \n"
output_step3: .asciiz "\n**Step 3: Linear layer = matmul(m1, relu)** \n"
output_step4: .asciiz "\n**Step 4: Argmax ** \n"
.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <INPUT_PATH> <M0_PATH> <M1_PATH> <OUTPUT_PATH>

    # Exit if incorrect number of command line args
    li t0 4
    blt a0 t0 error_num_args

# Prologue
    addi sp sp -52
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw s9 36(sp)
    sw s10 40(sp)
    sw s11 44(sp)
    sw ra 48(sp)


    mv s0 a1 # save argc into s0

	# =====================================
    # LOAD MATRICES
    # =====================================



    # Load pretrained m0
    li a0 4
    jal ra malloc
    mv s1 a0 # pointer to number of rows

    li a0 4
    jal ra malloc
    mv s2 a0 # pointer to number of columns

    lw a0 8(s0) 
    mv a1 s1 # save s1 to a1 (pointer to row)
    mv a2 s2 # save s2 to a2 (pointer to columns)
    jal ra read_matrix

    mv s3 a0 # save pointer to the matrix in memeory (m0)
    # mv a0 s3
     # lw a1 0(s1) 
     # lw a2 0(s2) 
     # jal ra print_int_array
     # jal error_num_args



    # Load pretrained m1
    li a0 4
    jal ra malloc
    mv s4 a0 # set the pointer to number of rows

    li a0 4
    jal ra malloc
    mv s5 a0 # set the pointer to number of columns
    
    lw a0 12(s0)
    mv a1 s4 # save s4 to a1 (pointer to rows)
    mv a2 s5 # save s5 to a2 (pointer to columns)
    jal ra read_matrix
    mv s6 a0 # save pointer to the matrix in memory (m1)
    mv a0 s6
    # lw a1 0(s4) 
    # lw a2 0(s5) 
    # jal ra print_int_array



    # Load input matrix
    li a0 4
    jal ra malloc
    mv s7 a0 # pointer to number of row
    li a0 4
    jal ra malloc
    mv s8 a0 # pointer to number of column
    
    lw a0 4(s0) # pointer to string
    mv a1 s7 # save s7 to a1 (pointer to rows)
    mv a2 s8 # save s8 to a2 (pointer to columns) (input)
    jal ra read_matrix
    mv s9 a0 # save pointer to maxtrix in memory (input)
    
    #  mv a0 s9
    # lw a1 0(s7) 
    #  lw a2 0(s8) 
    # jal ra print_int_array


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    
     lw t0 0(s1) # m0 rows
     # mv a1 t0
     # jal print_int
     # mv a1 t0
     # jal print_int
     lw t1 0(s8) # input cols
     # mv a1 t1
     # jal print_int 
     mul a1 t0 t1 # output array dimensions
     slli a1 a1 2 # multi 4
     jal ra malloc
     mv s10 a0 # pointer to the "d"

     mv a0 s3 # s3 is the pointer of m0
     lw a1 0(s1) # rows of m0 (argument for matmul a1)
     # lw t0 0(a1) # save row
     lw a2 0(s2) # columns of m0 (argument for matmul a2)
     # mv t0 a1 # save a1 into t0
     
     mv a3 s9 # s9 is the pointer of input
     lw a4 0(s7) # rows of input (argument for matmul a4)
     lw a5 0(s8) # columns of input (argument for matmul a5)
     # lw t1 0(a5) 
     # li t1 1 # save column 
     mv a6 s10 # pointer to the "d"
     jal ra matmul
     
     
    
    # Output of stage 1
     la a1, output_step1
     jal print_str

     # li t0 3
     # li t1 1 
     # # FILL OUT
     mv a0 s10 # Base ptr
     lw a1 0(s1) # rows
     lw a2 0(s8) # cols
     jal print_int_array 
    
  


    # 2. NONLINEAR LAYER: ReLU(m0 * input)

    mv a0 s10 # save the pointer to a0
    mv t3 a0
    lw t0 0(s1) # save m0 rows to t0
    lw t1 0(s8) # save input columns to t1
    mul a1 t0 t1 # total number of array rows*columns
    jal ra relu
    
    # Output of stage 1
    la a1, output_step2
    jal print_str

    # li t4 1 # test
    # li t5 3 # test
    ## FILL OUT
    mv a0 t3 # Base ptr
    lw a1 0(s1)  # rows
    lw a2 0(s8) # cols
    jal print_int_array 
   
   
    
    
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
   
    
    # Output of stage 3
    la a1, output_step3
    jal print_str

    lw t0 0(s4) # pointer number of rows (s4 m1 rows)
    lw t1 0(s8) # pointer number of columns (s8 input column)

    mul a0 t0 t1 # row * column total dimension
    slli a0 a0 2 # muti * 4

    jal ra malloc
    mv s11 a0  # save pointer to d

    # m1 
    mv a0 s6 # s6 = pointer of m1
    lw a1 0(s4) # rows of m1
    lw a2 0(s5) # cols of m1
    mv a3 s10 # pointer to matmul matrix
    lw a4 0(s1) # rows of matmul matrix
    lw a5 0(s8) # cols of matmul matrix
    mv a6 s11 # t0 save pointer to malloc'd array for output

    jal ra matmul

     # li t1 5
     # li t2 1
     ## FILL OUT
     mv a0 a6 # Base ptr
     lw a1 0(s4) # rows
     lw a2 0(s8) # cols
     jal print_int_array 

     
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0 16(s0) # Load pointer to output filename
    mv a1 s11 # pointer to the array in memory
    lw a2 0(s4) # number of rows
    lw a3 0(s8) # number of columns

    jal ra write_matrix





    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    

    # Print classification
    la a1, output_step4
    jal print_str
    
    # Output of stage 3
    mv a0 s11 # pointer to output array
    lw t0 0(s4) # rows of m1
    lw t1 0(s8) # coulumn of matmul matrix
    mul a1 t0 t1 # total size of matrix as argument a1 in argmax

    jal ra argmax
    
    ## FILL OUT
    # mv a0 a0 # Base ptr
    # mv a1 t0 # rows
    # mv a2 t1 # cols
    # jal print_int_array 
     mv a1 a0
     jal ra print_int



    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw s9 36(sp)
    lw s10 40(sp)
    lw s11 44(sp)
    lw ra 48(sp)
    addi sp sp 52


    jal exit

    error_num_args:
     li a1 3
     jal exit2