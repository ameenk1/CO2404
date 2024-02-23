String apikey ='ba99f6ccb496e7c89f997871aff42499';

String TrendingDay = 'https://api.themoviedb.org/3/trending/movie/day?api_key=$apikey';

String TrendingMovies = 'https://api.themoviedb.org/3/movie/popular?api_key=$apikey';

String MoviesTonight = 'https://api.themoviedb.org/3/movie/now_playing?api_key=$apikey';

String TopRatedMovies = 'https://api.themoviedb.org/3/movie/top_rated?api_key=$apikey';

String UpComingMovies = 'https://api.themoviedb.org/3/movie/upcoming?api_key=$apikey';

String upcomingmoviesurl = 'https://api.themoviedb.org/3/movie/upcoming?api_key=$apikey';

String bestmoviesurl = 'https://api.themoviedb.org/3/discover/movie?api_key=$apikey&primary_release_year=$currentYear&sort_by=popularity.desc';

String HighestGross = 'https://api.themoviedb.org/3/discover/movie?api_key=$apikey&sort_by=revenue.desc';

String currentYear = DateTime.now().year.toString();

