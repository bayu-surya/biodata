import 'dart:convert';
import 'dart:typed_data';

import 'package:biodata/common/navigation.dart';
import 'package:biodata/common/styles.dart';
import 'package:biodata/data/model/biodata.dart';
import 'package:biodata/provider/biodata_db_provider.dart';
import 'package:biodata/ui/add_biodata_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BiodataDetailPage extends StatelessWidget {
  static const routeName = '/biodata_detail';

  final String id;

  const BiodataDetailPage({
    @required this.id
  });

  @override
  Widget build(BuildContext context) {

    return Consumer<BiodataDbProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<Biodata>(
            future: provider.getBiodataByid(id.toString()),
            builder: (context, snapshot) {
              var biodata = snapshot.data ?? null;
              return Scaffold(
                appBar: _appBar2(biodata),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Center(
                              child: getImagenBase64(biodata.photo),
                            ),
                            SizedBox(height: 10),
                            Text(
                              biodata.name ?? "",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(biodata.address),
                            Divider(color: Colors.grey),
                            Text('Tanggal lahir : ${biodata.birthDate}'),
                            SizedBox(height: 10),
                            Text('Tinggi : ${biodata.height} cm'),
                            SizedBox(height: 10),
                            Text('Berat : ${biodata.weight} kg'),
                            Divider(color: Colors.grey),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0,10.0,0,0),
                              child: Material(
                                borderRadius: BorderRadius.circular(30.0),
                                shadowColor: Colors.lightBlueAccent.shade100,
                                elevation: 5.0,
                                color: primaryColor,
                                child:
                                MaterialButton(
                                  minWidth: 180.0,
                                  height: 42.0,
                                  child: Text('Edit Data Karyawan',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)
                                  ),
                                  onPressed: () {
                                    Navigation.intentWithData(
                                        AddBiodata.routeName, id);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        );
      },
    );
  }

  Widget getImagenBase64(String image) {
    String _imageBase64 = image;
    const Base64Codec base64 = Base64Codec();
    if (_imageBase64 == null) {
      return CircleAvatar(
        radius: 55,
        backgroundColor: Colors.black12,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(50)),
          width: 100,
          height: 100,
          child: Icon(
            Icons.camera_alt,
            color: Colors.grey[800],
          ),
        ),
      );
    }

    Uint8List bytes = base64.decode(_imageBase64);
    return CircleAvatar(
      radius: 55,
      backgroundColor: Colors.black12,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.memory(
          bytes,
          width: 100,
          height: 100,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  AppBar _appBar2(Biodata state) {
    return AppBar(
      title: Text("Detail Biodata",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
      actions: <Widget>[
        Consumer<BiodataDbProvider>(
          builder: (context, provider, child) {
            return FutureBuilder<bool>(
              future: provider.isBiodata(state.id.toString()),
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 26.0,
                  ),
                  onPressed: () {
                    provider.removeBiodata(state.id.toString());
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}

