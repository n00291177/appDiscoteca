
import 'package:flutter/material.dart';
import 'package:nina_app/screens/sales_screen.dart';

class HomeMozoPage extends StatelessWidget {
  final String userRole;

  const HomeMozoPage({required this.userRole, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido $userRole'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Panel de $userRole',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.add_shopping_cart),
              label: Text('Registrar Pedido'),
              onPressed: () {
                Navigator.pushNamed(context, '/registrarPedido');
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.list),
              label: Text('Ver Pedidos Activos'),
              onPressed: () {
                Navigator.pushNamed(context, '/verPedidos');
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.attach_money),
              label: Text('Ver Propinas'),
              onPressed: () {
                Navigator.pushNamed(context, '/verPropinas');
              },
            ),
            const SizedBox(height:10),
            ElevatedButton.icon(
              icon: Icon(Icons.pages),
              label: Text('Boleta'),
              onPressed: (){
                Navigator.pushNamed(context, '/verBoleta');
              },
            ),
            const SizedBox(height:10),
            ElevatedButton.icon(
              icon: Icon(Icons.print),
              label: Text('Factura'),
              onPressed: (){
                Navigator.pushNamed(context, '/verFactura');
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.logout),
              label: Text('Cerrar Sesión'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
