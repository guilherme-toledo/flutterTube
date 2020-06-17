class Video {

  final String id;
  final String title;
  final String thumb;
  final String channel;

  Video({this.id, this.title, this.thumb, this.channel});

  //factory vai pegar o seu Json e vai retornar um objeto contendo os dados do seu json
  factory Video.fromJson(Map<String, dynamic> json){
    if(json.containsKey("id")) //isso vai ser SE a gente receber o video la do google, da api
      return Video( //dessa forma, quando eu passar um json pro factory ele vai um objeto video com todos esses parametros do nosso json
        id: json["id"]["videoId"],
        title: json["snippet"]["title"],
        thumb: json["snippet"]["thumbnails"]["high"]["url"],
        channel: json["snippet"]["channelTitle"]
    );
    else return Video( //isso vai ser se recebermos o video q salvamos nos favoritos
      id: json["videoId"],
      title: json["title"],
      thumb: json["thumb"],
      channel: json["channel"]
    );
  }

  Map<String, dynamic> toJson(){ //para salvar em json
    return {
      "videoId": id,
      "title": title,
      "thumb": thumb,
      "channel": channel
    };
  }

}