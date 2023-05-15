import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/models/order_list.dart';
import 'package:store/widgets/app_drawer.dart';
import 'package:store/widgets/order.dart';

class OrdersViews extends StatelessWidget {
  const OrdersViews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of<OrderList>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Meus pedidos'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: orders.itemsCount,
        itemBuilder: (_, index) {
          return OrderWidget(order: orders.items[index]);
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
