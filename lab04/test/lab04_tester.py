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
  marsJar = "/home/vagtsal/vagtsal_labs/MarsMYY402_4_5.jar"

tests = [ \
 ("Test all", \
  [],\
  {'s0' : 120, 's1' : 1, 's2' : 5, 's3' : 0, 'sp' : 0x7fffeffc}, \
  {} \
 ) \
]

print (runTests("../lab04.asm", tests, marsJar, verbose=False))

