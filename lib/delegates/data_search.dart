import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataSearch extends SearchDelegate<String> { //...

  @override
  List<Widget> buildActions(BuildContext context) {

    return [  //temos q retornar uma lista de widgets
      IconButton(
        icon: Icon(Icons.clear), //botao pra limpar a nossa pesquisa
        onPressed: (){
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) { //widget q vai ficar no canto esquerdo

    return IconButton(
      icon: AnimatedIcon( //animação da setinha ao voltar
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }


  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration.zero).then((_) => close(context, query)); //adiando o close, dando um delayzin pra n dar erro, voltando a tela e passando oq quer q pesquisa

    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {  //digitou algo no search chama o buildSuggestions
    if(query.isEmpty) //se a pesquisa esta vazia retornar um container vazio
      return Container();
    else
      return FutureBuilder<List>(
        future: suggestions(query),                      //suggestions do query. query é basicamente oq a gente digitou buscando algo, oq estamos pesquisando
        builder: (context, snapshot){
          if(!snapshot.hasData){                       //se snapshot nao contem dado
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
                itemBuilder: (context, index){ //pra cada item das suggestions ele vai chamar esse item builder
                  return ListTile( //retornar o widget q vai simbolizar esse dado q o itemBuilder ta passando
                    title: Text(snapshot.data[index]), //o titulo vai ser o index de cada um dos q ta na lista la
                    leading: Icon(Icons.play_arrow),
                    onTap: (){
                      close(context, snapshot.data[index]);  //vai ir pra suggestao clicada
                    },
                  );
                },
              itemCount: snapshot.data.length, //passando qts itens tem pro item builder passar por cada um deles (ele precisa saber quantos itens tem)
            );
          }
        },
      );
  }

  Future<List> suggestions(String search) async {

    http.Response response = await http.get(
        "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"
    );

    if(response.statusCode == 200){ //esse statusCode == 200 quer dizer q deu td certo
      return json.decode(response.body)[1].map((v){  //pegar o arq json e ir na "pasta" 1, e vai ter um mapa la, em q todos vao ser "v"
        return v[0]; //ai vamos retornar o [0] de cada um dos v
      }).toList(); //transformando em lista
    } else {
      throw Exception("Failed to load suggestions");
    }

  }
  
}