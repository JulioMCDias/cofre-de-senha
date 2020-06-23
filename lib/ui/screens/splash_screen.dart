import 'package:cofresenha/generated/l10n.dart';
import 'package:cofresenha/ui/screens/open_repository_screen.dart';
import 'package:cofresenha/ui/widget/background_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _deslocament = false;
  double _opacityLevel = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1))
        .then((value) => setState(() => _deslocament = true));

    Future.delayed(Duration(seconds: 2))
        .then((value) => setState(() => _opacityLevel = 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BackgroundDecoration(),
        height: double.infinity,
        child: Center(
          child: Stack(
            overflow: Overflow.clip,
            alignment: AlignmentDirectional.center,
            children: [
              AnimatedPositioned(
                duration: Duration(seconds: 1),
                top: _deslocament ? 10 : 150,
                bottom: _deslocament ? 150 : 10,
                curve: Curves.fastOutSlowIn,
                child: Container(
                  padding: EdgeInsets.only(left: 80, right: 80, bottom: 100),
                  child: SvgPicture.asset(
                    "assets/icons/cofre.svg",
                    width: 200,
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _opacityLevel,
                duration: Duration(seconds: 1),
                child: Container(
                  padding: EdgeInsets.only(top: 150),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).infoOpenRepository,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.amber,
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 25, horizontal: 45),
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OpenRepositoryScreen()));
                          },
                          elevation: 5,
                          padding: EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          color: Colors.white,
                          child: Row(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Icon(Icons.folder, color: Colors.indigo),
                                    Center(
                                      child: Text(
                                        S.of(context).btnOpenRepository,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.indigo
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OpenRepositoryScreen()));
                          },
                          elevation: 5,
                          padding: EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          color: Colors.white,
                          child: Row(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Icon(Icons.note_add, color: Colors.indigo),
                                    Center(
                                      child: Text(
                                        S.of(context).btnNewRepository,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.indigo
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
