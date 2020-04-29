import 'package:coronawatch/Model/Pais.dart';
import 'package:coronawatch/TelaPrincipal.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getflutter/getflutter.dart';

class ListaPaises extends StatefulWidget {



  @override
  _ListaPaisesState createState() => _ListaPaisesState();
}

class _ListaPaisesState extends State<ListaPaises> {

  List _paises = [];


  _CarregarPaises() async {
    _paises.add(Pais(title: "World", code: "-"));
    String id;
    String title;
    String code;


    String url = "https://api.thevirustracker.com/free-api?countryTotals=ALL";
    http.Response response;
    response = await http.get(url);
    Map<String, dynamic> retorno = json.decode(response.body);
    int totalPaises = retorno["countryitems"][0].length; //tamanho dos itens

    int i = 1;
    var testeChave =
        retorno["countryitems"][0][i.toString()]["title"].toString();
    // int numPaises = testeChave.length;
    print("VAIII: " + totalPaises.toString());
    print("VAIII: " + testeChave);



    for (var i = 1; i < totalPaises; i++){
      //print("Nome pais: " + retorno["countryitems"][0][i.toString()]["title"].toString());
      id = retorno["countryitems"][0][i.toString()]["ourid"].toString();
      title = retorno["countryitems"][0][i.toString()]["title"].toString();
      code = retorno["countryitems"][0][i.toString()]["code"].toString();
     // print("ID: $id Paisao: $title Paisin: $code");

      setState(() {
        _paises.add(Pais(title: title, code: code));
      });


    }
      print("sera: " + _paises[1].title);
    itemsNew.addAll(_paises);

  }

  TextEditingController editingController = TextEditingController();
  String paisEscolhido = "-";

  _salvar() async{

    String paisSelecionado = paisEscolhido;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("code", paisSelecionado);
    print("Salvar: $paisSelecionado");
    //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> Navegar()));
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> TelaPrincipal()));

  }

  var items = List<String>();
  List itemsNew = [];
  var duplicateItems = List<String>();

  void resultadoPesquisa (String query){

    //List<String> dummySearchList = List<String>();
    List dummySearchList = [];
    dummySearchList.addAll(_paises);

    if(query.isNotEmpty){
      List dummyListData = [];
      print("tamanho: " + dummySearchList.length.toString());
      for (var i = 0; i <= dummySearchList.length; i++){
        if(dummySearchList[i].title.toLowerCase().contains(query.toLowerCase())){
          //print("resultado: " + dummySearchList[i].title);
          dummyListData.add(dummySearchList[i]);
         print("encontrados: " +dummyListData.length.toString());
         setState(() {

           itemsNew.clear();
           itemsNew.addAll(dummyListData);

         });


          //print("achei: " + dummyListData[i].title);
          //print("achei: " + dummySearchList[i]);
        }
      }

      return;

    } else {
      setState(() {
        itemsNew.clear();
        itemsNew.addAll(_paises);
      });
    }

  }



  @override
  void initState() {
    _CarregarPaises();
    //items.addAll(duplicateItems);

  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      /*appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, opacity: 1),
        backgroundColor: Color(0xff598747),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "CORONAVÍRUS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: "Righteous",
              ),
            ),
            /*Text("//",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "Righteous",
                ),
            ),*/
            Icon(Icons.assessment),
            Text(
              "TRACKER",
              style: TextStyle(
                //fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: "Righteous",
              ),
            ),
          ],
        ),
      ),*/
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 30,right: 30, top: 15),
                child: TextField(
                  onChanged: (value){
                    resultadoPesquisa(value);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      labelText: "Pesquisa",
                      hintText: "Pesquisa",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25))
                      )
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, indice){
                    return
                      ListTile(
                      leading: indice == 0 && itemsNew[indice].code.toString() == "-" ? Image.asset("imagens/mundo.png") : Image.network("https://www.countryflags.io/" + itemsNew[indice].code.toString() + "/shiny/64.png"),
                      /*GFAvatar(
                        backgroundImage: NetworkImage("https://www.countryflags.io/" + itemsNew[indice].code.toString() + "/shiny/64.png"),
                        backgroundColor: Colors.white,
                        shape: GFAvatarShape.standard,
                      )*/
                      onTap: (){
                        print("pais: " + itemsNew[indice].title);
                        setState(() {
                          paisEscolhido = itemsNew[indice].code.toString();
                        });
                        _salvar();
                      },
                      title: Text(
                          itemsNew[indice].title,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Righteous",
                          )
                      ) ,
                      subtitle: Text(
                          itemsNew[indice].code,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Righteous",
                          )
                      ),
                    );
                  },
                  separatorBuilder: (context,indice) => Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  itemCount: itemsNew.length
              ),
            )
          ],
        ),
      ),
    );

  }
}
