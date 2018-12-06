from django.http import HttpResponse
from django.http import request
from django.shortcuts import render,redirect
import core.function as fu_admin
from django.contrib import messages
from django.http import HttpResponseRedirect
import datetime,pytz
from datetime import datetime
import core.check_input as check


def login(request):
    if request.session.get('is_login', None):
        return render(request, 'login.html')
    if request.method == "POST":
        user = request.POST.get('account')
        passwd = request.POST.get('password')
        if user=='' or passwd=='' or len(user)>20 or len(passwd)>20:
            messages.info(request, 'Hãy nhập đúng thông tin đăng nhập')
            return render(request, 'login.html', {})
        else:
            result = fu_admin.login(user, passwd)
            if result[0] == 1:
                if 'remember' in request.POST:
                    request.session.set_expiry(3000)
                else:
                    request.session.set_expiry(300)
                request.session['is_login'] = True
                request.session['account']= user
                request.session['account_type'] = result[1]
                return HttpResponseRedirect('/dashboard/')
            elif result[0] == -99:
                messages.info(request, 'Sai thông tin tài khoản')
                return render(request, 'login.html', {})
    return render(request,'login.html')
def list_staff_departments(request,id):
    if request.session.get('is_login')==True:
        result=fu_admin.list_staff_departments(id)
        return render(request,'it/list_staff_departments.html',{'result':result})
    else:
        return HttpResponseRedirect('/')
def logout(request):
    request.session['is_login'] = False
    return HttpResponseRedirect('/')
def dashboard(request):
    if request.session.get('is_login') == True:
        result=fu_admin.hr_report()
        return render(request, 'dashboard.html',{'result':result})
    else:
        return HttpResponseRedirect('/')
    #return render(request, 'dashboard.html')
def new_departments(request):
    if request.method == 'POST':
        departments=request.POST.get('departments')
        result=fu_admin.new_departments(departments)
        if result==1:
            messages.info(request,'Đã thêm thành công')
        elif result==-99:
            messages.info(request, 'Phòng ban đã tồn tại')
        return HttpResponseRedirect('/dashboard/new-departments/')
    result = fu_admin.list_departments()
    id = []
    for i in result:
        id.append([i[0], i[1]])
    return render(request, 'octopus/new-departments.html',{'result':id})
def list_departments(request):
    if request.method == 'GET':
        result=fu_admin.list_departments()
        id=[]
        for i in result:
            id.append([i[0],i[1]])
        # return render(request,'octopus/list-departments.html',{'result':id})
        return render(request,'octopus/list-departments-content.html',{'result':id})
    if request.method == 'POST':
        messages.info(request,"Method not allow")
        return HttpResponseRedirect('/')
def edit_departments(request,id):
    if request.method == 'GET':
        # request.build_absolute_uri()
        result=fu_admin.info_departments(id)
        return render(request,'octopus/edit-department.html',{'name':result[1]})
    if request.method == 'POST':
        departments = request.POST.get('departments')
        modify=fu_admin.modify_departments(id,departments)
        if modify==1:
            messages.info(request,'Cập nhật thành công !')
            return HttpResponseRedirect('/dashboard/new-departments/')
        elif modify==-99:
            messages.info(request, 'Lỗi cập nhật vui lòng thử lại !')
            return HttpResponseRedirect('/dashboard/new-departments/')
        result = fu_admin.info_departments(id)
        return render(request, 'octopus/edit-department.html', {'name': result[1]})
def delete_departments(request,id):
    if request.session.get('is_login')==True:
        delete=fu_admin.delete_departments(id)
        if delete==1:
            messages.info(request,'Xóa thành công')
            return HttpResponseRedirect('/dashboard/new-departments/')
        elif delete==-99:
            messages.info(request, 'Đang có nhân viên trong phòng ban không thể xóa!')
            return HttpResponseRedirect('/dashboard/new-departments/')
        elif delete==-9:
            messages.info(request,'Không tồn tại phòng ban này ')
    return HttpResponseRedirect('/dashboard/new-departments/')
def new_staff_type(request):
    if request.session.get('is_login') == True:
        staff_type_list=fu_admin.list_staff_type()
        if request.method == 'POST':
            staff_type = request.POST.get('staff-type')
            result=fu_admin.new_staff_type(staff_type)
            if result==1:
                messages.info(request,'Thêm thành công!')
                # return render(request,'octopus/staff-type.html',{'result':staff_type_list})
                return HttpResponseRedirect('/dashboard/staff-type')
            if result==-99:
                messages.info(request, 'Đã tồn tại ! Nhập lại')
                return HttpResponseRedirect('/dashboard/staff-type')
    else:
        return HttpResponseRedirect('/')
    staff_type_list = fu_admin.list_staff_type()
    return render(request, 'octopus/staff-type.html', {'result':staff_type_list})
