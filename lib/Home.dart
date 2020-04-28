import 'package:coronawatch/ListaPaises.dart';
import 'package:coronawatch/TelaPrincipal.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String pesquisa = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "CORONAVIRUS TRACKER",
                          style: TextStyle(
                            fontSize: 26,
                            color: Color(0xff598747),
                            fontWeight: FontWeight.bold,
                            fontFamily: "Righteous",
                          ),
                        ),
                      ),

                      Image.asset("imagens/capa.png"),
                      Padding(
                        padding: EdgeInsets.only(top: 20,left: 20, right: 20),
                        child: RaisedButton(
                          child: Text(
                            "ATUALIZAR",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Righteous",
                            ),
                          ),
                          color: Color(0xff598747),
                          padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                          onPressed: (){

                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context)=> TelaPrincipal()));
                            //  MaterialPageRoute(builder: (context)=> ListaPaises(pesquisa)));

                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),

    );
  }
}
