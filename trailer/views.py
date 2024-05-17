from django.shortcuts import render, redirect
from django.http import HttpResponse
from utils.query import query
from django.db import connection
from django.db import Error
from django.views.decorators.csrf import csrf_exempt
import datetime
from psycopg2 import connect
import os

# Create your views here.


def index_trailer(request):
    try : 
        movie_top = """
            WITH viewer_count AS (
            SELECT rn.id_tayangan,
                COUNT(*) AS total_view
            FROM RIWAYAT_NONTON AS rn
            LEFT JOIN FILM AS f ON rn.id_tayangan = f.id_tayangan
            LEFT JOIN EPISODE AS e ON rn.id_tayangan = e.id_series
            WHERE rn.end_date_time >= NOW() - INTERVAL '7 days'
            AND EXTRACT(EPOCH FROM (rn.end_date_time - rn.start_date_time)) / 60 >= 0.7 * COALESCE(f.durasi_film, e.durasi)
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
        # print(response)
        
        movie_film = """
        SELECT 
        t.judul AS title,
        t.sinopsis_trailer AS synopsis,
        t.url_video_trailer AS url,
        t.release_date_trailer AS release_date
        FROM TAYANGAN AS t
        JOIN FILM AS f ON t.id = f.id_tayangan
        """

        response_film = query(movie_film)
        # print(response_film)

        movie_series = """
        SELECT
        t.judul AS title,
        t.sinopsis_trailer AS synopsis,
        t.url_video_trailer AS url,
        t.release_date_trailer AS release_date
        FROM TAYANGAN AS t
        JOIN SERIES AS s ON t.id = s.id_tayangan
        """
        response_series = query(movie_series)

        context = {
            # "movies": [
            #     {
            #         "rank": 1,
            #         "title": "The Shawshank Redemption",
            #         "synopsis": "Two imprisoned lorem ipsum dolor sit amet",
            #         "url": "https://www.youtube.com/watch?v=6hB3S9bIaco",
            #         "release_date": "1994",
            #         "total_view" : 1000000,
            #     },
            #     {
            #         "rank": 2,
            #         "title": "The Godfather",
            #         "synopsis": "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.",
            #         "url": "https://www.youtube.com/watch?v=sY1S34973zA",
            #         "release_date": "1972",
            #         "total_view" : 2000000,
            #     },
            #     {
            #         "rank": 3,
            #         "title": "The Dark Knight",
            #         "synopsis": "When the menace known as the Joker emerges from his mysterious past, he wreaks havoc and chaos on the people of Gotham.",
            #         "url": "https://www.youtube.com/watch?v=EXeTwQWrcwY",
            #         "release_date": "2008",
            #         "total_view" : 3000000,
            #     }
            # ], 
            "movies": response,
            "films" : response_film,
            # [
            #     {
            #         "title": "The Shawshank Redemption",
            #         "synopsis": "Two imprisoned lorem ipsum dolor sit amet",
            #         "url": "https://www.youtube.com/watch?v=6hB3S9bIaco",
            #         "release_date": "1994",
            #     },
            #     {
            #         "title": "The Godfather",
            #         "synopsis": "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.",
            #         "url": "https://www.youtube.com/watch?v=sY1S34973zA",
            #         "release_date": "1972",
            #     },
            #     {
            #         "title": "The Dark Knight",
            #         "synopsis": "When the menace known as the Joker emerges from his mysterious past, he wreaks havoc and chaos on the people of Gotham.",
            #         "url": "https://www.youtube.com/watch?v=EXeTwQWrcwY",
            #         "release_date": "2008",
            #     }
            # ],
            
            "series" : response_series
            # [
            #     {
            #         "title": "The Shawshank Redemption",
            #         "synopsis": "Two imprisoned lorem ipsum dolor sit amet",
            #         "url": "https://www.youtube.com/watch?v=6hB3S9bIaco",
            #         "release_date": "1994",
            #     },
            #     {
            #         "title": "The Godfather",
            #         "synopsis": "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.",
            #         "url": "https://www.youtube.com/watch?v=sY1S34973zA",
            #         "release_date": "1972",
            #     },
            #     {
            #         "title": "The Dark Knight",
            #         "synopsis": "When the menace known as the Joker emerges from his mysterious past, he wreaks havoc and chaos on the people of Gotham.",
            #         "url": "https://www.youtube.com/watch?v=EXeTwQWrcwY",
            #         "release_date": "2008",
            #     }
            # ]
        }
        
        return render(request, "index_trailer.html", context)
    except Exception as e:
        print(e)    

def search(request):
    search_input = request.GET.get("q")
    # print(search_input)
    try:
        search_query = f"""SELECT
        t.judul AS title,
        t.sinopsis_trailer AS synopsis,
        t.url_video_trailer AS url,
        t.release_date_trailer AS release_date
        FROM TAYANGAN AS t
        WHERE t.judul ILIKE '%%{search_input}%%'
        """
        print(search_query)

        response = query(search_query)
        print(response)
        context = {
            "movies": response
        }
        return render(request, "hasil_search.html", context)
    except Exception as e:
        print(e)
        return redirect("/")

