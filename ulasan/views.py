from django.http import HttpResponse
from django.shortcuts import render, redirect
from utils.query import query
from django.contrib import messages

# Create your views here.
def index_ulasan(request, id_tayangan):
    try :
        print("ID TAYANGAN: ", id_tayangan)
        query_ulasan = f"""
        SELECT username, rating, deskripsi 
        FROM ULASAN
        WHERE id_tayangan = '{id_tayangan}'
        ORDER BY timestamp DESC;
        ;
        """
        print(request.GET.get("rate"))
        print(request.GET.get("ulasan"))
        response = query(query_ulasan)
        context = {
            "daftar_ulasan": response,
            "id_tayangan": id_tayangan
        }

        return render(request, "index_ulasan.html", context=context)
    except Exception as e:
        return HttpResponse(e)
    
def create_ulasan(request, id_tayangan_sekarang):
    try:
        if request.method == "POST":
            username = request.session.get("username")
            rating = request.POST.get("rate")
            if(rating == None or rating == ""):
                rating = 0
            deskripsi = request.POST.get("ulasan")
            if(deskripsi == None or deskripsi == ""):
                deskripsi = "Tidak ada ulasan"
            print(deskripsi)
            id_tayangan = id_tayangan_sekarang
            query_create_ulasan = f"""
            INSERT INTO ULASAN (username, rating, deskripsi, id_tayangan, timestamp)
            VALUES ('{username}', {rating}, '{deskripsi}', '{id_tayangan}', 'NOW()');
            """
            response = query(query_create_ulasan)
            print(response)
            messages.success(request, "Ulasan berhasil ditambahkan")
            return redirect(f"/ulasan/{id_tayangan}")
        return redirect(f"/ulasan/{id_tayangan}")
    except Exception as e:
        return HttpResponse(e)