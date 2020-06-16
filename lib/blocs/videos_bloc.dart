
import 'dart:async';

import 'package:favoritosyoutube/api.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:favoritosyoutube/models/video.dart';

class VideosBloc implements BlocBase { //o nosso bloc sera basicamente a ponte entre nossos widgets e nossa api

  Api api;

  List<Video> videos;

  final StreamController<List<Video>> _videosCrontroller = StreamController<List<Video>>(); //quando passarmos videos pro nosso controllador ele ja vai passar pra stream
  Stream get outVideos => _videosCrontroller.stream;  //a parte sink, so temos acesso aq, mas a parte stream é q vamos dx o resto do codigo ter acesso, pois ela é so a saida

  //passando um dado pra dentro do bloc(no caso o search). Ha duas maneiras, uma com streamController e outra atraves de uma funçao
  final StreamController<String> _searchController = StreamController<String>();
  Sink get inSearch => _searchController.sink; //queremos receber dados de fora, por isso o sink

  VideoBloc(){
    api = Api();
    
    _searchController.stream.listen(_search);  //pegar a saida do searchController, ou seja, pra onde nossos dados vao ir
  }

  void _search(String search) async {

    videos = await api.search(search);
    _videosCrontroller.sink.add(videos);

  }

  @override
  void dispose() {
    _videosCrontroller.close();
    _searchController.close();

  }


}