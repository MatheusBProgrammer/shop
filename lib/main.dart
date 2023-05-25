import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/models/cart.dart';
import 'package:store/models/order_list.dart';
import 'package:store/utils/app_routes.dart';
import 'package:store/views/auth_or_home.dart';
import 'package:store/views/auth_page.dart';
import 'package:store/views/cart_view.dart';
import 'package:store/views/orders_page.dart';
import 'package:store/views/product_detail.dart';
import 'package:store/views/product_form_view.dart';
import 'package:store/views/product_view.dart';
import 'package:store/views/products_overview_page.dart';
import 'models/Auth.dart';
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
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        //provider que passará informações para a ramificação de widget's a partis deste ponto
        ChangeNotifierProxyProvider<Auth, ProductList>(
          //retorno do ChangeNotifier Productlist em models/product_list.dart
          //está passando para todos os filhos uma lista de produtos
          //está dependendo diretamente do Auth para poder carregar os produtos, devido a autenticação necessária pelo FireBase
          create: (_) => ProductList(token: '',''),
          update: (_, auth, previous) {
            return ProductList(token: auth.token?? '',auth.uid?? '');
          },
        ),
        ChangeNotifierProxyProvider<Auth,OrderList>(
          //criando a instância do orderlist
          create: (_) => OrderList(token: '',uid: ''),
          update: (_,auth,previous)=> OrderList(token: auth.token,uid: auth.uid?? ''),
        ),
        ChangeNotifierProvider(
          //parametro de gerenciamento de estado Cart passado para todas as ramificações na àrvore de widgets
          create: (_) => Cart(),
        ),

      ],
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.black54,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: Colors.deepOrange)),
        debugShowCheckedModeBanner: false,
        //home: ProductsOverviewPage(),
        routes: {
          AppRoutes.AUTHORHOMEPAGE: (_) => AuthOrHome(),
          AppRoutes.PRODUCT_DETAIL: (_) => ProductDetail(),
          AppRoutes.CART_VIEW: (_) => CartView(),
          AppRoutes.ORDERS: (_) => OrdersViews(),
          AppRoutes.PRODUCTS: (_) => ProductsView(),
          AppRoutes.PRODUCTS_FORM: (_) => ProductsFormView(),
        },
      ),
    );
  }
}
