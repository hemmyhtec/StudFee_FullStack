import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';

// String url = 'http://192.168.101.130:3000';
String url = 'https://studfees-server.onrender.com';

class Config {
  // static const appIcon = 'assets/images/logo.png';
  // static const flowerImage = 'assets/images/flower.png';
  // static const onboardScreen = 'assets/images/Girl.jpg';
  static const backgroundColor = Color.fromARGB(255, 24, 36, 48);
  static const primaryColor = Color(0xFF3879E9);
  static const inputFieldColor = Color.fromARGB(255, 212, 212, 212);
  static final cloudinary =
      CloudinaryPublic('profiler-app-hemmyhtec', 'ml_default');
}
