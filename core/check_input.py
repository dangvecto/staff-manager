import re,pymysql
import core.function as fu
import time,string,random
def check_email(email):
    match = re.match('^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$', email)
    return match
def check_phone(phone):
    match = re.match('0[1-9]{9}', phone)
    return match
def check_id(departments,staff_type,work_type):
    db = pymysql.connect(host=fu.host, user=fu.db_user, password=fu.db_pass, db=fu.db_name)
    cursor = db.cursor()
    cursor.callproc('check_id',[departments,staff_type,work_type])
    return cursor.fetchone()[0]
    db.close()
def check_date(start_time,end_time):
    try:
        # s1 = datetime.strptime(start_time, '%m/%d/%Y')
        # s2 = datetime.strptime(end_time, '%m/%d/%Y')
        s3 = int(time.mktime(start_time.timetuple()))
        s4 = int(time.mktime(end_time.timetuple()))
        if s4 - s3 >= 0:
            a = 1
        else:
            a = -1
    except:
        a=-99
    return a
# date123='10/28/2018'
# print(datetime.strptime(date123, '%m/%d/%Y'))
# import pyqrcode
# qr = pyqrcode.create('Bộ phận: Kế Toán Nhân viên: Trần Văn Hải SĐT: 0891273891 Email: haitv@gmail.com TAG: CHCE8URS9'.encode('utf8'))
# qr.png('famous-joke.png', scale=5)