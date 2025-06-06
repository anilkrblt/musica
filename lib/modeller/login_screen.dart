// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:musica/ana_sayfa.dart';
import 'package:musica/database/database_helper.dart';
import 'package:musica/database/user_crud.dart';
import 'package:musica/profil_sayfasi.dart';

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
    // Kullanıcı girişi başarılı, kullanıcı ID'sini al
    final userId = await _userCrud.getUserId(username);

    if (userId != null) {
      // Kullanıcı ID'sini CurrentUser sınıfına kaydet
      CurrentUser().login(userId);

      // Ana sayfaya yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AnaSayfa(username: username),
        ),
      );
    } else {
      _showErrorSnackBar('Kullanıcı ID alınamadı.');
    }
  } else {
    _showErrorSnackBar('Kullanıcı adı veya şifre yanlış.');
  }
}

void _showErrorSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //title: const Text('Giriş Yap'),
        backgroundColor: renk3(),
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: beyaz(),
            size: 38,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: genelTema(),
        child: Padding(

          padding: const EdgeInsets.all(16.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Expanded(flex:5,child: Column(children: [],)),
              const Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 150,
                  )),
              Expanded(
                flex: 12,
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(bottom: 30, right: 200),
                        child: Text(
                          "Giriş yap",
                          style: TextStyle(
                              fontSize: 33,
                              fontWeight: FontWeight.w900,
                              color: beyaz()),
                        )),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: renk2(),
                            spreadRadius: 7,
                            blurRadius: 35,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Expanded(
                        flex: 2,
                        child: TextField(
                          
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            hintText: 'Kullanıcı adı',
                            //labelText: 'Kullanıcı adı',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25, bottom: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: renk2(),
                              spreadRadius: 7,
                              blurRadius: 35,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              hintText: 'Şifre',
                              filled: true,
                              
                              alignLabelWithHint: true,
                              floatingLabelStyle: TextStyle(fontSize: 20),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              fillColor: Colors.white,
                            ),
                            obscureText: true,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: _login,
                        child:  Text('Giriş Yap', style: TextStyle(color: renk3()),),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child:Text('Şifremi Unuttum' ,
                            style: TextStyle(color: renk3())),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hesabın yok mu? ",
                          style: TextStyle(color: beyaz(), fontSize: 18),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(
                                context, '/RegisterScreen');
                          },
                          child: Text(
                            'Kaydol',
                            style: TextStyle(color: beyaz(), fontSize: 18),
                          ),
                        ),
                      ],
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