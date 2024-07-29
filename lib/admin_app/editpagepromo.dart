import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skripsi/data/service/api_service.dart';

class EditPagePromo extends StatefulWidget {
  final String gambar1 = 'assets/JAKEATS.png';
  String cd_promo;
  String description;
  String date_open;
  String date_closed;
  int min_trans;
  String terms;
  Uint8List? image;
  EditPagePromo(
      {super.key,
      required this.cd_promo,
      required this.description,
      required this.date_open,
      required this.date_closed,
      required this.min_trans,
      required this.terms,
      required this.image});
  @override
  _EditPagePromoState createState() => _EditPagePromoState();
}

class _EditPagePromoState extends State<EditPagePromo> {
  final key = GlobalKey<FormState>();
  File? image;
  Uint8List? webImage;
  final picker = ImagePicker();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateOpenController = TextEditingController();
  final TextEditingController dateClosedController = TextEditingController();
  final TextEditingController minTransController = TextEditingController();
  final TextEditingController termsController = TextEditingController();

  @override
  void initState() {
    descriptionController.text = widget.description;
    dateOpenController.text = widget.date_open;
    dateClosedController.text = widget.date_closed;
    minTransController.text = widget.min_trans.toString();
    termsController.text = widget.terms;
    webImage = widget.image;
    super.initState();
  }

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
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    child: _buildAvatar(),
                  ),
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3
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
              TextField(
                controller: minTransController,
                decoration: InputDecoration(labelText: 'Transaksi Minimum'),
              ),
              TextField(
                controller: termsController,
                decoration: InputDecoration(labelText: 'Syarat dan Ketentuan'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (key.currentState!.validate()) {
                    APIService().updatePromo(
                        context,
                        widget.cd_promo,
                        descriptionController.text,
                        dateOpenController.text,
                        dateClosedController.text,
                        minTransController.text,
                        termsController.text,
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
