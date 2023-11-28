// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:musica/database/database_helper.dart';
import 'package:musica/database/user_crud.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserCRUD userCRUD = UserCRUD(DatabaseHelper.instance);

  void _register() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final firstName = _usernameController.text.trim();
    final lastName = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      // Kullanıcı adı veya şifre boş olamaz
      _showSnackBar('Kullanıcı adı ve şifre boş bırakılamaz');
      return;
    }

    // Kullanıcı adının zaten var olup olmadığını kontrol edin
    final userExists = await userCRUD.isUserExists(username);
    if (userExists) {
      // Kullanıcı adı zaten varsa, hata mesajını göster
      _showSnackBar('Kullanıcı adı zaten kullanılıyor');
      return;
    }

    // Kullanıcıyı oluştur
    final userId = await userCRUD.createUser(
      username,
      password,
      firstName,
      lastName
    );
    if (userId > 0) {
      // Kullanıcı başarıyla oluşturulduysa, giriş ekranına dön
      Navigator.pushNamed(context, '/');
    } else {
      // Kullanıcı oluşturulamadıysa, hata mesajını göster
      _showSnackBar('Kullanıcı oluşturulamadı');
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}
