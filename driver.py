#!/usr//bin/python3
#
# driver.py - The driver tests the correctness
import subprocess
import re
import os
import sys
import argparse
import shutil
import json


# Basic tests
tests_json = """{
  "dot": {
      "timeout 120 java -jar venus.jar ./test_files/test_dot.s > ./out/test_dot.out": 0,
      "diff ./out/test_dot.out ./ref/test_dot.out": 10
      },
    "argmax": {
      "timeout 120 java -jar venus.jar ./test_files/test_argmax.s > ./out/test_argmax.out": 0,
      "diff ./out/test_argmax.out ./ref/test_argmax.out": 10
      },
      "relu": {
      "timeout 120 java -jar venus.jar ./test_files/test_relu.s > ./out/test_relu.out": 0,
      "diff ./out/test_relu.out ./ref/test_relu.out": 10
      },
      "matmul": {
      "timeout 120 java -jar venus.jar ./test_files/test_matmul.s > ./out/test_matmul.out": 0,
      "diff ./out/test_matmul.out ./ref/test_matmul.out": 10
      },
      "read_matrix": {
      "timeout 120 java -jar venus.jar ./test_files/test_read_matrix.s > ./out/test_read_matrix.out": 0,
      "diff ./out/test_read_matrix.out ./ref/test_read_matrix.out": 10
      }
    }
"""

simple0_json = """{
  "simple0-input0": {
    "timeout 120 java -jar venus.jar ./test_files/main.s ./inputs/simple0/bin/inputs/input0.bin ./inputs/simple0/bin/m0.bin ./inputs/simple0/bin/m1.bin -ms -1 > ./out/simple0/input0.trace" : 0,
    "python3 part2_tester.py simple0/input0": 15
  },
  "simple0-input1": {
    "timeout 120 java -jar venus.jar ./test_files/main.s ./inputs/simple0/bin/inputs/input1.bin ./inputs/simple0/bin/m0.bin ./inputs/simple0/bin/m1.bin -ms -1 > ./out/simple0/input1.trace" : 0,
    "python3 part2_tester.py simple0/input1": 15
  },
  "simple0-input2": {
    "timeout 120 java -jar venus.jar ./test_files/main.s ./inputs/simple0/bin/inputs/input2.bin ./inputs/simple0/bin/m0.bin ./inputs/simple0/bin/m1.bin -ms -1 > ./out/simple0/input2.trace" : 0,
    "python3 part2_tester.py simple0/input2": 15
  }
  }"""

simple1_json = """{
  "simple1-input0": {
    "timeout 120 java -jar venus.jar ./test_files/main.s ./inputs/simple1/bin/inputs/input0.bin ./inputs/simple1/bin/m0.bin ./inputs/simple1/bin/m1.bin -ms -1 > ./out/simple1/input0.trace" : 0,
    "python3 part2_tester.py simple1/input0": 15
  },
  "simple1-input1": {
    "timeout 120 java -jar venus.jar ./test_files/main.s ./inputs/simple1/bin/inputs/input1.bin ./inputs/simple1/bin/m0.bin ./inputs/simple1/bin/m1.bin -ms -1 > ./out/simple1/input1.trace" : 0,
    "python3 part2_tester.py simple1/input1": 15
  },
  "simple1-input2": {
    "timeout 120 java -jar venus.jar ./test_files/main.s ./inputs/simple1/bin/inputs/input2.bin ./inputs/simple1/bin/m0.bin ./inputs/simple1/bin/m1.bin -ms -1 > ./out/simple1/input2.trace" : 0,
    "python3 part2_tester.py simple1/input2": 15
  }
  }"""

simple2_json = """{
  "simple2-input0": {
    "timeout 120 java -jar venus.jar ./test_files/main.s ./inputs/simple2/bin/inputs/input0.bin ./inputs/simple2/bin/m0.bin ./inputs/simple2/bin/m1.bin -ms -1 > ./out/simple2/input0.trace" : 0,
    "python3 part2_tester.py simple2/input0": 15
  },
  "simple2-input1": {
    "timeout 120 java -jar venus.jar ./test_files/main.s ./inputs/simple2/bin/inputs/input1.bin ./inputs/simple2/bin/m0.bin ./inputs/simple2/bin/m1.bin -ms -1 > ./out/simple2/input1.trace" : 0,
    "python3 part2_tester.py simple2/input1": 15
  },
  "simple2-input2": {
    "timeout 120 java -jar venus.jar ./test_files/main.s ./inputs/simple2/bin/inputs/input2.bin ./inputs/simple2/bin/m0.bin ./inputs/simple2/bin/m1.bin -ms -1 > ./out/simple2/input2.trace" : 0,
    "python3 part2_tester.py simple2/input2": 15
  }
  }"""