def edit_staff_type(request,id):
    if request.session.get('is_login') == True:
        if request.method == 'POST':
            staff_type = request.POST.get('staff-type')
            result=fu_admin.edit_staff_type(id,staff_type)
            if result==1:
                messages.info(request,'Cập nhật thành công')
                return HttpResponseRedirect('/dashboard/staff-type')
            elif result==-99:
                messages.info(request, 'Cập nhật thất bại')
                return HttpResponseRedirect('/dashboard/staff-type')
    else:
        return HttpResponseRedirect('/')
    staff_type_list = fu_admin.list_staff_type()
    staff_type = fu_admin.info_staff_type(id)
    if staff_type[0]==-99:
        messages.info(request,'ID không tồn tại')
        return HttpResponseRedirect('/dashboard/staff-type')
    return render(request, 'octopus/edit-staff-type.html', {'result': staff_type_list, 'staff_type': staff_type[1]})
def delete_staff_type(request,id):
    if request.session.get('is_login')==True:
        delete=fu_admin.delete_staff_type(id)
        if delete==1:
            messages.info(request,'Xóa thành công')
            return HttpResponseRedirect('/dashboard/staff-type/')
        elif delete==-99:
            messages.info(request, 'Lỗi  vui lòng thử lại !')
            return HttpResponseRedirect('/dashboard/staff-type/')
    return HttpResponseRedirect('/dashboard/staff-type/')
def add_new_staff(request):
    if request.session.get('is_login') == True:
        if request.method == 'POST':
            flag = 1
            fullname = request.POST.get('fullname')
            email = request.POST.get('email')
            phone =request.POST.get('phone')
            address=request.POST.get('address')
            departments=request.POST.get('departments')
            work_type=request.POST.get('work_type')
            staff_type = request.POST.get('staff_type')
            start_time = datetime.strptime(request.POST.get('start_time'), '%m/%d/%Y')
            sex = request.POST.get('sex')
            staff_birthday = datetime.strptime(request.POST.get('staff_birthday'), '%m/%d/%Y')
            note = request.POST.get('note')
            full_time=request.POST.get('full_time')
            test_time=request.POST.get('test_time')
            if 'email' not in request.POST or email=='' or check.check_email(email)==None:
                messages.info(request,'Sai định dạng email')
                flag=-1
            if 'phone' not in  request.POST or check.check_phone(phone)==None:
                messages.info(request, 'Sai định dạng phone')
                flag = -2
            if check.check_id(departments,staff_type,work_type)==-99:
                messages.info(request,'Dữ liệu phòng ban hoặc chức vụ hoặc loại hình không chính xác')
                flag = -3
            if 'start_time' not in request.POST or 'end_time' =='':
                messages.info(request,'Sai ngày bắt đầu  hãy nhập lại')
                flag = -4
            if 'sex' not in request.POST or sex=='':
                messages.info(request, 'Chưa chọn giới tính')
                flag = -5
            if 'staff_birthday' not in request.POST or staff_birthday=='':
                flag=-7
                messages.info(request,'Hãy nhập ngày sinh cho nhân viên')
            if 'work_type' not in request.POST or work_type=='':
                flag=-6
                messages.info(request, 'Hãy chọn hình thức làm việc cho nhân viên')
            if full_time=='' and test_time=='':
                flag=-8
                messages.info(request,'Hãy chọn thời gian hợp đồng cho nhân viên')
            if full_time!='' and test_time=='':
                contract_time=full_time
                status=1
            if full_time=='' and test_time!='':
                contract_time=test_time
                status=0
            if full_time!='' and test_time!='':
                flag=-9
                messages.info(request,'Chọn lại thời gian hợp đồng của nhân viên')
            if flag<0:
                return HttpResponseRedirect('/dashboard/add-new-staff/')
            elif flag==1:
                add=fu_admin.add_new_staff(fullname,phone,email,address,staff_birthday,contract_time,status,staff_type,departments,work_type,start_time,note,sex)
                if add==1:
                    messages.info(request, 'Đã thêm thành công')
                elif add==-99:
                    messages.info(request, 'Email đã có nhân viên sử dụng')
                return HttpResponseRedirect('/dashboard/add-new-staff/')
        result = fu_admin.list_departments()
        top_new_staff=fu_admin.top_50_new_staff()
        departments = []
        for i in result:
            departments.append([i[0],i[1]])
        staff_type_list = fu_admin.list_staff_type()
        list_work_type=fu_admin.list_work_type()
        return render(request,'octopus/add-new-staff.html',{'departments':departments,'staff_type':staff_type_list,'work_type':list_work_type,'top_new_staff':top_new_staff})
    else:
        return HttpResponseRedirect('/')
