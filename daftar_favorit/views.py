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
def delete_daftar_favorit(request, timestamp, username):
    q = 'DELETE FROM daftar_favorit WHERE timestamp = %s AND username = %s'
    query(q, [timestamp, username])
    return redirect('list_daftar_favorit')

# READ isi daftar favorit (judul tayangan)
def detail_daftar_favorit(request, judul):
    print("tes")
    logged_in_user = request.session["username"]
    q = '''
    SELECT t.id, t.judul, tf.timestamp
    FROM tayangan t
    JOIN tayangan_memiliki_daftar_favorit tf ON t.id = tf.id_tayangan
    JOIN daftar_favorit df on tf.timestamp = df.timestamp AND tf.username = df.username
    WHERE tf.username = %s AND df.judul = %s
    '''
    detail_daftar_favorit = query(q, [logged_in_user, judul])
    print("judul: ", judul)
    print(detail_daftar_favorit)
    print("tes 2")
    return render(request, 'detail_daftar_favorit.html', context = {'detail_daftar_favorit': detail_daftar_favorit})

def delete_tayangan_daftar_favorit(request, id_tayangan, timestamp, username):
    q = 'DELETE FROM tayangan_memiliki_daftar_favorit WHERE id_tayangan = %s AND timestamp = %s AND username = %s'
    query(q, [id_tayangan, timestamp, username])
    return redirect('list_isi_daftar_favorit', timestamp=timestamp, username=username)
