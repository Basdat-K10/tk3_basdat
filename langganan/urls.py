from django.urls import path, include
from .views import show_beli, show_user_paket, beli

urlpatterns = [
    path('', show_user_paket, name='show_user_paket'),
    path('pembelian/', show_beli, name='show_beli'),
    path('pembelian/beli/', beli, name='beli'),
]