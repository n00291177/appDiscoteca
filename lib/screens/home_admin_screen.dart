import 'package:flutter/material.dart';
import 'package:nina_app/screens/user_management_screen.dart';
import 'package:nina_app/screens/sales_screen.dart';
import 'package:nina_app/screens/inventory_screen.dart';

class AppColors {
  static const Color background = Color(0xFF0D0D0D);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color buttonPrimary = Color(0xFFFFFFFF);
  static const Color buttonText = Color(0xFF000000);
  static const Color buttonSecondary = Color(0xFF2C2C2C);
  static const Color accentFuchsia = Color(0xFFFF2D95);
  static const Color accentBlue = Color(0xFF00CFFF);
  static const Color error = Color(0xFFFF3B3B);
  static const Color success = Color(0xFF00FF85);
  static const Color hover = Color(0xFF3A3A3A);
  static const Color divider = Color(0xFF4D4D4D);
}

class HomeAdminPage extends StatelessWidget {
  final String userRole;

  const HomeAdminPage({required this.userRole, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, color: AppColors.textPrimary),
            SizedBox(width: 10),
            Text(
              'Bienvenido, $userRole',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildTile(context, 'Gestionar Usuarios', Icons.people, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const UserManagementScreen()));
            }),
            _buildTile(context, 'Categorias', Icons.list, () {
              // Acción futura
            }),
            _buildTile(context, 'Productos', Icons.inventory_2, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const InventoryScreen()));
              // Acción futura
            }),
            _buildTile(context, 'Registrar Venta', Icons.inventory_sharp, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SalesScreen()));
            }),
            _buildTile(context, 'Reservas de Mesas', Icons.event_seat, () {
              // Acción futura
            }),
            _buildTile(context, 'Mozos', Icons.people_outline, () {
              // Acción futura
            }),
            _buildTile(context, 'Clientes', Icons.people_alt_outlined, () {
              // Acción futura
            }),
            _buildTile(context, 'Ver Reportes', Icons.bar_chart, () {
              // Acción futura
            }),
            _buildTile(context, 'Finanzas', Icons.account_balance, () {
              // Acción futura
            }),
            _buildTile(
              context,
              'Cerrar Sesión',
              Icons.logout,
                  () {
                Navigator.pop(context);
              },
              color: AppColors.accentFuchsia,
              textColor: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, String title, IconData icon, VoidCallback onTap,
      {Color? color, Color? textColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color ?? AppColors.buttonSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: textColor ?? AppColors.accentBlue),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  color: textColor ?? AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}