import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/utils/app_routes.dart';

import '../models/Auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.black,
            title: Text('Bem vindo!'),
            //retira o menu da pagina de drawer
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Loja'),
            onTap: () {
              //O pushReplacementNamed não empilha telas, ao invés disso, ele muda para uma nova, impedindo um retorno,
              //se faz necessária assim a estratégia de colocar um drawer para ir para uma tela subsequente, caso queira
              Navigator.of(context).pushReplacementNamed(AppRoutes.AUTHORHOMEPAGE);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Pedidos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.ORDERS);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Gerenciar Produtos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.PRODUCTS);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sair'),
            onTap: () {

              Provider.of<Auth>(context,listen: false).logout();
              Navigator.of(context).pushReplacementNamed(AppRoutes.AUTHORHOMEPAGE);
            },
          ),
        ],
      ),
    );
  }
}
