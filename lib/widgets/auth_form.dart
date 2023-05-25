import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/exceptions/auth_exception.dart';

import '../models/Auth.dart';

enum AuthMode {
  //Modo de registro
  Singup,
  //Modo de login
  Login,
}

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  Map<String, String> _authData = {'email': '', 'password': ''};

  bool _isLoading = false;

  final formKey = GlobalKey<FormState>();

  //controller do password para fins de validação
  final _passwordController = TextEditingController();

  //o modo da tela, por padrão, está como login
  AuthMode _authMode = AuthMode.Login;

  //Boleanos para verificações
  bool _isLogin() => _authMode == AuthMode.Login;

  bool _isSingUp() => _authMode == AuthMode.Singup;

  void _switchAuthMode() {
    if (_isLogin()) {
      setState(() {
        _authMode = AuthMode.Singup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  //Dialog Screen de exibição de erro
  void _showErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Ocorreu um erro'),
              content: Text(msg),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Voltar'),
                )
              ],
            ));
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    //Fundamental para o funcionamento do validade
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid /*isValid == false*/) {
      setState(() => _isLoading = false);
      return;
    }
    //caso passe pela validação, passaremos para o proximo passo

    //chamada do meto onSave dos TextFormField's
    formKey.currentState!.save();
    //chamando o provider de autenticação
    Auth auth = Provider.of<Auth>(context, listen: false);

    //caso estejamos na tela de login, ele cumprirá os protocolos de login
    try{
      if (_isLogin()) {
        print('login');
        //login
        await auth.signIn(
          _authData['email']!,
          _authData['password']!,
        );
        setState(() => _isLoading = false);
      }
      //caso estejamos na tela de cadastro, ele cumprirá os protocolos de cadastro
      else {
        //registrar
        await auth.signUp(
          _authData['email']!,
          _authData['password']!,
        );
        setState(() => _isLoading = false);
      }
    } on AuthException catch(error){
      _showErrorDialog(error.toString());
      setState(() => _isLoading = false);

    } catch(error){
      _showErrorDialog('Ocorreu um erro inesperado');
      setState(() => _isLoading = false);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            onSaved: (email) => _authData['email'] = email ?? '',
            validator: (_email) {
              final email = _email ?? '';
              if (email.trim().isEmpty || !email.contains('@')) {
                return 'Informe um e-mail válido.';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Senha',
              labelStyle: TextStyle(color: Colors.black54),
              hintStyle: TextStyle(color: Colors.white),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            onSaved: (password) => _authData['password'] = password ?? '',
          ),
          if (_isSingUp())
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar senha',
                labelStyle: TextStyle(color: Colors.black54),
                hintStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              //verifica se o AuthMode está setado para login
              validator: _isLogin()
                  ? null
                  : (_password) {
                      final password = _password ?? '';
                      if (password != _passwordController.text ||
                          password.length < 6) {
                        //caso as senhas sejam diferentes, ele da um retorno textual
                        return 'Senhas informadas não conferem.';
                      } else {
                        //confirma que deu tudo certo na validação
                        return null;
                      }
                    },
            ),
          SizedBox(height: 50),
          if (_isLoading)
            CircularProgressIndicator()
          else
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                backgroundColor: Colors.black54, // Defina a cor desejada aqui
              ),
              onPressed: _submit,
              child: Text(_authMode == AuthMode.Login ? 'Entrar' : 'Registrar'),
            ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 25,
          ),
          TextButton(
              onPressed: _switchAuthMode,
              child: Text(
                _isLogin() ? 'Deseja se Registrar?' : 'Já possui conta?',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold,
                ),
              ))
        ],
      ),
    );
  }
}
