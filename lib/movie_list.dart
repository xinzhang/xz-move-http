import 'package:flutter/material.dart';
import 'package:movie_http/http_helper.dart';
import 'package:movie_http/movie_detail.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  String result;
  HttpHelper helper;
  int moviesCount;
  List movies;

  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

  Icon visibleIcon = Icon(Icons.search);
  Widget searchBar = Text('Movies');

  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  Future initialize() async {
    movies = List();
    movies = await helper.getUpcoming();
    setState(() {
      moviesCount = movies.length;
      movies = movies;
    });
  }

  Future search(text) async {
    movies = await helper.findMovies(text);
    setState(() {
      moviesCount = movies == null ? 0 : movies.length;
      movies = movies;
    });
  }

  void resetState() {
    this.visibleIcon = Icon(Icons.search);
    this.searchBar = Text("Movies");
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    return Scaffold(
      appBar: AppBar(
          //title: Text("Movies"),
          title: searchBar,
          leading: IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              initialize();
              resetState();
            },
          ),
          actions: <Widget>[
            IconButton(
                icon: visibleIcon,
                onPressed: () {
                  setState(() {
                    if (this.visibleIcon.icon == Icons.search) {
                      this.visibleIcon = Icon(Icons.cancel);
                      this.searchBar = buildTextSearchBar();
                    } else {
                      resetState();
                    }
                  });
                }),
          ]),
      body: Container(
        child: ListView.builder(
            itemCount: (this.moviesCount == null) ? 0 : moviesCount,
            itemBuilder: (BuildContext context, int position) {
              if (movies[position].posterPath != null) {
                image = NetworkImage(iconBase + movies[position].posterPath);
              } else {
                image = NetworkImage(defaultImage);
              }
              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  onTap: () {
                    MaterialPageRoute route = MaterialPageRoute(
                        builder: (_) => MovieDetail(movie: movies[position]));
                    Navigator.push(context, route);
                  },
                  leading: CircleAvatar(backgroundImage: image),
                  title: Text(movies[position].title),
                  subtitle: Text('Released: ' +
                      (movies[position].releaseDate ?? '') +
                      ' - Vote: ' +
                      movies[position].voteAverage.toString()),
                ),
              );
            }),
      ),
    );
  }

  TextField buildTextSearchBar() {
    return TextField(
      textInputAction: TextInputAction.search,
      style: TextStyle(color: Colors.white, fontSize: 20.0),
      onSubmitted: (String text) {
        search(text);
      },
    );
  }
}
