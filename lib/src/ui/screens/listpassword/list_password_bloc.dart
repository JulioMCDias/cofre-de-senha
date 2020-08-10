
import 'dart:async';

import 'package:cofresenha/src/data/model/password.dart';
import 'package:cofresenha/src/presentation/addpassword/add_password_presenter.dart';
import 'package:cofresenha/src/presentation/listpassword/list_password_presenter.dart';
import 'package:cofresenha/src/presentation/listpassword/list_password_view.dart';
import 'package:cofresenha/src/ui/screens/listpassword/list_password_screen.dart';
import 'package:flutter/material.dart';

class ListPasswordBloc implements ListPasswordView{
  @override ListPasswordScreen screen;
  BuildContext _context;
  final ListPasswordPresenter _presenter;


  //----- construtor --------
  ListPasswordBloc(this._presenter) {
    screen = ListPasswordScreen(this);
  }

  //----- initState -----
  void initState(BuildContext context){
    this._context = context;
    _presenter.setTitle();
    _presenter.updateList();
  }


  @override
  Future<void> navigationScreen(Password password) async {
    return await Navigator.push(_context,
      MaterialPageRoute( builder: (context) => AddPasswordPresenter(password: password).view.screen)
    );
  }

  void btnAddPassword(){
    _presenter.addPassword();
  }

  void btnEditPassword(Password password){
    _presenter.editPassword(password);
  }




// ------------- StreamControllers -----------------
  final _listPassword = StreamController<List<Password>>();
  Stream<List<Password>> get streamListPassword => _listPassword.stream;


  @override
  void setListPassword(List<Password> passwords){
    _listPassword.sink.add(passwords);
  }

  final _title = StreamController<String>();
  Stream<String> get streamTitle => _title.stream;

  @override
  void setTitle(String title){
    _title.sink.add(title);
  }
  //-------



  void dispose(){
    _listPassword.close();
    _title.close();
  }
}