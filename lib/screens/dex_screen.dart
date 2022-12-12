import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livingdex_tracker/data/data_helper.dart';

import '../data/PokeAPI.dart';
import '../notifications/gen_changed.dart';
import '../widgets/side_menu.dart';

class DexScreen extends StatefulWidget {
  const DexScreen( {Key? key} ) : super(key: key);

  @override
   State<DexScreen> createState() => _DexScreenState();
}

class _DexScreenState extends State<DexScreen> {
  //TODO: get from the constructor
  var _currentGen = DataHelper.generations[0].number;
  var _pokemonList = <Pokemon>[];

  @override
  initState() {
    super.initState();
    getPokemon();
  }

  getPokemon() async {
    _pokemonList = await PokeAPI().fetchPokemonByGeneration(_currentGen);
    _pokemonList.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
     setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<GenChanged>(
        onNotification: (notification) {

          setState(() {
            _currentGen = notification.val;
            _pokemonList = [];
            getPokemon();
          });
          return true;
        },
        child: Scaffold(
          drawer: const SideMenu(),
          appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(
                "Living Dex $_currentGen",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              )
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: GridView.builder(
              itemCount: _pokemonList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4
              ),
              itemBuilder: (context, index) {
                return Text(_pokemonList[index].name,
                    style: Theme.of(context).textTheme.bodySmall);
              },
              ),
            ),
          ),
        );
  }
}