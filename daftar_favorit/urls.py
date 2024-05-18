from django.urls import path
from .views import (
    list_daftar_favorit,
    delete_daftar_favorit,
    detail_daftar_favorit,
    delete_tayangan_daftar_favorit,
)

app_name = 'daftar_favorit'

urlpatterns = [
    path('', list_daftar_favorit, name='list_daftar_favorit'),
    path('detail_daftar_favorit/<str:judul>/', detail_daftar_favorit, name='detail_daftar_favorit'),
    path('daftar_favorit/<str:timestamp>/<str:username>/', detail_daftar_favorit, name='list_isi_daftar_favorit'),
    path('delete_daftar_favorit/<str:judul>/', delete_daftar_favorit, name='delete_daftar_favorit'),
    path('delete_tayangan_daftar_favorit/<str:id>/<str:judul>/', delete_tayangan_daftar_favorit, name='delete_tayangan_daftar_favorit'),
]