from django.http import HttpResponse
from django.shortcuts import render
from utils.query import query

# Create your views here.
def index(request):
    try : 
        movie_top = """
            WITH episode_durations AS (
            SELECT id_series,
                SUM(durasi) AS total_durasi
            FROM EPISODE
            GROUP BY id_series
        ),
        viewer_count AS (
            SELECT rn.id_tayangan,
                COUNT(*) AS total_view
            FROM RIWAYAT_NONTON AS rn
            LEFT JOIN FILM AS f ON rn.id_tayangan = f.id_tayangan
            LEFT JOIN episode_durations AS ed ON rn.id_tayangan = ed.id_series
            WHERE rn.end_date_time >= NOW() - INTERVAL '1 month'
            AND EXTRACT(EPOCH FROM (rn.end_date_time - rn.start_date_time)) / 60 >= 0.7 * COALESCE(f.durasi_film, ed.total_durasi)
            GROUP BY rn.id_tayangan
        ),
        ranked_viewers AS (
            SELECT id_tayangan,
                COALESCE(total_view, 0) AS total_view,
                ROW_NUMBER() OVER (ORDER BY COALESCE(total_view, 0) DESC) AS rank
            FROM viewer_count
        )
        SELECT
        t.id as id,  
        t.judul AS title, 
        t.sinopsis_trailer AS synopsis, 
        t.url_video_trailer AS url,
        t.release_date_trailer AS release_date,
        COALESCE(total_view, 0) as total_view,
        CASE WHEN rv.total_view = 0 THEN ROW_NUMBER() OVER (ORDER BY t.judul)
            ELSE rv.rank
        END AS rank
        FROM TAYANGAN AS t 
        LEFT JOIN ranked_viewers AS rv ON t.id = rv.id_tayangan
        ORDER BY rank
        LIMIT 10;
        """
        response = query(movie_top)
        
        movie_film = """
        SELECT 
        t.id as id,
        t.judul AS title,
        t.sinopsis_trailer AS synopsis,
        t.url_video_trailer AS url,
        t.release_date_trailer AS release_date
        FROM TAYANGAN AS t
        JOIN FILM AS f ON t.id = f.id_tayangan
        """

        response_film = query(movie_film)

        movie_series = """
        SELECT
        t.id as id,
        t.judul AS title,
        t.sinopsis_trailer AS synopsis,
        t.url_video_trailer AS url,
        t.release_date_trailer AS release_date
        FROM TAYANGAN AS t
        JOIN SERIES AS s ON t.id = s.id_tayangan
        """
        response_series = query(movie_series)
        context = { 
            "movies": response,
            "films" : response_film,
            "series" : response_series
        }
        
        return render(request, "index_tayangan.html", context)
    except Exception as e:
        print(e)    
        return HttpResponse(e)

