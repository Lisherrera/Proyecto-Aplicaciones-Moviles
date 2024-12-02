import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AgregarPage extends StatefulWidget {
  @override
  _AgregarPageState createState() => _AgregarPageState();
}

class _AgregarPageState extends State<AgregarPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  String? _selectedCategory;
  List<String> _categorias = [];
  bool _isLoadingCategorias = true;

  @override
  void initState() {
    super.initState();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _authorController.text = user.email ?? '';
    }

    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('categorias').get();
      setState(() {
        _categorias = snapshot.docs.map((doc) => doc['nombre'] as String).toList();
        _isLoadingCategorias = false;
      });
    } catch (e) {
      print('Error al cargar categorías: $e');
      setState(() {
        _isLoadingCategorias = false;
      });
    }
  }

  void _submitRecipe() async {
  if (_formKey.currentState!.validate()) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: no hay usuario logueado.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    String recetaId = FirebaseFirestore.instance.collection('recipes').doc().id;

    final recipeData = {
      'recetaId': recetaId, 
      'name': _nameController.text.trim(),
      'category': _selectedCategory,
      'author': _authorController.text.trim(),
      'instructions': _instructionsController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'userId': user.uid, 
    };

    try {
      await FirebaseFirestore.instance.collection('recipes').doc(recetaId).set(recipeData);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('¡Receta guardada exitosamente!'),
        backgroundColor: Colors.green,
      ));

      _formKey.currentState!.reset();
      setState(() {
        _selectedCategory = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al guardar la receta: $e'),
        backgroundColor: Colors.red,
      ));
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Color(0xFFd8eff9),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Añadir Nueva Receta",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1f7596),
              ),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _isLoadingCategorias
                          ? Center(child: CircularProgressIndicator())
                          : DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              hint: Text('Selecciona una categoría'),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCategory = newValue;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Por favor, selecciona una categoría";
                                }
                                return null;
                              },
                              items: _categorias.map<DropdownMenuItem<String>>((String category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                            ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Nombre de la receta",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Por favor, ingresa el nombre de la receta";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _authorController,
                        decoration: InputDecoration(
                          labelText: "Autor",
                          border: OutlineInputBorder(),
                        ),
                        readOnly: false,
                      ),
                      SizedBox(height: 16),
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
                      ElevatedButton(
                        onPressed: _submitRecipe,
                        child: Text(
                          "Guardar Receta",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
