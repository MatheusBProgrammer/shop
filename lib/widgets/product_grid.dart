import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:store/widgets/product_grid_item.dart';

import '../models/product.dart';
import '../models/product_list.dart';

class ProductGrid extends StatelessWidget {
  //parâmetro booleano recebido que definirá quais itens serão exibidos, se serão os favoritos ou todos os items
  final bool showFavoriteOnly;

  const ProductGrid({super.key, required this.showFavoriteOnly});

  @override
  Widget build(BuildContext context) {
    //necessário definir que se trata de um <ProductList>bn
    final provider = Provider.of<ProductList>(context);
    //a exibição aqui dependerá do valor boleano recebido como parâmetro de
    //##########################
    //caso o valor sejá true, ele mostrará o menu de favoritos, que foi definido no product_list
    final List<Product> loadedProducts =
        showFavoriteOnly ? provider.favoriteItems : provider.items;
    return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //exibição de objetos por linha
          crossAxisCount: 2,
          //relação entre altura e largura
          childAspectRatio: 3 / 2.5,
          //espaçamento no eixo cruzado
          crossAxisSpacing: 10,
          //espaçamento no eixo principal
          mainAxisSpacing: 10,
        ),
        itemCount: loadedProducts.length,
        //passará um objeto da lista loadedProducts atraves do índice para widgets/product_item pelo método value
        itemBuilder: (_, index) => ChangeNotifierProvider.value(
              //está passando para seus filhos um objeto carregado da lista, pelo índice, que será um objeto Product
              //quando o value atualizar, o child será modificado
              value: loadedProducts[index],
              //O objeto específico é passado pelo value, não mais como parâmetro.
              //
              //No proximo trecho de código, ja que estamos passando um valor Product, pois o productlist é uma lista de produtos,
              //devemos fornecer um Provider.of<Product>, mesmo que nao esteja presente no main, pois este estará se relacionando com o 'value'
              child: ProductGridItem(),
            ));
  }
}
