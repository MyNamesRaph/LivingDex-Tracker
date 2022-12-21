import 'package:flutter/material.dart';
import 'package:livingdex_tracker/data/PokeAPI.dart';
import 'package:livingdex_tracker/data/database_helper.dart';
import 'package:livingdex_tracker/notifications/pokemon_changed.dart';

import '../data/models/pokemon.dart';

class SelectedPokemon extends StatefulWidget {
  const SelectedPokemon({
    super.key,
    required this.pokemonModel
  });
  final PokemonModel pokemonModel;

  @override
  State<SelectedPokemon> createState() => _SelectedPokemon();
}

class _SelectedPokemon extends State<SelectedPokemon> {
  Map<String,dynamic>? _info;


  @override
  initState() {
    super.initState();
    getPokemonInfo();
  }

  @override
  didUpdateWidget(SelectedPokemon oldWidget) {
    super.didUpdateWidget(oldWidget);
    getPokemonInfo();
  }

  getPokemonInfo() async {
    _info = await PokeAPI().fetchPokemonInfo(widget.pokemonModel.pokemonId);
    setState(() {});
  }

  getPokemonTypes() {
    List<dynamic> types = _info!["types"];

    var widgets = <Widget>{};
    if (types.isNotEmpty) {
      widgets.add(Image.asset("assets/images/types/${_info!["types"][0]["type"]["name"]}.png",scale: 0.5));

      if (types.length > 1) {
        widgets.add(Image.asset("assets/images/types/${_info!["types"][1]["type"]["name"]}.png",scale: 0.5));
      }
    }
    else {
      widgets.add(Image.asset("assets/images/types/unknown.png"));
    }

    return widgets.toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_info != null)
    {
      return Container (
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Image.network(_info!['sprites']['front_default'], scale: 0.75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: getPokemonTypes()
            ),
            Text(
              _info!['name'].toString().toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>( (Set<MaterialState> states) {
                          return widget.pokemonModel.caught == 1 ? Theme.of(context).primaryColor : Theme.of(context).shadowColor;
                        },
                      ),
                    ),
                    onPressed: () {
                        DatabaseHelper.instance.update(
                            PokemonModel(
                                pokemonId: widget.pokemonModel.pokemonId,
                                name: widget.pokemonModel.name,
                                caught: widget.pokemonModel.caught == 1 ? 0 : 1,
                                shiny: widget.pokemonModel.shiny,
                                generation: widget.pokemonModel.generation,
                                apiUrl: widget.pokemonModel.apiUrl
                            )
                        );
                        widget.pokemonModel.caught = widget.pokemonModel.caught == 1 ? 0 : 1;
                        //Update the parent
                        PokemonChanged(widget.pokemonModel).dispatch(context);
                    },
                    child: Text(
                        "Caught",
                        style: Theme.of(context).textTheme.titleLarge
                    )
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color?>( (Set<MaterialState> states) {
                          return widget.pokemonModel.shiny == 1 ? Theme.of(context).primaryColor : Theme.of(context).shadowColor;
                        },
                      ),
                    ),
                    onPressed: () {
                      DatabaseHelper.instance.update(
                          PokemonModel(
                              pokemonId: widget.pokemonModel.pokemonId,
                              name: widget.pokemonModel.name,
                              caught: widget.pokemonModel.caught,
                              shiny: widget.pokemonModel.shiny == 1 ? 0 : 1,
                              generation: widget.pokemonModel.generation,
                              apiUrl: widget.pokemonModel.apiUrl
                          )
                      );
                      widget.pokemonModel.shiny = widget.pokemonModel.shiny == 1 ? 0 : 1;
                      //Update the parent
                      PokemonChanged(widget.pokemonModel).dispatch(context);
                    },
                    child: Text(
                        "Shiny",
                        style: Theme.of(context).textTheme.titleLarge
                    )
                  ),
                ),
              ],
            ),
          ]
        )
      );
    }
    else {
      return Center(
        child: Text(
          "Loading ...",
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      );
    }

  }
}