def list_staff(request):
    result=fu_admin.list_all_staff()
    return render(request,'octopus/list-staff.html',{'result':result})
def list_probationary_staff(request):
    staff_test = fu_admin.list_probationary_staff()
    return render(request, 'octopus/list_probationary_staff.html', {'staff_test': staff_test})
def upgrade_probationary_staff(request,id):
    if request.session.get('is_login') == True:
        result=fu_admin.upgrade_probationary_staff(id)
        if result==1:
            messages.info(request,'Đã chuyển chính thức thành công')
        else:
            messages.info(request, 'Lỗi không thể chuyển lên chính thức')
        return HttpResponseRedirect('/dashboard/upgrade-staff/')
    return HttpResponseRedirect('/dashboard/upgrade-staff/')
def staff_quit(request,id):
    if request.session.get('is_login') == True:
        result=fu_admin.staff_quit(id)
        if result==1:
            messages.info(request,'Cập nhật thành công : nhân viên đã nghỉ việc')
        else:
            messages.info(request, 'Không thể cập nhật do nhân viên chưa bàn giao thiết bị')
        return HttpResponseRedirect('/dashboard/list-staff/')
    return HttpResponseRedirect('/dashboard/list-staff/')
def staff_quit_list(request):
    if request.session.get('is_login') == True:
        result=fu_admin.staff_quit_list()
        return render(request, 'octopus/staff_quit_list.html',{'result':result})
    return render(request,'octopus/staff_quit_list.html')
def work_type(request):
    if request.method=='POST':
        type=request.POST.get('work-type')
        result=fu_admin.add_new_work_type(type)
        if result==1:
            messages.info(request,'Thêm thành công')
            return HttpResponseRedirect('/dashboard/work-type/')
        elif result==-99:
            messages.info(request, 'Loại hình đã tồn tại')
            return HttpResponseRedirect('/dashboard/work-type/')
        # list_type=fu_admin.list_work_type()
        # return render(request,'octopus/new_work_type.html',{'result':list_type})
        return HttpResponseRedirect('/dashboard/work-type/')
    list_type = fu_admin.list_work_type()
    return render(request, 'octopus/new_work_type.html', {'result': list_type})
def edit_work_type(request,id):
    if request.session.get('is_login') == True:
        if request.method == 'POST':
            type = request.POST.get('work-type')
            result=fu_admin.edit_work_type(id,type)
            if result==1:
                messages.info(request,'Cập nhật thành công')
                return HttpResponseRedirect('/dashboard/work-type/')
            elif result==-99:
                messages.info(request, 'Cập nhật thất bại')
                return HttpResponseRedirect('/dashboard/work-type/')
            elif result == -1:
                messages.info(request, 'Không tồn tại id trên thử lại')
                return HttpResponseRedirect('/dashboard/work-type/')
    else:
        return HttpResponseRedirect('/')
    work_type_name=fu_admin.get_work_type_name(id)
    if work_type_name[0]==1:
        return render(request, 'octopus/edit-work-type.html',{'name':work_type_name[1]})
    else:
        messages.info(request, 'Không tồn tại id trên thử lại')
        return HttpResponseRedirect('/dashboard/work-type/')
def delete_work_type(request,id):
    if request.session.get('is_login') == True:
        result=fu_admin.delete_work_type(id)
        if result==1:
            messages.info(request,'Xóa thành công')
        elif result==-99:
            messages.info(request,'Không thể xóa có nhân viên hoặc không tồn tại ')
    return HttpResponseRedirect('/dashboard/work-type/')

def full_info_staff(request,id):
    if request.session.get('is_login') == True:
        result=fu_admin.staff_info(id)
        return render(request,'octopus/staff_info.html',{'result':result,'id':id})
    else:
        return HttpResponseRedirect('/')
def delete_staff(request,id):
    if request.session.get('is_login') == True:
        result=fu_admin.delete_staff(id)
        if result==1:
            messages.info(request,'Xóa thành công')
        elif result==-99:
            messages.info(request,'Xóa thất bại ')
        return HttpResponseRedirect('/dashboard/list-staff/')
    else:
        return HttpResponseRedirect('/')
