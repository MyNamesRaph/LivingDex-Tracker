import '../PokeAPI.dart';

class PokemonModel {
  int? id;
  late int pokemonId;
  late String name;
  late String apiUrl;
  late int caught;
  late int shiny;
  late int generation;

  PokemonModel({
    this.id,
    required this.pokemonId,
    required this.name,
    required this.apiUrl,
    required this.caught,
    required this.shiny,
    required this.generation,
  });

  PokemonModel.fromMap(Map<String, dynamic> map) {
    print("Making PokemonModel from map: $map");
    id = map['id'];
    pokemonId = map['pokemon_id'];
    name = map['name'];
    apiUrl = map['api_url'];
    caught = map['caught'];
    shiny = map['shiny'];
    generation = map['generation'];
  }

  PokemonModel.fromPokemon(Pokemon pokemon, int pokemonGeneration) {
    print("Making model from pokemon: $pokemon");
    id = null;
    pokemonId = int.parse(pokemon.id);
    name = pokemon.name;
    apiUrl = pokemon.url;
    caught = 0;
    shiny = 0;
    generation = pokemonGeneration;
  }

  Map<String, dynamic> toMap() {
    return {
      'pokemon_id': pokemonId,
      'name': name,
      'api_url': apiUrl,
      'caught': caught,
      'shiny': shiny,
      'generation': generation
    };
  }

  @override
  String toString() {
    return 'PokemonModel{id: $id, pokemonId: $pokemonId, name: $name, apiUrl: $apiUrl, caught: $caught, shiny: $shiny, generation: $generation}';
  }
}