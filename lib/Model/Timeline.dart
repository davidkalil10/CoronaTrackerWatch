import 'package:coronawatch/Model/InfoDiaria.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_format/date_format.dart';
import 'package:fl_chart/fl_chart.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {

  List _dadosDiarios = [];
  //List<FlSpot> pontosCasos ;
  List<FlSpot> pontosCasos ;
  List<FlSpot> hahaha = [];
  List<FlSpot> convertido;



  _atualizarTimeline() async{

    var data;
    String novosCasos = "";
    String novasMortes = "";
    double totalCasos;
    String totalMortes = "";
    String totalRecuperacao = "";


    String url = "https://api.thevirustracker.com/free-api?countryTimeline=br";

    http.Response response;
    response = await http.get(url);
    Map<String, dynamic> retorno = json.decode(response.body);
    String testeChave = retorno["timelineitems"][0]["4/19/20"].toString();
    // String testeChave = retorno["countrydata"]["info"]["title"].toString();
    print("O país éeee: " + testeChave);

    //Definir data de hoje e subtrair a data inicial para ter os dados , 1/22/20
    var dataH = DateTime.now();
    var dataHoje = new DateTime.utc(dataH.year, dataH.month, dataH.day); //data hoje limpa
    var dataInicial = new DateTime.utc(2020, DateTime.april, 1); //data primeiro caso da API
    var dataRotativa = dataInicial;

    Duration difference = dataHoje.difference(dataInicial);
    int diasBase = difference.inDays; // total de dias a pesquisar

    //DateTime dataInicials = DateTime.parse("1/22/20");
    /*String text = formatDate(dataHoje, [m, '/', dd, '/', yy]);
    print("data é: " + text);
    var d = DateFormat('kk:mm d/MM','pt_BR');*/

   // hahaha.add(FlSpot((0.0),6000.0));
   // hahaha.add(FlSpot((5.0),15000.0));
   // hahaha.add(FlSpot((10.0),30000.0));
    //convertido = spots(hahaha);
   // for (var k = 0; k<50;k++){
     // hahaha.add(FlSpot(k+1.0,k+6000.0));
    //}
    //hahaha.add(FlSpot((0.0),0.0));
    for (var i = 0; i < diasBase; i++){
      dataRotativa = dataInicial.add(Duration(days: i));
      var dataRotativaString = formatDate(dataRotativa, [m, '/', dd, '/', yy]).toString();
      //print("data X: " + formatDate(dataRotativa, [m, '/', dd, '/', yy]));
      //print(formatDate(dataRotativa, [m, '/', dd, '/', yy]) +": " + retorno["timelineitems"][0][formatDate(dataRotativa, [m, '/', dd, '/', yy])].toString());
      print(dataRotativaString +": " + retorno["timelineitems"][0][dataRotativaString].toString());

      //Checa o resultado da pesquisa do dia, se nulo adicionar "" para o daily e repetir o dia anterior

      if (retorno["timelineitems"][0][dataRotativaString].toString() == null){

        data = dataRotativa;
        novosCasos = "";
        novasMortes = "";
        totalCasos = totalCasos;
        totalMortes = totalMortes;
        totalRecuperacao = totalRecuperacao;

        setState(() {
          _dadosDiarios.add(DadoDia(data: data, novosCasos: novosCasos,novasMortes: novasMortes,totalCasos: totalCasos,totalMortes: totalMortes, totalRecuperacao: totalRecuperacao ));
          print("tamanho do list grande: " +_dadosDiarios[i].data.toString());

          if (_dadosDiarios[i].totalCasos == null ){
           // hahaha.add(FlSpot((i+1.0),0.0));
          }
          print("tamanho do list teste: " +hahaha.length.toString());

        });


      } else{
        data = dataRotativa;
        novosCasos = retorno["timelineitems"][0][dataRotativaString]["new_daily_cases"].toString();
        novasMortes = retorno["timelineitems"][0][dataRotativaString]["new_daily_deaths"].toString();
        //totalCasos = retorno["timelineitems"][0][dataRotativaString]["total_cases"].toString();
        double weight = retorno["timelineitems"][0][dataRotativaString]["total_cases"].toDouble() as num;
        totalCasos = weight;
        totalMortes = retorno["timelineitems"][0][dataRotativaString]["total_deaths"].toString();
        totalRecuperacao = retorno["timelineitems"][0][dataRotativaString]["total_recoveries"].toString();

        //Carregar dados na lista da memória e setar no gráfico

        setState(() {
          _dadosDiarios.add(DadoDia(data: data, novosCasos: novosCasos,novasMortes: novasMortes,totalCasos: totalCasos,totalMortes: totalMortes, totalRecuperacao: totalRecuperacao ));
         // pontosCasos = FlSpot((i+1.0),_dadosDiarios[i].totalCasos.toDouble());
          //print("tamanho do list: " +_dadosDiarios[i].totalCasos.toString());
          print("tamanho do list teste1: " + hahaha.length.toString() );
          //double weight = _dadosDiarios[i].totalCasos.toString() as num;
          //pontosCasos =[FlSpot((i+1.0),_dadosDiarios[i].totalCasos)];
          hahaha.add(FlSpot((i+1.0),weight));


          if (_dadosDiarios[i].totalCasos == null ){
          //  hahaha.add(FlSpot((i+1.0),0.0));
          }else{
          //  hahaha.add(FlSpot((i+1.0),_dadosDiarios[i].totalCasos));
          }
          print("tamanho do list teste2: " +hahaha.length.toString());



        });

      }

      //Converter spots


    }



  //  final dataInicial = d.format(("1/22/20"));

  }


  List<FlSpot> spots(List<FlSpot> inputSpots) {
    return inputSpots.map((spot) {
      return spot.copyWith();
    }).toList();
  }




