from django.urls import path, include
from .views import index, detail_episode, detail_film, detail_series, search, tentukan_tayangan

urlpatterns = [
    path("", index),
    path("top/<str:id>", tentukan_tayangan , name="top"),
    path("search/", search, name="search"),
    path("series/<str:id>", detail_series, name="series"),
    path("film/<str:id>", detail_film, name="film"),
    path("series/episode/<uuid:id_series>/<str:sub_judul>", detail_episode, name="episode")
]