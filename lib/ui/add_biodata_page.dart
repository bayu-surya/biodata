import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:biodata/data/model/biodata.dart';
import 'package:biodata/provider/biodata_db_provider.dart';
import 'package:biodata/provider/photo_provider.dart';
import 'package:biodata/ui/add_biodata_fragment.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddBiodata extends StatefulWidget {
  static const routeName = '/add_biodata';

  final String id;

  const AddBiodata({
    this.id
  });

  @override
  _AddBiodataState createState() => _AddBiodataState();
}

class _AddBiodataState extends State<AddBiodata> {

  String _photo= "";

  @override
  Widget build(BuildContext context) {

    return Consumer<BiodataDbProvider>(
        builder: (context, provider, child) {
          return FutureBuilder<Biodata>(
              future: provider.getBiodataByid(widget.id.toString()),
              builder: (context, snapshot) {
                var biodata = snapshot.data ?? null;
                if (widget.id!=null) {
                  if (biodata != null) {
                    if (_photo == "") {
                      _photo = biodata.photo;
                      Provider.of<PhotoProvider>(context, listen: false).complete(_photo);
                    }
                  }
                }
                return Scaffold(
                  appBar: AppBar(
                    title: Text( widget.id!=null? 'Edit Biodata':'Tambah Biodata',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                  backgroundColor: Colors.white,
                  body: Center(
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 0, right: 0),
                      children: <Widget>[
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: getImagenBase64(_photo),
                        ),
                        widget.id!=null ?
                        AddBiodataFragment(id: biodata.id) :
                        AddBiodataFragment() ,
                      ],
                    ),
                  ),
                );
              }
          );
        }
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget getImagenBase64(String image) {
    String _imageBase64 = image;
    const Base64Codec base64 = Base64Codec();
    if (_imageBase64 == null || _imageBase64=="") {
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

  _imgFromCamera() async {
    final _picker = ImagePicker();
    PickedFile image = await _picker.getImage(
            source: ImageSource.camera, imageQuality: 50
        );
    setState(() {
      final bytes = File(image.path).readAsBytesSync();
      _photo = base64Encode(bytes);
      Provider.of<PhotoProvider>(context, listen: false).complete(_photo);
    });
  }

  _imgFromGallery() async {
    final _picker = ImagePicker();
    PickedFile image = await _picker.getImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    setState(() {
      final bytes = File(image.path).readAsBytesSync();
      _photo = base64Encode(bytes);
      Provider.of<PhotoProvider>(context, listen: false).complete(_photo);
    });
  }
}