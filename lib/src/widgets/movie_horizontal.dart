// ignore_for_file: use_key_in_widget_constructors, unnecessary_new, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, prefer_const_constructors, unused_element

import 'package:flutter/material.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula>? peliculas;
  final Function siguientePagina;

  MovieHorizontal({required this.peliculas, required this.siguientePagina});

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: peliculas?.length,
        itemBuilder: (context, i) => _tarjeta(context, peliculas![i]),
        //children: _tarjetas(context),
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula) {

     pelicula.uniqueId = '${pelicula.id}-poster';

    final tarjeta = Container(
      margin: EdgeInsets.only(right: 10.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId.toString(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 120.0,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            pelicula.title.toString(),
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );


    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );

  }

  List<Widget> _tarjetas(BuildContext context) {
    return peliculas!.map((pelicula) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 140.0,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              pelicula.title.toString(),
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      );
    }).toList();
  }
}
