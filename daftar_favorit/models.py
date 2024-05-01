from django.db import models
from django.contrib.auth.models import User

class Favorit(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE) 
    judul = models.CharField(max_length=100)
    waktu_ditambahkan = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.judul

class Daftar(models.Model):
    nama_daftar = models.CharField(max_length=100)

    def __str__(self):
        return self.nama_daftar