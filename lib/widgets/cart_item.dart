import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  //do tipo modelo CartItem
  final CartItem cartItem;

  const CartItemWidget({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
      ),
      //quando o dismissed for chamado:
      onDismissed: (_) => Provider.of<Cart>(context, listen: false)
          .removeItem(cartItem.productId),
      //confirmação do dismissed
      confirmDismiss: (_) {
        //exibição de uma tela Dialog
        return showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text('Tem Certeza?'),
                  content: Text('Quer remover o item do carrinho?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        'Remover',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('Não',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold)))
                  ],
                ));
      },
      //chame do dismisseble
      key: ValueKey(cartItem.id),
      //direção do dismissible
      direction: DismissDirection.endToStart,
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Padding(
                padding: EdgeInsets.all(4),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Text(
                    '${cartItem.price}',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ),
            title: Text(cartItem.name),
            subtitle: Text('Preço R\$${cartItem.price}'),
            trailing: Text('${cartItem.quantity}'),
          ),
        ),
      ),
    );
  }
}
