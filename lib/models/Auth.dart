import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:store/data/saveData.dart';
import 'package:store/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  //atributos que serão recebidos quando fizermos a requisição de login e serão usados para a autentificaçãdo
  String? _token;
  String? _email;
  String? _uid;
  DateTime? _expiryDate;
  Timer? _logoutTimer;

  bool get isAuth {
    //caso a data de expiração seja depois da data atual, isvalid = false
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    //checagem de autenticação, verificará se chegou um token e se o isValid é true
    return _token != null && isValid;
  }

  String? get token {
    //está autenticado? retorna o token
    return isAuth ? _token : null;
  }

  String? get email {
    //está autenticado? retorna o email
    return isAuth ? _email : null;
  }

  String? get uid {
    //está autenticado? retorna o uid
    return isAuth ? _uid : null;
  }

  DateTime? get expiryDate {
    return isAuth ? _expiryDate : null;
  }

  //a url completa seria: https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY], mas retiramos o ultimo trecho "[API_KEY],Iremos na parte de autenticação do Firebase,
  //em configurações de projeto, e pegar a chave de API da web, para então substituir o [API_KEY]
  //Url de requisição
  static const _url =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCtQDkkh3yB82tMMRmUU3XVAIKuiRO_3ec';

  //https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]
  //https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[API_KEY]

  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyCtQDkkh3yB82tMMRmUU3XVAIKuiRO_3ec';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);

    //caso retorne um erro no body:
    if (body['error'] != null) {
      //uma exeção é "jogada"
      throw AuthException(msg: body['error']['message']);
    }
    //caso tudo tenha dado certo e tenha recebido os dados via http.post
    else {
      _token = body['idToken'];
      _email = body['email'];
      _uid = body['localId'];
      _expiryDate =
          DateTime.now().add(Duration(seconds: int.parse(body['expiresIn'])));

      //Salvando os dados para Login Automático.
      SaveData.saveMap('userData', {
        'token': _token,
        'email': _email,
        'uid': _uid,
        'expiryDate': _expiryDate!.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> tryAutoLogin() async {
    //1° Verificação
  if(isAuth) return;

  final userData = await SaveData.getMap('userData');

  if(userData.isEmpty) return ;

  final expiryDate = DateTime.parse(userData['expiryDate']);

  if(expiryDate.isBefore(DateTime.now())) return;

  _token = userData['token'];
  _email = userData['email'];
  _uid = userData['uid'];
  _expiryDate = expiryDate;

  _autoLogout();
  notifyListeners();
  }



  //SingUp(registro)
  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  //SingIn(login)
  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = null;
    _email = null;
    _uid = null;
    _expiryDate = null;
    clearLogoutTimer();
    SaveData.remove('userData').then((value) => notifyListeners());
    ;
  }

  //re-usar o código para ter certeza de que limpamos o timer
  void clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    clearLogoutTimer();
    //diferença entre a data de expiração e a data atual em Segundos
    final int? timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout ?? 0), logout);
  }
}
