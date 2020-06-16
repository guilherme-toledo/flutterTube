import 'dart:convert';

import 'package:favoritosyoutube/models/video.dart';
import 'package:http/http.dart' as http;

const API_KEY = "AIzaSyD92fAa0gksjZT4kTF1hVSeXACE4QKKz_k";

class Api {

  search(String search) async {

    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"
    );

    return decode(response);

  }

  List<Video> decode(http.Response response){

    if(response.statusCode == 200){ //se der certo

      var decode = json.decode(response.body); //precisamos transformar em uma lista de videos. Tem q ser uma lista de objetos video, models => video.dart

      List<Video> videos = decode["items"].map<Video>( //dentro do items temos varios maps, cada map vao significar um video
          (map){
            return Video.fromJson(map); //pegou todos os mapas e transformou cada um em um arq video
          }
      ).toList(); //e no final, ele transformou em uma lista de videos

      return videos;

    } else {
      throw Exception("Failed to load videos"); //caso dê algum erro, fala q deu
    }

  }

}