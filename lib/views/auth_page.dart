import 'dart:math';

import 'package:flutter/material.dart';
import 'package:store/widgets/auth_form.dart';

//Página de autentificação
class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //background
          Container(
            //estilização do container
            decoration: BoxDecoration(color: Colors.black87)
          ),
          Container(
            width: double.infinity,
            child: Column(
              //alinhamento da Column no centro do container
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //fundo do formulário
                Container(

                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10)),
                  width: MediaQuery.of(context).size.width / 1.2,
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.width / 50,
                      horizontal: MediaQuery.of(context).size.width / 20),
                  //Esse método permite um deslocamento em graus do container
                  //Angulação
                  //Uso de cascata/cascade -> ".."
                  //translate -> recebe um double
                  //transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
/*                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black12,
                      //Sombra da caixa
                      */ /*boxShadow: const [ BoxShadow(
                        //spread da sombra
                          blurRadius: 10,
                          color: Colors.black54,
                          //posição da sombra
                          offset: Offset(-10,-10),
                      )
                      ]*/ /*),*/
                  child: AuthForm(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
