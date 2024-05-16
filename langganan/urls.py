from django.urls import path, include
from .views import show_paket, show_beli, show_user_paket

urlpatterns = [
    path('', show_user_paket, name='show_user_paket'),
    path('pembelian', show_beli, name='show_beli'),
]