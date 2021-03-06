import 'package:cofresenha/generated/l10n.dart';
import 'package:cofresenha/src/ui/screens/createrepository/create_repository_bloc.dart';
import 'package:cofresenha/src/ui/widget/background_decoration.dart';
import 'package:cofresenha/src/ui/widget/loading_visibility.dart';
import 'package:cofresenha/src/ui/widget/text_form_field_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CreateRepositoryScreen extends StatefulWidget {
  final CreateRepositoryBloc _bloc;
  CreateRepositoryScreen(this._bloc);

  @override
  _CreateRepositoryScreenState createState() => _CreateRepositoryScreenState();
}

class _CreateRepositoryScreenState extends State<CreateRepositoryScreen> {
  CreateRepositoryBloc _bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _bloc = widget._bloc;
    _bloc.initState(context);

    // -------- info error -----------
    _bloc.infoError = (String value) {
      final snack = SnackBar(
        content: Text(value), duration: Duration(seconds: 2));
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(snack);
    };

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BackgroundDecoration(),
        height: double.infinity,
        child: Stack(
          children: [
            LoadingVisibility(_bloc.streamLoadingVisibility),

            Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 25, horizontal: 45),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Text(S.of(context).infoRepository,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 20, color: Colors.white),
                                    ),
                              ),
                            Expanded(
                              child: StreamBuilder<String>(
                                initialData: "",
                                stream: _bloc.streamPathRepository,
                                builder: (context, snapshot) {
                                  return Text(snapshot.data,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(fontSize: 18, color: Colors.white),
                            );
                                }
                              )
                            )
                          ],
                        ),
                    ),
                    StreamBuilder<String>(
                      initialData: null,
                      stream: _bloc.streamValidatePassword,
                      builder:(context, snapshot) {
                      return TextFormFieldPassword(
                        errorText: snapshot.data,
                        color: Theme.of(context).primaryColor,
                        controller: _bloc.textEditingPassword,
                      );}
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        StreamBuilder<bool>(
                          stream: _bloc.streamRememberPassword,
                          initialData: false,
                          builder: (context, snapshot){
                            return Checkbox(
                              value: snapshot.data,
                              checkColor: Colors.blue,
                              activeColor: Colors.white,
                              onChanged: (value) => _bloc.setRememberPassword(value),
                            );},
                        ),
                        Text(
                          S.of(context).checkBoxPassword,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 25),
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () {
                          _bloc.btnCreateRepository();
                        },
                        elevation: 5,
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                        color: Colors.white,
                        child: Row(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Icon(
                                    Icons.note_add,
                                    color: Colors.indigo,
                                  ),
                                  Center(
                                    child: Text(
                                      S.of(context).btnNewRepository,
                                      style: TextStyle(fontSize: 20,
                                        color: Colors.indigo),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
