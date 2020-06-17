import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:favoritosyoutube/api.dart';
import 'package:favoritosyoutube/blocs/favorite_bloc.dart';
import 'package:favoritosyoutube/blocs/videos_bloc.dart';
import 'package:favoritosyoutube/screens/home.dart';
import 'package:flutter/material.dart';

void main() {

  Api api = Api();
  api.search("eletro");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: VideosBloc(),
      child: BlocProvider(
        bloc: FavoriteBloc(),
        child: MaterialApp(
          title: "FlutterTube",
          debugShowCheckedModeBanner: false,
          home: Home(),
        ),
      )
    );
  }
}

