import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cart/cart_bloc.dart';
import '../../logic/login/login_bloc.dart';
import '../../logic/login/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginBloc>().add(
            LoginSubmitEvent(emailCtrl.text.trim(), passCtrl.text),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state.success) {
                    context.read<CartBloc>().add(LoadCartEvent());
                    Navigator.pushReplacementNamed(context, '/sessions');
                  }
                  if (state.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error!),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo/logo.png',
                            height: 150,
                          ),
                          // App branding
                          const SizedBox(height: 30),
                          Text(
                            'Sign in to continue',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.white10, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.6),
                                  blurRadius: 30,
                                  offset: const Offset(0, 18),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _StyledTextField(
                                  controller: emailCtrl,
                                  label: 'Email',
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Email is required'
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                _StyledTextField(
                                  controller: passCtrl,
                                  label: 'Password',
                                  obscureText: true,
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Password is required'
                                      : null,
                                ),
                                const SizedBox(height: 20),
                                if (state.loading) ...[
                                  const LinearProgressIndicator(
                                    minHeight: 2,
                                    color: Colors.white,
                                    backgroundColor: Colors.white24,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                                _PrimaryButton(
                                  text: 'Login',
                                  onPressed: state.loading ? null : _submit,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),
                          // Tiny footer
                          Text(
                            'Powered by Firebase Auth',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white38,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Minimal black & white text field
class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _StyledTextField({
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF111111),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
        ),
      ),
    );
  }
}

/// Minimal full-width black button with white text
class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const _PrimaryButton({required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
