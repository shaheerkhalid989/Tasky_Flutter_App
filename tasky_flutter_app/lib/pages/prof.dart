import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasky_flutter_app/Service/Auth_service.dart';
import 'package:tasky_flutter_app/pages/signin.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  AuthClass authClass = AuthClass();

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff1d1e26),
              Color(0xff252041),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 25,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              backgroundColor: Colors.white
                                  .withOpacity(0.9), // Set the opacity
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Set the corner radius
                              ),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text('Confirm Logout',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 20),
                                    Text(
                                        'Are you sure you want to logout your account?'),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        TextButton(
                                          child: Text('No'),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Dismiss the dialog
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Yes'),
                                          onPressed: () async {
                                            await authClass.logout();
                                            Navigator.pop(context);
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (builder) =>
                                                        SignInPage()),
                                                (route) => false);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.logout, color: Colors.white, size: 28),
                    ),
                  ], 
                ),
              ),
              SizedBox(
                height: 80,
              ),
              CircleAvatar(
                radius:
                    120, // Increase this value to make the CircleAvatar larger
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: _imageFile != null
                      ? Image(
                          image: FileImage(_imageFile!, scale: 1),
                          fit: BoxFit
                              .contain, // Use this to control how the image fits
                          width: 500.0,
                          height: 500.0,
                        )
                      : null,
                ),
                key: ValueKey(_imageFile?.path),
              ),
              TextButton(
                child: Text(_imageFile != null ? 'Update Image' : 'Pick Image'),
                onPressed: () async {
                  final XFile? imageFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (imageFile != null) {
                    final String imagePath = await saveImageToDisk(imageFile);
                    await updateImagePathInDatabase(imagePath, userId);
                    final File nonNullImageFile = File(imagePath);
                    setState(() {
                      _imageFile = nonNullImageFile;
                    });
                  }
                },
              ),
              if (_imageFile != null)
                TextButton(
                  child: Text('Delete Image'),
                  onPressed: () async {
                    await deleteImageFromDatabase(userId);
                    await deleteImageFromFileSystem();
                    setState(() {
                      _imageFile = null;
                    });
                  },
                ),
              SizedBox(
                height: 20,
              ),
              if (FirebaseAuth.instance.currentUser!.displayName != null)
                Text(
                  FirebaseAuth.instance.currentUser!.displayName!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (FirebaseAuth.instance.currentUser!.displayName != null)
                SizedBox(height: 20),
              if (FirebaseAuth.instance.currentUser!.email != null)
                Text(
                  FirebaseAuth.instance.currentUser!.email!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              if (FirebaseAuth.instance.currentUser!.email != null)
                SizedBox(height: 20),
              if (FirebaseAuth.instance.currentUser!.phoneNumber != null)
                Text(
                  FirebaseAuth.instance.currentUser!.phoneNumber!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> saveImageToDisk(XFile imageFile) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final String imagePath = '$path/image.png';
    final File newImageFile = File(imagePath);

    if (await newImageFile.exists()) {
      await newImageFile.delete();
    }

    await File(imageFile.path).copy(imagePath);
    return imagePath;
  }

  Future<void> updateImagePathInDatabase(
      String imagePath, String userId) async {
    final Database db = await openDatabase('app.db', version: 1);
    int updatedRows = await db.update(
        'images', {'path': imagePath, 'userId': userId},
        where: 'id = ? AND userId = ?', whereArgs: [1, userId]);
    if (updatedRows == 0) {
      await db.insert('images', {'id': 1, 'path': imagePath, 'userId': userId});
    }
  }

  Future<void> deleteImageFromDatabase(String userId) async {
    final Database db = await openDatabase('app.db', version: 1);
    await db.delete('images',
        where: 'id = ? AND userId = ?', whereArgs: [1, userId]);
  }

  Future<void> deleteImageFromFileSystem() async {
    if (_imageFile != null) {
      await _imageFile!.delete();
    }
  }

  Future<void> loadImageFromDatabase(String userId) async {
    final Database db = await openDatabase('app.db', version: 1);
    final List<Map<String, dynamic>> maps =
        await db.query('images', where: 'userId = ?', whereArgs: [userId]);
    if (maps.isNotEmpty) {
      final File imageFile = File(maps.first['path']);
      final bool fileExists = await imageFile.exists();
      if (fileExists) {
        setState(() {
          _imageFile = imageFile;
        });
      }
    }
  }

  Future<void> initDatabase() async {
    final Database db = await openDatabase('app.db', version: 2,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE images (id INTEGER PRIMARY KEY, path TEXT, userId TEXT)');
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      if (oldVersion < 2) {
        await db.execute('ALTER TABLE images ADD COLUMN userId TEXT');
      }
    });
    loadImageFromDatabase(userId);
  }
}
