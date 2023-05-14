import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/models/cart.dart';
import 'package:store/utils/app_routes.dart';
import 'package:store/views/cart_view.dart';
import 'package:store/views/product_detail.dart';
import 'package:store/views/products_overview_page.dart';
import 'models/product_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //MultiProvider possibilita o gerenciamento de mais de um provider
    return MultiProvider(
      providers: [
        //provider que passará informações para a ramificação de widget's a partis deste ponto
        ChangeNotifierProvider(
          //retorno do ChangeNotifier Productlist em models/product_list.dart
          //está passando para todos os filhos uma lista de produtos
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          //parametro de gerenciamento de estado Cart passado para todas as ramificações na àrvore de widgets
          create: (_) => Cart(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Color.fromRGBO(0, 0, 128, 1),
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        home: ProductsOverviewPage(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {AppRoutes.PRODUCT_DETAIL: (_) => ProductDetail(),
        AppRoutes.CART_VIEW:(_) => CartView()},
      ),
    );
  }
}
