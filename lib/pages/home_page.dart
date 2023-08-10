import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = ""; // Inicialmente vazio para permitir pesquisa
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    Uri urlTrending = Uri.parse(
        "https://api.giphy.com/v1/gifs/trending?api_key=fuoJ7VYfGNWR5dWUzLOWUTKCSVV519LX&limit=25&offset=$_offset&rating=g&bundle=messaging_non_clips");
    Uri urlSearch = Uri.parse(
        "https://api.giphy.com/v1/gifs/search?api_key=fuoJ7VYfGNWR5dWUzLOWUTKCSVV519LX&q=$_search&limit=20&offset=$_offset&rating=g&lang=en&bundle=messaging_non_clips");

    // Use a URL de pesquisa somente se houver uma pesquisa válida
    Uri selectedUrl = _search.isEmpty ? urlTrending : urlSearch;

    response = await http.get(selectedUrl);

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _search = value; // Atualiza a pesquisa conforme o usuário digita
                  _offset = 0; // Reinicia o offset para nova pesquisa
                });
              },
              decoration: InputDecoration(
                labelText: "Search GIFs",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0)),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5,
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Container();
                      } else {
                        return _createGifTable(context, snapshot);
                      }
                  }
                }),
          )
        ],
      ),
    );
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    final gifData = snapshot.data["data"];

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: gifData.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Image.network(
            gifData[index]["images"]["fixed_height"]["url"],
            height: 300,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
