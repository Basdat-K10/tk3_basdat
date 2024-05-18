from django.shortcuts import render, redirect
from utils.query import query

def show_daftar_unduh(request):
    return render(request, "daftar_unduh.html")

# READ list daftar unduh
def list_daftar_unduh(request):
    logged_in_user = request.session["username"]
    q = '''
    SELECT t.id, t.judul, tr.timestamp
    FROM tayangan t
    JOIN tayangan_terunduh tr on t.id = tr.id_tayangan 
    WHERE username = %s
    '''
    daftar_unduh = query(q, [logged_in_user])
    return render(request, 'daftar_unduh.html', {'daftar_unduh': daftar_unduh})

# DELETE list daftar unduh
def delete_tayangan(request, id):
    logged_in_user = request.session["username"]
    q = 'DELETE FROM tayangan_terunduh WHERE id_tayangan = %s AND username = %s'
    query(q, [id, logged_in_user])
    return redirect(request, 'daftar_unduh.html', {'daftar_unduh':list_daftar_unduh})