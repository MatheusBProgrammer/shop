import 'package:store/models/Auth.dart';

class AuthException implements Exception {
  static const Map<String,String> errors= {
    "EMAIL_EXISTS":"O endereço de e-mail já está sendo usado por outra conta.",
    "OPERATION_NOT_ALLOWED":"O login por senha está desabilitado",
    "TOO_MANY_ATTEMPTS_TRY_LATER":"bloqueamos todas as solicitações deste dispositivo devido a atividades incomuns. Tente mais tarde.",
    "EMAIL_NOT_FOUND":"Usuário não encontrado.",
    "INVALID_PASSWORD":"A senha é inválida ou o usuário não possui senha.",
    "USER_DISABLED":"A conta de usuário foi desabilitada por um administrador.",
  };

  final String msg;



  AuthException({required this.msg});


  //mensagem que será exibida quando o erro for chamado
  @override
  String toString() {
    // TODO: implement toString
    return errors[msg]?? 'Ocorreu um erro';
  }
}