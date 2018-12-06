import pymysql,string,random
import datetime
host='localhost'
db_user='root'
db_pass='passroot'
db_name='staffmanager'
def login(account,passwd):
    db=pymysql.connect(host=host,user=db_user,password=db_pass,db=db_name,autocommit=True)
    cursor=db.cursor()
    login_time=datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cursor.callproc('account_login',[account,passwd,login_time])
    return cursor.fetchone()
    db.close()
def new_departments(departments):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name, autocommit=True)
    cursor = db.cursor()
    create_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cursor.callproc('new_departments',[departments,create_time])
    return cursor.fetchone()[0]
    db.close()
def list_departments():
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.callproc('select_departments',[])
    return cursor.fetchall()
    db.close()
def info_departments(id):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.callproc('info_department', [id,])
    return cursor.fetchone()
    db.close()
def modify_departments(id,new_name):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name, autocommit=True)
    cursor = db.cursor()
    modify_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cursor.callproc('modify_departments', [id,new_name,modify_time])
    return cursor.fetchone()[0]
    db.close()
def delete_departments(id):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name, autocommit=True)
    cursor = db.cursor()
    cursor.callproc('delete_departments', [id,])
    return cursor.fetchone()[0]
    db.close()
def new_staff_type(name):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name, autocommit=True)
    cursor = db.cursor()
    create_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cursor.callproc('new_staff_type', [name, create_time])
    return cursor.fetchone()[0]
    db.close()
def list_staff_type():
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name, autocommit=True)
    cursor = db.cursor()
    cursor.callproc('list_staff_type', [])
    result=[]
    for i in cursor.fetchall():
        result.append([i[0],i[1]])
    return result
    db.close()
def info_staff_type(id):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name, autocommit=True)
    cursor = db.cursor()
    modify_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cursor.callproc('info_staff_type', [id])
    return cursor.fetchone()
    db.close()
def edit_staff_type(id,name):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name, autocommit=True)
    cursor = db.cursor()
    modify_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cursor.callproc('modify_staff_type', [id,name,modify_time])
    return cursor.fetchone()[0]
    db.close()
def delete_staff_type(id):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name, autocommit=True)
    cursor = db.cursor()
    cursor.callproc('delete_staff_type', [id,])
    return cursor.fetchone()[0]
    db.close()
def list_staff_departments(id):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.callproc('list_staff_departments',[id,])
    return cursor.fetchall()
    db.close()
# def add_new_staff(id):
#     db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name, autocommit=True)
#     cursor = db.cursor()
#     cursor.callproc('delete_staff_type', [id,])
#     return cursor.fetchone()[0]
#     db.close()
def add_new_staff(staff_fullname,staff_phone,staff_email,staff_adress,staff_birthday,contract,status,staff_type_id,departments_id,work_id,start_time,staff_note,sex):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name, autocommit=True)
    cursor = db.cursor()
    modify_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cursor.callproc('add_new_staff', [staff_fullname,staff_phone,staff_email,staff_adress,staff_birthday,contract,status,staff_type_id,departments_id,work_id,start_time,staff_note,sex,modify_time])
    return cursor.fetchone()[0]
    db.close()
def top_50_new_staff():
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.callproc('top_50_new_staff',[])
    return cursor.fetchall()
    db.close()
def list_all_staff():
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.callproc('list_all_staff',[])
    return cursor.fetchall()
    db.close()
def list_probationary_staff():
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.callproc('list_probationary_staff',[])
    return cursor.fetchall()
    db.close()
def add_new_work_type(type):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name, autocommit=True)
    cursor = db.cursor()
    cursor.callproc('new_work_type', [type])
    return cursor.fetchone()[0]
    db.close()
def list_work_type():
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.callproc('list_work_type',[])
    return cursor.fetchall()
    db.close()
def edit_work_type(id,name):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name, autocommit=True)
    cursor = db.cursor()
    cursor.callproc('modify_work_type',[id,name])
    return cursor.fetchone()[0]
    db.close()
def get_work_type_name(id):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.callproc('get_work_type_name',[id,])
    return cursor.fetchone()
    db.close()
def delete_work_type(id):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name, autocommit=True)
    cursor = db.cursor()
    cursor.callproc('delete_work_type',[id])
    return cursor.fetchone()[0]
    db.close()
def staff_info(id):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.callproc('staff_info',[id,])
    return cursor.fetchone()
    db.close()
def delete_staff(id):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name, autocommit=True)
    cursor = db.cursor()
    cursor.callproc('delete_staff',[id])
    return cursor.fetchone()[0]
    db.close()
def upgrade_probationary_staff(id):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name, autocommit=True)
    cursor = db.cursor()
    cursor.callproc('upgrade_probationary_staff',[id])
    return cursor.fetchone()[0]
    db.close()
def staff_quit(id):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name, autocommit=True)
    cursor = db.cursor()
    cursor.callproc('staff_quit',[id])
    return cursor.fetchone()[0]
    db.close()
def staff_quit_list():
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.callproc('staff_quit_list',[])
    return cursor.fetchall()
    db.close()
def staff_profile_list():
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.callproc('staff_profile_list',[])
    return cursor.fetchall()
    db.close()
