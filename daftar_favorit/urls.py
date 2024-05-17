from django.urls import path
from .views import (
    list_daftar_favorit,
    delete_daftar_favorit,
    detail_daftar_favorit,
    delete_tayangan_daftar_favorit,
    show_detail_daftar_favorit
)

urlpatterns = [
    path('', list_daftar_favorit, name='list_daftar_favorit'),
    path('detail_daftar_favorit', show_detail_daftar_favorit, name='detail_daftar_favorit'),
    path('daftar/delete/<str:timestamp>/<str:username>/', delete_daftar_favorit, name='delete_daftar_favorit'),
    path('daftar_favorit/<str:timestamp>/<str:username>/', detail_daftar_favorit, name='list_isi_daftar_favorit'),
    path('daftar_favorit/delete/<uuid:id_tayangan>/<str:timestamp>/<str:username>/', delete_tayangan_daftar_favorit, name='delete_isi_daftar_favorit'),
]