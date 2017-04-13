# coding: utf-8
try:
    f = open('D:/ECC_DEV/ECCOK_Int_jsu/app/config/com/tps/config/com_tps_sysmgmt_scheduler_properties')
    print('文件名：', f.name)
    print('是否处于关闭状态：', f.closed)
    print('打开的模式：', f.mode)
    lines = f.readlines()
    for line in lines:
        print(line)
finally :
    f.close()
    print('是否处于关闭状态：', f.closed)
