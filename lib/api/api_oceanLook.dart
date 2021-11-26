import 'package:http/http.dart' as http;
import 'dart:convert';

class APIocean {
  var result;
  var url = Uri.parse(
      'https://ocean-look.com/mb/openapidata.do?token=62e9c79cc52a7aff6e90ba67db2e4f94c0a70d46f8af510feb20636533d808b0&outputFormat=json');

  getOcean() async {
    final response = await http.get(url);
    result = json.decode(response.body);
    return result;
  }
}
