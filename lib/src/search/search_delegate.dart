// ignore_for_file: unnecessary_new, prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam!',
    'Ironman',
    'Capitan America',
    'iroman 2',
    'iroman 3',
    'iroman 4',
    'iroman 5',
  ];

  final peliculasRecientes = ['Spiderman', 'Capitan America'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones del AppBar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Icono a la izquierda del appbar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que se va a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias cuando la persona escribe

    return query == ''
        ? Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.topLeft,
            child: Text('Ingrese una pelicula...', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          )
        : FutureBuilder(
            future: peliculasProvider.buscarPelicula(query),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                final peliculas = snapshot.data;

                return ListView(
                  children: peliculas!.map((pelicula) {
                    return ListTile(
                      leading: FadeInImage(
                        image: NetworkImage(pelicula.getPosterImg()),
                        placeholder: AssetImage('assets/img/no-image.jpg'),
                        width: 50.0,
                        fit: BoxFit.contain,
                      ),
                      title: Text(pelicula.title.toString()),
                      subtitle: Text(pelicula.originalTitle.toString()),
                      onTap: () {
                        close(context, null);
                        pelicula.uniqueId = '';
                        Navigator.pushNamed(context, 'detalle',
                            arguments: pelicula);
                      },
                    );
                  }).toList(),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
  }

  /*
  @override
  Widget buildSuggestions(BuildContext context) {
    final listaSugerida = (query.isEmpty)
        ? peliculasRecientes
        : peliculas
            .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    // Son las sugerencias cuando la persona escribe
    return ListView.builder(
        itemCount: listaSugerida.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: Icon(Icons.movie),
            title: Text(listaSugerida[i]),
            onTap: () {
              seleccion = listaSugerida[i];
              showResults(context);
            },
          );
        });
  }
  */
}
