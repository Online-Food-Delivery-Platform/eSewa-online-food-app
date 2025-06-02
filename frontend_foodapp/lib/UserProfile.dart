import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend_foodapp/Dashboard.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Userprofile extends StatefulWidget {
  const Userprofile({super.key});

  @override
  State<Userprofile> createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  User? user;
  File? _image;
  bool isEditing = false;

  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    nameController.text = user?.displayName ?? '';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });

      final uid = user!.uid;
      final storageRef = FirebaseStorage.instance.ref().child(
        'profile_images/$uid.jpg',
      );

      try {
        await storageRef.putFile(_image!);
        final downloadURL = await storageRef.getDownloadURL();

        await user!.updatePhotoURL(downloadURL);
        await user!.reload();
        user = FirebaseAuth.instance.currentUser;

        setState(() {});
      } catch (e) {
        print("Image upload failed: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPhoneUser =
        user?.providerData.any((p) => p.providerId == 'phone') ?? false;
    final isGoogleUser =
        user?.providerData.any((p) => p.providerId == 'google.com') ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.yellow[700],
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const DashboardScreen(initialIndex: 0),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.black),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/', (route) => false);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    _image != null
                        ? FileImage(_image!)
                        : (user?.photoURL != null
                                ? NetworkImage(user!.photoURL!)
                                : null)
                            as ImageProvider<Object>?,
                child:
                    (_image == null && user?.photoURL == null)
                        ? const Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.white,
                        )
                        : null,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    editableField(
                      "Name",
                      nameController,
                      isEditable: isEditing,
                    ),
                    readOnlyField(
                      "Phone Number",
                      user?.phoneNumber ?? "",
                      isReadOnly: isPhoneUser,
                    ),
                    readOnlyField(
                      "Email",
                      user?.email ?? "",
                      isReadOnly: isGoogleUser,
                    ),
                    editableField(
                      "Gender",
                      genderController,
                      isEditable: isEditing,
                    ),
                    editableField(
                      "Date of Birth",
                      dobController,
                      isEditable: isEditing,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.yellow[700],
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  if (isEditing) {
                    try {
                      await user!.updateDisplayName(nameController.text);
                      await user!.reload();
                      user = FirebaseAuth.instance.currentUser;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile updated successfully'),
                        ),
                      );
                    } catch (e) {
                      print("Error updating profile: $e");
                    }
                  }

                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                child: Text(
                  isEditing ? "SAVE" : "EDIT PROFILE",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget editableField(
    String label,
    TextEditingController controller, {
    bool isEditable = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          TextField(
            controller: controller,
            readOnly: !isEditable,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 4),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget readOnlyField(String label, String value, {bool isReadOnly = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          Container(
            width: double.infinity,
            height: 30,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12)),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(value, style: const TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
