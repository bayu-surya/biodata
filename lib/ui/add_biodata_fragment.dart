import 'dart:async';

import 'package:biodata/common/styles.dart';
import 'package:biodata/data/model/biodata.dart';
import 'package:biodata/provider/biodata_db_provider.dart';
import 'package:biodata/provider/photo_provider.dart';
import 'package:biodata/utils/date_time_helper.dart';
import 'package:biodata/widgets/date_picker.dart';
import 'package:biodata/widgets/edit_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBiodataFragment  extends StatefulWidget {

  final String id;
  final String photo;

  const AddBiodataFragment({
    Key key, this.id, this.photo
  })
      : super(key: key);

  @override
  _AddBiodataFragmentState createState() => _AddBiodataFragmentState();
}

class _AddBiodataFragmentState extends State<AddBiodataFragment> {

  String _alertString = "";
  String _name = "";
  String _address= "";
  String _height= "";
  String _weight= "";
  String _photo= "";

  final TextEditingController nameController= TextEditingController();
  final TextEditingController addressController= TextEditingController();
  final TextEditingController heightController= TextEditingController();
  final TextEditingController weightController= TextEditingController();
  final TextEditingController birthDateController= TextEditingController();

  Timer _timer;
  int _start = 60;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    nameController.dispose();
    addressController.dispose();
    birthDateController.dispose();
    heightController.dispose();
    weightController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    const _oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      _oneSec,
          (Timer timer) {
            if (_start > 0) {
              setState(() {
                _start--;
              });
            }
      },
    );
  }

  String changeTimer(int data){
    int minute = (data/60).floor();
    int second = data%60;
    return changeTimerString(minute)+":"+changeTimerString(second);
  }

  String changeTimerString(int data){
    String dataFix="";
    if(data<10){
      dataFix="0"+data.toString();
    } else {
      dataFix=data.toString();
    }
    return dataFix;
  }

  @override
  Widget build(BuildContext context) {

    DateTime currentDate = DateTime.now();
    Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
      final DateTime pickedDate = await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: DateTime(1901),
          lastDate: DateTime(2100));
      if (pickedDate != null && pickedDate != currentDate)
        setState(() {
          currentDate = pickedDate;
          String data = DateTimeHelper.formatDate(currentDate);
          controller.text= data;
        });
    }

    final _loginButton = Consumer<BiodataDbProvider>(
      builder: (context, provider, child) {
        return Consumer<PhotoProvider>(
          builder: (context, photoProfider, _) {
            return Padding(
              padding: EdgeInsets.fromLTRB(0,10.0,0,0),
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.lightBlueAccent.shade100,
                elevation: 5.0,
                color: _start>0 ? primaryColor : Colors.grey,
                child:
                MaterialButton(
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(widget.id!=null? 'Edit Biodata':'Tambah Biodata',
                      style: TextStyle(
                          color: _start>0 ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)
                  ),
                  onPressed: _start>0 ?
                      () {
                    if(_name==""){
                      setState(() {
                        _alertString="Anda belum mengisi Nama";
                      });
                    } else if(_address==""){
                      setState(() {
                        _alertString="Anda belum mengisi Alamat";
                      });
                    } else if(birthDateController.text==""){
                      setState(() {
                        _alertString="Anda belum mengisi Tanggal Lahir";
                      });
                    } else if(heightController.text==""){
                      setState(() {
                        _alertString="Anda belum mengisi Tinggi";
                      });
                    } else if(weightController.text==""){
                      setState(() {
                        _alertString="Anda belum mengisi Berat";
                      });
                    } else if(photoProfider.photo==null || photoProfider.photo==""){
                      setState(() {
                        _alertString="Anda belum memilih Foto";
                      });
                    } else {

                      Biodata biodata =  widget.id!=null?
                      Biodata(
                          id: widget.id,
                          name: _name,
                          address: _address,
                          birthDate: birthDateController.text.toString(),
                          height: _height,
                          weight: _weight,
                          photo: photoProfider.photo
                      ) :
                      Biodata(
                          name: _name,
                          address: _address,
                          birthDate: birthDateController.text,
                          height: _height,
                          weight: _weight,
                          photo: photoProfider.photo
                      );
                      widget.id!=null?
                      provider.updateBiodata(biodata)
                          :provider.addBiodata(biodata);

                      nameController.clear();
                      addressController.clear();
                      birthDateController.clear();
                      heightController.clear();
                      weightController.clear();

                      _name="";
                      _address="";
                      _height="";
                      _weight="";
                      _photo="";

                      Navigator.pop(context);
                    }
                  } : null ,
                ),
              ),
            );
          },
        );
      },
    );

    final _tittle = Padding (
      padding: EdgeInsets.fromLTRB(15.0,0,0,0),
      child: Text(
        _start>0 ?
        changeTimer(_start) : changeTimer(_start)+"  waktu habis",
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );

    return Consumer<BiodataDbProvider>(
        builder: (context, provider, child) {
          return FutureBuilder<Biodata>(
              future: provider.getBiodataByid(widget.id.toString()),
              builder: (context, snapshot) {
                var biodata = snapshot.data ?? null;
                if (widget.id!=null){
                  if(biodata!=null) {
                    if (nameController.text == "") {
                      nameController.text = biodata.name;
                    }
                    if (addressController.text == "") {
                      addressController.text = biodata.address;
                    }
                    if (birthDateController.text == "") {
                      birthDateController.text = biodata.birthDate;
                    }
                    if (heightController.text == "") {
                      heightController.text = biodata.height;
                    }
                    if (weightController.text == "") {
                      weightController.text = biodata.weight;
                    }

                    if (_name == "") {
                      _name = biodata.name;
                    }
                    if (_address == "") {
                      _address = biodata.address;
                    }
                    if (_height == "") {
                      _height = biodata.height;
                    }
                    if (_weight == "") {
                      _weight = biodata.weight;
                    }
                    if (_photo == "") {
                      _photo = biodata.photo;
                    }
                  }
                }
                return Center(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 24.0, right: 24.0),
                    children: <Widget>[
                      SizedBox(height: 10),
                      _tittle,
                      SizedBox(height: 8.0),
                      EditText(text: "Nama",
                        onChanged: (value) {
                          _name=value;
                        },
                        textController: nameController,
                        numbers: false,),
                      SizedBox(height: 8.0),
                      EditText(text: "Alamat",
                        onChanged: (value) {
                          _address=value;
                        },
                        textController: addressController,
                        numbers: false,),
                      SizedBox(height: 8.0),
                      DatePicker(
                          text: "Tanggal Lahir",
                          textController: birthDateController,
                          onClick: () => _selectDate(context, birthDateController)),
                      SizedBox(height: 8.0),
                      EditText(text: "Tinggi *cm",
                        onChanged: (value) {
                          _height=value;
                        },
                        textController: heightController,
                        numbers: true,),
                      SizedBox(height: 8.0),
                      EditText(text: "Berat *kg",
                        onChanged: (value) {
                          _weight=value;
                        },
                        textController: weightController,
                        numbers: true,),
                      SizedBox(height: 24.0),
                      _loginButton,
                      SizedBox(height: 24.0),
                      _alertString != "" ? Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '$_alertString',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        color: _alertString==""?
                        Colors.white :
                        Colors.redAccent,
                      ) :
                      SizedBox(height: 0),
                    ],
                  ),
                );
              }
          );
        }
    );
  }
}