import 'package:flutter/material.dart';
import 'package:musica/database/database_helper.dart';
import 'package:musica/database/user_crud.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userCrud = UserCRUD(DatabaseHelper.instance); // DatabaseHelper örneği


  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final isValidUser = await _userCrud.verifyUser(username, password);

    if (!mounted) return; // Widget ağaçtan kaldırıldıysa, işlemi durdur.

    if (isValidUser) {
      // Kullanıcı girişi başarılı, ana sayfaya yönlendir
      Navigator.pushReplacementNamed(context, '/AnaSayfa');
    } else {
      final isUserExists = await _userCrud.isUserExists(username);

      if (!mounted) return; // İkinci bir kontrol daha

      final errorMessage =
          isUserExists ? 'Şifre geçersiz' : 'Kullanıcı adı bulunamadı';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giriş Yap')),
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
              onPressed: _login,
              child: const Text('Giriş Yap'),
            ),
            ElevatedButton(
                onPressed: () {

                  Navigator.popAndPushNamed(context, '/RegisterScreen');
                },
                child: const Text('Kaydol')),
          ],
        ),
      ),
    );
  }
}

