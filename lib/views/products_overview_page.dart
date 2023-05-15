import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/models/cart.dart';
import 'package:store/utils/app_routes.dart';
import 'package:store/views/cart_view.dart';
import 'package:store/widgets/app_drawer.dart';
import '../models/product_list.dart';
import '../widgets/badgee.dart';
import '../widgets/product_grid.dart';

enum FilterOptions {
  Favorite,
  All,
}

//Pagina de exibição de todos os items
//#2 - é uma classe stateful para fazer realizar a exibição de itens geral ou apenas dos favoritos
class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  //valor boleano para a seleção dos favoritos através do PopupMenuButton
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Minha Loja',
        ),
        actions: [
          //menu PopUp
          PopupMenuButton(
            icon: const Icon(Icons.more_vert_outlined),
            itemBuilder: (_) =>
            [
              //Item do menu PopUp
              const PopupMenuItem(
                //value: retorno enum
                value: FilterOptions.All,
                child: Text('Todos'),
              ),
              //Item do menu PopUp
              const PopupMenuItem(
                //value: retorno enum
                value: FilterOptions.Favorite,
                child: Text('Somente Favoritos'),
              ),
            ],
            //função de retorno da seleção dos itens do menu popup
            onSelected: (FilterOptions selectValue) {
              setState(() {
                //Caso o valor selecionado seja o de mostrar apenas os de favoritos, ele transforma o valor boleano de _showFavorite em true,
                //caso a opção seja outra, no caso, .All, ele transformara o valor em falso.
                //##########################################################################
                //Após a releção dos valores, o valor boleano _showFavorite será passado como parâmetro para o ProductGrid, que organizará o modo de
                //exibição
                if (selectValue == FilterOptions.Favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {Navigator.of(context).pushNamed(AppRoutes.CART_VIEW);},
              icon: Icon(Icons.shopping_cart),
            ),
          builder: (ctx, cart, child) =>
              Badgee(
                  value: cart.itemsCount.toString(),
                  // o ! é passado para afirmar que eu sei que o child será/(está sendo) passado
                  child: child!,
              ))
        ],
        backgroundColor: Theme
            .of(context)
            .primaryColor,
      ),
      body: ProductGrid(showFavoriteOnly: _showFavoriteOnly),
      drawer: AppDrawer(),
    );
  }
}
