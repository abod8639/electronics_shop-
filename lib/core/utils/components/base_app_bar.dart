import 'package:flutter/material.dart';

AppBar baseAppBar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(100) ,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
     centerTitle: true,
     );
  }