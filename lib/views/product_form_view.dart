import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/product_list.dart';

class ProductsFormView extends StatefulWidget {
  const ProductsFormView({Key? key}) : super(key: key);

  @override
  State<ProductsFormView> createState() => _ProductsFormViewState();
}

class _ProductsFormViewState extends State<ProductsFormView> {
  //Focus
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();

  //Basta colocar esta linha de código no TextFormField em que de aciona o Submit,
  /*onFieldSubmitted: (_){FocusScope.of(context).requestFocus(_priceFocus);},*/
  //E então colocar o foco no TextFormField que se deseja 'pular para'
  /*focusNode: _priceFocus*/

  //controller's
  final TextEditingController _imageUrlController = TextEditingController();

  //chave global para gerenciar o Estado de um formulário envolvido em um Widget Form
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  void updateImage() {
    setState(() {
      _imageUrlController;
    });
  }

  bool isValidImageUrl(String url) {
    //Linha de Código para saber se a url é valida ou não
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    //verificar se a URL termina com determinado tipo de extensão de imagem
    bool endsWithExtension = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    //caso um dos dois seja falso, o retorno será false. caso ambos sejam verdadeiros, o retorno será true
    return isValidUrl && endsWithExtension;
  }


  //esse método está sendo sobescrito para adaptar a dois cenários:
  //1 - Criar um novo produto
  //2 - Editar um produto já existente
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      //método de captura de um argumento passado via arguments
      final arg = ModalRoute.of(context)?.settings.arguments;
      //Caso receba dados (significa que veio e uma tela de edição):
      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;
        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  void submitForm() {
    //retorno boleano para validações
    final isValid = _formKey.currentState?.validate() ?? false;
    //caso não seja válido, ele retorna deste ponto.
    if (!isValid) {
      return;
    }
    //obter o estado atual do formulário, e executa cada função onSaved dentro da Widget Form
    _formKey.currentState?.save();
    //Configuração de um Product e adição de um novo Product via passagem de parâmetro para a função addProductFromData
    Provider.of<ProductList>(context, listen: false)
        .saveProductFromData(_formData);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Produto'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [IconButton(onPressed: submitForm, icon: Icon(Icons.save))],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _formData['name']?.toString(),
                //initialValue: (_formData['name'] ??'') as String,
                //Pulará para a proxima linha quando concluido no keyboard do dispositivo
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Nome*',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocus);
                },
                //verificação se o _formData inicia vazio ou com parâmetros repassados para a edição
                onSaved: (name) => _formData['name'] = name ?? '',
                validator: (name) {
                  final _name = name ?? '';
                  //trim() retira os espaços vazios
                  if (_name.trim().isEmpty) {
                    return 'Nome do produto é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['price']?.toString(),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Preço*',
                  //Cor do Text da label
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  //Cor da linha inferior
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                ),
                focusNode: _priceFocus,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
                //verificação se o _formData inicia vazio ou com parâmetros repassados para a edição
                onSaved: (price) {
                  if (price == null || price.isEmpty) {
                    _formData['price'] = 0.0;
                  } else {
                    _formData['price'] = double.parse(price);
                  }
                },
                validator: (price) {
                  final _price = price ?? '';
                  if (_price.trim().isEmpty) {
                    return 'Preço inválido';
                  }
                  //conver
                  final parsedPrice = double.tryParse(_price);
                  if (parsedPrice == null || parsedPrice <= 0) {
                    return 'Preço inválido';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['description']?.toString(),
                //Pulará para a proxima linha quando concluido no keyboard do dispositivo
                //textInputAction: TextInputAction.next,//essa linha de código precisa ser comentada para possibilitar a quebra de linha
                decoration: InputDecoration(
                  labelText: 'Descrição (opcional)',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                ),
                focusNode: _descriptionFocus,
                //para usar multiplas linhas
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_imageUrlFocus);
                },
                onSaved: (description) =>
                    _formData['description'] = description ?? '',
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Um TextFormField para inserir a URL da imagem
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Url da imagem*',
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                      ),
                      focusNode: _imageUrlFocus,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      controller: _imageUrlController,
                      // Usamos um TextEditingController aqui
                      onFieldSubmitted: (_) {
                        submitForm();
                      },
                      //verificação se o _formData inicia vazio ou com parâmetros repassados para a edição
                      onSaved: (imageUrl) =>
                          _formData['imageUrl'] = imageUrl ?? '',
                      validator: (_imageUrl) {
                        final imageUrl = _imageUrl ?? '';
                        if (!isValidImageUrl(imageUrl.toString())) {
                          return 'Informe uma Url válida!';
                        }
                        return null;
                      },
                    ),
                  ),

                  // ValueListenableBuilder é um widget que ouve as mudanças em um ValueListenable, neste caso, nosso TextEditingController
                  //semelhante ao Consumer, porém diferente pois o Consumer vem do Provider e mexe com uma Árvode de Widget's mais complexa,
                  //nesse caso se trata de um estado presente no meesmo componente
                  ValueListenableBuilder<TextEditingValue>(
                    // Nós passamos o TextEditingController como o ValueListenable para o ValueListenableBuilder ouvir
                    valueListenable: _imageUrlController,
                    // O builder é uma função que é chamada sempre que o ValueListenable muda
                    // Ele recebe três argumentos:
                    // 1. O contexto atual, que você pode usar para acessar o tema, MediaQuery, etc
                    // 2. O valor atual do ValueListenable, neste caso um TextEditingValue
                    // 3. Um widget filho que você pode optar por reutilizar em várias chamadas do construtor
                    builder: (context, TextEditingValue value, _) {
                      return Container(
                        height: 100,
                        width: 100,
                        margin: EdgeInsets.only(top: 8, left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        // Se o texto atual no TextEditingController estiver vazio, mostramos um texto placeholder
                        // Caso contrário, mostramos a imagem da URL inserida
                        child: value.text.isEmpty ||
                                isValidImageUrl(_imageUrlController.text) ==
                                    false
                            ? Text('Informe a Url')
                            // A função Image.network carrega uma imagem da internet a partir da URL fornecida
                            : Container(
                                width: 100,
                                height: 100,
                                child: FittedBox(
                                  child: Image.network(value.text),
                                  fit: BoxFit.cover,
                                ),
                              ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
