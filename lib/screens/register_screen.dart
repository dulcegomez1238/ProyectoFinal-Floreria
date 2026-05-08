import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    setState(() => _isLoading = true);
    debugPrint('Intentando registrar usuario: ${_emailController.text}');
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.registerWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      debugPrint('Registro exitoso');
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Error en registro: $e');
      String errorMsg = e.toString();
      if (errorMsg.contains('configuration-not-found')) {
        errorMsg = 'ERROR: Debes habilitar "Correo/Contraseña" en la Consola de Firebase -> Authentication -> Sign-in method';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          duration: const Duration(seconds: 10),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green.shade800),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Crear Cuenta',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    label: 'Correo Electrónico',
                    icon: Icons.email,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => val!.isEmpty ? 'Ingresa tu correo' : null,
                  ),
                  CustomTextField(
                    label: 'Contraseña',
                    icon: Icons.lock,
                    obscureText: true,
                    controller: _passwordController,
                    validator: (val) => val!.length < 6 ? 'Mínimo 6 caracteres' : null,
                  ),
                  CustomTextField(
                    label: 'Confirmar Contraseña',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    controller: _confirmPasswordController,
                    validator: (val) => val!.isEmpty ? 'Confirma tu contraseña' : null,
                  ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [Colors.pink.shade400, Colors.pink.shade300],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Registrarse',
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
