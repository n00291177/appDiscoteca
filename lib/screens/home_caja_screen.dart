
import 'package:flutter/material.dart';


class HomeCajaPage extends StatelessWidget {
  final String userRole;

  HomeCajaPage({required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, $userRole'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Panel de $userRole',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(Icons.people, color: Colors.deepPurple),
                title: Text('Gestionar Usuarios'),
                onTap: () {
                  // Navegar a pantalla de gestión de usuarios (en el futuro)
                },
              ),
            ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(Icons.bar_chart, color: Colors.deepPurple),
                title: Text('Ver Reportes'),
                onTap: () {
                  // Navegar a reportes
                },
              ),
            ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.deepPurple),
                title: Text('Cerrar Sesión'),
                onTap: () {
                  Navigator.pop(context); // Volver al login
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
