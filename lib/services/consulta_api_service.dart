import 'dart:convert';
import 'package:http/http.dart' as http;

class ConsultaApiService {
  // Reemplaza con tu token real generado desde apis.net.pe
  static const String _token = 'v0OsmHJEelIhY892MF89dPmQ5n8iaCaH';

  // Consulta DNI a RENIEC
  static Future<Map<String, dynamic>?> consultarDNI(String dni) async {
    final url = Uri.parse('https://api.apis.net.pe/v1/dni?numero=$dni');

    final response = await http.get(url, headers: {
      'Authorization': _token,
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error al consultar DNI: ${response.statusCode}');
      return null;
    }
  }

  // Consulta RUC a SUNAT
  static Future<Map<String, dynamic>?> consultarRUC(String ruc) async {
    final url = Uri.parse('https://api.apis.net.pe/v1/ruc?numero=$ruc');

    final response = await http.get(url, headers: {
      'Authorization': _token,
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error al consultar RUC: ${response.statusCode}');
      return null;
    }
  }
}