mnist_json = """{
  "mnist-input0": {
    "timeout 120 java -jar venus.jar ./test_files/main.s ./inputs/mnist/bin/inputs/mnist_input0.bin ./inputs/mnist/bin/m0.bin ./inputs/mnist/bin/m1.bin -ms -1 > ./out/mnist/mnist_input0.trace" : 0,
    "python3 part2_tester.py mnist/mnist_input0": 40
  },
  "mnist-input1": {
    "timeout 120 java -jar venus.jar ./test_files/main.s ./inputs/mnist/bin/inputs/mnist_input1.bin ./inputs/mnist/bin/m0.bin ./inputs/mnist/bin/m1.bin -ms -1 > ./out/mnist/mnist_input1.trace" : 0,
    "python3 part2_tester.py mnist/mnist_input1": 40
  },
  "mnist-input2": {
    "timeout 120 java -jar venus.jar ./test_files/main.s ./inputs/mnist/bin/inputs/mnist_input2.bin ./inputs/mnist/bin/m0.bin ./inputs/mnist/bin/m1.bin -ms -1 > ./out/mnist/mnist_input2.trace" : 0,
    "python3 part2_tester.py mnist/mnist_input2": 40
  },
  "mnist-input3": {
    "timeout 120 java -jar venus.jar ./test_files/main.s ./inputs/mnist/bin/inputs/mnist_input3.bin ./inputs/mnist/bin/m0.bin ./inputs/mnist/bin/m1.bin -ms -1 > ./out/mnist/mnist_input3.trace" : 0,
    "python3 part2_tester.py mnist/mnist_input3": 40
  },
  "mnist-input4": {
    "timeout 120 java -jar venus.jar ./test_files/main.s ./inputs/mnist/bin/inputs/mnist_input4.bin ./inputs/mnist/bin/m0.bin ./inputs/mnist/bin/m1.bin -ms -1 > ./out/mnist/mnist_input4.trace" : 0,
    "python3 part2_tester.py mnist/mnist_input4": 40
  },
  "mnist-input5": {
    "timeout 120 java -jar venus.jar ./test_files/main.s ./inputs/mnist/bin/inputs/mnist_input5.bin ./inputs/mnist/bin/m0.bin ./inputs/mnist/bin/m1.bin -ms -1 > ./out/mnist/mnist_input5.trace" : 0,
    "python3 part2_tester.py mnist/mnist_input5": 40
  },
  "mnist-input6": {
    "timeout 120 java -jar venus.jar ./test_files/main.s ./inputs/mnist/bin/inputs/mnist_input6.bin ./inputs/mnist/bin/m0.bin ./inputs/mnist/bin/m1.bin -ms -1 > ./out/mnist/mnist_input6.trace" : 0,
    "python3 part2_tester.py mnist/mnist_input6": 40
  },
  "mnist-input7": {
    "timeout 120 java -jar venus.jar ./test_files/main.s ./inputs/mnist/bin/inputs/mnist_input7.bin ./inputs/mnist/bin/m0.bin ./inputs/mnist/bin/m1.bin -ms -1 > ./out/mnist/mnist_input7.trace" : 0,
    "python3 part2_tester.py mnist/mnist_input7": 40
  },
  "mnist-input8": {
    "timeout 120 java -jar venus.jar ./test_files/main.s ./inputs/mnist/bin/inputs/mnist_input8.bin ./inputs/mnist/bin/m0.bin ./inputs/mnist/bin/m1.bin -ms -1 > ./out/mnist/mnist_input8.trace" : 0,
    "python3 part2_tester.py mnist/mnist_input8": 40
  }  
}"""


Final = {}
Error = ""
Success = ""
PassOrFail = 0
#
# main - Main function
#


def runtests(test, name):
    total = 0
    points = 0
    global Success
    global Final
    global Error
    global PassOrFail
    for steps in test.keys():
        print(steps)
        p = subprocess.Popen(
            steps, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout_data, stderr_data = p.communicate()
        total = total + test[steps]
        if(p.returncode != 0):
            Error += "### " + "*"*5+steps+"*"*5
            Error += "\n ```" + stdout_data.decode()
            Error += "\n```\n"
            PassOrFail = p.returncode
        else:
            points += test[steps]
            Success += "### " + "*"*5+steps+"*"*5
            Success += "\n ```" + stdout_data.decode() + "\n```\n"
        if points < total:
            Final[name] = {"mark": points,
                           "comment": "Program exited with return code"+str(p.returncode)}
        else:
            Final[name] = {"mark": points,
                           "comment": "Program ran and output matched."}


def main():
        # Parse the command line arguments

    parser = argparse.ArgumentParser()
    parser.add_argument("-A", action="store_true", dest="autograde",
                        help="emit autoresult string for Autolab")

    parser.add_argument("-D", dest="output",
                        help="output directory", required=True)

    opts = parser.parse_args()
    autograde = opts.autograde
    output_folder = opts.output
    if os.path.exists(output_folder):
        shutil.rmtree(output_folder)

    # Basic Tests
    test_dict = json.loads(tests_json)
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)
    for parts in test_dict.keys():
        runtests(test_dict[parts], parts)

    # Simple tests (0,1,2)
    test_dict = json.loads(simple0_json)
    if not os.path.exists(output_folder+"/simple0"):
        os.makedirs(output_folder+"/simple0")
    for parts in test_dict.keys():
        runtests(test_dict[parts], parts)

    test_dict = json.loads(simple1_json)
    if not os.path.exists(output_folder+"/simple1"):
        os.makedirs(output_folder+"/simple1")
    for parts in test_dict.keys():
        runtests(test_dict[parts], parts)

    test_dict = json.loads(simple2_json)
    if not os.path.exists(output_folder+"/simple2"):
        os.makedirs(output_folder+"/simple2")
    for parts in test_dict.keys():
        runtests(test_dict[parts], parts)

    # MNIST Tests
    test_dict = json.loads(mnist_json)
    if not os.path.exists(output_folder+"/mnist"):
        os.makedirs(output_folder+"/mnist")
    for parts in test_dict.keys():
        runtests(test_dict[parts], parts)

    githubprefix = os.path.basename(os.getcwd())
    Final["userid"] = "GithubID:" + githubprefix
    j = json.dumps(Final, indent=2)

    with open(githubprefix + "_Grade"+".json", "w+") as text_file:
        text_file.write(j)

    with open("LOG.md", "w+") as text_file:
        text_file.write("## " + '*'*20 + 'FAILED' + '*'*20 + '\n' + Error)
        text_file.write("\n" + "*" * 40)
        text_file.write("\n## " + '*'*20 + 'SUCCESS' + '*'*20 + '\n' + Success)

    sys.exit(PassOrFail)

    # execute main only if called as a script
if __name__ == "__main__":
    main()
