import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrijourney/models/meal.dart';
import 'package:uuid/uuid.dart';

import '../utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


class TrackerService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> trackMeal(
      email,
      mealType,
      selectedDate,
      mealName,
      calories,
      carbohydrates,
      proteins,
      fats,
      image
      ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management

    String res = "Some error occurred"; // set res as error first

    try {
      String imageLink =
          "https://docs.flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png";

      imageLink = await uploadImageToStorage('recipes', image);

      String trackerId = const Uuid().v1(); // creates unique id based on time

      Meal meal = Meal(
        mealId: trackerId,
        mealName: mealName,
        mealType: mealType,
        image: imageLink,
        selectedDate: selectedDate,
        calories: calories,
        fats: fats,
        proteins: proteins,
        carbohydrates: carbohydrates,
      );

      firestore.collection('users')
            .doc(email)
            .collection('tracker')
            .doc(selectedDate)
            .collection(selectedDate).add(meal.toJson());

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> scanBarcode() async {
    try {
      return await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", // Line color
        "Cancel", // Cancel button text
        true, // Show flashlight icon
        ScanMode.BARCODE,
      );
    } catch (e) {
      return ''; // Handle error or return empty string
    }
  }

  Future<Map<String, dynamic>?> fetchProductDetails(String barcode) async {
    try {
      final response = await http.get(Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json'));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var jsonString = jsonResponse.toString();
        // Print in chunks
        for (var i = 0; i < jsonString.length; i += 1000) {
          if (i + 1000 < jsonString.length) {
            print("API Response Data: ${jsonString.substring(i, i + 1000)}");
          } else {
            print("API Response Data: ${jsonString.substring(i)}");
          }
        }
        if (jsonResponse['status'] == 1) {
          return jsonResponse['product'];
        } else {
          print("Product not found in the database.");
        }
      } else {
        print("Error with API call: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching product details: $e");
    }
    return null;
  }





}
