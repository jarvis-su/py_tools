# coding: utf-8
f = open('E:/tmp/test.txt')
print ('文件名：', f.name)
print ('是否处于关闭状态：', f.closed)
print ('打开的模式：', f.mode)
f.close()
print ('是否处于关闭状态：', f.closed)