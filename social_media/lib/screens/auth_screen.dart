import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/service/auth_service.dart';

import '../widgets/snack_bar.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  File? _image;

  final ImagePicker _picker = ImagePicker();
  bool _isSignUp = true;  // Toggle between sign-up and login

  Future<void> _pickImage() async {
    final ImageSource? selectedSource = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.camera_alt, color: Colors.blue),
                    title: Text('Take a Photo'),
                    onTap: () {
                      Navigator.of(context).pop(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library, color: Colors.green),
                    title: Text('Choose from Gallery'),
                    onTap: () {
                      Navigator.of(context).pop(ImageSource.gallery);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.close, color: Colors.red),
                    title: Text('Cancel'),
                    onTap: () {
                      Navigator.of(context).pop(null);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (selectedSource != null) {
      final pickedFile = await _picker.pickImage(source: selectedSource);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    }
  }

  void _toggleForm() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSignUp ? 'Sign Up' : 'Log In'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isSignUp) _buildImagePicker(),
                SizedBox(height: 16.0),
                _buildUsernameField(),
                SizedBox(height: 16.0),
                _buildPasswordField(),
                if (_isSignUp) ...[
                  SizedBox(height: 32.0),
                  _buildConfirmPasswordField(),
                ],
                SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildCancelButton(),
                    SizedBox(width: 8.0),
                    _buildSignUpButton(),
                  ],
                ),
                SizedBox(height: 16.0),
                _buildToggleFormLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Center(
      child: Column(
        children: [
          _image != null
              ? CircleAvatar(
            radius: 50,
            backgroundImage: FileImage(_image!),
          )
              : CircleAvatar(
            radius: 50,
            child: Icon(Icons.camera_alt),
          ),
          SizedBox(height: 8.0),
          TextButton(
            onPressed: _pickImage,
            child: Text('Pick Image'),
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      decoration: InputDecoration(
        labelText: 'Username',
      ),
      style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a username';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
      ),
      style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
      ),
      style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        return null;
      },
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          final username = _usernameController.text;
          final password = _passwordController.text;
          final confirmPassword = _confirmPasswordController.text;

          if (_isSignUp && password != confirmPassword) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: GradientSnackBar(
                  message: 'Passwords do not match!',
                  gradientColors: [Colors.red, Colors.deepOrange],
                ),
                backgroundColor: Colors.transparent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            );
            return;
          }

          if (_image != null || !_isSignUp) {
            print('Username: $username');
            print('Password: $password');
            if (_image != null) {
              print('Image path: ${_image!.path}');
            }
            
            _authService.signup(image: _image, username: _usernameController.text, password: _passwordController.text);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: GradientSnackBar(
                  message: _isSignUp ? 'Sign-up successful!' : 'Login successful!',
                  gradientColors: [_isSignUp ? Colors.green : Colors.blue, Colors.lightGreen],
                ),
                backgroundColor: Colors.transparent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: GradientSnackBar(
                  message: 'No image selected.',
                  gradientColors: [Colors.orange, Colors.amber],
                ),
                backgroundColor: Colors.transparent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            );
          }
        }
      },
      child: Text(_isSignUp ? 'Sign Up' : 'Log In'),
    );
  }

  Widget _buildCancelButton() {
    return TextButton(
      onPressed: () {
        _usernameController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        setState(() {
          _image = null;
        });
      },
      child: Text('Cancel'),
    );
  }

  Widget _buildToggleFormLink() {
    return Center(
      child: TextButton(
        onPressed: _toggleForm,
        child: Text(
          _isSignUp ? 'Already have an account? Log In' : 'Don\'t have an account? Sign Up',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
