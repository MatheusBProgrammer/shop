import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/models/product_list.dart';
import '../models/product.dart';
import '../utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  //Passa um argumento Product para edição
                  Navigator.of(context)
                      .pushNamed(AppRoutes.PRODUCTS_FORM, arguments: product);
                },
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                )),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text('Tem certeza?'),
                            content: Text('Deseja realmente excluir o produto cadastrado?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Text('Não',style: TextStyle(color: Theme.of(context).primaryColor),),
                              ),
                              TextButton(
                                onPressed: () {
                                  //acessando a lista pelo Provider ProductList e removendo o produto pelo id
                                  Provider.of<ProductList>(context,listen: false).removeProduct(product);
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text('Excluir',style: TextStyle(color: Colors.red),),
                              )
                            ],
                          ));
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
          ],
        ),
      ),
    );
  }
}
