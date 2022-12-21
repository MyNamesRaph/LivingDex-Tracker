import 'package:flutter/material.dart';
import 'package:livingdex_tracker/data/database_helper.dart';
import 'package:livingdex_tracker/data/generation_helper.dart';
import 'package:livingdex_tracker/data/models/pokemon.dart';
import 'package:livingdex_tracker/notifications/pokemon_changed.dart';
import 'package:livingdex_tracker/widgets/selected_pokemon.dart';

import '../data/PokeAPI.dart';
import '../notifications/gen_changed.dart';
import '../widgets/pokemon_tile.dart';
import '../widgets/side_menu.dart';

class DexScreen extends StatefulWidget {
  const DexScreen({
    super.key,
    required this.generation
  });

  final int generation;

  @override
   State<DexScreen> createState() => _DexScreenState();
}

class _DexScreenState extends State<DexScreen> {
  var _currentGen = 1;
  List<PokemonModel> _pokemonModels = [];
  PokemonModel? _selectedPokemon;

  @override
  initState() {
    super.initState();
    _currentGen = widget.generation;
    setupDatabase();
  }



  setupDatabase() async {
    print("Setting up database");
    _pokemonModels = [];

    var db = DatabaseHelper.instance;

    var pokemonModels = await db.queryGeneration(_currentGen);
    if (pokemonModels != null) {
      if (pokemonModels.isNotEmpty) {
        _pokemonModels = pokemonModels.map((e) => PokemonModel.fromMap(e)).toList();
        setState(() {});
        return;
      }
    }


    var pokemonList = await getPokemon(_currentGen);
    var pokemonModelList = <PokemonModel>[];

    for (var pokemon in pokemonList) {
      pokemonModelList.add(PokemonModel.fromPokemon(pokemon, _currentGen));
    }

    await db.insertBatch(pokemonModelList);
    pokemonModels = await db.queryGeneration(_currentGen);
    for (var pokemon in pokemonModels!) {
      print("Read from database: $pokemon");
    }
    _pokemonModels = pokemonModels.map((e) => PokemonModel.fromMap(e)).toList();
    setState(() {});
  }

  Future<List<Pokemon>> getPokemon(int generation) async {
    var pokemonList = await PokeAPI().fetchPokemonByGeneration(generation);
    pokemonList.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));

    return pokemonList;
  }

  setupPokemonTile(index) {
    if (_pokemonModels == null ) {
      return SizedBox();
    }

    return PokemonTile(
        pokemon: _pokemonModels[index],
        caught: _pokemonModels[index].caught == 1 ? true : false,
        shiny: _pokemonModels[index].shiny == 1 ? true : false,
    );
  }

  setupSelectedPokemon() {
    if (_selectedPokemon == null) {
      return null;
    }
    return SelectedPokemon(
      pokemonModel: _selectedPokemon!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<PokemonChanged>(
      onNotification: (notification) {
        setState(() {
          print("Pokemon changed: ${notification.val}");
          _selectedPokemon = notification.val;
        });
        return true;
      },
      child: NotificationListener<GenChanged>(
        onNotification: (notification) {

          setState(() {
            print("Gen changed to ${notification.val}");
            _currentGen = notification.val;
            _selectedPokemon = null;
            setupDatabase();
          });
          return true;
        },
        child: Scaffold(
          drawer: const SideMenu(),
          appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(
                "Generation ${GenerationHelper.generations[_currentGen-1].text}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              )
          ),
          body: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: _pokemonModels.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10
                      ),
                      itemBuilder: (context, index) {
                        return setupPokemonTile(index);
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).shadowColor,
                    ),
                    child: setupSelectedPokemon()
                  )
                ],
              )
          ),
        ),
      )
    );
  }
}