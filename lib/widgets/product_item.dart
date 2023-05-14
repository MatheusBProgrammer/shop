import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/models/product.dart';
import 'package:store/utils/app_routes.dart';
import '../models/cart.dart';

//chamado em views/products_overview_page.dart
class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //O product recebido é especifico do índice, pois o método
    //value passa para os filhos aquele objeto, no caso, está passando loadedProducts[index]
    final product = Provider.of<Product>(
      context,
      //está 'escutando' e a modificação será escutada e o valor será alterado no value que nos envia esse "parâmetro";
      //é um padrão opcional, o valão padrão é true
      listen: true,
    );
    //recebimento do provider Cart
    final cart = Provider.of<Cart>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            product.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          //define algo à direita do title
          trailing: IconButton(
              onPressed: () {
                cart.addItem(product);
                print(cart.itemsTypeCount);
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).accentColor,
              )),
          //leading: define algo à esquerda do title
          //<Product> é o definido aqui por ser o ponto de impacto na interface gráfica
          leading: Consumer<Product>(
            builder: (ctx, productconsumer, _) => IconButton(
              onPressed: () {
                //o estado do será modificado pois o estado Pai altera o estado filho de um StatelessWidget, gerando impacto na interface.
                productconsumer.toggleFavorite();
              },
              icon: Icon(product.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border_outlined),
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            //pushNamed passa um argumento para uma página que não recebe parâmetros via construtor
            Navigator.of(context)
                .pushNamed(AppRoutes.PRODUCT_DETAIL, arguments: product);
          },
          child: Image.network(
            product.imageUrl,
            //extensão da imagem
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
