import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:recipe_finder/Constants/Constants_api.dart';

class ApiService {
  // var url =
  //     Uri.parse('https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/pay');

  fetchData(String apiUrl) async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          // "authorization": API_KEY.toString(),
          // HttpHeaders.authorizationHeader: API_KEY.toString(),
        },
      );
      log(response.toString());

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        return json.decode(response.body);
      } else {
        log(response.body);
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  postApis(postUrl, headers, Object? body) async {
    try {
      var res = await http.post(
        postUrl,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: API_KEY,
        },
        body: body,
      );
      log(res.statusCode.toString());
      log(res.body.toString());
      // Utils().toastMessage("Booking Confirmed");
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
