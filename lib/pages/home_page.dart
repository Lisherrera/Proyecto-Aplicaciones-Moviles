import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_flutter/pages/agregar_page.dart';
import 'package:proyecto_flutter/pages/acercade_page.dart';
import 'package:proyecto_flutter/pages/detalle_receta_page.dart';
import 'package:proyecto_flutter/pages/login_page.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';

User? user = FirebaseAuth.instance.currentUser;
String? userId = user?.uid; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedCategory;

  List<String> categories = [
    'Todas',
    'Entrantes',
    'Platos Principales',
    'Guarniciones',
    'Salsas y Condimentos',
    'Postres',
    'Bebidas y Cocteles',
    'Cocina Internacional',
    'Vegetariana/Vegana',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF5aa7a9), Color(0xFF1f7596)],
              ),
            ),
          ),
          leading: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Image.asset(
                'assets/images/iconopng.png',
                height: 50,
                width: 50,
              ),
            ),
          ),
          title: const Text(
            'Recetas',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () async {
                String? category = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text('Selecciona una categoría'),
                      children: categories.map((category) {
                        return SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context, category);
                          },
                          child: Text(category),
                        );
                      }).toList(),
                    );
                  },
                );
                if (category != null) {
                  setState(() {
                    selectedCategory = category;
                  });
                }
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'Recetas'),
              Tab(text: 'Mis Recetas'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xFF5aa7a9), Color(0xFF1f7596)],
                  ),
                ),
                child: Image.asset(
                  'assets/images/iconopng.png',
                  height: 100,
                  width: 100,
                ),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('Acerca de'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AcercadePage()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Salir'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        ),
        body: Container(
          color: Color(0xFFd8eff9),
          child: TabBarView(
            children: [
              RecetasList(category: selectedCategory), 
              MisRecetasList(category: selectedCategory), 
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AgregarPage()),
            );
          },
          child: const Icon(Icons.add),
          backgroundColor: Color(0xFF5aa7a9),
        ),
      ),
    );
  }
}

class RecetasList extends StatelessWidget {
  final String? category;

  const RecetasList({super.key, this.category});

  String _getImageForCategory(String? category) {
    switch (category) {
      case 'Entrantes':
        return 'assets/images/entrante.jpg';
      case 'Platos Principales':
        return 'assets/images/platoprincipal.jpg';
      case 'Guarniciones':
        return 'assets/images/guarniciones.jpg';
      case 'Postres':
        return 'assets/images/postre.jpg';
      case 'Salsas y Condimentos':
        return 'assets/images/salsas.jpg';
      case 'Bebidas y Cocteles':
        return 'assets/images/bebida.jpg';
      case 'Cocina Internacional':
        return 'assets/images/internacional.jpg';
      case 'Vegetariana/Vegana':
        return 'assets/images/vegetariana.jpg';
      default:
        return 'assets/images/icono.jpg';
    }
  }

  Future<List<Map<String, dynamic>>> _getRecetas(String? category) async {
    try {
      QuerySnapshot snapshot;
      if (category == null || category == 'Todas') {
        snapshot = await FirebaseFirestore.instance.collection('recipes').get();
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection('recipes')
            .where('category', isEqualTo: category)
            .get();
      }

      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      print('Error al obtener las recetas: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getRecetas(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay recetas disponibles.'));
        }

        List<Map<String, dynamic>> recetas = snapshot.data!;

        return ListView.builder(
          itemCount: recetas.length,
          itemBuilder: (context, index) {
            var receta = recetas[index];
            String imageUrl = receta['imageUrl'] ?? _getImageForCategory(receta['category']);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalleRecetaPage(
                      recetaId: receta['id'],
                      nombre: receta['name'] ?? 'Sin nombre',
                      categoria: receta['category'] ?? 'Sin categoría',
                      autor: receta['author'] ?? 'Desconocido',
                      imagenUrl: imageUrl,
                      instrucciones: receta['instructions'] ?? 'Sin instrucciones.',
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(16.0),
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: receta['imageUrl'] != null && receta['imageUrl'].isNotEmpty
                        ? NetworkImage(receta['imageUrl'])
                        : AssetImage(_getImageForCategory(receta['category'])) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                receta['name'] ?? 'Sin nombre',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class MisRecetasList extends StatelessWidget {
  final String? category;

  const MisRecetasList({super.key, this.category});

  String _getImageForCategory(String? category) {
    switch (category) {
      case 'Entrantes':
        return 'assets/images/entrante.jpg';
      case 'Platos Principales':
        return 'assets/images/platoprincipal.jpg';
      case 'Guarniciones':
        return 'assets/images/guarniciones.jpg';
      case 'Postres':
        return 'assets/images/postre.jpg';
      case 'Salsas y Condimentos':
        return 'assets/images/salsas.jpg';
      case 'Bebidas y Cocteles':
        return 'assets/images/bebida.jpg';
      case 'Cocina Internacional':
        return 'assets/images/internacional.jpg';
      case 'Vegetariana/Vegana':
        return 'assets/images/vegetariana.jpg';
      default:
        return 'assets/images/icono.jpg';  
    }
  }

  Future<List<Map<String, dynamic>>> _getMisRecetas(String? category) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('Usuario no logueado');
        return []; 
      }

      QuerySnapshot snapshot;
      if (category == null || category == 'Todas') {
        snapshot = await FirebaseFirestore.instance
            .collection('recipes')
            .where('userId', isEqualTo: user.uid)  
            .get();
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection('recipes')
            .where('category', isEqualTo: category)
            .where('userId', isEqualTo: user.uid)  
            .get();
      }

      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      print('Error al obtener las recetas: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>( 
      future: _getMisRecetas(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No has agregado ninguna receta.'));
        }

        List<Map<String, dynamic>> recetas = snapshot.data!;

        return ListView.builder(
          itemCount: recetas.length,
          itemBuilder: (context, index) {
            var receta = recetas[index];

            String imageUrl = receta['imageUrl'] != null && receta['imageUrl'].isNotEmpty
                ? receta['imageUrl']
                : _getImageForCategory(receta['category']);  

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalleRecetaPage(
                      recetaId: receta['id'],
                      nombre: receta['name'] ?? 'Sin nombre',
                      categoria: receta['category'] ?? 'Sin categoría',
                      autor: receta['author'] ?? 'Desconocido',
                      imagenUrl: imageUrl,
                      instrucciones: receta['instructions'] ?? 'Sin instrucciones.',
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(16.0),
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageUrl), // Cambié a AssetImage si es una imagen local
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                receta['name'] ?? 'Sin nombre',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
