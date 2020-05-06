import 'package:flutter/material.dart';
import 'package:todoapp/ui/view/home_view.dart';

void main() => runApp(MaterialApp(
      initialRoute: "/",
      routes: {"/": (context) => HomeView()},
    ));
