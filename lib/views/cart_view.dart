import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/models/order_list.dart';
import 'package:store/widgets/cart_item.dart';

import '../models/cart.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    //itens do Map carrinho e convertendo para uma lista
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Card(
            elevation: 0.5,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Builder(builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Total',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Chip(
                      label: Text(
                        'R\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    const Spacer(),
                    _cartButton(cart: cart)
                  ],
                ),
              );
            }),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.itemsTypeCount,
                  itemBuilder: (_, index) {
                    return CartItemWidget(cartItem: items[index]);
                  }))
        ],
      ),
    );
  }
}

class _cartButton extends StatefulWidget {
  const _cartButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<_cartButton> createState() => _cartButtonState();
}

class _cartButtonState extends State<_cartButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : TextButton(
            onPressed: widget.cart.itemsCount == 0
                //verificação para que não mande pedidos vazios para o banco de dados
                ? () {}
                : () async {
                    setState(() => _isLoading = true);
                    //await para que o carrinho apenas seja limpo quando limpar o pedido
                    await Provider.of<OrderList>(context, listen: false)
                        .addOrder(widget.cart);
                    setState(() => _isLoading = false);

                    widget.cart.clear();
                  },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.secondary),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Text(
              'Comprar',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }
}
