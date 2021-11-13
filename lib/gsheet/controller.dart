import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:joelfindtechnician/gsheet/model.dart';



class FormController {

  
  static const String URL = "https://script.google.com/macros/s/AKfycbxOxqEIXypi_fZpPpKT42Koq3fQQV9qL451yjlUsRmnthUkw7QcLqC5YQofBPMWqKrx/exec";
  
 
  static const STATUS_SUCCESS = "SUCCESS";

  /// Async function which saves feedback, parses [registerFoam] parameters
  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
   void submitForm(
      RegisterFoam registerFoam, void Function(String) callback) async {
    try {
      await http.post(Uri.parse("https://script.google.com/macros/s/AKfycbxOxqEIXypi_fZpPpKT42Koq3fQQV9qL451yjlUsRmnthUkw7QcLqC5YQofBPMWqKrx/exec"), body: registerFoam.toJson()).then((response) async {
        if (response.statusCode == 302) {
          var uri = response.headers['location'];
          await http.get(Uri()).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
          
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
      
    } catch (e) {
      print(e);
    }

    
  }
}