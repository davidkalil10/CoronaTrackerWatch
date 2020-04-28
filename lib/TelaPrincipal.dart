import 'dart:developer';
import 'package:coronawatch/Model/Pais.dart';
import 'package:coronawatch/LinhadoTempo.dart';
import 'package:coronawatch/ListaPaises.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class TelaPrincipal extends StatefulWidget {


  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {



  _atualizarMundo() async {



    String url = "https://api.thevirustracker.com/free-api?global=stats";

    http.Response response;
    response = await http.get(url);
    Map<String, dynamic> retorno = json.decode(response.body);
    String testeChave = retorno["results"][0]["total_cases"].toString();
    // String testeChave = retorno["countrydata"]["info"]["title"].toString();
    print("O país éeee: " + testeChave);

    //Mascara para formatação dos milhares
    var f = NumberFormat('#,###', "pt_BR");
    var f2 = NumberFormat('##.##', "pt_BR");
    var d = DateFormat('HH:mm d/MM','pt_BR');

    print("rodei");

    setState(() {

      nomePais = "World";
      totalCasos = f.format(retorno["results"][0]["total_cases"]).toString();
      totalObitos = f.format(retorno["results"][0]["total_deaths"]).toString();
      letalidade = f2.format( ((retorno["results"][0]["total_deaths"]) / (retorno["results"][0]["total_cases"]))*100).toString() + "%";
      childBandeira = Image.asset("imagens/mundo.png", width: 60,height: 60,);
      var now = DateTime.now();
      horaAtualizacao = d.format(now);

    });

  }


  _atualizarCasos() async{

    String country = _textoSalvo;
    print("checando: $country");

    if (country == "-"){
      return _atualizarMundo();
    }


    String url = "https://api.thevirustracker.com/free-api?countryTotal=" + country;

    http.Response response;
    response = await http.get(url);
    Map<String, dynamic> retorno = json.decode(response.body);
    //dynamic countryCode = retorno[dropdownValue];
    String testeChave = retorno["countrydata"][0]["info"]["title"].toString();
   // String testeChave = retorno["countrydata"]["info"]["title"].toString();
    print("O país éeee: " + testeChave);

    //Mascara para formatação dos milhares
    var f = NumberFormat('#,###', "pt_BR");
    var f2 = NumberFormat('##.##', "pt_BR");
    var d = DateFormat('HH:mm d/MM','pt_BR');

    setState(() {
      nomePais = retorno["countrydata"][0]["info"]["title"].toString();
      totalCasos = f.format(retorno["countrydata"][0]["total_cases"]).toString();
      totalObitos = f.format(retorno["countrydata"][0]["total_deaths"]).toString();
      letalidade = f2.format( ((retorno["countrydata"][0]["total_deaths"]) / (retorno["countrydata"][0]["total_cases"]))*100).toString() + "%";
      urlBandeira = "https://www.countryflags.io/" + country + "/shiny/64.png";
      childBandeira = Image.network(urlBandeira);
      var now = DateTime.now();
      horaAtualizacao = d.format(now);


    });


  }


  _recuperar() async{

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _textoSalvo = prefs.getString("code") ?? "-";
      dropdownIndicadores = prefs.getString("indicador") ?? "Casos";
      dropdownAgrupamento = prefs.getString("agrupamento") ?? "Totais";
      dropdownPeriodo = prefs.getString("periodo") ?? "Todos";
      String _corGraf = prefs.getString("cor") ?? Color(0xff28B4C8).toString();

      String valueString = _corGraf.split('(0x')[1].split(')')[0]; // kind of hacky..
      int ret = int.parse(valueString, radix: 16);
      corGrafico = new Color(ret);

      if (dropdownIndicadores == "Casos"){
      corBotao = Colors.blue[50];

      }else if(dropdownIndicadores=="Óbitos"){
        corBotao = Colors.yellow[50];

      }

      if (dropdownAgrupamento == "Totais"){
        tituloGrafico = dropdownIndicadores + " Acumulados";
      }else{
        tituloGrafico = dropdownIndicadores + " Diários";
      }


      print("texto lido: $_textoSalvo");
      _atualizarCasos();
    });

  }


  _salvarReferencias() async{

    final prefs = await SharedPreferences.getInstance();
    String selecaoIndicador = dropdownIndicadores;
    String selecaoAgrupamento = dropdownAgrupamento;
    String selecaoPeriodo = dropdownPeriodo;
    String corGraf= "";

    //recuperar cor de string e passar para cor de volta
    /*String valueString = corGraf.split('(0x')[1].split(')')[0]; // kind of hacky..
    int ret = int.parse(valueString, radix: 16);
    Color otherColor = new Color(ret);
    print(otherColor == corGrafico);*/

    if (selecaoIndicador == "Casos"){
      corGraf = Color(0xff28B4C8).toString();
    }else{
      corGraf = Color(0xffE4B949).toString();
    }

    //Salvar info no BD
    await prefs.setString("indicador", selecaoIndicador);
    await prefs.setString("agrupamento", selecaoAgrupamento);
    await prefs.setString("periodo", selecaoPeriodo);
    await prefs.setString("cor", corGraf);

    print("F1: $selecaoIndicador , F2: $selecaoAgrupamento, F3: $selecaoPeriodo");

    //Renderizar gráfico
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> TelaPrincipal()));

  }



  //Variáveis iniciais
 // String dropdownValue = "-";
  String _textoSalvo = "";
  String nomePais ="-";
  String totalCasos = "-";
  String totalObitos = "-";
  String letalidade = "-";
  String urlBandeira = "";
  Widget childBandeira = Container();
  String horaAtualizacao = "--:-- --/--";
  DateFormat formatoHora;
  DateFormat formatoData;
  List<String> listaIndicadores = ["Casos", "Óbitos"];
  String dropdownIndicadores;
  var listaAgrupamento = ["Totais", "Diários"];
  String dropdownAgrupamento;
  //var listaPeriodo = ["Totais", "Último mês", "Última Semana"];
  var listaPeriodo = ["Todos","Último mês", "Última Semana"];
  String dropdownPeriodo;
  Color corGrafico = Color(0xff28B4C8);
  Color corBotao = Colors.blue[50];
  String tituloGrafico = "";
 // List _paises =[];
 // var _codigoPais = ["-"];



  @override
  void initState() {

    initializeDateFormatting("pt_BR");
    _recuperar();

  }

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    Widget graficos = LinhadoTempo();
    double fatorAjusteGrafico = (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width? 0.27: 0.71 );
    //Widget graficos = Timeline();
    //Widget graficos = LinhadoTempo();


    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
          opacity: 1
        ),
        backgroundColor: Color(0xff598747),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("CORONAVÍRUS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: "Righteous",
              ),
            ),
            Icon(Icons.assessment),
            Text("TRACKER",
              style: TextStyle(
                //fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: "Righteous",
              ),
            ),
          ],
        ),
      ),
      body: Scaffold(
        body: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10,right: 10,left: 10),
                    child: Material(
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Última Atualização",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontFamily: "Righteous",
                              color: Color(0xffA6AEB7),
                            ),
                          ),
                          Text(
                            horaAtualizacao,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: "Daysone",
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  //Seleção do país
                  Padding(
                    padding: EdgeInsets.only(top: 20,right: 20, left: 20,bottom: 5),
                    child: Material(
                      color: Colors.white,
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(24),
                      shadowColor: Color(0x802196f3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Selecione o país",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: "Righteous",
                                  ),
                                ),
                                Material(
                                  color: Colors.blue[50],
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                  shadowColor: Color(0x802196f3),
                                  child: FlatButton(
                                      onPressed: (){
                                        setState(() {
                                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> ListaPaises()));
                                          //dropdownValue = newValue;
                                          //_atualizarCasos();
                                        });

                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            _textoSalvo,
                                            style: TextStyle(
                                              fontSize: 40,
                                              fontFamily: "Daysone",
                                              color: Colors.blue[300],
                                            ),
                                          ),
                                          Icon(FontAwesomeIcons.caretDown,color:Colors.blue[400])
                                        ],
                                      )
                                  ),
                                )
                                ,
                                Text(
                                  nomePais,
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: "Daysone",
                                    color: Color(0xff59AA91),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],

                      ),
                    ),
                  ),
                  //Primeiro Card
                  Padding(
                    padding: EdgeInsets.only(top: 10,right: 20, left: 20,bottom: 10),
                    child: Material(
                      color: Colors.white,
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(24),
                      shadowColor: Color(0x802196f3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Casos Confirmados",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: "Righteous",
                                  ),
                                ),
                                Text(
                                  totalCasos,
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 35,
                                    fontFamily: "Daysone",
                                    color: Color(0xff6978FC),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: childBandeira,
                          )
                        ],

                      ),
                    ),
                  ),
                  //Segundo Card
                  Padding(
                    padding: EdgeInsets.only(top: 10,right: 20, left: 20,bottom: 20),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Material(
                            color: Colors.white,
                            elevation: 14.0,
                            borderRadius: BorderRadius.circular(24),
                            shadowColor: Color(0x802196f3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Óbitos",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          fontFamily: "Righteous",
                                        ),
                                      ),
                                      Text(
                                        totalObitos,
                                        style: TextStyle(
                                          //fontWeight: FontWeight.bold,
                                          fontSize: 28,
                                          fontFamily: "Daysone",
                                          color: Color(0xffE4B949),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Material(
                            color: Colors.white,
                            elevation: 14.0,
                            borderRadius: BorderRadius.circular(24),
                            shadowColor: Color(0x802196f3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Letalidade",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          fontFamily: "Righteous",
                                        ),
                                      ),
                                      Text(
                                        letalidade,
                                        style: TextStyle(
                                          //fontWeight: FontWeight.bold,
                                          fontSize: 28,
                                          fontFamily: "Daysone",
                                          color: Color(0xffCD5075),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  //Card gráfico
                  Padding(
                    padding: EdgeInsets.only(left: 20,right: 20,bottom: 10),
                    child: Container(
                      child: Material(
                        color: Colors.white,
                        elevation: 14.0,
                        borderRadius: BorderRadius.circular(24),
                        shadowColor: Color(0x802196f3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            //Stack do titulo e dos botoes de controle
                            Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: (MediaQuery.of(context).size.width)/9,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            /*IconButton(
                                        icon: Icon(Icons.info_outline),
                                        onPressed: (){},
                                        tooltip: "Gire o celular para uma melhor experiência",
                                      ),*/
                                            Padding(
                                              padding: EdgeInsets.only(left: 10,top: 0),
                                              child: Text(
                                                tituloGrafico,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  fontFamily: "Righteous",
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.info_outline),
                                              onPressed: (){},
                                              tooltip: "Gire o celular para uma melhor experiência",
                                            )
                                            /*IconButton(
                                        icon: Icon(Icons.info_outline),
                                        onPressed: (){},
                                        tooltip: "Fonte dos dados: TheVirusTracker.com",
                                      )*/
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 24,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 00,left: 10,right: 10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            //Primeiro Filtro
                                            Material(
                                              color: corBotao,
                                              elevation: 1.0,
                                              borderRadius: BorderRadius.all(Radius.circular(50)),
                                              shadowColor: Color(0x802196f3),
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 10),
                                                child: DropdownButton(
                                                  value: dropdownIndicadores,
                                                  onChanged: (String newValue){
                                                    setState(() {
                                                      dropdownIndicadores = newValue;
                                                      _salvarReferencias();
                                                    });
                                                  },
                                                  items: listaIndicadores.map<DropdownMenuItem<String>>((String value){
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          Text(
                                                            value,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily: "Daysone",
                                                              color: corGrafico.withOpacity(1.0),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                            //Segundo Filtro
                                            Material(
                                              color: corBotao,
                                              elevation: 1.0,
                                              borderRadius: BorderRadius.all(Radius.circular(50)),
                                              shadowColor: Color(0x802196f3),
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 10),
                                                child: DropdownButton(
                                                  value: dropdownAgrupamento,
                                                  onChanged: (String newValue){
                                                    setState(() {
                                                      dropdownAgrupamento = newValue;
                                                      _salvarReferencias();
                                                    });
                                                  },
                                                  items: listaAgrupamento.map<DropdownMenuItem<String>>((String value2){
                                                    return DropdownMenuItem<String>(
                                                      value: value2,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          Text(
                                                            value2,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily: "Daysone",
                                                              color: corGrafico.withOpacity(1.0),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                            //Terceiro Filtro
                                            Material(
                                              color: corBotao,
                                              elevation: 1.0,
                                              borderRadius: BorderRadius.all(Radius.circular(50)),
                                              shadowColor: Color(0x802196f3),
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 10),
                                                child: DropdownButton(
                                                  value: dropdownPeriodo,
                                                  onChanged: (String newValue){
                                                    setState(() {
                                                      dropdownPeriodo = newValue;
                                                      _salvarReferencias();
                                                    });
                                                  },
                                                  items: listaPeriodo.map<DropdownMenuItem<String>>((String value3){
                                                    return DropdownMenuItem<String>(
                                                      value: value3,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          Text(
                                                            value3,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily: "Daysone",
                                                              color: corGrafico.withOpacity(1.0),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                            ],
                            ),
                            //Stack do grafico
                            Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: (MediaQuery.of(context).size.height*fatorAjusteGrafico),
                                  //height: MediaQuery.of(context).size.height,
                                  child: graficos,
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
