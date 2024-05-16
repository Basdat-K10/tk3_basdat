from django.urls import path, include
from .views import index_ulasan, create_ulasan

urlpatterns = [
    path("<str:id_tayangan>/", index_ulasan, name="ulasan"),
    path("create_ulasan/<str:id_tayangan_sekarang>/", create_ulasan, name="create_ulasan")
]