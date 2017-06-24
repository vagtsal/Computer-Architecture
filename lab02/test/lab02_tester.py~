#!/usr/bin/env python3.4
import os.path
from mipsTester import runTests

if os.path.isfile("/usr/home/grads/courses/myy402/bin/MarsMYY402_4_5.jar"):
  # This is the path to MarsMYY402_4_5.jar for the lab machines.
  marsJar = "/usr/home/grads/courses/myy402/bin/MarsMYY402_4_5.jar"
else:
  ##########################################
  # This is my set-up for my machine,
  # MODIFY FOR YOUR PERSONAL COMPUTER SETUP!
  #  USING THE FULL PATH TO MarsMYY402_4_5.jar IN YOUR COMPUTER
  ##########################################
  marsJar = "/home/efthym/t/ca_course/MarsMYY402_4_5.jar"

tests = [ \
 ("Empty array",\
  ["s/^length:.*$/length: .word 0/", "s/^input:.*$/input: .word 1, -2, 4/"],\
  {'s0' : 0, 's1' : 0},\
  {}\
 ), \
 ("Single positive odd",\
  ["s/^length:.*$/length: .word 1/", "s/^input:.*$/input: .word 1/"],\
  {'s0' : 1, 's1' : 0},\
  {} \
 ), \
 ("Single negative even",\
  ["s/^length:.*$/length: .word 1/", "s/^input:.*$/input: .word -2/"],\
  {'s0' : 0, 's1' : -2},\
  {} \
 ), \
 ("Pos evens, neg odds",\
  ["s/^length:.*$/length: .word 5/", "s/^input:.*$/input: .word -1, 2, -7, 40, -33/"],\
  {'s0' : 0, 's1' : 0},\
  {} \
 ) \
]

# Change verbose below to True, if you get errors to get more detailed information
print (runTests("../lab02.asm", tests, marsJar, verbose=False))

