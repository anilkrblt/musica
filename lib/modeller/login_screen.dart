import 'package:flutter/material.dart';
import 'package:musica/ana_sayfa.dart';
import 'package:musica/database/database_helper.dart';
import 'package:musica/database/user_crud.dart';
import 'package:musica/play_music_sayfasi.dart';
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
      // Kullanıcı girişi başarılı, ana sayfaya yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AnaSayfa(username: username),
        ),
      );
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
      appBar: AppBar(
        title: Text('Giriş Yap'),
        backgroundColor: renk2(),
      ),
      body: Container(
        decoration: genelTema(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Expanded(flex:5,child: Column(children: [],)),
              Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 150,
                  )),
              Expanded(
                flex: 12,
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 30, right: 200),
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
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _usernameController,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Kullanıcı adı',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                              offset: Offset(0, 0),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Şifre',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text('Giriş Yap'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Şifremi Unuttum'),
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
