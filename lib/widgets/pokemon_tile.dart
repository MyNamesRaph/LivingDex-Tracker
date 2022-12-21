import 'package:flutter/material.dart';
import 'package:livingdex_tracker/notifications/pokemon_changed.dart';

import '../data/models/pokemon.dart';

class PokemonTile extends StatefulWidget {
  const PokemonTile({
    super.key,
    required this.pokemon,
    required this.caught,
    required this.shiny
  });

  final PokemonModel pokemon;
  final bool caught;
  final bool shiny;

  @override
  State<PokemonTile> createState() => _PokemonTileState();
}

class _PokemonTileState extends State<PokemonTile> {

  imageStackGenerator() {
    var widgets = <Widget>{};
    if (widget.caught) {
      widgets.add(
          Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.all(5),
              child: Image.asset("assets/images/pokeball_closed.png")
              //child: Image.asset(widget.caught ? "assets/images/pokeball_closed.png" : "assets/images/pokeball_open.png")
          )
      );
      if (widget.shiny == true) {
        widgets.add(
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(5),
                child: Image.asset("assets/images/shiny.png")
            )
        );
      }
    }
    return widgets.toList();
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).shadowColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
               PokemonChanged(widget.pokemon).dispatch(context);
            },
            child: Stack(
              children: [
                Stack(
                    children: imageStackGenerator()
                ),
                Center(
                  child: Text(
                    widget.pokemon.name.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          )
        ),
    );
  }
}