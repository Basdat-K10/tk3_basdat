from django.shortcuts import render
from utils.query import query

# Create your views here.
def index(request):
    try :
        query_ulasan = """
        SELECT username, rating, deskripsi FROM ULASAN 
        """
        response = query(query_ulasan)
        context = {
            "daftar_ulasan": response
        }

        return render(request, "index_ulasan.html", context=context)
    except Exception as e:
        return render(request, "404.html", {"error": e})