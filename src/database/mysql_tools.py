import  pymysql

def connect_test(db_host,db_user,db_user_pwd,db_database):
    db = pymysql.connect(db_host,db_user,db_user_pwd,db_database)
    # 使用 cursor() 方法创建一个游标对象 cursor
    cursor = db.cursor()
    # 使用 execute()  方法执行 SQL 查询
    cursor.execute("SELECT VERSION()")
    # 使用 fetchone() 方法获取单条数据.
    data = cursor.fetchone()
    print("Database version : %s " % data)
    # 关闭数据库连接
    db.close()


if __name__ == "__main__":
    db_host = "47.95.235.115"
    db_user = "jarvis_db"
    db_user_pwd = "Jarvis%123456"
    db_database = "jarvis_db"
    connect_test(db_host,db_user,db_user_pwd,db_database)