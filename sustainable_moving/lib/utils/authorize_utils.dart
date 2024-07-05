import 'dart:convert';
import 'package:sustainable_moving/Impact/impact.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class AuthorizeUtils {
  //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences

  static Future<int?> authorize() async {
    try {
      //Create the request
      final url = Impact.baseUrl + Impact.tokenEndpoint;
      final body = {'username': Impact.username, 'password': Impact.password};

      //Get the response
      print('Calling: $url');
      final response = await http.post(Uri.parse(url), body: body);

      //If 200, set the token
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final sp = await SharedPreferences.getInstance();
        sp.setString('access', decodedResponse['access']);
        sp.setString('refresh', decodedResponse['refresh']);
      }

      //Just return the status code
      return response.statusCode;
    } on SocketException catch (e) {
      print('Network error: $e');
      return null; // or an appropriate error code
    } on http.ClientException catch (e) {
      print('Client error: $e');
      return null; // or an appropriate error code
    } catch (e) {
      print('An unexpected error occurred: $e');
      return null; // or an appropriate error code
    }
  }

  //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
  static Future<int> refreshTokens() async {
    try {
      //Create the request
      final url = Impact.baseUrl + Impact.refreshEndpoint;
      final sp = await SharedPreferences.getInstance();
      final refresh = sp.getString('refresh');
      final body = {'refresh': refresh};

      //Get the response
      print('Calling: $url');
      final response = await http.post(Uri.parse(url), body: body);

      //If 200, set the tokens
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final sp = await SharedPreferences.getInstance();
        sp.setString('access', decodedResponse['access']);
        sp.setString('refresh', decodedResponse['refresh']);
      }

      //Return just the status code
      return response.statusCode;
    } on SocketException catch (e) {
      print('Network error: $e');
      return 500; // or an appropriate error code
    } on http.ClientException catch (e) {
      print('Client error: $e');
      return 500; // or an appropriate error code
    } catch (e) {
      print('An unexpected error occurred: $e');
      return 500; // or an appropriate error code
    }
  }

  static unauthorize() async {
    final sp = await SharedPreferences.getInstance();
    sp.remove('access');
    sp.remove('refresh');
  }
}
