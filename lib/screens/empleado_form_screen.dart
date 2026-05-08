import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/empleado_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../widgets/custom_text_field.dart';

class EmpleadoFormScreen extends StatefulWidget {
  final Empleado? empleado; 

  const EmpleadoFormScreen({super.key, this.empleado});

  @override
  State<EmpleadoFormScreen> createState() => _EmpleadoFormScreenState();
}

class _EmpleadoFormScreenState extends State<EmpleadoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _puestoController;
  late TextEditingController _sueldoController;
  late TextEditingController _fechaController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.empleado?.nombre ?? '');
    _puestoController = TextEditingController(text: widget.empleado?.puesto ?? '');
    _sueldoController = TextEditingController(text: widget.empleado?.sueldo ?? '');
    _fechaController = TextEditingController(text: widget.empleado?.fecha ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _puestoController.dispose();
    _sueldoController.dispose();
    _fechaController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final firestoreService = Provider.of<FirestoreService>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      final userId = authService.currentUser!.uid;

      final empleado = Empleado(
        id: widget.empleado?.id,
        nombre: _nombreController.text.trim(),
        puesto: _puestoController.text.trim(),
        sueldo: _sueldoController.text.trim(),
        fecha: _fechaController.text.trim(),
        createdAt: widget.empleado?.createdAt,
        userId: userId,
      );

      if (widget.empleado == null) {
        await firestoreService.addEmpleado(empleado);
      } else {
        await firestoreService.updateEmpleado(empleado);
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
    final isEditing = widget.empleado != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Empleado' : 'Registrar Empleado',
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal.shade600,
        foregroundColor: Colors.white,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.white],
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
                  label: 'Nombre del Empleado',
                  icon: Icons.person,
                  controller: _nombreController,
                  validator: (val) => val!.isEmpty ? 'El nombre es obligatorio' : null,
                ),
                CustomTextField(
                  label: 'Puesto',
                  icon: Icons.work,
                  controller: _puestoController,
                  validator: (val) => val!.isEmpty ? 'El puesto es obligatorio' : null,
                ),
                CustomTextField(
                  label: 'Sueldo',
                  icon: Icons.monetization_on,
                  controller: _sueldoController,
                  keyboardType: TextInputType.number,
                  validator: (val) => val!.isEmpty ? 'El sueldo es obligatorio' : null,
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      _fechaController.text = formattedDate;
                    }
                  },
                  child: AbsorbPointer(
                    child: CustomTextField(
                      label: 'Fecha de ingreso',
                      icon: Icons.calendar_today,
                      controller: _fechaController,
                      validator: (val) => val!.isEmpty ? 'La fecha es obligatoria' : null,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _guardar,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.teal.shade500,
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
