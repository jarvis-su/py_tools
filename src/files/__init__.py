import os
import os.path
import shutil
import sys
from sys import exit

def get_file_info():
    file = "./example/test.txt"
    try:
        stat = os.stat(file)
        print(stat.st_size)
    except:
        print("unexpected error . %s", sys.exc_info())
        exit(1)
    get_file_info()

if __name__ == "__main__":
