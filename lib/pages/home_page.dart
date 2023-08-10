import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search = "";
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    Uri urlTrending = Uri.parse(
        "https://api.giphy.com/v1/gifs/trending?api_key=fuoJ7VYfGNWR5dWUzLOWUTKCSVV519LX&limit=20&rating=g&bundle=messaging_non_clips");
    Uri urlSearch = Uri.parse(
        "https://api.giphy.com/v1/gifs/search?api_key=fuoJ7VYfGNWR5dWUzLOWUTKCSVV519LX&q=$_search&limit=20&offset=$_offset&rating=g&lang=en&bundle=messaging_non_clips");

    if (_search == null) {
      response = await http.get(urlTrending);
    } else {
      response = await http.get(urlSearch);
    }

    return json.decode(response.body);
  }


  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map);
    });
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
          const Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search GIFs",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0)
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
