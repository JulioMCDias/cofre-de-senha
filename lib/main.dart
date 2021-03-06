
import 'package:cofresenha/src/presentation/splash/splash_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        S.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        unselectedWidgetColor: Colors.white,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPresenter().view.screen,
      title: "Cofre de senha",
    );
  }
}

