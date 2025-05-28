import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'loginscreen.dart'; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  File? _image;
  Uint8List? webImageBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Create Account",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: showSelectionDialog,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: _image == null
                            ? const AssetImage("assets/images/camera.png")
                            : _buildProfileImage(),
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(nameController, "Full Name", Icons.person),
                    _buildTextField(emailController, "Email", Icons.email, inputType: TextInputType.emailAddress),
                    _buildTextField(passwordController, "Password", Icons.lock, isObscure: true),
                    _buildTextField(confirmPasswordController, "Confirm Password", Icons.lock_outline, isObscure: true),
                    _buildTextField(phoneController, "Phone Number", Icons.phone, inputType: TextInputType.phone),
                    _buildTextField(addressController, "Address", Icons.location_on, maxLines: 3),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: registerUserDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Register", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()));
                      },
                      child: const Text("Already have an account? Login"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {bool isObscure = false, TextInputType inputType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }

  void registerUserDialog() {
    if ([nameController, emailController, passwordController, confirmPasswordController, phoneController, addressController]
        .any((c) => c.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Register Account"),
            content: const Text("Are you sure you want to register?"),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  registerUser();
                },
                child: const Text("Confirm"),
              ),
            ],
          );
        });
  }

  void registerUser() {
    http.post(
      Uri.parse("http://10.133.132.76/wtms/register_worker.php"),
      body: {
        "full_name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "phone": phoneController.text,
        "address": addressController.text,
      },
    ).then((response) {
      var jsondata = json.decode(response.body);
      if (jsondata['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registration successful")));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to register")));
      }
    });
  }

  void showSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Profile Image"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(onPressed: _selectFromCamera, child: const Text("Camera")),
            TextButton(onPressed: _selectfromGallery, child: const Text("Gallery")),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: kIsWeb ? ImageSource.gallery : ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      if (kIsWeb) {
        webImageBytes = await pickedFile.readAsBytes();
      }
      setState(() {});
    }
  }

  Future<void> _selectfromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {});
    }
  }

  ImageProvider _buildProfileImage() {
    if (_image != null) {
      return kIsWeb ? MemoryImage(webImageBytes!) : FileImage(File(_image!.path)) as ImageProvider;
    }
    return const AssetImage("assets/images/camera.png");
  }
}
