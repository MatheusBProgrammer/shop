import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/models/product_list.dart';
import '../models/product.dart';
import '../utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  //O product aqui ja está sendo recebido com um Index de product_view, então trata-se de um produto específico/indivudualizado
  final Product product;

  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
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
                  //Passa um argumento Product para edição em product_form_view.dart
                  Navigator.of(context)
                      .pushNamed(AppRoutes.PRODUCTS_FORM, arguments: product);
                },
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                )),
            IconButton(
                onPressed: () {
                  showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Excluir Produto'),
                      content: Text('Tem certeza?'),
                      actions: [
                        TextButton(
                          child: Text('Não'),
                          //o valor sendo falso, ele nao realiza nenhuma ação
                          onPressed: () => Navigator.of(ctx).pop(false),
                        ),
                        TextButton(
                          child: Text('Sim'),
                          //o valor sendo true, ele ajusta uma função no then
                          onPressed: () => Navigator.of(ctx).pop(true),
                        ),
                      ],
                    ),
                  ).then((value) async {
                    //aqui colocamos um verificador null para setar um valor padrão para false, ou seja, para nao realizar nada, para caso de acontecer
                    //alguma interação indevida na interface
                    if (value ?? false) {
                      try {
                        await Provider.of<ProductList>(
                          context,
                          listen: false,
                        ).removeProduct(product);
                      } catch (error) {
                        msg.showSnackBar(SnackBar(content: Text(error.toString()),));
                      }

                    }
                  });
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
