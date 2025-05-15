import 'package:flutter/material.dart';

class User {
  String name;
  String role;
  String password;

  User({required this.name, required this.role, required this.password});
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final List<User> _users = [
    User(name: 'Juan Pérez', role: 'Administrador', password: '1234'),
    User(name: 'Luis Gómez', role: 'Mozo', password: '5678'),
    User(name: 'Jian Diaz', role: 'Administrador', password: '1234'),
    User(name: 'Leiner', role: 'Mozo', password: '1234'),
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Mozo';
  int? _editingIndex;
  bool _obscurePassword = true;

  void _saveUser() {
    if (_formKey.currentState!.validate()) {
      final newUser = User(
        name: _nameController.text.trim(),
        role: _selectedRole,
        password: _passwordController.text,
      );

      setState(() {
        if (_editingIndex == null) {
          _users.add(newUser);
        } else {
          _users[_editingIndex!] = newUser;
          _editingIndex = null;
        }
      });

      _nameController.clear();
      _passwordController.clear();
      _selectedRole = 'Mozo';
      _obscurePassword = true;
      Navigator.of(context).pop();
    }
  }

  void _showUserDialog({User? user, int? index}) {
    if (user != null) {
      _nameController.text = user.name;
      _passwordController.text = user.password;
      _selectedRole = user.role;
      _editingIndex = index;
    } else {
      _nameController.clear();
      _passwordController.clear();
      _editingIndex = null;
      _selectedRole = 'Mozo';
    }

    _obscurePassword = true;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(user == null ? 'Agregar Usuario' : 'Editar Usuario'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (context, setStatePassword) {
                    return TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                            setStatePassword(() {});
                          },
                        ),
                      ),
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Campo requerido' : null,
                    );
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  items: const [
                    DropdownMenuItem(value: 'Administrador', child: Text('Administrador')),
                    DropdownMenuItem(value: 'Mozo', child: Text('Mozo')),
                    DropdownMenuItem(value: 'Cajero', child: Text('Cajero')),
                  ],
                  onChanged: (value) => setState(() {
                    _selectedRole = value!;
                  }),
                  decoration: const InputDecoration(
                    labelText: 'Rol',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.supervisor_account),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _nameController.clear();
              _passwordController.clear();
              _editingIndex = null;
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: _saveUser,
            icon: const Icon(Icons.save),
            label: const Text('Guardar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  void _deleteUser(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("¿Eliminar usuario?"),
        content: Text("¿Seguro que deseas eliminar a ${_users[index].name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _users.removeAt(index);
              });
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        backgroundColor: Colors.teal,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _users.isEmpty
              ? const Center(child: Text('No hay usuarios registrados.'))
              : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _users.asMap().entries.map((entry) {
                final index = entry.key;
                final user = entry.value;

                return SizedBox(
                  width: constraints.maxWidth > 600
                      ? (constraints.maxWidth / 2) - 20
                      : constraints.maxWidth,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Text(user.name[0]),
                      ),
                      title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Rol: ${user.role}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showUserDialog(user: user, index: index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(index),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUserDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
        backgroundColor: Colors.teal,
      ),
    );
  }
}