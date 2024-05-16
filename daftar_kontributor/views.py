from django.shortcuts import render
from utils.query import query
# Create your views here.

def show_contributors(request):
    # Ambil dari tiap tabel penulis, pemain dan sutradar, lalu disatukan, biar memunculkan overlapped tipe
    contributors = query(
    """
    SELECT
    CONTRIBUTORS.nama AS nama,
    'Penulis' AS tipe,
    CASE CONTRIBUTORS.jenis_kelamin
        WHEN 0 THEN 'Laki-Laki'
        WHEN 1 THEN 'Perempuan'
        ELSE 'Unknown'
    END AS jenis_kelamin,
    CONTRIBUTORS.kewarganegaraan AS kewarganegaraan
    FROM
        CONTRIBUTORS
    INNER JOIN PENULIS_SKENARIO ON CONTRIBUTORS.id = PENULIS_SKENARIO.id

    UNION

    SELECT
        CONTRIBUTORS.nama AS nama,
        'Aktor' AS tipe,
        CASE CONTRIBUTORS.jenis_kelamin
            WHEN 0 THEN 'Laki-Laki'
            WHEN 1 THEN 'Perempuan'
            ELSE 'Unknown'
        END AS jenis_kelamin,
        CONTRIBUTORS.kewarganegaraan AS kewarganegaraan
    FROM
        CONTRIBUTORS
    INNER JOIN PEMAIN ON CONTRIBUTORS.id = PEMAIN.id

    UNION

    SELECT
        CONTRIBUTORS.nama AS nama,
        'Sutradara' AS tipe,
        CASE CONTRIBUTORS.jenis_kelamin
            WHEN 0 THEN 'Laki-Laki'
            WHEN 1 THEN 'Perempuan'
            ELSE 'Unknown'
        END AS jenis_kelamin,
        CONTRIBUTORS.kewarganegaraan AS kewarganegaraan
    FROM
        CONTRIBUTORS
    INNER JOIN SUTRADARA ON CONTRIBUTORS.id = SUTRADARA.id;

    """)
    context = {'contributors': contributors}
    return render(request, "daftar_kontributor.html", context)