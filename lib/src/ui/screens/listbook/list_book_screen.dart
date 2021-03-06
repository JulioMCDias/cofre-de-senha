import 'package:cofresenha/src/data/model/book.dart';
import 'package:cofresenha/generated/l10n.dart';
import 'package:cofresenha/src/ui/screens/listbook/list_book_bloc.dart';
import 'package:cofresenha/src/ui/widget/background_decoration.dart';
import 'package:cofresenha/src/ui/widget/loading_visibility.dart';
import 'package:flutter/material.dart';

class ListBookScreen extends StatefulWidget {
  final ListBookBloc _bloc;
  ListBookScreen(this._bloc);

  @override
  _ListBookScreenState createState() => _ListBookScreenState();
}

class _ListBookScreenState extends State<ListBookScreen> {
  ListBookBloc _bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _bloc = widget._bloc;
    _bloc.initState(context);

    _bloc.infoError = (String value) {
      final snack = SnackBar(
        content: Text(value), duration: Duration(seconds: 2));
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(snack);
    };

    super.initState();
  }


  // --------------------- view --------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text(S.of(context).titleBooks,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          centerTitle: true,
          actions: [
            // --- btn barra voltar ---
            IconButton(
              icon: Icon(Icons.exit_to_app, color: Theme.of(context).primaryColor,),
              onPressed: () => _bloc.btnLogout(),

            )
          ],
        ),
        body: Container(
          decoration: BackgroundDecoration(),
          height: double.infinity,
          child: Stack(
            children: [
              LoadingVisibility(_bloc.streamLoadingVisibility),

              StreamBuilder<List<Book>>(
                stream: _bloc.streamListBook,
                initialData: [],
                builder: (context, list){
                  return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: list.data.length,
                    itemBuilder: (context, index){
                      return _buildItem(context, list.data[index], index);
                    },
                  );
                },
              )
            ]),
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.indigo,),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: (){
          showDialogAddBook(context);
        },
      ),
    );
  }


  // --------------- list item remove ---------
  Widget _buildItem(context, Book book, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-.9, 0),
          child: Icon(Icons.delete, color: Colors.white,),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: _bookCard(context, book),
      onDismissed: (direction) {
        _bloc.btnRemove(book, index);

        final snack = SnackBar(
          content: Text("${S.of(context).infoBook}: ${book.name} ${S.of(context).infoBookRemoved}"),
          action: SnackBarAction(label: S.of(context).infoUndo,
            onPressed: (){
              _bloc.btnRestoreItemBook();
            },),
          duration: Duration(seconds: 2),
        );
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(snack);
      }
    );
  }


  // ---------------- card -----------------
  Widget _bookCard(context, Book book){
    return Container(

      child: GestureDetector(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                book.name,
                style: TextStyle(color: Colors.indigo, fontSize: 24),
              ),
            ),
          ),
        ),
        onTap: ()=> _bloc.btnItem(book),
        onLongPress: () => showDialogAddBook(context, book: book),
      ),
    );
  }
  // ---------



  // ---------- dialog book ------------
  void showDialogAddBook(BuildContext context, {Book book}){
    TextEditingController _textEditCon = TextEditingController();
    StateSetter _setStage;
    bool nameNotNull = true;

    if(book != null) _textEditCon.text = book.name;

    showDialog( context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text((book == null) ? S.of(context).infoAddNewBook :
          S.of(context).infoEditBook),
          content: StatefulBuilder(
            builder:(BuildContext context, StateSetter setState) {
              _setStage = setState;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _textEditCon,
                  decoration: InputDecoration(
                    labelText: S
                      .of(context)
                      .infoNameBook,
                    labelStyle: TextStyle(color: Colors.black87),
                    errorText: (nameNotNull) ? null : S
                      .of(context)
                      .validateNameBook,
                    contentPadding: const EdgeInsets.only(left: 8.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(width: 1, color: Colors.black87)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(width: 1, color: Colors.black87)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(width: 2, color: Colors.redAccent)
                    ),
                  ),
                ),
              );
            }
          ),
          actions: <Widget>[
            // btn cancel
            FlatButton(
              child: Text(S.of(context).btnCancel),
              onPressed: () => Navigator.of(context).pop()
            ),
            FlatButton(
              child: Text(S.of(context).btnSave),
              onPressed: () {
                _setStage(() {
                  if(_textEditCon.text == null || _textEditCon.text == "")
                    nameNotNull = false;
                  else {
                    nameNotNull = true;
                    (book == null) ? _bloc.btnAdd(_textEditCon.text) :
                    _bloc.updateBook(book, _textEditCon.text);

                    Navigator.of(context).pop();
                  }
                });
              },
            ),
          ],
        );
      }
    );
  }

  // -- add book ---
  Widget alertDialogAddBook() {
    TextEditingController _textEditingController = TextEditingController();

    return AlertDialog(
      title: Text(S.of(context).infoAddNewBook),
      content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              labelText: S.of(context).infoNameBook,
              labelStyle: TextStyle(color: Colors.black87),
              contentPadding: const EdgeInsets.only(left: 8.0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(width: 1, color: Colors.black87)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(width: 1, color: Colors.black87)
              ),
            ),
          ),
      ),
      actions: <Widget>[
        // btn cancel
        FlatButton(
          child: Text("Cancelar"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text("Salvar"),
          onPressed: () {

          },
        ),
      ],
    );
  }


  // -- edit book ---
  Widget alertDialogEditBook(Book book) => AlertDialog(
        title: new Text("Alert Dialog titulo"),
        content: new Text("Alert Dialog body"),
        actions: <Widget>[
          // btn cancel
          new FlatButton(
            child: new Text("Cancelar"),
            onPressed: () {},
          ),
          new FlatButton(
            child: new Text("Salvar"),
            onPressed: () {},
          ),
        ],
      );





  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
