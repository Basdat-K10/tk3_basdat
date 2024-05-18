from django.urls import path, include
from .views import list_daftar_unduh, delete_tayangan

app_name = 'daftar_unduh'

urlpatterns = [
    path('', list_daftar_unduh, name='list_daftar_unduh'),
    path('delete_tayangan/<str:id>/', delete_tayangan, name='delete_tayangan'),
]