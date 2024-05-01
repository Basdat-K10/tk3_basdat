from django.shortcuts import render
from .models import Unduhan

def show_daftar_unduh(request):
    daftar_unduh = Unduhan.objects.all()

    return render(request, 'daftar_unduh.html', {'daftar_unduh': daftar_unduh})
