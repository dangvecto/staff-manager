"""staffmanager URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from django.conf.urls import include, url
from django.views.generic import RedirectView
import core.views as views

urlpatterns = [
    url(r'^favicon\.ico$',RedirectView.as_view(url='/assets/favicon.ico')),
    path('',views.login),
    path('logout/',views.logout),
    path('dashboard/',views.dashboard),
    path('dashboard/new-departments/',views.new_departments),
    path('dashboard/list-departments/',views.list_departments),
    path('dashboard/list-staff-departments/<int:id>',views.list_staff_departments),
    path('dashboard/list-departments/edit/<int:id>',views.edit_departments),
    path('dashboard/list-departments/delete/<int:id>',views.delete_departments),
    path('dashboard/staff-type/',views.new_staff_type),
    path('dashboard/staff-type/edit/<int:id>',views.edit_staff_type),
    path('dashboard/staff-type/delete/<int:id>',views.delete_staff_type),
    path('dashboard/work-type/', views.work_type),
    path('dashboard/work-type/edit/<int:id>', views.edit_work_type),
    path('dashboard/work-type/delete/<int:id>', views.delete_work_type),
    path('dashboard/add-new-staff/',views.add_new_staff),
    path('dashboard/list-staff/',views.list_staff),
    path('dashboard/staff-info/<int:id>/',views.full_info_staff),
    #path('dashboard/staff-delete/<int:id>',views.delete_staff),
    path('dashboard/upgrade-staff/',views.list_probationary_staff),
    path('dashboard/upgrade-staff/<int:id>',views.upgrade_probationary_staff),
    path('dashboard/staff-quit/',views.staff_quit_list),
    path('dashboard/staff-quit/<int:id>',views.staff_quit),
    path('dashboard/staff-file/list/',views.staff_file_list),
    path('dashboard/staff-file/update/<int:id>',views.staff_file_update),
    path('dashboard/profile/',views.admin_profile),
    path('dashboard/profile/changepasswd/<str:account>',views.admin_profile_change_passwd),
    #### IT patch###
    path('dashboard/it/device-partner-add/',views.add_new_device_partner),
    path('dashboard/it/device-partner-list/',views.list_device_partner),
    path('dashboard/it/device-type/', views.device_type),
    path('dashboard/it/device-type-all/', views.device_type_all),
    path('dashboard/it/device-type-all/<int:id>', views.device_type_all_id),
    path('dashboard/it/device-receive/', views.device_receive),
    path('dashboard/it/device-no-transfer/', views.device_receive_no_transfer),
    path('dashboard/it/transfer-device/', views.transfer_device),
    path('dashboard/it/transfer-device-list/', views.transfer_device_list),
    path('dashboard/it/transfer-device-staff-to-it/', views.transfer_device_staff_to_it),
    path('dashboard/it/list-device-staff-use/<int:id>', views.list_device_staff_use),
    path('dashboard/it/transfer-device-staff-to-it-list/', views.transfer_device_staff_to_it_list),
    path('dashboard/it/device-detail/<int:id>', views.device_detail),
    path('dashboard/it/device-crash/<str:tag>',views.device_crash),

]
