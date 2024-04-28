from django.shortcuts import render

# Create your views here.
def index(request):
    try :
        context = {
            "daftar_ulasan": [
                "Ulasan 1",
                "Ulasan 2",
                "Ulasan 3",
            ]
        }

        return render(request, "index.html", context=context)
    except Exception as e:
        return render(request, "404.html", {"error": e})