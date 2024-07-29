import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skripsi/data/service/api_service.dart';

class AddRekomendasiView extends StatefulWidget {
  @override
  _AddRekomendasiViewState createState() => _AddRekomendasiViewState();
}

class _AddRekomendasiViewState extends State<AddRekomendasiView> {
  final key = GlobalKey<FormState>();
  File? image;
  Uint8List? webImage;
  final picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController timeOpenController = TextEditingController();
  final TextEditingController timeClosedController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  Future<void> selectTimeOpen(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        timeOpenController.text = picked.format(context);
      });
    }
  }

  Future<void> selectTimeClosed(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
      appBar: AppBar(
        title: Text("REKOMENDASI"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: key,
          child: Column(
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    child: _buildAvatar(),
                  ),
                ),
              ),
              TextField(
                controller: nameController,
                autocorrect: true,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Nama Tempat",
                ),
              ),
              SizedBox(
                height: 20,
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
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: timeClosedController,
                readOnly: true,
                onTap: () => selectTimeClosed(context),
                decoration: InputDecoration(
                  hintText: 'Jam Tutup',
                  suffixIcon: Icon(Icons.access_time),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: locationController,
                textInputAction: TextInputAction.done,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Lokasi",
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  if (key.currentState!.validate()) {
                    APIService().createShop(
                        context,
                        nameController.text,
                        timeOpenController.text,
                        timeClosedController.text,
                        locationController.text,
                        image);
                  }
                },
                child: Text("Tambah tempat"),
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
