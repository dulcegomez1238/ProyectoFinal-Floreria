import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    debugPrint('Intentando iniciar sesión con correo: ${_emailController.text}');
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      debugPrint('Inicio de sesión exitoso');
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      debugPrint('Error en login: $e');
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

  Future<void> _googleSignIn() async {
    setState(() => _isLoading = true);
    debugPrint('Intentando iniciar sesión con Google...');
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = await authService.signInWithGoogle();
      if (user != null && mounted) {
        debugPrint('Inicio de sesión con Google exitoso');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      debugPrint('Error en Google Sign-In: $e');
      String errorMsg = e.toString();
      if (errorMsg.contains('configuration-not-found')) {
        errorMsg = 'ERROR: Debes habilitar "Google" en la Consola de Firebase -> Authentication -> Sign-in method';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), duration: const Duration(seconds: 10)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _forgotPassword() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa tu correo para recuperar la contraseña')),
      );
      return;
    }
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.sendPasswordResetEmail(_emailController.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo de recuperación enviado')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Icon(Icons.local_florist, size: 100, color: Colors.pink.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'Florería Admin',
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
                    validator: (val) => val!.isEmpty ? 'Ingresa tu contraseña' : null,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _forgotPassword,
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(color: Colors.green.shade700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Iniciar Sesión',
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _googleSignIn,
                    icon: const Icon(Icons.login),
                    label: const Text('Ingresar con Google'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: Colors.green.shade800,
                      side: BorderSide(color: Colors.green.shade800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿No tienes cuenta?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RegisterScreen()),
                          );
                        },
                        child: Text(
                          'Regístrate',
                          style: TextStyle(
                            color: Colors.pink.shade400,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
