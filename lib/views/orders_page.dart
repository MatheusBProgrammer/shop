import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/models/order_list.dart';
import 'package:store/widgets/app_drawer.dart';
import 'package:store/widgets/order.dart';

class OrdersViews extends StatelessWidget {
  const OrdersViews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Meus pedidos'),
        centerTitle: true,
      ),
      body:FutureBuilder(
        future:  Provider.of<OrderList>(context,listen: false).loadOrders(),
        builder: (_,snapshot){
          //se estiver esperando o estado da coneção
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }else if(snapshot.error != null){
            return Center(child: Text('Ocorreu um erro'),);
          }
          else{
            return Consumer<OrderList>(
              builder:(ctx,orders,child) => ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: (_, index) {
                  return OrderWidget(order: orders.items[index]);
                },
              ),
            );
          }
        },
      ),

      drawer: AppDrawer(),
    );
  }
}