@override
  void initState() {
  initializeDateFormatting("pt_BR");
  //_atualizarTimeline();
  }

  //Lista cores gradiente
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  // Botão gráfico
  bool showDaily = true;
  String textoBotaodaily ="Dia";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //padding: EdgeInsets.all(5),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width? 1.7 : 2.5 ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            color: Color(0xff232d37)),
                        child: Padding(
                          padding: EdgeInsets.only(right: 18, left: 12,top: 24,bottom: 12),
                          child: LineChart(
                            showDaily ? dailyData() : mainData(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 34,
                      child: FlatButton(
                        onPressed: (){
                          setState(() {
                            showDaily = !showDaily;

                            showDaily ? textoBotaodaily ="Dia" : textoBotaodaily ="Total";

                          });
                        },
                        child: Text(
                          textoBotaodaily,
                          style: TextStyle(
                              fontSize: 12,color: showDaily ? Colors.white.withOpacity(0.5) : Colors.white),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  LineChartData mainData(){
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value){//linhas de grade horizontais
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value){//linhas de grade verticais
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData( //legendas
        show: true,
        bottomTitles: SideTitles( //legenda horizontal
          showTitles: true,
          reservedSize: 22,
          textStyle:
          const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value){ //preparar eixo de rotulo de legenda
            switch (value.toInt()){
              case 2:
                return "MAR";
              case 5:
                return "JUN";
              case 8:
                return "SET";
            }
            return "";
          },
          margin: 8,
          ),
        leftTitles: SideTitles( //legenda vertical
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value){
            switch (value.toInt()){
              case 1:
                return "10k";
              case 3:
                return "30K";
              case 5:
                return "50k";
            }
            return "";
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
        FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1 )),
        minX: 0, //start x
        maxX: 20, // total da escala + 10%
        minY: 7000, //start y
        maxY: 45000, // total da escala + 10%
        lineBarsData: [
          LineChartBarData( //primeira linha do gráfico
            spots: hahaha,
            isCurved: true, //linha suavizada
            colors: gradientColors,
            barWidth: 5, //espessura da linha
            isStrokeCapRound: true, //final da linha arredondado
            dotData: FlDotData( show: true),//marcador dos pontos
            belowBarData: BarAreaData( //virar grafico de area
              show: false,
              colors: gradientColors.map((color)=> color.withOpacity(0.3)).toList(),
            ),
          ),
          //Segunda linha do gráfico
          LineChartBarData( //primeira linha do gráfico
            spots: hahaha,
            isCurved: true, //linha suavizada
            colors: gradientColors,
            barWidth: 5, //espessura da linha
            isStrokeCapRound: true, //final da linha arredondado
            dotData: FlDotData( show: true),//marcador dos pontos
            belowBarData: BarAreaData( //virar grafico de area
              show: false,
              colors: gradientColors.map((color)=> color.withOpacity(0.3)).toList(),
            ),
          )
        ],
    );
  }

  LineChartData dailyData(){
    return LineChartData(
      lineTouchData: LineTouchData(enabled: true),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value){//linhas de grade horizontais
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value){//linhas de grade verticais
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData( //legendas
        show: true,
        bottomTitles: SideTitles( //legenda horizontal
          showTitles: true,
          reservedSize: 22,
          textStyle:
          const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value){ //preparar eixo de rotulo de legenda
            switch (value.toInt()){
              case 2:
                return "MAR";
              case 5:
                return "JUN";
              case 8:
                return "SET";
            }
            return "";
          },
          margin: 8,
        ),
        leftTitles: SideTitles( //legenda vertical
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value){
            switch (value.toInt()){
              case 1:
                return "10k";
              case 3:
                return "30K";
              case 5:
                return "50k";
            }
            return "";
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
      FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1 )),
      minX: 0, //start x
      maxX: 100, // total da escala + 10%
      minY: 0, //start y
      maxY: 45000, // total da escala + 10%
      lineBarsData: [
        LineChartBarData( //primeira linha do gráfico
          spots: [//rodar função para adicionar os pontos || x é data y é o valor // lista de widgets
            FlSpot(0, 3),
            FlSpot(2, 3),
            FlSpot(4, 3),
            FlSpot(6, 3),
            FlSpot(8, 3),
            FlSpot(9, 3),
            FlSpot(11, 3),
          ],
          isCurved: true, //linha suavizada
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2),
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2),
          ],
          barWidth: 5, //espessura da linha
          isStrokeCapRound: true, //final da linha arredondado
          dotData: FlDotData( show: true),//marcador dos pontos
          belowBarData: BarAreaData( //virar grafico de area
            show: false,
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),
              ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),
            ],
          ),
        ),
        //Segunda linha do gráfico
        LineChartBarData( //primeira linha do gráfico
          spots: [//rodar função para adicionar os pontos || x é data y é o valor // lista de widgets
            FlSpot(0, 1),
            FlSpot(2, 1),
            FlSpot(4, 1),
            FlSpot(6, 1),
            FlSpot(8, 1),
            FlSpot(10, 1),
            FlSpot(11, 1),
          ],
          isCurved: true, //linha suavizada
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2),
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2),
          ],
          barWidth: 5, //espessura da linha
          isStrokeCapRound: true, //final da linha arredondado
          dotData: FlDotData( show: true),//marcador dos pontos
          belowBarData: BarAreaData( //virar grafico de area
            show: false,
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),
              ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),
            ],
          ),
        )
      ],
    );
  }


}
