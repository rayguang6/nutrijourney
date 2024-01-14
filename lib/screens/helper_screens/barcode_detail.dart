import 'dart:convert';

import 'package:flutter/material.dart';
class BarcodeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> productDetails;

  BarcodeDetailScreen({Key? key, required this.productDetails}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    String rawJson = json.encode(productDetails); // Convert to JSON string

    return Scaffold(
      appBar: AppBar(
        title: Text(productDetails['product_name'] ?? 'PRODUCT Details'),
      ),
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (productDetails['image_url'] != null)
                Image.network(productDetails['image_url']),
              Text('Name: ${productDetails['product_name'] ?? 'N/A'}'),
              Text('Calories: ${productDetails['nutriments']['energy_value'] ?? 'N/A'}'),
              Text('Carbs: ${productDetails['nutriments']['carbohydrates'] ?? 'N/A'}'),
              Text('Proteins: ${productDetails['nutriments']['proteins'] ?? 'N/A'}'),
              Text('Fats: ${productDetails['nutriments']['fat'] ?? 'N/A'}'),

              SizedBox(height: 16,),
              Text("Raw JSON Data:", style: TextStyle(fontWeight: FontWeight.bold)),
              SelectableText(rawJson, style: TextStyle(fontFamily: "monospace")),
            ],
          ),
        ),
      ),
    );
  }
}