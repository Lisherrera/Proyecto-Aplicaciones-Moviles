import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_flutter/pages/home_page.dart';

class DetalleRecetaPage extends StatelessWidget {
  final String nombre;
  final String categoria;
  final String autor;
  final String imagenUrl;
  final String instrucciones;
  final String recetaId;

  DetalleRecetaPage({
    required this.nombre,
    required this.categoria,
    required this.autor,
    required this.imagenUrl,
    required this.instrucciones,
    required this.recetaId,
  });


  Future<bool?> _showConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Estás seguro de que deseas eliminar esta receta?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);  
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);  
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }


  Future<void> eliminarReceta(BuildContext context, String recetaId) async {
    try {

      bool? confirmDelete = await _showConfirmationDialog(context);

      if (confirmDelete != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Eliminación cancelada.')),
        );
        return;
      }

      await FirebaseFirestore.instance
          .collection('recetas')
          .doc(recetaId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Receta eliminada con éxito.')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), 
        (Route<dynamic> route) => false, 
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la receta: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    bool esMiReceta = userId != null && userId == userId;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF5aa7a9), Color(0xFF1f7596)],
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          nombre,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Color(0xFFd8eff9),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFd8eff9), Color(0xFFbde4f2)],
            ),
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  imagenUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Categoría: $categoria",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1f7596),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Autor: $autor",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                "Instrucciones:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1f7596),
                ),
              ),
              SizedBox(height: 8),
              Text(
                instrucciones,
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),

              if (esMiReceta)
                ElevatedButton(
                  onPressed: () => eliminarReceta(context, userId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFe74c3c),
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Eliminar Receta"),
                ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
