import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _formController;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;
  
  // Staggered animations
  late Animation<double> _fadeLogo;
  late Animation<Offset> _slideTitle;
  late Animation<Offset> _slideEmail;
  late Animation<Offset> _slidePassword;
  late Animation<Offset> _slideButton;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat(reverse: true);
    _topAlignmentAnimation = Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight).animate(_bgController);
    _bottomAlignmentAnimation = Tween<Alignment>(begin: Alignment.bottomRight, end: Alignment.bottomLeft).animate(_bgController);

    _formController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    
    _fadeLogo = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _formController, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)));
    _slideTitle = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(parent: _formController, curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic)));
    _slideEmail = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(parent: _formController, curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic)));
    _slidePassword = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(parent: _formController, curve: const Interval(0.5, 0.9, curve: Curves.easeOutCubic)));
    _slideButton = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(parent: _formController, curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic)));

    _formController.forward();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _formController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService.post('/auth/login', {
        'email': _emailController.text,
        'password': _passwordController.text,
      });

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', response.data['token']);
        await prefs.setString('user_role', response.data['role']);
        await prefs.setString('user_name', response.data['name']);
        
        if (mounted) {
          context.go('/dashboard');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Invalid credentials. Please try again.";
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dynamic Mesh Gradient Background
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, _) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
                    begin: _topAlignmentAnimation.value,
                    end: _bottomAlignmentAnimation.value,
                  ),
                ),
              );
            },
          ),
          
          // Floating Animated Orbs
          ...List.generate(5, (index) => _FloatingOrb(index: index)),

          // Heavy Glass Blur Layer
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: const SizedBox(),
            ),
          ),
          
          // Central Login Card
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: 450,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 56),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 40, spreadRadius: -10),
                      BoxShadow(color: Colors.deepPurpleAccent.withOpacity(0.1), blurRadius: 60, spreadRadius: 20),
                    ],
                  ),
                  child: AnimatedBuilder(
                    animation: _formController,
                    builder: (context, child) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Animated Logo
                          Opacity(
                            opacity: _fadeLogo.value,
                            child: Transform.scale(
                              scale: 0.8 + (_fadeLogo.value * 0.2),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(colors: [Colors.cyanAccent, Colors.blueAccent, Colors.deepPurpleAccent]),
                                  boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.5), blurRadius: 30)]
                                ),
                                child: const Icon(Icons.hub_outlined, size: 56, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Animated Title
                          SlideTransition(
                            position: _slideTitle,
                            child: Opacity(
                              opacity: _fadeLogo.value,
                              child: Column(
                                children: [
                                  const Text("Welcome Back", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                                  const SizedBox(height: 8),
                                  Text("Secure Supply Chain Access", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent, fontSize: 14)),
                            ),
                          
                          // Animated Fields
                          SlideTransition(position: _slideEmail, child: Opacity(opacity: _slideEmail.value.dy == 0 ? 1 : (1 - _slideEmail.value.dy.abs()), child: _buildTextField(controller: _emailController, icon: Icons.email_rounded, label: "Email Address", obscureText: false))),
                          const SizedBox(height: 24),
                          SlideTransition(position: _slidePassword, child: Opacity(opacity: _slidePassword.value.dy == 0 ? 1 : (1 - _slidePassword.value.dy.abs()), child: _buildTextField(controller: _passwordController, icon: Icons.lock_rounded, label: "Password", obscureText: true))),
                          const SizedBox(height: 48),
                          
                          // Animated Button
                          SlideTransition(
                            position: _slideButton,
                            child: Opacity(
                              opacity: _slideButton.value.dy == 0 ? 1 : (1 - _slideButton.value.dy.abs()),
                              child: _HoverScaleButton(isLoading: _isLoading, onTap: _handleLogin),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => context.go('/register'),
                            child: Text("Don't have an account? Register here", style: TextStyle(color: Colors.white.withOpacity(0.5))),
                          ),
                        ],
                      );
                    }
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required IconData icon, required String label, required bool obscureText}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: Colors.cyanAccent.withOpacity(0.8)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.04),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.05), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
        ),
      ),
    );
  }
}

// Complex Hover Button
class _HoverScaleButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _HoverScaleButton({required this.isLoading, required this.onTap});

  @override
  State<_HoverScaleButton> createState() => _HoverScaleButtonState();
}

class _HoverScaleButtonState extends State<_HoverScaleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Colors.cyanAccent, Colors.blueAccent]),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(_isHovered ? 0.6 : 0.3), 
                blurRadius: _isHovered ? 25 : 15, 
                offset: const Offset(0, 8)
              )
            ]
          ),
          child: Center(
            child: widget.isLoading 
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3))
              : const Text("Authenticate", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 1.5)),
          ),
        ),
      ),
    );
  }
}

// Floating Animated Orb for Background
class _FloatingOrb extends StatefulWidget {
  final int index;
  const _FloatingOrb({required this.index});

  @override
  State<_FloatingOrb> createState() => _FloatingOrbState();
}

class _FloatingOrbState extends State<_FloatingOrb> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 10 + widget.index * 2))..repeat(reverse: true);
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final rand = Random(widget.index);
    final size = 200.0 + rand.nextInt(300);
    final isCyan = widget.index % 2 == 0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Positioned(
          left: (MediaQuery.of(context).size.width * rand.nextDouble()) + (sin(_controller.value * pi * 2) * 100),
          top: (MediaQuery.of(context).size.height * rand.nextDouble()) + (cos(_controller.value * pi * 2) * 100),
          child: Container(
            width: size, height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isCyan ? Colors.cyanAccent : Colors.deepPurpleAccent).withOpacity(0.15),
            ),
          ),
        );
      }
    );
  }
}
