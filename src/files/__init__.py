import os
import os.path
import shutil
import sys
from sys import exit

file = "F:/tmp/071917_001-caribpr-1080p.mp4"
try:
    stat = os.stat(file)
    print(stat.st_size)
except:
    print("unexpected error . %s", sys.exc_info())
    exit(1)
