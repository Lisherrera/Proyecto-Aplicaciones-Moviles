import 'package:flutter/material.dart';
import 'package:proyecto_flutter/pages/home_page.dart';

class AcercadePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            if (Navigator.canPop(context)) {
              Navigator.pop(context); 
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()), 
              );
            }
          },
        ),
        title: const Text(
          'Acerca',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFd8eff9), Color(0xFFbde4f2)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Acerca de la Aplicación",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1f7596),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Creadores:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5aa7a9),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "- Cristopher Pereira Altamirano\n- Lisbeth Herrera Quiñones",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Universidad:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5aa7a9),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Universidad Técnica Federico Santa María",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Asignatura:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5aa7a9),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Desarrollo de Aplicaciones Móviles",
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Center(
              child: Text(
                "© 2024 - Todos los derechos reservados",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