def staff_file_list(request):
    if request.session.get('is_login') == True:
        result=fu_admin.staff_profile_list()
        return render(request,'octopus/staff_profile_list.html',{'result':result})
    else:
        return HttpResponseRedirect('/')
def staff_file_update(request,id):
    if request.session.get('is_login') == True:
        staff_certificate=request.POST.get('staff_certificate')
        staff_health_certificate=request.POST.get('staff_health_certificate')
        staff_papers=request.POST.get('staff_papers')
        staff_marital_status=request.POST.get('staff_marital_status')
        fu_admin.staff_profile_update(id,staff_certificate,staff_health_certificate,staff_papers,staff_marital_status)
        messages.info(request, 'Cập nhật thành công')
        return HttpResponseRedirect('/dashboard/staff-file/list/')
    else:
        return HttpResponseRedirect('/')
def admin_profile(request):
    if request.session.get('is_login') == True:
        account=request.session.get('account')
        result=fu_admin.admin_account_profile(account)
        if result[0]==1:
            return render(request,'profile.html',{'result':result})
        else:
            return HttpResponseRedirect('/')
    else:
        return HttpResponseRedirect('/')
def admin_profile_change_passwd(request,account):
    if request.session.get('is_login') == True:
        if request.method=='POST':
            old_passwd=request.POST.get('oldpasswd')
            newpasswd=request.POST.get('newpasswd')
            renewpasswd=request.POST.get('renewpasswd')
            result=fu_admin.admin_profile_change_passwd(account,old_passwd,newpasswd,renewpasswd)
            if result==-99:
                messages.info(request,'Mật khẩu hiện tại không khớp')
            elif result==-10:
                messages.info(request,'Mật khẩu mới nhập 2 lần không khớp')
            elif result==-11:
                messages.info(request,'Mật khẩu mới phải khác mật khẩu cũ')
            elif result==1:
                messages.info(request,'Đổi mật khẩu thành công')
            return HttpResponseRedirect('/dashboard/profile/')
    else:
        return HttpResponseRedirect('/')
####################################### IT VIEW####################
def add_new_device_partner(request):
    if request.session.get('is_login') == True and request.session.get('account_type') == 2:
        top_10_device_partner=fu_admin.top_10_device_partner()
        if request.method == 'POST':
            partner_name=request.POST.get('partner_name')
            partner_phone = request.POST.get('partner_phone')
            partner_address = request.POST.get('partner_address')
            partner_note = request.POST.get('partner_note')
            partner_email = request.POST.get('partner_email')
            if check.check_email(partner_email)==None or check.check_phone(partner_phone)==None:
                messages.info(request,'Sai định dạng email hoặc phone ! kiểm tra lại')
            else:
                result=fu_admin.add_new_device_partner(partner_name,partner_phone,partner_address,partner_note,partner_email)
                if result==1:
                    messages.info(request,'Thêm thành công')
                elif result==-99:
                    messages.info(request,'Nhà cung cấp đã tồn tại')
            return HttpResponseRedirect('/dashboard/it/device-partner-add')
        return render(request,'it/device_partner_add.html',{'top_10_device_partner':top_10_device_partner})
    else:
        return HttpResponseRedirect('/')
def list_device_partner(request):
    if request.session.get('is_login') == True and request.session.get('account_type') == 2:
        result=fu_admin.device_partner_list()
        return render(request,'it/device_partner_list.html',{'result':result})
    else:
        return HttpResponseRedirect('/')
def device_type(request):
    if request.session.get('is_login') == True and request.session.get('account_type') == 2:
        list_type=fu_admin.device_type_list()
        if request.method=='POST':
            device_type=request.POST.get('device_type')
            result=fu_admin.device_type_add(device_type)
            if result==1:
                messages.info(request,'Thêm thành công')
            elif result==-99:
                messages.info(request,'Tên đã tồn tại')
            return HttpResponseRedirect('/dashboard/it/device-type')
        return render(request,'it/device_type.html',{'result':list_type})
    else:
        return HttpResponseRedirect('/')
def device_type_all(request):
    if request.session.get('is_login') == True and request.session.get('account_type') == 2:
        list_type=fu_admin.device_type_list()
        return render(request,'it/device_type_all.html',{'result':list_type})
    else:
        return HttpResponseRedirect('/')
def device_type_all_id(request,id):
    if request.session.get('is_login') == True and request.session.get('account_type') == 2:
        list_type=fu_admin.device_type_id(id)
        return render(request,'it/list_device_id.html',{'result':list_type})
    else:
        return HttpResponseRedirect('/')
