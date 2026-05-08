import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/floreria_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import 'floreria_form_screen.dart';

class FloreriasListTab extends StatelessWidget {
  const FloreriasListTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);
    final user = authService.currentUser;

    if (user == null) return const SizedBox.shrink();

    return StreamBuilder<List<Floreria>>(
      stream: firestoreService.getFlorerias(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final florerias = snapshot.data ?? [];

        if (florerias.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.eco, size: 80, color: Colors.green.shade200),
                const SizedBox(height: 16),
                Text(
                  'No tienes florerías registradas',
                  style: GoogleFonts.lato(fontSize: 18, color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: florerias.length,
          itemBuilder: (context, index) {
            final floreria = florerias[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: Colors.pink.shade100,
                  child: Icon(Icons.local_florist, color: Colors.pink.shade700),
                ),
                title: Text(
                  floreria.nombre,
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
                        Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Expanded(child: Text(floreria.direccion)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(floreria.telefono),
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
                            builder: (_) => FloreriaFormScreen(floreria: floreria),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _confirmarEliminacion(context, firestoreService, floreria.id!);
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
        title: const Text('Eliminar Florería'),
        content: const Text('¿Estás seguro de que deseas eliminar esta florería?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              service.deleteFloreria(id);
              Navigator.pop(ctx);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
