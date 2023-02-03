import 'package:flutter/material.dart';
import 'package:flutter_burger_restaurant_app/app/delivery_app.dart';
import 'app/core/config/env/env.dart';

void main() async {
  await Env.i.load();
  runApp(const DeliveryApp());
}