def staff_profile_update(id,certificate,health_certificate,papers,marital_status):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name, autocommit=True)
    cursor = db.cursor()
    flag=1
    if certificate!=None:
        cursor.execute('update staff_profile set staff_certificate=%s where staff_id=%s',[certificate,id])
    else:
        flag=-1
    if health_certificate!=None:
        cursor.execute('update staff_profile set staff_health_certificate=%s where staff_id=%s',[health_certificate,id])
    else:
        flag=-1
    if papers!=None:
        cursor.execute('update staff_profile set staff_papers=%s where staff_id=%s',[papers,id])
    else:
        flag=-1
    if marital_status!=None:
        cursor.execute('update staff_profile set staff_marital_status=%s where staff_id=%s',[marital_status,id])
    else:
        flag=-1
    return flag
    db.close()
def hr_report():
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.callproc('hr_report', [])
    return cursor.fetchone()
    db.close()
def admin_account_profile(account):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.callproc('show_info_admin_account', [account,])
    return cursor.fetchone()
    db.close()
def admin_profile_change_passwd(account,oldpasswd,newpasswd,renewpasswd):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name,autocommit=True)
    cursor = db.cursor()
    cursor.callproc('change_admin_account_passwd', [account,oldpasswd,newpasswd,renewpasswd])
    return cursor.fetchone()[0]
    db.close()
#####################################################IT account#######################
def add_new_device_partner(name,phone,address,note,email):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name,autocommit=True)
    cursor = db.cursor()
    cursor.callproc('add_new_device_partner', [name,phone,address,note,email])
    return cursor.fetchone()[0]
    db.close()
def top_10_device_partner():
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.callproc('top_10_device_partner', [])
    return cursor.fetchall()
    db.close()
def device_type_add(name):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name,autocommit=True)
    cursor = db.cursor()
    cursor.callproc('device_type_add', [name])
    return cursor.fetchone()[0]
    db.close()
def device_type_list():
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.execute('select * from device_type_list')
    return cursor.fetchall()
    db.close()
def device_type_id(id):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.callproc('device_type_all_id',[id,])
    return cursor.fetchall()
    db.close()
def device_partner_list():
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.callproc('device_partner_list',[])
    return cursor.fetchall()
    db.close()
def tag_generator(size=9, chars=string.ascii_uppercase + string.digits):
    return ''.join(random.choice(chars) for _ in range(size))
def device_receive(device_name,device_price,device_info,device_type,partner,receive_time,device_protection_time):
    modify_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    device_tag=tag_generator()
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name,autocommit=True)
    cursor = db.cursor()
    cursor.callproc('device_receive', [device_name,device_tag,device_price,device_info,device_type,partner,receive_time,modify_time,device_protection_time])
    return cursor.fetchone()[0]
    db.close()
def device_no_tranfer():
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.execute('select * from device_no_tranfer_list')
    return cursor.fetchall()
    db.close()

def tranfers_device(departments,staff,devicetypeid,device_id):
    import pyqrcode
    from staffmanager.settings import BASE_DIR
    modify_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name,autocommit=True,charset="utf8")
    cursor = db.cursor()
    cursor.callproc('qrcode_get_info',[departments,staff,device_id])
    qrcodedata=cursor.fetchone()
    qrcode='Bộ phận: '+qrcodedata[1] + ' ' + 'Nhân viên: '+qrcodedata[2]+ ' ' + 'SĐT: '+qrcodedata[3] +' '+'Email: '+qrcodedata[4]+' '+'TAG: '+qrcodedata[5]
    qr = pyqrcode.create(qrcode,encoding='utf-8')
    #debug True
    qr.png(BASE_DIR+'/static/qrcode/'+qrcodedata[5]+'.png', scale=5)
    #debug False
    #path='/home/it.iliketv.net/public_html/static/'
    #qr.png(path + qrcodedata[5] + '.png', scale=5)
    qrcode_url='/qrcode/'+qrcodedata[5]+'.png'
    cursor.callproc('device_tranfers_to_staff', [departments,staff,devicetypeid,device_id,qrcode_url,modify_time])
    return cursor.fetchone()[0]
    db.close()
def device_tranfer_listall():
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.execute('select * from device_tranfer_list')
    return cursor.fetchall()
    db.close()
def device_staff_to_it_listall():
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.execute('select * from device_staff_to_it_list')
    return cursor.fetchall()
    db.close()
def device_staff_used(id):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.callproc('list_device_staff_use',[id,])
    return cursor.fetchall()
    db.close()
def tranfer_device_staff_to_it(departments,staff,device):
    import os
    from staffmanager.settings import BASE_DIR
    modify_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name, autocommit=True, charset="utf8")
    cursor = db.cursor()
    cursor.callproc('device_tranfer_staff_to_it_exe',[departments,staff,device,modify_time])
    result=cursor.fetchone()
    if int(result[0])==1:
        #debug True
        path=BASE_DIR+'/static/qrcode/'+str(result[1])+'.png'
        #debug False
        #path='/home/it.iliketv.net/public_html/static/'+str(result[1])+'.png'
        os.remove(path)
    return result
    db.close
def device_detail_id(id):
    db = pymysql.connect(host=host, user=db_user, password=db_pass, db=db_name)
    cursor = db.cursor()
    cursor.callproc('device_detail_id',[id,])
    return cursor.fetchone()
    db.close()