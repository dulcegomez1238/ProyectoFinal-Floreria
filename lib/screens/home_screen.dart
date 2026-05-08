import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'florerias_list_tab.dart';
import 'empleados_list_tab.dart';
import 'empleado_form_screen.dart';
import 'floreria_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    EmpleadosListTab(),
    FloreriasListTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    // Confiamos en que AuthWrapper maneja la protección de esta pantalla
    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0 ? 'Mis Empleados' : 'Mis Florerías',
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _currentIndex == 0 ? Colors.teal.shade600 : Colors.green.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: _tabs[_currentIndex],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_currentIndex == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EmpleadoFormScreen()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FloreriaFormScreen()),
            );
          }
        },
        backgroundColor: _currentIndex == 0 ? Colors.teal.shade500 : Colors.pink.shade400,
        icon: Icon(_currentIndex == 0 ? Icons.person_add : Icons.add, color: Colors.white),
        label: Text(
          _currentIndex == 0 ? 'Agregar Empleado' : 'Agregar Florería',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: _currentIndex == 0 ? Colors.teal.shade700 : Colors.green.shade700,
        unselectedItemColor: Colors.grey.shade500,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Empleados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist),
            label: 'Florerías',
          ),
        ],
      ),
    );
  }
}
