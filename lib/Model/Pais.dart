import 'package:flutter/material.dart';

class Pais{

  //String id;
  final title;
  final code;

  //Pais({this.id, this.title, this.code});
  Pais({this.title, this.code});


  factory Pais.fromJson(Map<String, dynamic> json){//retorna uma unica instancia, economiza memoria

    //print("id é: " + json["10"]["title"].toString());
    Pais(
      //id: json["ourid"],
      title: json["title"],
      code: json["code"],
    );

    return Pais();

  }


}