def detail_series(request, id):
    try :
        judul_series = f"""
        SELECT
            t.judul AS title,
            t.sinopsis AS sinopsis,
            t.asal_negara AS asal_negara
            FROM TAYANGAN AS t
        WHERE t.id = '{id}'
        """ 
        
        response_normal = query(judul_series)

        query_for_episode = f"""
        SELECT e.sub_judul AS sub_judul, 
        e.url_video AS url_video, 
        e.id_series as id_series,
        CONCAT(e.id_series, e.sub_judul) AS primary_episode
        FROM EPISODE AS e
        WHERE e.id_series = '{id}'
        """
        response_episode = query(query_for_episode)
        
        if(len(response_episode) == 0):
            response_episode = [{"sub_judul": "Unknown", "url_video": "Unknown"}]

        query_for_genre = f"""
        SELECT genre 
        FROM GENRE_TAYANGAN
        WHERE id_tayangan = '{id}'
        """
        response_genre = query(query_for_genre)
        if(len(response_genre) == 0):
            response_genre = [{"genre": "Unknown"}]

        query_for_pemain = f"""
        SELECT c.nama AS nama
        FROM CONTRIBUTORS AS c
        JOIN PEMAIN AS p ON c.id = p.id
        JOIN MEMAINKAN_TAYANGAN as m ON p.id = m.id_pemain
        WHERE m.id_tayangan = '{id}'
        """
        response_pemain = query(query_for_pemain)
        if(len(response_pemain) == 0):
            response_pemain = [{"nama": "Unknown"}]

        query_for_penulis = f"""
        SELECT c.nama AS nama
        FROM CONTRIBUTORS AS c
        JOIN PENULIS_SKENARIO AS ps ON c.id = ps.id
        JOIN MENULIS_SKENARIO_TAYANGAN as m ON ps.id = m.id_penulis_skenario
        WHERE m.id_tayangan = '{id}'
        """
        response_penulis = query(query_for_penulis)
        if(len(response_penulis) == 0):
            response_penulis = [{"nama": "Unknown"}]

        query_for_sutradara = f"""
        SELECT c.nama AS nama
        FROM CONTRIBUTORS AS c
        JOIN SUTRADARA AS s ON c.id = s.id
        JOIN TAYANGAN as t ON s.id = t.id_sutradara
        WHERE t.id = '{id}'
        """
        response_sutradara = query(query_for_sutradara)
        if(len(response_sutradara) == 0):
            response_sutradara = [{"nama": "Unknown"}]

        query_for_total_view = f"""
         WITH episode_durations AS (
            SELECT id_series,
                SUM(durasi) AS total_durasi
            FROM EPISODE
            GROUP BY id_series
        )
        SELECT rn.id_tayangan,
            COUNT(*) AS total_view
            FROM RIWAYAT_NONTON AS rn
            LEFT JOIN FILM AS f ON rn.id_tayangan = f.id_tayangan
            LEFT JOIN episode_durations AS ed ON rn.id_tayangan = ed.id_series
            JOIN TAYANGAN AS t ON rn.id_tayangan = t.id
            WHERE rn.end_date_time >= NOW() - INTERVAL '1 month' and t.id = '{id}'
            AND EXTRACT(EPOCH FROM (rn.end_date_time - rn.start_date_time)) / 60 >= 0.7 * COALESCE(f.durasi_film, ed.total_durasi)
            GROUP BY rn.id_tayangan
        """
        response_total_view = query(query_for_total_view)
        if(len(response_total_view) == 0):
            response_total_view = [{"total_view": 0}]

        context = {
            "title" : response_normal[0]["title"],
            "episode" : response_episode,
            "total_view": response_total_view[0]["total_view"],
            "rating_rata_rata": 9.3,
            "sinopsis" : response_normal[0]["sinopsis"],
            "genre" : response_genre,
            "asal_negara": response_normal[0]["asal_negara"],
            "pemain": response_pemain,
            "penulis_skenario": response_penulis,
            "sutradara": response_sutradara,
        }
        return render(request, "detail_series.html", context)
    except Exception as e:
        print(e)
        return e

