import os
import sys
import argparse
import numpy as np


def read_matrix(filename):
    with open(filename, "rb") as handle:
        rows = int.from_bytes(handle.read(4), byteorder="little")
#         # print(int.from_bytes(rows, byteorder='little'))
        cols = int.from_bytes(handle.read(4), byteorder="little")
#         # print(int.from_bytes(cols, byteorder='little'))
        data = np.empty(shape=(rows, cols))
        for i in range(rows):
            for j in range(cols):
                data[i, j] = int.from_bytes(
                    handle.read(4), byteorder="little", signed=True)
    return data


def matmul(mat1, mat2):
    result = np.empty(shape=(mat1.shape[0], mat2.shape[1]))
    for i in range(mat1.shape[0]):
        for j in range(mat2.shape[1]):
            for k in range(mat1.shape[1]):
                result[i, j] += mat1[i, k]*mat2[k, j]
    return result


def main():
    # print(sys.argv[1])
    input = read_matrix(sys.argv[1])
    m0 = read_matrix(sys.argv[2])
    m1 = read_matrix(sys.argv[3])
    hidden1 = m0.dot(input)
    hidden2 = np.maximum(hidden1, 0)
    hidden3 = m1.dot(hidden2)
    # print(hidden3)
    print(hidden3.argmax())


if __name__ == "__main__":
    main()
