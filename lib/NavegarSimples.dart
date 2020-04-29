import 'package:coronawatch/LinhadoTempo.dart';
import 'package:coronawatch/ListaPaises.dart';
import 'package:coronawatch/TelaPrincipal.dart';
import 'package:coronawatch/Model/Timeline.dart';
import 'package:coronawatch/Home.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NavegarSimples extends StatefulWidget {
  @override
  _NavegarSimplesState createState() => _NavegarSimplesState();
}

class _NavegarSimplesState extends State<NavegarSimples> {

  int _currentIndex = 0;
  PageController _pageController;



  @override
  void initState() {
    super.initState();

    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index){
            setState(() {
              _currentIndex = index;
            });
          },
          children: <Widget>[
            TelaPrincipal(),
            LinhadoTempo()

          ],
        ),
      ),
      /*bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index){
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Text("País"),
              icon: Icon(FontAwesomeIcons.globeAmericas),
              activeColor: Colors.blue[500]
          ),
          BottomNavyBarItem(
            title: Text("Dashboard"),
            icon: Icon(FontAwesomeIcons.tachometerAlt),
            activeColor: Colors.amber[500],
          ),
          BottomNavyBarItem(
              title: Text("Casos"),
              icon: Icon(FontAwesomeIcons.chartLine)
          ),
          BottomNavyBarItem(
              title: Text("Óbitos"),
              icon: Icon(FontAwesomeIcons.bookDead),
              activeColor: Colors.red
          ),
        ],
      ),*/
    );
  }
}

