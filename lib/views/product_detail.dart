import 'package:flutter/material.dart';
import '../models/product.dart';

//chamado em product_grid_item.dart
class ProductDetail extends StatelessWidget {
  const ProductDetail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //recebimento de argumento por pushNamed para um Widget que não recebe via construtor(product_grid_item)
    final Product product =
        ModalRoute.of(context)?.settings.arguments as Product;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                height: 300,
                //para ocupar a largura inteira
                width: double.infinity,
                child: Hero(
                  tag: product.id,
                  child: Stack(children: [
                    Container(
                      width: double.infinity,
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0, 0.8),
                              end: Alignment(0, 0),
                              colors: [
                                Color.fromRGBO(0, 0, 0, 0.9),
                                Color.fromRGBO(0, 0, 0, 0),
                              ],
                            ),
                          ),),
                    )
                  ]),
                ),
              ),
              title: Text(product.name),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Text(
              'R\$ ${product.price}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
              ),
            ),
          ]))
        ],
      ),
    );
  }
}
