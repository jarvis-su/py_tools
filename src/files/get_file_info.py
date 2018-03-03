import hashlib
import os
import time

## 较小的文件
def get_md5_01(file_path):
    md5 = None
    if os.path.isfile(file_path):
        f = open(file_path, 'rb')
        md5_obj = hashlib.md5()
        md5_obj.update(f.read())
        hash_code = md5_obj.hexdigest()
        f.close()
        md5 = str(hash_code).lower()
    return md5

# 较大的文件
def get_md5_02(file_path):
  f = open(file_path,'rb')
  md5_obj = hashlib.md5()
  while True:
    d = f.read(8096)
    if not d:
      break
    md5_obj.update(d)
  hash_code = md5_obj.hexdigest()
  f.close()
  md5 = str(hash_code).lower()
  return md5

if __name__ == "__main__":
    file_path = "./example/test.txt"
    md5_01 = get_md5_01(file_path)
    print(md5_01)

    md5_02 = get_md5_02(file_path)
    print(md5_02)

    statInfo = os.stat(file_path)
    print(statInfo)
    print(time.localtime(statInfo.st_atime))