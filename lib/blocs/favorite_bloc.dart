import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:favoritosyoutube/models/video.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteBloc implements BlocBase {

  Map<String, Video> _favorites = {}; //salvamos em um formato de map, dps, pra salvar os favorites vamos transformar isso em json


  //no rxdart temos basicamente tres tipos de stream.. uma delas é o behaviorSubject. quando vc começa a observar ele, ele vai te enviar ja o ultimo obj q passou atraves dele
  final _favController = BehaviorSubject<Map<String, Video>>(seedValue: {});
  Stream<Map<String, Video>> get outFav => _favController.stream;

  FavoriteBloc(){  //pra quando a gente abrir o app, esse construtor vai verificar se ja possui algo na lista de prefs, nos fav
    SharedPreferences.getInstance().then((prefs){ //getInstance, vai receber as prefs. then pq demora um pouquinho
      if(prefs.getKeys().contains("favorites")){ //se contem algo nos favorites
        _favorites = json.decode(prefs.getString("favorites")).map((k, v){ //a gente pega o q ja estava nos favorites e transforma em json ... mapear um mapa......
          return MapEntry(k, Video.fromJson(v)); //uma key e um valor, no caso a key é o k , valor é video.fromJson(recebendo o valor v)
        }).cast<String, Video>();

        _favController.add(_favorites); //entao quando a gente abrir o app se ja tiver algo nos favorites ele vai mandar add la no sink
      }
    });
  }

  void toggleFavorite(Video video){
    if(_favorites.containsKey(video.id)) _favorites.remove(video.id);
    else _favorites[video.id] = video;

    _favController.sink.add(_favorites);

    _saveFav(); //funçao pra salvar
  }

  void _saveFav(){
    SharedPreferences.getInstance().then((prefs){
      prefs.setString("favorites", json.encode(_favorites)); //salvar em json
    });
  }

  @override
  void dispose() {
    _favController.close();
  }

}


