import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skripsi/admin_app/navigationAdmin.dart';

import 'package:skripsi/data/service/api_service.dart';
import 'package:skripsi/users_app/navigation.dart';

class ProfilePageAdmin extends StatefulWidget {
  final String codeUser;
  final String title;
  ProfilePageAdmin({
    Key? key,
    required this.codeUser,
    required this.title,
  }) : super(key: key);

  final String gambar1 = 'assets/JAKEATS.png';

  @override
  _ProfilePageAdminState createState() => _ProfilePageAdminState();
}

class _ProfilePageAdminState extends State<ProfilePageAdmin> {
  final key = GlobalKey<FormState>();
  File? image;
  Uint8List? webImage;
  final picker = ImagePicker();

  String name = '';
  String email = '';
  String password = '123';
  String phone = '';

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    var userData = await APIService().getUser(widget.codeUser);
    if (userData != null) {
      setState(() {
        name = userData['name'];
        // email = userData['email'];
        // phone = userData['phone'];
        if (userData['image'] != null) {
          webImage = base64Decode(userData['image']);
        }
        loadData();
      });
    }
  }

  void loadData() {
    setState(() {
      _nameController.text = name;
      _emailController.text = email;
      _passwordController.text = password;
      _phoneController.text = phone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      endDrawer: NavAdmin(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Color(0xff4682a9),
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
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(50.0),
        child: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Center(
              //   child: InkWell(
              //     onTap: () {
              //       _pickImage(ImageSource.gallery);
              //     },
              //     child: CircleAvatar(
              //       radius: 50,
              //       backgroundColor: Color(0xff4682a9),
              //       child: _buildAvatar(),
              //     ),
              //   ),
              // ),
              SizedBox(height: 20.0),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              // SizedBox(height: 10.0),
              // TextField(
              //   controller: _emailController,
              //   decoration: InputDecoration(labelText: 'Email'),
              // ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              // TextField(
              //   controller: _phoneController,
              //   decoration: InputDecoration(labelText: 'Phone'),
              // ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  await APIService().updateUser(
                    context,
                    widget.codeUser,
                    _nameController.text,
                    _emailController.text,
                    _passwordController.text,
                    _phoneController.text,
                    image,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff4682a9), // Warna latar belakang tombol
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
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
        child: Icon(
          Icons.person,
          color: Colors.white,
        ),
        backgroundColor: Color(0xff4682a9),
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
