import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/empleado_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import 'empleado_form_screen.dart';

class EmpleadosListTab extends StatelessWidget {
  const EmpleadosListTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);
    final user = authService.currentUser;

    if (user == null) return const SizedBox.shrink();

    return StreamBuilder<List<Empleado>>(
      stream: firestoreService.getEmpleados(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final empleados = snapshot.data ?? [];

        if (empleados.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.badge, size: 80, color: Colors.teal.shade200),
                const SizedBox(height: 16),
                Text(
                  'No tienes empleados registrados',
                  style: GoogleFonts.lato(fontSize: 18, color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: empleados.length,
          itemBuilder: (context, index) {
            final empleado = empleados[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: Colors.teal.shade100,
                  child: Icon(Icons.person, color: Colors.teal.shade700),
                ),
                title: Text(
                  empleado.nombre,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.work, size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Expanded(child: Text(empleado.puesto)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.monetization_on, size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text('\$${empleado.sueldo}'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(empleado.fecha),
                      ],
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmpleadoFormScreen(empleado: empleado),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _confirmarEliminacion(context, firestoreService, empleado.id!);
                      },
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

  void _confirmarEliminacion(BuildContext context, FirestoreService service, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Empleado'),
        content: const Text('¿Estás seguro de que deseas eliminar este empleado?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              service.deleteEmpleado(id);
              Navigator.pop(ctx);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
