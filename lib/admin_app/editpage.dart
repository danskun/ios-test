// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skripsi/data/service/api_service.dart';

class EditPage extends StatefulWidget {
  final String gambar1 = 'assets/JAKEATS.png';
  String cd_shop;
  String name;
  String time_open;
  String time_closed;
  String location;
  Uint8List? image;
  EditPage(
      {super.key,
      required this.cd_shop,
      required this.name,
      required this.time_open,
      required this.time_closed,
      required this.location,
      required this.image});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final key = GlobalKey<FormState>();
  File? image;
  Uint8List? webImage;
  final picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController timeOpenController = TextEditingController();
  final TextEditingController timeClosedController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.name;
    timeOpenController.text = widget.time_open;
    timeClosedController.text = widget.time_closed;
    locationController.text = widget.location;
    webImage = widget.image;
    super.initState();
  }

  TimeOfDay _stringToTimeOfDay(String time) {
    final format = time.split(":");
    final hour = int.parse(format[0]);
    final minute = int.parse(format[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> selectTimeOpen(BuildContext context) async {
    TimeOfDay initialTime = _stringToTimeOfDay(widget.time_open);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      setState(() {
        timeOpenController.text = picked.format(context);
      });
    }
  }

  Future<void> selectTimeClosed(BuildContext context) async {
    TimeOfDay initialTime = _stringToTimeOfDay(widget.time_closed);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      setState(() {
        timeClosedController.text = picked.format(context);
      });
    }
  }

  @override
  void dispose() {
    timeOpenController.dispose();
    timeClosedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
        backgroundColor: Colors.white,
        title: SizedBox(
          child: Image.asset(
            widget.gambar1,
            height: 100,
            width: 100,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: InkWell(
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.transparent,
                    child: _buildAvatar(),
                  ),
                ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: timeOpenController,
                readOnly: true,
                onTap: () => selectTimeOpen(context),
                decoration: InputDecoration(
                  hintText: 'Jam Buka',
                  suffixIcon: Icon(Icons.access_time),
                ),
              ),
              TextField(
                controller: timeClosedController,
                readOnly: true,
                onTap: () => selectTimeClosed(context),
                decoration: InputDecoration(
                  hintText: 'Jam Buka',
                  suffixIcon: Icon(Icons.access_time),
                ),
              ),
              TextField(
                controller: locationController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Lokasi'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (key.currentState!.validate()) {
                    APIService().updateShop(
                        context,
                        widget.cd_shop,
                        nameController.text,
                        timeOpenController.text,
                        timeClosedController.text,
                        locationController.text,
                        image);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (image != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(image!),
      );
    } else if (webImage != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: MemoryImage(webImage!),
      );
    } else {
      return CircleAvatar(
        radius: 50,
        child: Icon(Icons.person),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
        webImage = null;
      });
    }
  }
}
