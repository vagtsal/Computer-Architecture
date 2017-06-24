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
 ("Minimal", \
  ["s/^rows:.*$/rows: .word 1/", "s/^cols:.*$/cols: .word 1/", "s/^picture:.*$/picture: .word 0x01/"],\
  {}, \
  {'r_clues' : 1, 'c_clues' : 1} \
 ), \
 ("Man and dog",\
  ["s/^rows:.*$/rows: .word 30/", \
   "s/^cols:.*$/cols: .word 25/",\
   "s/^picture:.*$/picture: .word 0x000007c, 0x00000fe, 0x00000fe, 0x000005e, 0x00000fe, 0x000007e, 0x000003c, 0x0000018, 0x0001ffc, 0x0003ffe, 0x000303f, 0x000143f, 0x0001c3f, 0x000083f, 0x000083f, 0x008083f, 0x00f081f, 0x00d9c1f, 0x00f943f, 0x18f007e, 0x11e00fc, 0x13f01ec, 0x1ff81ff, 0x0ff81ff, 0x0fcc003, 0x070000d, 0x060000c, 0x060000c, 0x060000c, 0x030001c/"\
  ],
  {},\
  {'r_clues' : 5, \
   'r_clues+64' : 7, \
   'r_clues+2*64' : 7, \
   'r_clues+3*64' : 1, 'r_clues+3*64+4' : 4, \
   'r_clues+4*64' : 7, \
   'r_clues+5*64' : 6, \
   'r_clues+6*64' : 4, \
   'r_clues+7*64' : 2, \
   'r_clues+8*64' : 11, \
   'r_clues+9*64' : 13, \
   'r_clues+10*64' : 2, 'r_clues+10*64+4' : 6, \
   'r_clues+11*64' : 1, 'r_clues+11*64+4' : 1, 'r_clues+11*64+8' : 6, \
   'r_clues+12*64' : 3, 'r_clues+12*64+4' : 6, \
   'r_clues+13*64' : 1, 'r_clues+13*64+4' : 6, \
   'r_clues+14*64' : 1, 'r_clues+14*64+4' : 6, \
   'r_clues+15*64' : 1, 'r_clues+15*64+4' : 1, 'r_clues+15*64+8' : 6, \
   'r_clues+16*64' : 4, 'r_clues+16*64+4' : 1, 'r_clues+16*64+8' : 5, \
   'r_clues+17*64' : 2, 'r_clues+17*64+4' : 2, 'r_clues+17*64+8' : 3, 'r_clues+17*64+12' : 5, \
   'r_clues+18*64' : 5, 'r_clues+18*64+4' : 1, 'r_clues+18*64+8' : 1, 'r_clues+18*64+12' : 6, \
   'r_clues+19*64' : 2, 'r_clues+19*64+4' : 4, 'r_clues+19*64+8' : 6, \
   'r_clues+20*64' : 1, 'r_clues+20*64+4' : 4, 'r_clues+20*64+8' : 6, \
   'r_clues+21*64' : 1, 'r_clues+21*64+4' : 6, 'r_clues+21*64+8' : 4, 'r_clues+21*64+12' : 2, \
   'r_clues+22*64' : 10,'r_clues+22*64+4' : 9, \
   'r_clues+23*64' : 9, 'r_clues+23*64+4' : 9, \
   'r_clues+24*64' : 6, 'r_clues+24*64+4' : 2, 'r_clues+24*64+8' : 2, \
   'r_clues+25*64' : 3, 'r_clues+25*64+4' : 2, 'r_clues+25*64+8' : 1, \
   'r_clues+26*64' : 2, 'r_clues+26*64+4' : 2, \
   'r_clues+27*64' : 2, 'r_clues+27*64+4' : 2, \
   'r_clues+28*64' : 2, 'r_clues+28*64+4' : 2, \
   'r_clues+29*64' : 2, 'r_clues+29*64+4' : 3, \
   'c_clues' : 4, \
   'c_clues+1*64' : 1, 'c_clues+1*64+4' : 3, \
   'c_clues+2*64' : 7, \
   'c_clues+3*64' : 9, \
   'c_clues+4*64' : 6, 'c_clues+4*64+4' :  1, \
   'c_clues+5*64' : 10, \
   'c_clues+6*64' : 9, \
   'c_clues+7*64' : 1, 'c_clues+7*64+4' :  6, \
   'c_clues+8*64' : 4, 'c_clues+8*64+4' :  3, \
   'c_clues+9*64' : 2, 'c_clues+9*64+4' :  3, \
   'c_clues+10*64' : 1, \
   'c_clues+11*64' : 2, \
   'c_clues+12*64' : 5, 'c_clues+12*64+4' :  2, \
   'c_clues+13*64' : 2, 'c_clues+13*64+4' :  6, \
   'c_clues+14*64' : 2, 'c_clues+14*64+4' :  2, 'c_clues+14*64+8' :  2, \
   'c_clues+15*64' : 2, \
   'c_clues+16*64' : 2, 'c_clues+16*64+4' :  3, \
   'c_clues+17*64' : 2, 'c_clues+17*64+4' :  1, 'c_clues+17*64+8' :  2,'c_clues+17*64+12' :  4, \
   'c_clues+18*64' : 6, 'c_clues+18*64+4' :  2, 'c_clues+18*64+8' :  5, \
   'c_clues+19*64' : 3, 'c_clues+19*64+4' :  3, 'c_clues+19*64+8' :  8,'c_clues+19*64+12' :  6, \
   'c_clues+20*64' : 21,'c_clues+20*64+4' :  2, \
   'c_clues+21*64' : 24,'c_clues+21*64+4' :  5, \
   'c_clues+22*64' : 7, 'c_clues+22*64+4' :  16,'c_clues+22*64+8' :  5, \
   'c_clues+23*64' : 5, 'c_clues+23*64+4' :  11,'c_clues+23*64+8' :  3, \
   'c_clues+24*64' : 9, 'c_clues+24*64+4' :  4 } \
 ), \
 ("Moose", \
  ["s/^rows:.*$/rows: .word 14/", \
   "s/^cols:.*$/cols: .word 16/", \
   "s/^picture:.*$/picture: .word 0x0d81b, 0x0da5b, 0x07a5b, 0x03e3e, 0x00df0, 0x003f8, 0x0057c, 0x00ffe, 0x01ffe, 0x03fff, 0x07fbf, 0x05c3f, 0x07c3f, 0x383f/" \
  ], \
  {}, \
  {'r_clues' : 2, 'r_clues+4' : 2, 'r_clues+8' : 2, 'r_clues+12' : 2, \
   'r_clues+1*64' : 2, 'r_clues+1*64+4' : 2, 'r_clues+1*64+8' : 1, 'r_clues+1*64+12' : 1, \
   'r_clues+2*64' : 4, 'r_clues+2*64+4' : 1, 'r_clues+2*64+8' : 1, 'r_clues+2*64+12' : 2, \
   'r_clues+3*64' : 5, 'r_clues+3*64+4' : 5, \
   'r_clues+4*64' : 2, 'r_clues+4*64+4' : 5, \
   'r_clues+5*64' : 7, \
   'r_clues+6*64' : 1, 'r_clues+6*64+4' : 1, 'r_clues+6*64+8' : 5, \
   'r_clues+7*64' : 11, \
   'r_clues+8*64' : 12, \
   'r_clues+9*64' : 14, \
   'r_clues+10*64' : 8, 'r_clues+10*64+4' : 6, \
   'r_clues+11*64' : 1, 'r_clues+11*64+4' : 3, 'r_clues+11*64+8' : 6, \
   'r_clues+12*64' : 5, 'r_clues+12*64+4' : 6, \
   'r_clues+13*64' : 3, 'r_clues+13*64+4' : 6, \
   'c_clues' : 2, \
   'c_clues+1*64' : 3, 'c_clues+1*64+4' : 3, \
   'c_clues+2*64' : 2, 'c_clues+2*64+4' : 2, 'c_clues+2*64+8' : 2, \
   'c_clues+3*64' : 4, 'c_clues+3*64+4' : 6, \
   'c_clues+4*64' : 5, 'c_clues+4*64+4' : 7, \
   'c_clues+5*64' : 2, 'c_clues+5*64+4' : 7, \
   'c_clues+6*64' : 3, 'c_clues+6*64+4' : 1, 'c_clues+6*64+8' : 4, \
   'c_clues+7*64' : 7, \
   'c_clues+8*64' : 2, 'c_clues+8*64+4' : 4, \
   'c_clues+9*64' : 2, 'c_clues+9*64+4' : 6, \
   'c_clues+10*64' : 11, \
   'c_clues+11*64' : 14, \
   'c_clues+12*64' : 4, 'c_clues+12*64+4' : 9, \
   'c_clues+13*64' : 1, 'c_clues+13*64+4' : 8, \
   'c_clues+14*64' : 4, 'c_clues+14*64+4' : 7, \
   'c_clues+15*64' : 3, 'c_clues+15*64+4' : 5\
  }, \
 ) \
]

print (runTests("../lab03.asm", tests, marsJar, verbose=False))

