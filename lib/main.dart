import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'episodes_page.dart';
import 'got.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  GOT got;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchEpisodes();
  }

  Future<void> fetchEpisodes() async {
    var res = await http.get(
        "http://api.tvmaze.com/singlesearch/shows?q=game-of-thrones&embed=episodes");

    var decodeRes = jsonDecode(res.body);

    got = GOT.fromJson(decodeRes);
    print(decodeRes);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Game",style: TextStyle(color: Colors.white),),
            Text(" Of",style: TextStyle(
                color: Colors.white70
            ),
            ),
            Text(" Thrones",style: TextStyle(color: Colors.white),),
          ],
        ),
      ),
      backgroundColor: Colors.indigo,
      body: got == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView(children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Hero(
                  tag: got.name,
                  child: CircleAvatar(
                    radius: 100.0,
                    backgroundImage: NetworkImage(got.image.original),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  got.name,
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  got.summary,
                  style: TextStyle(fontWeight: FontWeight.w500,fontStyle: FontStyle.normal),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EpisodesPage(
                                episodes: got.eEmbedded.episodes,
                                got: got)));
                  },
                  child: Text(
                    "All Episodes",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.blueGrey,
                )
              ],
            ),
          ),
        )
      ],),
    );
  }
}