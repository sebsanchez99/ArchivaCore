import 'package:flutter/material.dart';

class RecyclingView extends StatelessWidget {
  const RecyclingView({super.key});
  
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista de Reciclaje'),
      ),
      body: Center(
        child: Text('Contenido de reciclaje va aquí'),
      ),
    );
  }
}
