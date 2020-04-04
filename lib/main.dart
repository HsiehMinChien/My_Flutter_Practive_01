import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/pokemon_data_format.dart';
import 'package:myapp/pokemondetail.dart';

void main() => runApp(new MaterialApp(
  title: "Poke App",
  home: HomePage(),
  debugShowCheckedModeBanner: false,
));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  var url = "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  PokeHub pokeHub;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  fetchData() async {
    var res = await http.get(url);
    print(res);
    var decodedJson = jsonDecode(res.body);
    pokeHub = PokeHub.fromJson(decodedJson);
    print(pokeHub.toJson());
    setState(() {});
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text('My practice 01'),
        backgroundColor: Colors.cyan,
      ),
      backgroundColor: pokeHub == null ? Colors.white : Colors.cyan[100],
      body: pokeHub == null ?
      Center(child: CircularProgressIndicator()) :
        GridView.count(
          crossAxisCount: 2,
          children: pokeHub.pokemon
            .map((poke) => Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PokeDetail(
                        pokemon: poke,
                  )));
                },
                child: Hero(
                  tag: poke.img,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width:
                              MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(poke.img))),
                        ),
                        Text(
                          poke.name,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ))
          .toList(),
        ),
      drawer: Drawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.cyan,
          child: Icon(Icons.refresh),
      ),
    );
  }
}
