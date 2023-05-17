import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/widgets/app_drawer.dart';
import 'package:store/widgets/product_item.dart';
import '../models/product_list.dart';
import '../utils/app_routes.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of<ProductList>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Produtos'),
        centerTitle: true,
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(AppRoutes.PRODUCTS_FORM);
          }, icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(itemCount:products.itemsCount, itemBuilder: (_,index){
          return Column(
            children: [
              ProductItem(product: products.items[index]),
              Divider()
            ],
          );
        },),
      ),
    );
  }
}
