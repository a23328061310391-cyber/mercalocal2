import 'package:flutter/material.dart';

void main() {
  runApp(const MercaLocalApp());
}

class MercaLocalApp extends StatelessWidget {
  const MercaLocalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MercaLocal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F4E79),
          primary: const Color(0xFF1F4E79),
          secondary: const Color(0xFFF4A41B),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  PANTALLA DE LOGIN / REGISTRO
// ─────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // Controla si mostramos Login o Registro
  bool _isLogin = true;

  // Tipo de usuario seleccionado
  String _userType = 'cliente'; // 'cliente' o 'negocio'

  // Controladores de texto
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _negocioController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    _negocioController.dispose();
    super.dispose();
  }

  // Alterna entre Login y Registro con animación
  void _toggleMode() {
    _animController.reverse().then((_) {
      setState(() {
        _isLogin = !_isLogin;
        _formKey.currentState?.reset();
      });
      _animController.forward();
    });
  }

  // Simula el envío del formulario
  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulación de llamada a servidor (1.5 segundos)
      await Future.delayed(const Duration(milliseconds: 1500));

      setState(() => _isLoading = false);

      if (!mounted) return;

      // Navegar a la pantalla principal (placeholder)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isLogin
                ? '¡Bienvenido a MercaLocal! 🛒'
                : '¡Cuenta creada exitosamente! 🎉',
          ),
          backgroundColor: const Color(0xFF1F4E79),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              // ── Logo y título ──
              _buildHeader(),
              const SizedBox(height: 32),

              // ── Tarjeta principal ──
              FadeTransition(
                opacity: _fadeAnim,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título Login / Registro
                        Text(
                          _isLogin ? 'Iniciar sesión' : 'Crear cuenta',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F4E79),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isLogin
                              ? 'Ingresa tus datos para continuar'
                              : 'Regístrate gratis en minutos',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Selector Tipo de usuario (solo en Registro)
                        if (!_isLogin) ...[
                          _buildUserTypeSelector(),
                          const SizedBox(height: 20),
                        ],

                        // Formulario
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Nombre (solo registro)
                              if (!_isLogin) ...[
                                _buildTextField(
                                  controller: _nombreController,
                                  label: 'Nombre completo',
                                  icon: Icons.person_outline,
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Ingresa tu nombre'
                                      : null,
                                ),
                                const SizedBox(height: 16),
                              ],

                              // Nombre del negocio (solo registro tipo negocio)
                              if (!_isLogin && _userType == 'negocio') ...[
                                _buildTextField(
                                  controller: _negocioController,
                                  label: 'Nombre del negocio',
                                  icon: Icons.store_outlined,
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Ingresa el nombre de tu negocio'
                                      : null,
                                ),
                                const SizedBox(height: 16),
                              ],

                              // Email
                              _buildTextField(
                                controller: _emailController,
                                label: 'Correo electrónico',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Ingresa tu correo';
                                  }
                                  if (!v.contains('@')) {
                                    return 'Correo inválido';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Teléfono (solo registro)
                              if (!_isLogin) ...[
                                _buildTextField(
                                  controller: _telefonoController,
                                  label: 'Número de teléfono',
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                  validator: (v) => v == null || v.length < 10
                                      ? 'Teléfono inválido (10 dígitos)'
                                      : null,
                                ),
                                const SizedBox(height: 16),
                              ],

                              // Contraseña
                              _buildPasswordField(),
                              const SizedBox(height: 12),

                              // ¿Olvidaste tu contraseña? (solo Login)
                              if (_isLogin)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Se enviará un correo de recuperación'),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      '¿Olvidaste tu contraseña?',
                                      style: TextStyle(
                                          color: Color(0xFF2E75B6)),
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 24),

                              // Botón principal
                              _buildSubmitButton(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Toggle Login / Registro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isLogin
                        ? '¿No tienes cuenta? '
                        : '¿Ya tienes cuenta? ',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  GestureDetector(
                    onTap: _toggleMode,
                    child: Text(
                      _isLogin ? 'Regístrate' : 'Inicia sesión',
                      style: const TextStyle(
                        color: Color(0xFF1F4E79),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── WIDGETS AUXILIARES ────────────────────────────────

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo circular
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFF1F4E79),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1F4E79).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.shopping_basket_rounded,
            color: Colors.white,
            size: 44,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'MercaLocal',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F4E79),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tu tienda del barrio, en tu celular',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildUserTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de cuenta',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // Botón Cliente
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _userType = 'cliente'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: _userType == 'cliente'
                        ? const Color(0xFF1F4E79)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _userType == 'cliente'
                          ? const Color(0xFF1F4E79)
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_rounded,
                        color: _userType == 'cliente'
                            ? Colors.white
                            : Colors.grey[500],
                        size: 28,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Soy Cliente',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _userType == 'cliente'
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Botón Negocio
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _userType = 'negocio'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: _userType == 'negocio'
                        ? const Color(0xFFF4A41B)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _userType == 'negocio'
                          ? const Color(0xFFF4A41B)
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.store_rounded,
                        color: _userType == 'negocio'
                            ? Colors.white
                            : Colors.grey[500],
                        size: 28,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Soy Negocio',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _userType == 'negocio'
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF2E75B6)),
        filled: true,
        fillColor: const Color(0xFFF5F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFF2E75B6), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      validator: (v) {
        if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
        if (!_isLogin && v.length < 6) {
          return 'Mínimo 6 caracteres';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Contraseña',
        prefixIcon:
            const Icon(Icons.lock_outline, color: Color(0xFF2E75B6)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[500],
          ),
          onPressed: () =>
              setState(() => _obscurePassword = !_obscurePassword),
        ),
        filled: true,
        fillColor: const Color(0xFFF5F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFF2E75B6), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1F4E79),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                _isLogin ? 'Iniciar sesión' : 'Crear cuenta',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}