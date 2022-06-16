// ignore_for_file: prefer_final_fields, unnecessary_new, use_rethrow_when_possible

import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actores_model.dart';

import 'dart:convert';

import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {

  String _apiKey   = '752d2576837c37391ffdbeba9011c025';
  String _url      = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPages = 0;

  bool _cargando = false;

  List<Pelicula> _populares = [];

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams(){
    _popularesStreamController.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {

    try {
      final resp = await http.get(url);
      final decodedData = json.decode(resp.body);

      final peliculas = new Peliculas.fromJsonList(decodedData['results']);  

      return peliculas.items;

    } catch (e) {
      throw e;
    }
  }


  Future<List<Pelicula>> getEnCines() async{

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'  : _apiKey,
      'language' : _language
    });

    return await _procesarRespuesta(url);

  }

  Future<List<Pelicula>> getPopulares() async{

    if ( _cargando ) return [];

    _cargando = true;

    _popularesPages++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'  : _apiKey,
      'language' : _language,
      'page'     : _popularesPages.toString()
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;
    return resp;

  }

  Future<List<Actor>> getCast(String peliId) async{

    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key'   : _apiKey,
      'languaje'  : _language,
    });

    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    final cast = new Cast.formJsonList(decodeData['cast']);

    return cast.actores;

  }

  Future<List<Pelicula>> buscarPelicula(String query) async{

    final url = Uri.https(_url, '3/search/movie', {
      'api_key'  : _apiKey,
      'language' : _language,
      'query'    : query,
    });

    return await _procesarRespuesta(url);

  }


}