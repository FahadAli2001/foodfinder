import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:foodfinder/const/images.dart';
import 'package:foodfinder/controller/upload_image_controller/upload_image_controller.dart';
import 'package:foodfinder/model/user_model.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  final UserModel? user;
  const UploadImageScreen({super.key,this.user});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  UploadImageController uploadImageController = UploadImageController();

  Future getImage(ImageSource imageSource,UserModel? user) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);

    setState(() {
      if (pickedFile != null) {
        uploadImageController.image = File(pickedFile.path);
        uploadImageController.sendImageToAPI(context,user);
      } else {
        log('No image selected.');
      }
    });
    log(uploadImageController.image.toString());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: Colors.black,
        elevation: 0,
        title: Image.asset(
          logo,
          width: size.width * 0.5,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            uploadImageController.image == null
                ? Center(child: Image.asset(uploadImage))
                : Center(child: Image.file(uploadImageController.image!)),
            SizedBox(
              height: size.height * 0.1,
            ),
            uploadImageController.isSearching == true
                ? CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            getImage(ImageSource.camera,widget.user);
                          },
                          child: Image.asset(captureImageBtn,
                          width: size.width *0.4),)
                          ,
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      GestureDetector(
                          onTap: () {
                            getImage(ImageSource.gallery,widget.user);
                          },
                          child: Image.asset(browseFileBtn,
                          width: size.width *0.4))
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
