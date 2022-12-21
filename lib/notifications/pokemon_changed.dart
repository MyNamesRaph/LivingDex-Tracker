import 'package:flutter/material.dart';
import '../data/models/pokemon.dart';

class PokemonChanged extends Notification {
  final PokemonModel val;
  PokemonChanged(this.val);
}