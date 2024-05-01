from django.urls import path, include
from .views import show_paket, show_beli

urlpatterns = [
    path('', show_paket, name='show_paket'),
    path('pembelian', show_beli, name='show_beli'),
]