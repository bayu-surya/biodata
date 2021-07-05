import 'package:biodata/common/navigation.dart';
import 'package:biodata/data/model/biodata.dart';
import 'package:biodata/provider/biodata_db_provider.dart';
import 'package:biodata/ui/biodata_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardArticle extends StatelessWidget {

  final Biodata article;
  final String jenis;

  const CardArticle({
    Key key, @required this.article, this.jenis,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BiodataDbProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () {
            Navigation.intentWithData(
                BiodataDetailPage.routeName, article.id.toString());
          },
          child: Card(
            elevation: 1.7,
            child: Row(
              children: [
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Text(article.name ?? "",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                      SizedBox(height: 5),
                      Text("tanggal lahir : "+article.birthDate ?? "",
                        style: TextStyle(
                            fontSize: 12),
                      ),
                      SizedBox(height: 5),
                      Text("alamat : "+article.address ?? "",
                        style: TextStyle(
                            fontSize: 12),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.grey,
                    size: 26.0,
                  ),
                  onPressed: () {
                    provider.removeBiodata(article.id.toString());
                  },
                ),
                SizedBox(width: 15),
              ],
            ),
          ),
        );
      },
    );
  }
}
