//Cris: Esta ya no va pq no se pide jajaja

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_flutter/pages/home_page.dart';

class EditarPage extends StatefulWidget {
  final String nombre;
  final String categoria;
  final String autor;
  final String instrucciones;

  EditarPage({
    required this.nombre,
    required this.categoria,
    required this.autor,
    required this.instrucciones,
  });

  @override
  _EditRecipePageState createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditarPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.nombre;
    _categoryController.text = widget.categoria;
    _authorController.text = widget.autor;
    _instructionsController.text = widget.instrucciones;
  }

  Future<void> _updateRecipe(String recetaId) async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('recetas').doc(recetaId).update({
          'nombre': _nameController.text,
          'categoria': _categoryController.text,
          'autor': _authorController.text,
          'instrucciones': _instructionsController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Receta actualizada con éxito')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar receta: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFF5aa7a9),
            ),
        ),
        leading: Image.asset(
          'assets/images/iconopng.png',
          height: 10,
          width: 120,
        ),
        title: Text(
          'Editar Receta',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF5aa7a9),
              Color(0xFF1f7596),
            ],
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nombre de la receta"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingresa el nombre de la receta";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Categoria
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: "Categoría"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingresa la categoría";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Autor
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(labelText: "Autor"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingresa el autor de la receta";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Instrucciones
              TextFormField(
                controller: _instructionsController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Instrucciones",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingresa las instrucciones";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Botón para guardar
              ElevatedButton(
                onPressed: () {
                  String recetaId = 'ID_de_la_receta'; 
                  _updateRecipe(recetaId);
                },
                child: Text("Guardar Cambios"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()), 
                    (Route<dynamic> route) => false, 
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5aa7a9), 
                ),
                child: Text(
                  "Volver al Home",
                  style: TextStyle(color: Colors.white), 
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
