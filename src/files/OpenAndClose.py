#! /usr/bin/python
import os,sys

# coding: utf-8
try:
    f = open('E:/tmp/test.txt')
    print('文件名：', f.name)
    print('是否处于关闭状态：', f.closed)
    print('打开的模式：', f.mode)
finally :
    f.close()
    print('是否处于关闭状态：', f.closed)

try:
    fsock = open('E:/tmp/test.txt', "r")
except IOError:
    print ("The file don't exist, Please double check!")
    exit()
print ('The file mode is ',fsock.mode)
print ('The file name is ',fsock.name)
P = fsock.tell()
print ('the postion is %d' %(P))
fsock.close()

# Read file
fsock = open("E:/tmp/test.txt", "r")
AllLines = fsock.readlines()
# Method 1
for EachLine in fsock:
    print (EachLine)

# Method 2
print ('Star'+'='*60)
for EachLine in AllLines:
    print (EachLine)
print ('End'+'='*130)
fsock.close()

# write this file
fsock = open("E:/tmp/test.txt", "a")
fsock.write("""
# Line 1 Just for test purpose
# Line 2 Just for test purpose
# Line 3 Just for test purpose""")
fsock.close()


#check the file status
S1 = fsock.closed
if True == S1:
    print ('the file is closed')
else:
    print ('The file donot close')