
String apikey ='ba99f6ccb496e7c89f997871aff42499';

String popularmoviesurl = 'https://api.themoviedb.org/3/movie/popular?api_key=$apikey';

String TrendingMovies = 'https://api.themoviedb.org/3/movie/popular?api_key=$apikey';

String UpComingMoviesurl = 'https://api.themoviedb.org/3/movie/upcoming?api_key=$apikey';

String MoviesTonight = 'https://api.themoviedb.org/3/movie/now_playing?api_key=$apikey';

String bestmoviesurl = 'https://api.themoviedb.org/3/discover/movie?api_key=$apikey&primary_release_year=$currentYear&sort_by=popularity.desc';

String HighestGross = 'https://api.themoviedb.org/3/discover/movie?api_key=$apikey&sort_by=revenue.desc';

String currentYear = DateTime.now().year.toString();

String populartvseriesurl ='https://api.themoviedb.org/3/tv/popular?api_key=$apikey';

String topratedtvseriesurl ='https://api.themoviedb.org/3/tv/top_rated?api_key=$apikey';

String onairtvseriesurl ='https://api.themoviedb.org/3/tv/on_the_air?api_key=$apikey';

String childrenurl = 'https://api.themoviedb.org/3/discover/movie?api_key=$apikey&sort_by=revenue.desc&adult=false&with_genres=16';

