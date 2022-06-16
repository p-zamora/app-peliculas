// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unused_element

import 'package:flutter/material.dart';

import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula>? peliculas;

  CardSwiper({required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {

          peliculas![index].uniqueId = '${peliculas![index].id}-tarjeta';

          return Hero(
            tag: int.parse(peliculas![index].id.toString()),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                child: FadeInImage(
                  image: NetworkImage(peliculas![index].getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                ),
                onTap: () => Navigator.pushNamed(context, 'detalle', arguments: peliculas![index])
              ),
              //new Image.network("https://via.placeholder.com/350x150",fit: BoxFit.cover)
            ),
          );
        },
        itemCount: peliculas!.length,
        //pagination: new SwiperPagination(),
        //control: new SwiperControl(),
      ),
    );
  }

  Widget _imagen() {
    return Container();
  }
}
