import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/floreria_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../widgets/custom_text_field.dart';

class FloreriaFormScreen extends StatefulWidget {
  final Floreria? floreria; // Si es null, es creación. Si no, es edición.

  const FloreriaFormScreen({super.key, this.floreria});

  @override
  State<FloreriaFormScreen> createState() => _FloreriaFormScreenState();
}

class _FloreriaFormScreenState extends State<FloreriaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _direccionController;
  late TextEditingController _telefonoController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.floreria?.nombre ?? '');
    _direccionController = TextEditingController(text: widget.floreria?.direccion ?? '');
    _telefonoController = TextEditingController(text: widget.floreria?.telefono ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final firestoreService = Provider.of<FirestoreService>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      final userId = authService.currentUser!.uid;

      final floreria = Floreria(
        id: widget.floreria?.id,
        nombre: _nombreController.text.trim(),
        direccion: _direccionController.text.trim(),
        telefono: _telefonoController.text.trim(),
        createdAt: widget.floreria?.createdAt,
        userId: userId,
      );

      if (widget.floreria == null) {
        // Crear
        await firestoreService.addFloreria(floreria);
      } else {
        // Actualizar
        await firestoreService.updateFloreria(floreria);
      }

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.floreria != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Florería' : 'Nueva Florería',
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Nombre de la Florería',
                  icon: Icons.store,
                  controller: _nombreController,
                  validator: (val) => val!.isEmpty ? 'El nombre es obligatorio' : null,
                ),
                CustomTextField(
                  label: 'Dirección',
                  icon: Icons.location_on,
                  controller: _direccionController,
                  validator: (val) => val!.isEmpty ? 'La dirección es obligatoria' : null,
                ),
                CustomTextField(
                  label: 'Teléfono',
                  icon: Icons.phone,
                  controller: _telefonoController,
                  keyboardType: TextInputType.phone,
                  validator: (val) => val!.isEmpty ? 'El teléfono es obligatorio' : null,
                ),
                const SizedBox(height: 32),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _guardar,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.pink.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isEditing ? 'Actualizar' : 'Guardar',
                          style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
