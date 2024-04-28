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

def search(request):
    pass