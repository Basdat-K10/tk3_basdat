from django.shortcuts import render, redirect
from utils.query import query

def show_daftar_favorit(request):
    return render(request, "daftar_favorit.html")

def show_daftar(request):
    return render(request, "daftar.html")

# READ list daftar favorit
def list_daftar_favorit(request):
    logged_in_user = request.session["username"]
    q = 'SELECT timestamp, username, judul FROM daftar_favorit WHERE username = %s'
    daftar_favorit = query(q, [logged_in_user])
    print(logged_in_user)
    return render(request, 'daftar.html', {'daftar_favorit': daftar_favorit})

# DELETE list daftar favorit
def delete_daftar_favorit(timestamp, username):
    q = 'DELETE FROM daftar_favorit WHERE timestamp = %s AND username = %s'
    query(q, [timestamp, username])
    return redirect('list_daftar_favorit')

# READ isi daftar favorit (judul tayangan)
def list_isi_daftar_favorit(request):
    logged_in_user = request.session["username"]
    q = '''
    SELECT 
        tm.id_tayangan,
        df.judul,
    FROM 
        TAYANGAN_MEMILIKI_DAFTAR_FAVORIT tm
    JOIN 
        DAFTAR_FAVORIT ON tm.username = df.username
    JOIN 
        PENGGUNA p ON df.username = p.username
    WHERE 
        p.username = %s;
    '''
    isi_daftar_favorit = query(q, [logged_in_user])
    return render(request, 'daftar_favorit.html', {'isi_daftar_favorit': isi_daftar_favorit})

# DELETE isi daftar favorit
def delete_isi_daftar_favorit(id_tayangan, timestamp, username):
    q = 'DELETE FROM tayangan_memiliki_daftar_favorit WHERE id_tayangan = %s AND timestamp = %s AND username = %s'
    query(q, [id_tayangan, timestamp, username])
    return redirect('list_isi_daftar_favorit', timestamp=timestamp, username=username)
