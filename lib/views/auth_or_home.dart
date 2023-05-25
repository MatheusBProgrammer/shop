import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/views/auth_page.dart';
import 'package:store/views/products_overview_page.dart';

import '../models/Auth.dart';

class AuthOrHome extends StatelessWidget {
  const AuthOrHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    //return auth.isAuth? const ProductsOverviewPage() : const AuthPage();
    return FutureBuilder(
        future: auth.tryAutoLogin(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child:CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return Center(
              child: Text('Ocorreu um erro'),
            );
          } else{
            return auth.isAuth ? const ProductsOverviewPage() : const AuthPage();
          }
        });
  }
}
/*{
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return const Center(
            child: Text('Ocorreu um erro!'),
          );
        } else {
          return auth.isAuth ? const ProductsOverviewPage() : const AuthPage();
        }
      }*/