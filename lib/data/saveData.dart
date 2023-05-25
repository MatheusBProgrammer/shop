import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SaveData {
  // Método para salvar uma string no SharedPreferences
  // Parâmetros:
  // - key: a chave para identificar o valor armazenado
  // - value: o valor da string a ser armazenada
  // Retorna:
  // - Future<bool>: um Future que completa com um valor booleano indicando se a operação foi bem-sucedida
  static Future<bool> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value); // Utiliza o método setString para armazenar a string no SharedPreferences
  }

  // Método para salvar um mapa (Map) no SharedPreferences
  // Parâmetros:
  // - key: a chave para identificar o valor armazenado
  // - value: o valor do mapa a ser armazenado
  // Retorna:
  // - Future<bool>: um Future que completa com um valor booleano indicando se a operação foi bem-sucedida
  static Future<bool> saveMap(String key, Map<String, dynamic> value) async {
    return saveString(key, jsonEncode(value)); // Converte o mapa em uma string JSON e chama o método saveString para armazená-lo
  }

  // Método para obter uma string do SharedPreferences
  // Parâmetros:
  // - key: a chave para identificar o valor armazenado
  // - defaultValue: um valor padrão a ser retornado caso a chave não exista no SharedPreferences (opcional, o padrão é uma string vazia)
  // Retorna:
  // - Future<String>: um Future que completa com a string obtida do SharedPreferences
  static Future<String> getString(String key, [String defaultValue = '']) async {
    final prefs = await SharedPreferences.getInstance();
    // Utiliza o método getString para obter a string correspondente à chave
    // Se a chave não existir ou o valor for nulo, retorna o valor padrão especificado
    return prefs.getString(key) ?? defaultValue;
  }

  // Método para obter um mapa (Map) do SharedPreferences
  // Parâmetros:
  // - key: a chave para identificar o valor armazenado
  // Retorna:
  // - Future<Map<String, dynamic>>: um Future que completa com o mapa obtido do SharedPreferences
  static Future<Map<String, dynamic>> getMap(String key) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      // Obtém a string do SharedPreferences usando o método getString e, em seguida, decodifica-a de JSON para um mapa
      return jsonDecode(await getString(key));
    } catch (_) {
      // Se ocorrer um erro durante a decodificação ou a chave não existir, retorna um mapa vazio
      return {};
    }
  }

  // Método para remover um valor do SharedPreferences
  // Parâmetros:
  // - key: a chave do valor a ser removido
  // Retorna:
  // - Future<bool>: um Future que completa com um valor booleano indicando se a operação foi bem-sucedida
  static Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key); // Utiliza o método remove para excluir o valor correspondente à chave especificada
  }
}
