import 'package:flutter/material.dart';

class DadoDia{

  //String id;
  final data;
  final novosCasos;
  final novasMortes;
  final totalCasos;
  final totalMortes;
  final totalRecuperacao;


  DadoDia({this.data, this.novosCasos, this.novasMortes,this.totalCasos, this.totalMortes, this.totalRecuperacao});


  factory DadoDia.fromJson(Map<String, dynamic> json){//retorna uma unica instancia, economiza memoria


    DadoDia(
      //id: json["ourid"],
      novosCasos: json["new_daily_cases"],
      novasMortes: json["new_daily_deaths"],
      totalCasos: json["total_cases"],
      totalMortes: json["total_deaths"],
      totalRecuperacao: json["total_recoveries"],
    );

    return DadoDia();

  }


}