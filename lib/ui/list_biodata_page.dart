import 'package:biodata/provider/biodata_db_provider.dart';
import 'package:biodata/ui/add_biodata_page.dart';
import 'package:biodata/utils/result_state.dart';
import 'package:biodata/widgets/card_article.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BiodataListPage extends StatelessWidget {
  static const routeName = '/biodata_list';

  const BiodataListPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List biodata',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle_rounded,
              color: Colors.white,
              size: 26.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBiodata(),
                ),
              );
            },
          ),
        ],
      ),
      body:
      Consumer<BiodataDbProvider>(
        builder: (context, provider, child) {
          if (provider.state == ResultState.HasData) {
            return ListView.builder(
              padding: EdgeInsets.all(3.0),
              itemCount: provider.biodata.length,
              itemBuilder: (context, index) {
                return CardArticle(article: provider.biodata[index]);
              },
            );
          } else {
            return Center(
              child: Text(provider.message),
            );
          }
        },
      ),
    );
  }
}
