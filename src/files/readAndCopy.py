import os
import os.path
import shutil
import sys
from sys import exit

rootdir = "D:/TDownload"  # 指明被遍历的文件夹
dstDir = "F:/tmp" #目标文件夹

for parent, dirnames, filenames in os.walk(rootdir):  # 三个参数：分别返回1.父目录 2.所有文件夹名字（不含路径） 3.所有文件名字
    for dirname in dirnames:
        # 输出文件夹信息
        print("parent is:" + parent)
        # print ("dirname is" + dirname)

    for filename in filenames:  # 输出文件信息
        # print("parent is:" + parent)
        # print("filename is:" + filename)
        # 输出文件路径信息
        print("the full name of the file is:" + os.path.join(parent, filename))
        absoluteFileName = os.path.join(parent, filename)
        absoluteDestFile = os.path.join(dstDir, filename)
        if filename.endswith(".xltd"):
            print("downloading , please do not touch it ")
        elif filename.endswith(".torrent") or filename.endswith(".JPG") or filename.endswith(".jpg") or filename.endswith(".gif") or filename.endswith(".png"):
            print("do not need it ")
            try:
                print("deleting file " + absoluteFileName)
                os.remove(absoluteFileName)
            except:
                print("unexpected error . %s", sys.exc_info())
        elif os.path.exists(absoluteDestFile) and os.path.isfile(absoluteDestFile):
            stat = os.stat(absoluteDestFile)
            print("file has been existed")
            print(stat.st_size)
            try:
                print("deleting file " + absoluteFileName)
                os.remove(absoluteFileName)
            except:
                print("unexpected error . %s", sys.exc_info())
        elif filename.endswith(".mp4") or filename.endswith(".mkv") or filename.endswith(".avi") or filename.endswith(".MP4"):
            print(filename)
            # print(absoluteDestFile)
            try:
                shutil.copyfile(absoluteFileName, absoluteDestFile)
            except IOError as e:
                print("unable to copy file. %s"%e)
                exit(1)
            except:
                print("unexpected error . %s", sys.exc_info())
                exit(1)
print("Over the processing ,exit")
exit(0)