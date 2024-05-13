from django.http import HttpResponse
from django.shortcuts import render, redirect
from utils.query import query
from django.contrib import messages

# Create your views here.
def index(request):
    try :
        query_ulasan = """
        SELECT username, rating, deskripsi FROM ULASAN 
        """
        print(request.GET.get("rate"))
        print(request.GET.get("ulasan"))
        response = query(query_ulasan)
        context = {
            "daftar_ulasan": response
        }

        return render(request, "index_ulasan.html", context=context)
    except Exception as e:
        return HttpResponse(e)
    
def create_ulasan(request):
    try:
        if request.method == "POST":
            username = "DavidKim"
            rating = request.POST.get("rate")
            if(rating == None or rating == ""):
                rating = 0
            deskripsi = request.POST.get("ulasan")
            if(deskripsi == None or deskripsi == ""):
                deskripsi = "Tidak ada ulasan"
            print(deskripsi)
            id_tayangan = '9a5ae86a-b6f1-4878-a84d-35970f4b0089'
            query_create_ulasan = f"""
            INSERT INTO ULASAN (username, rating, deskripsi, id_tayangan, timestamp)
            VALUES ('{username}', {rating}, '{deskripsi}', '{id_tayangan}', 'NOW()');
            """
            response = query(query_create_ulasan)
            print(response)
            messages.success(request, "Ulasan berhasil ditambahkan")
            return redirect("/ulasan")
        return redirect("/ulasan")
    except Exception as e:
        return HttpResponse(e)