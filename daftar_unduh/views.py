from django.shortcuts import render, redirect
from utils.query import query

def show_daftar_unduh(request):
    return render(request, "daftar_unduh.html")

# READ list daftar unduh
def list_daftar_unduh(request):
    logged_in_user = request.session["username"]
    q = 'SELECT timestamp, username, judul FROM tayangan_terunduh WHERE username = %s'
    daftar_unduh = query(q, [logged_in_user])
    print(logged_in_user)
    return render(request, 'daftar_unduh.html', {'daftar_unduh': daftar_unduh})

# DELETE list daftar unduh
def delete_tayangan(timestamp, username):
    q = 'DELETE FROM tayangan_terunduh WHERE timestamp = %s AND username = %s'
    query(q, [timestamp, username])
    return redirect('list_daftar_unduh')