def detail_film(request, id):
    try :
        query_judul_film = f"""
        SELECT t.judul AS title,
        t.sinopsis AS sinopsis,
        f.durasi_film AS durasi_film,
        f.release_date_film AS tanggal_rilis_film,
        f.url_video_film AS url_film,
        t.asal_negara AS asal_negara
        FROM TAYANGAN as t
        JOIN FILM as f ON t.id = f.id_tayangan
        WHERE t.id = '{id}'
        """
        
        response = query(query_judul_film)

        query_genre = f"""
        SELECT 
        genre 
        from GENRE_TAYANGAN 
        WHERE id_tayangan = '{id}'
        """
        response_genre = query(query_genre)

        query_pemain = f"""
        SELECT c.nama AS nama
        FROM CONTRIBUTORS AS c
        JOIN PEMAIN AS p ON c.id = p.id
        JOIN MEMAINKAN_TAYANGAN as m ON p.id = m.id_pemain
        WHERE m.id_tayangan = '{id}'
        """
        response_pemain = query(query_pemain)

        query_penulis = f"""
        SELECT c.nama AS nama
        FROM CONTRIBUTORS AS c
        JOIN PENULIS_SKENARIO AS ps ON c.id = ps.id
        JOIN MENULIS_SKENARIO_TAYANGAN as m ON ps.id = m.id_penulis_skenario
        WHERE m.id_tayangan = '{id}'
        """

        response_penulis = query(query_penulis)

        query_sutradara = f"""
        SELECT c.nama AS nama
        FROM CONTRIBUTORS AS c
        JOIN SUTRADARA AS s ON c.id = s.id
        JOIN TAYANGAN as t ON s.id = t.id_sutradara
        WHERE t.id = '{id}'
        """
        response_sutradara = query(query_sutradara)
        
        context = {
            "title" : response[0]["title"],
            "total_view": 1000000,
            "rating_rata_rata": 9.3,
            "sinopsis" : response[0]["sinopsis"],
            "durasi_film": response[0]["durasi_film"],
            "tanggal_rilis_film": response[0]["tanggal_rilis_film"],
            "url_film": response[0]["url_film"],
            "genre" : response_genre,
            "asal_negara": response[0]["asal_negara"],
            "pemain": response_pemain,
            "penulis_skenario": response_penulis,
            "sutradara": response_sutradara,
        }
        return render(request, "detail_film.html", context)
    except Exception as e:
        print(e)
        return HttpResponse(e)

def detail_episode(request, id_series, sub_judul):
    try: 
        print(str(id_series) + str(sub_judul))
        query_sub_title = f"""
        SELECT e.sub_judul AS sub_title, t.judul AS title, e.sinopsis as sinopsis_episode, e.durasi as durasi_episode, e.url_video as url_episode, e.release_date as tanggal_rilis_episode
        FROM EPISODE AS e
        JOIN TAYANGAN AS t ON e.id_series = t.id
        WHERE e.id_series = '{id_series}' AND e.sub_judul = '{sub_judul}'
        """

        response_sub_judul = query(query_sub_title)

        query_episode = f"""
        SELECT e.sub_judul AS sub_judul,
        e.id_series AS id_series
        FROM EPISODE AS e
        WHERE e.id_series = '{id_series}' and e.sub_judul != '{sub_judul}';
        """
        response_episode = query(query_episode)
      
        context = {
            "title" : response_sub_judul[0]['title'],
            "sub_title": response_sub_judul[0]['sub_title'],
            "other_episode" : response_episode,
            "sinopsis_episode": response_sub_judul[0]['sinopsis_episode'],
            "durasi_episode": response_sub_judul[0]['durasi_episode'],
            "url_episode": response_sub_judul[0]['url_episode'],
            "tanggal_rilis_episode": response_sub_judul[0]['tanggal_rilis_episode'],
        }
        return render(request, "detail_episode.html", context)
    except Exception as e:
        print(e)

def search(request):
    search_input = request.GET.get("search")

    try:
        search_query = f"""SELECT
        t.judul AS title,
        t.sinopsis_trailer AS synopsis,
        t.url_video_trailer AS url,
        t.release_date_trailer AS release_date
        FROM TAYANGAN AS t
        WHERE t.judul ILIKE '%%{search_input}%%'
        """
        response = query(search_query)
        context = {
            "search": response
        }
        return render(request, "search.html", context)
    except Exception as e:
        print(e)
        return HttpResponse(e)


def tentukan_tayangan(request, id):
    try:
        query_tayangan = f"""
        SELECT
            CASE
                WHEN EXISTS (SELECT 1 FROM FILM WHERE id_tayangan = '{id}') THEN 'film'
                WHEN EXISTS (SELECT 1 FROM SERIES WHERE id_tayangan = '{id}') THEN 'series'
                ELSE 'unknown'
            END AS tayangan_type
        """
        response = query(query_tayangan)
        tayangan_type = response[0]["tayangan_type"]
        if tayangan_type == "film":
            return detail_film(request, id)
        elif tayangan_type == "series":
            return detail_series(request, id)
        else:
            return HttpResponse("Unknown tayangan type")
    except Exception as e:
        print(e)
        return HttpResponse(e)
        