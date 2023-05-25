import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/widgets/app_drawer.dart';
import 'package:store/widgets/product_item.dart';
import '../models/product_list.dart';
import '../utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/widgets/app_drawer.dart';
import 'package:store/widgets/product_item.dart';
import '../models/product_list.dart';
import '../utils/app_routes.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({Key? key}) : super(key: key);

  //função para dar um Refresh de dados na tela, acessando um banco de dados
  //nesse cenário, foi precisao incrimentar um Contexto passando como parâmetrod e função, pois estamos toda do Build
  Future<void> _refreshProducts(BuildContext context) async {
    return Provider.of<ProductList>(
      context,
      listen: false,
    ).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of<ProductList>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Produtos'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.PRODUCTS_FORM);
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      //recarrega a página
      body: RefreshIndicator(
        //passando o contexto como parâmetro
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: products.itemsCount,
            itemBuilder: (_, index) {
              return Column(
                children: [
                  ProductItem(product: products.items[index]),
                  Divider()
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
