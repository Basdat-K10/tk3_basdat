from django.shortcuts import render

# Create your views here.
def index(request):
    try : 
        context = { 
            "movies": [
                {
                    "rank": 1,
                    "title": "The Shawshank Redemption",
                    "synopsis": "Two imprisoned lorem ipsum dolor sit amet",
                    "url": "https://www.youtube.com/watch?v=6hB3S9bIaco",
                    "release_date": "1994",
                    "total_view" : 1000000,
                },
                {
                    "rank": 2,
                    "title": "The Godfather",
                    "synopsis": "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.",
                    "url": "https://www.youtube.com/watch?v=sY1S34973zA",
                    "release_date": "1972",
                    "total_view" : 2000000,
                },
                {
                    "rank": 3,
                    "title": "The Dark Knight",
                    "synopsis": "When the menace known as the Joker emerges from his mysterious past, he wreaks havoc and chaos on the people of Gotham.",
                    "url": "https://www.youtube.com/watch?v=EXeTwQWrcwY",
                    "release_date": "2008",
                    "total_view" : 3000000,
                }
            ], 
            "films" : [
                {
                    "rank": 1,
                    "title": "The Shawshank Redemption",
                    "synopsis": "Two imprisoned lorem ipsum dolor sit amet",
                    "url": "https://www.youtube.com/watch?v=6hB3S9bIaco",
                    "release_date": "1994",
                    "total_view" : 1000000,
                },
                {
                    "rank": 2,
                    "title": "The Godfather",
                    "synopsis": "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.",
                    "url": "https://www.youtube.com/watch?v=sY1S34973zA",
                    "release_date": "1972",
                    "total_view" : 2000000,
                },
                {
                    "rank": 3,
                    "title": "The Dark Knight",
                    "synopsis": "When the menace known as the Joker emerges from his mysterious past, he wreaks havoc and chaos on the people of Gotham.",
                    "url": "https://www.youtube.com/watch?v=EXeTwQWrcwY",
                    "release_date": "2008",
                    "total_view" : 3000000,
                }
            ],
            "series" : [
                {
                    "rank": 1,
                    "title": "The Shawshank Redemption",
                    "synopsis": "Two imprisoned lorem ipsum dolor sit amet",
                    "url": "https://www.youtube.com/watch?v=6hB3S9bIaco",
                    "release_date": "1994",
                    "total_view" : 1000000,
                },
                {
                    "rank": 2,
                    "title": "The Godfather",
                    "synopsis": "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.",
                    "url": "https://www.youtube.com/watch?v=sY1S34973zA",
                    "release_date": "1972",
                    "total_view" : 2000000,
                },
                {
                    "rank": 3,
                    "title": "The Dark Knight",
                    "synopsis": "When the menace known as the Joker emerges from his mysterious past, he wreaks havoc and chaos on the people of Gotham.",
                    "url": "https://www.youtube.com/watch?v=EXeTwQWrcwY",
                    "release_date": "2008",
                    "total_view" : 3000000,
                }
            ]
        }
        
        return render(request, "index.html", context)
    except Exception as e:
        print(e)    

def detail_series(request, id):
    try :
        context = {
            "title" : "The Shawshank Redemption",
            "episode" : [
                "Episode 1",
                "Episode 2",
                "Episode 3",
            ],
            "total_view": 1000000,
            "rating_rata_rata": 9.3,
            "sinopsis" : "Two imprisoned lorem ipsum dolor sit amet",
            "genre" : [
                "Drama",
                "Crime"
            ],
            "asal_negara": "United States",
            "pemain": [
                "Tim Robbins",
                "Morgan Freeman"
            ],
            "penulis_skenario": [
                "Frank Darabont"
            ],
            "sutradara": "Frank Darabont",
        }
        return render(request, "detail_series.html", context)
    except Exception as e:
        print(e)

def detail_film(request, id):
    try :
        context = {
            "title" : "The Shawshank Redemption",
            "total_view": 1000000,
            "rating_rata_rata": 9.3,
            "sinopsis" : "Two imprisoned lorem ipsum dolor sit amet",
            "durasi_film": "111 menit",
            "tanggal_rilis_film": "14 Oktober 1994",
            "url_film": "https://www.youtube.com/watch?v=6hB3S9bIaco",
            "genre" : [
                "Drama",
                "Crime"
            ],
            "asal_negara": "United States",
            "pemain": [
                "Tim Robbins",
                "Morgan Freeman"
            ],
            "penulis_skenario": [
                "Frank Darabont"
            ],
            "sutradara": "Frank Darabont",
        }
        return render(request, "detail_film.html", context)
    except Exception as e:
        print(e)

def detail_episode(request, id):
    try: 
        context = {
            "title" : "The Shawshank Redemption",
            "sub_title": "Episode 1",
            "other_episode" : [
                "Episode 2",
                "Episode 3",
            ],
            "sinopsis_episode": "Two imprisoned lorem ipsum dolor sit amet",
            "durasi_episode": "60 menit",
            "url_episode": "https://www.youtube.com/watch?v=6hB3S9bIaco",
            "tanggal_rilis_episode": "14 Oktober 1994",
        }
        return render(request, "detail_episode.html", context)
    except Exception as e:
        print(e)

def search(request):
    pass