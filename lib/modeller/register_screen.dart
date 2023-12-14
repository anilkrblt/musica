// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:musica/ana_sayfa.dart';
import 'package:musica/database/database_helper.dart';
import 'package:musica/database/user_crud.dart';
import 'package:musica/play_music_sayfasi.dart';
import 'package:musica/profil_sayfasi.dart';

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
      appBar: AppBar(backgroundColor: renk2()),
      body: Container(decoration: genelTema(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              //Expanded(flex: 2 ,child: SizedBox(height: 50,)),

              Expanded( flex: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("Kaydol", style: TextStyle(color: beyaz(), fontWeight:FontWeight.w900, fontSize: 33 ),
                      ),
                      margin: EdgeInsets.only(left: 20, bottom: 50 ),
                    ),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Kullanıcı adı', filled: true,
                          fillColor: Colors.white, border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ), ),


                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25,bottom: 20),
                      child: TextField(

                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Şifre', filled: true,  border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                          fillColor: Colors.white, ),
                        obscureText: true,
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: _register,
                        child: const Text('Kaydol'),

                      ),
                    ),
                    ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
