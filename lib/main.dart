import 'package:biodata/common/navigation.dart';
import 'package:biodata/common/styles.dart';
import 'package:biodata/data/db/biodata_database_helper.dart';
import 'package:biodata/provider/biodata_db_provider.dart';
import 'package:biodata/provider/photo_provider.dart';
import 'package:biodata/ui/add_biodata_page.dart';
import 'package:biodata/ui/biodata_detail_page.dart';
import 'package:biodata/ui/list_biodata_page.dart';
import 'package:biodata/ui/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => BiodataDbProvider(databaseHelper: BiodataDatabaseHelper()),),
          ChangeNotifierProvider(
            create: (_) => PhotoProvider(),),
        ],
        child: MaterialApp(
          title: 'Biodata',
          theme: ThemeData(
            primaryColor: primaryColor,
            accentColor: secondaryColor,
            scaffoldBackgroundColor: Colors.white,
            textTheme: myTextTheme,
            appBarTheme: AppBarTheme(
              textTheme: myTextTheme.apply(bodyColor: Colors.black),
              elevation: 0,
            ),
            buttonTheme: ButtonThemeData(
              buttonColor: primaryColor,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                ),
              ),
            ),
          ),
          navigatorKey: navigatorKey,
          initialRoute: Splashscreen.routeName,
          routes: {
            Splashscreen.routeName: (context) => Splashscreen(),
            BiodataListPage.routeName: (context) => BiodataListPage(),
            BiodataDetailPage.routeName: (context) => BiodataDetailPage(
              id: ModalRoute.of(context).settings.arguments,
            ),
            AddBiodata.routeName: (context) => AddBiodata(
              id: ModalRoute.of(context).settings.arguments,
            ),
          },
        ),
      );
  }
}


