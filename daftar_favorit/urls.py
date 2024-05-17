from django.urls import path
from .views import (
    show_daftar_favorit,
    show_daftar,
    list_daftar_favorit,
    delete_daftar_favorit,
    list_isi_daftar_favorit,
    delete_isi_daftar_favorit
)

urlpatterns = [
    path('', list_daftar_favorit, name='list_daftar_favorit'),
    path('all/', show_daftar, name='show_daftar'),
    path('daftar/', list_daftar_favorit, name='list_daftar_favorit'),
    path('daftar/delete/<str:timestamp>/<str:username>/', delete_daftar_favorit, name='delete_daftar_favorit'),
    path('daftar_favorit/<str:timestamp>/<str:username>/', list_isi_daftar_favorit, name='list_isi_daftar_favorit'),
    path('daftar_favorit/delete/<uuid:id_tayangan>/<str:timestamp>/<str:username>/', delete_isi_daftar_favorit, name='delete_isi_daftar_favorit'),
]