def device_receive(request):
    if request.session.get('is_login') == True and request.session.get('account_type') == 2:
        if request.method=='POST':
            device_name=request.POST.get('device_name')
            device_price=request.POST.get('device_price')
            device_info=request.POST.get('device_info')
            device_type=request.POST.get('device_type')
            partner=request.POST.get('partner')
            receive_time=datetime.strptime(request.POST.get('receive_time'), '%m/%d/%Y')
            device_protection_time=request.POST.get('device_protection_time')
            device_quantity=request.POST.get('device_quantity')
            if int(device_protection_time)<0 or int(device_quantity)<0:
                messages.info(request,'Số lượng và thời gian bảo hành nhập sai')
            else:
                for i in range(0,int(device_quantity)):
                    result = fu_admin.device_receive(device_name, device_price, device_info, device_type, partner,
                                                     receive_time, device_protection_time)
                    if result == 1:
                        messages.info(request, 'Nhập thành công')
                    elif result == -99:
                        messages.info(request, 'Tag đã tồn tại')
            return HttpResponseRedirect('/dashboard/it/device-receive')
            # print(device_name,device_price,device_info,device_type,partner,receive_time)
        device_type_list=fu_admin.device_type_list()
        partner_list=fu_admin.device_partner_list()
        return render(request,'it/device_buy.html',{'device_type':device_type_list,'partner':partner_list})
    else:
        return HttpResponseRedirect('/')
def device_receive_no_transfer (request):
    if request.session.get('is_login') == True and request.session.get('account_type') == 2:
        result=fu_admin.device_no_tranfer()
        return render(request,'it/device_no_tranfer_list.html',{'result':result})
    else:
        return HttpResponseRedirect('/')
def transfer_device(request):
    if request.session.get('is_login') == True and request.session.get('account_type') == 2:
        if request.method=='POST':
            departments=request.POST.get('departments')
            staff=request.POST.get('staff')
            devicetypeid=request.POST.get('devicetypeid')
            device_id=request.POST.get('device_id')
            result=fu_admin.tranfers_device(departments,staff,devicetypeid,device_id)
            if result==-99:
                messages.info(request,'Thiết bị đã bàn giao ! Vui lòng thử lại')
            elif result==1:
                messages.info(request,'Bàn giao thành công')
            return HttpResponseRedirect('/dashboard/it/transfer-device/')
        return render(request,'it/tranfer_device.html')
    else:
        return HttpResponseRedirect('/')
def transfer_device_list(request):
    if request.session.get('is_login') == True and request.session.get('account_type') == 2:
        result=fu_admin.device_tranfer_listall()
        return render(request,'it/tranfer_device_list.html',{'result':result})
    else:
        return HttpResponseRedirect('/')
def transfer_device_staff_to_it(request):
    if request.session.get('is_login') == True and request.session.get('account_type') == 2:
        if request.method=='POST':
            departments=request.POST.get('departments')
            staff=request.POST.get('staff')
            device=request.POST.get('device-user-list')
            result=fu_admin.tranfer_device_staff_to_it(departments,staff,device)
            if result[0]==1:
                messages.info(request,'Bàn giao thành công')
            else:
                messages.info(request,'Bàn giao thất bại')
            return HttpResponseRedirect('/dashboard/it/transfer-device-staff-to-it/')
        return render(request,'it/device_tranfer_staff_to_it.html')
    else:
        return HttpResponseRedirect('/')
def list_device_staff_use(request,id):
    if request.session.get('is_login') == True and request.session.get('account_type') == 2:
        device_list=fu_admin.device_staff_used(id)
        return render(request,'it/device_staff_used.html',{'result':device_list})
    else:
        return HttpResponseRedirect('/')
def transfer_device_staff_to_it_list(request):
    if request.session.get('is_login') == True and request.session.get('account_type') == 2:
        result=fu_admin.device_staff_to_it_listall()
        return render(request,'it/device_staff_tranfer_to_it.html',{'result':result})
    else:
        return HttpResponseRedirect('/')
def device_detail(request,id):
    if request.session.get('is_login') == True and request.session.get('account_type') == 2:
        result=fu_admin.device_detail_id(id)
        return render(request,'it/device_detail.html',{'result':result})
    else:
        return HttpResponseRedirect('/')
def device_crash(request,tag):
    if request.session.get('is_login') == True and request.session.get('account_type') == 2:
        pass
    else:
        return HttpResponseRedirect('/')