from django.http import HttpResponse
from django.shortcuts import render, redirect
from utils.query import query

def show_daftar_favorit(request):
    return render(request, "daftar_favorit.html")

def show_detail_daftar_favorit(request):
    return render(request, "detail_daftar_favorit.html")

# READ list daftar favorit
def list_daftar_favorit(request):
    logged_in_user = request.session["username"]
    q = 'SELECT timestamp, username, judul FROM daftar_favorit WHERE username = %s'
    daftar_favorit = query(q, [logged_in_user])
    return render(request, 'daftar_favorit.html', {'daftar_favorit': daftar_favorit})

# DELETE list daftar favorit
def delete_daftar_favorit(request, judul):
    print("tes")
    logged_in_user = request.session["username"]
    q = 'DELETE FROM daftar_favorit WHERE judul = %s AND username = %s'
    query(q, [judul, logged_in_user])
    return HttpResponse('Succesfully deleted.', status=200)

# READ isi daftar favorit (judul tayangan)
def detail_daftar_favorit(request, judul):
    logged_in_user = request.session["username"]
    q = '''
    SELECT t.id, t.judul, tf.timestamp
    FROM tayangan t
    JOIN tayangan_memiliki_daftar_favorit tf ON t.id = tf.id_tayangan
    JOIN daftar_favorit df on tf.timestamp = df.timestamp AND tf.username = df.username
    WHERE tf.username = %s AND df.judul = %s
    '''
    detail_daftar_favorit = query(q, [logged_in_user, judul])
    return render(request, 'detail_daftar_favorit.html', context = {'detail_daftar_favorit': detail_daftar_favorit})

def delete_tayangan_daftar_favorit(request, id, judul):
    logged_in_user = request.session["username"]
    q = '''
    DELETE FROM tayangan_memiliki_daftar_favorit 
    WHERE id IN (SELECT t.id FROM tayangan t WHERE t.id = id)
    AND timestamp IN (SELECT df.timestamp FROM daftar_favorit df JOIN pengguna p ON df.username = p.username)
    WHERE df.judul = %s AND p.username = %s
    '''
    query(q, [id, judul, logged_in_user])
    return HttpResponse('Succesfully deleted.', status=200)