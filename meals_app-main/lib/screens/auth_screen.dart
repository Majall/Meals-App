import 'package:flutter/material.dart';
import 'package:meals_app/theme/app_theme.dart';
import 'package:meals_app/widgets/app_section_header.dart';
import 'package:meals_app/widgets/app_text_field.dart';
import 'package:meals_app/widgets/glass_app_bar.dart';
import 'package:meals_app/widgets/premium_card.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: GlassAppBar(
        title: _isLogin ? 'Welcome back' : 'Create your account',
        subtitle: _isLogin
            ? 'Sign in to continue your premium journey.'
            : 'Join Meals App and unlock curated experiences.',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          PremiumCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSectionHeader(
                  title: _isLogin ? 'Sign in' : 'Create account',
                  subtitle: _isLogin
                      ? 'Access saved meals, favorites, and insights.'
                      : 'Build a personalized meal experience.',
                  padding: EdgeInsets.zero,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _isLogin
                      ? const SizedBox.shrink()
                      : Column(
                          key: const ValueKey('name-field'),
                          children: [
                            AppTextField(
                              label: 'Full name',
                              controller: _nameController,
                              hintText: 'Jordan Lee',
                              textInputAction: TextInputAction.next,
                              prefixIcon: Icons.person_outline,
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ],
                        ),
                ),
                AppTextField(
                  label: 'Email address',
                  controller: _emailController,
                  hintText: 'you@company.com',
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.mail_outline,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                  hintText: '••••••••',
                  prefixIcon: Icons.lock_outline,
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(_isLogin ? 'Sign in' : 'Create account'),
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.alternate_email),
                  label: Text(
                    _isLogin ? 'Continue with Google' : 'Sign up with Google',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin
                          ? 'New to Meals App?'
                          : 'Already have an account?',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      child: Text(_isLogin ? 'Create account' : 'Sign in'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PremiumCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure & premium',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'We use enterprise-grade security, personalized curation, and intelligent recommendations.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
