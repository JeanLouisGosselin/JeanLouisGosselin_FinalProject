import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkEnsurer {

  NetworkEnsurer(this.url);
  final String url;

  Future getData() async {

    http.Response resp = await http.get(url);

    if (resp.statusCode == 200) {
      String data = resp.body;
      print(data);
      return jsonDecode(data);
    }
    else {
      print(resp.statusCode);
    }
  }
}
