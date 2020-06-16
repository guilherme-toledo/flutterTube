import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:favoritosyoutube/blocs/videos_bloc.dart';
import 'package:favoritosyoutube/delegates/data_search.dart';
import 'package:favoritosyoutube/widgets/video_tile.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 60,
          child: Image.asset("images/youtube_logo.jpg"),
        ),
        elevation: 0,
          backgroundColor: Colors.black87,
        actions: [
          Align(
            alignment: Alignment.center,
            child: Text("0"),
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: (){

            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String result = await showSearch(context: context, delegate: DataSearch());
              if(result != null) BlocProvider.of<VideosBloc>(context).inSearch.add(result);
              },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: BlocProvider.of<VideosBloc>(context).outVideos,
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return ListView.builder(
                itemBuilder: (context, index){
                  return VideoTile(snapshot.data[index]);
                },
              itemCount: snapshot.data.length,
            );
        else
          return Container();
        }
      )
    );
  }
}


    