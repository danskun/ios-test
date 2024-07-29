import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skripsi/data/service/api_service.dart';

class PromoInput extends StatefulWidget {
  @override
  _PromoInputState createState() => _PromoInputState();
}

class _PromoInputState extends State<PromoInput> {
  final key = GlobalKey<FormState>();
  File? image;
  Uint8List? webImage;
  final picker = ImagePicker();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateOpenController = TextEditingController();
  final TextEditingController dateClosedController = TextEditingController();
  final TextEditingController minTransController = TextEditingController();
  final TextEditingController termsController = TextEditingController();

  Future<void> selectDateOpen(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2101);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        dateOpenController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> selectDateClosed(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2101);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        dateClosedController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PROMOSI INPUT"),
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
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.transparent,
                    child: _buildAvatar(),
                  ),
                ),
              ),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                autocorrect: true,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Deskripsi",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: dateOpenController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Periode Mulai',
                  hintText: 'Select a date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => selectDateOpen(context),
                  ),
                ),
                readOnly: true,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: dateClosedController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Periode Selesai',
                  hintText: 'Select a date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => selectDateClosed(context),
                  ),
                ),
                readOnly: true,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: minTransController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "Minimal Transaksi",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: termsController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "Syarat Dan Ketentuan",
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  if (key.currentState!.validate()) {
                    APIService().createPromo(
                        context,
                        descriptionController.text,
                        dateOpenController.text,
                        dateClosedController.text,
                        minTransController.text,
                        termsController.text,
                        image);
                  }
                },
                child: Text("Tambah Promosi"),
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
