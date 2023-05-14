// /*
// import 'package:flutter/material.dart';
// import 'package:store/providers/counter.dart';
// import 'package:store/utils/app_routes.dart';
//
// import '../models/product.dart';
//
// //chamado em product_item.dart
// class CounterPage extends StatefulWidget {
//   const CounterPage({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<CounterPage> createState() => _CounterPageState();
// }
//
// class _CounterPageState extends State<CounterPage> {
//   @override
//   Widget build(BuildContext context) {
//     //recebimento de argumento por pushNamed para um Widget que não recebe via construtor
//     final Product product =
//         ModalRoute.of(context)?.settings.arguments as Product;
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(product.title),
//       ),
//       body: Column(
//         children: [
//           Text(CounterProvider.of(context)?.chicolopes.value.toString() ?? '0'),
//           IconButton(
//               onPressed: () {
//                 setState(() {
//                   CounterProvider.of(context)?.chicolopes.inc();
//                 });
//                 print(CounterProvider.of(context)?.chicolopes.value);
//               },
//               icon: Icon(Icons.add)),
//           IconButton(
//               onPressed: () {
//                 setState(() {
//                   CounterProvider.of(context)?.chicolopes.dec();
//                 });
//
//                 print(CounterProvider.of(context)?.chicolopes.value);
//               },
//               icon: Icon(Icons.remove))
//         ],
//       ),
//     );
//   }
// }*/

