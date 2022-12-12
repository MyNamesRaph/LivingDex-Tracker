import 'package:http/http.dart' as http;
import 'dart:convert' as json;

class PokeAPI {
  Future<List<Pokemon>> fetchPokemonByGeneration(int generationNumber) async {
    final response = await http.get(
      Uri.parse("https://pokeapi.co/api/v2/generation/$generationNumber"),
      headers: {'Accept': 'application/json'},
    );

    final List<dynamic> pokemonJson = json.jsonDecode(response.body)['pokemon_species'];
    return pokemonJson.map((p) => Pokemon.fromJson(p)).toList();
  }


}

class Pokemon {
  final String name;
  final String url;
  final String id;

  Pokemon({required this.name, required this.url, required this.id});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      url: json['url'],
      id: json['url'].split('/')[6],
    );
  }
}

//TODO: cache the data
