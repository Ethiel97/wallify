import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wallinice/core/di/di.dart';
import 'package:wallinice/features/auth/auth.dart';
import 'package:wallinice/shared/routing/routing.dart';
import 'package:wallinice/shared/theme/theme.dart';
import 'package:wallinice/shared/utils/utils.dart';
import 'package:wallinice/shared/widgets/widgets.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = getIt<AuthCubit>();

    _usernameController.addListener(() {
      setState(() {}); // Update UI when username changes
    });
    _emailController.addListener(() {
      setState(() {}); // Update UI when email changes
    });
    _passwordController.addListener(() {
      setState(() {}); // Update UI when password changes
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      _authCubit.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _usernameController.text.trim(),
      );
    }
  }

  bool get isSubmitButtonEnabled =>
      _usernameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      !_authCubit.state.registerStatus.isLoading;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authCubit,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.zero,
          child: AppBar(
            elevation: 0,
            backgroundColor: AppColors.primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        body: BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.registerStatus != current.registerStatus,
          listener: (context, state) {
            if (state.registerStatus.isSuccess) {
              _authCubit.clearRegisterStatus();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.registerStatus.value ?? 'Registration successful',
                  ),
                  // TODO: Add to l10n
                  backgroundColor: AppColors.successColor,
                  duration: const Duration(seconds: 2),
                ),
              );
              // Redirect to main app (landing page) like in original
              context.router.goToMain();
            } else if (state.registerStatus.isError) {
              final errorMessage = state.registerStatus.error?.message ?? '';
              final userFriendlyMessage =
                  ErrorMessageMapper.mapErrorToUserFriendlyMessage(
                errorMessage,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(userFriendlyMessage),
                  backgroundColor: AppColors.errorColor,
                ),
              );
            }
          },
          child: ColoredBox(
            color: Colors.white,
            child: Stack(
              children: [
                const CurvedContainer(),
                ListView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.proportionateWidth(25),
                    vertical: context.proportionateHeight(12),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: context.proportionateWidth(8),
                        top: context.screenHeight * 0.08,
                      ),
                      child: Image.asset(
                        'assets/images/ico.png',
                        fit: BoxFit.contain,
                        height: 60,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.wallpaper,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        bottom: context.proportionateWidth(30),
                        top: context.proportionateWidth(0),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Create Account', // TODO: Add to l10n
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 4),
                                  blurRadius: 8,
                                  color: AppColors.darkColor
                                      .withValues(alpha: 0.1),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(25),
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: customInputDecoration(
                                    prefix: const Icon(Iconsax.user),
                                    'Username', // TODO: Add to l10n
                                    context,
                                    contentPadding: 12,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  controller: _usernameController,
                                  validator: Validators.usernameValidator,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppColors.darkColor,
                                      ),
                                ),
                                SizedBox(
                                  height: context.proportionateWidth(4),
                                ),
                                TextFormField(
                                  decoration: customInputDecoration(
                                    prefix: const Icon(Iconsax.user_octagon),
                                    'Email', // TODO: Add to l10n
                                    context,
                                    contentPadding: 12,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  controller: _emailController,
                                  validator: Validators.emailValidator,
                                  keyboardType: TextInputType.emailAddress,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppColors.darkColor,
                                      ),
                                ),
                                SizedBox(
                                  height: context.proportionateWidth(4),
                                ),
                                TextFormField(
                                  decoration: customInputDecoration(
                                    prefix: const Icon(Iconsax.password_check),
                                    'Password', // TODO: Add to l10n
                                    context,
                                    contentPadding: 12,
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppColors.darkColor,
                                      ),
                                  controller: _passwordController,
                                  validator: Validators.passwordValidator,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true,
                                ),
                                SizedBox(
                                  height: context.proportionateWidth(40),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: context.proportionateHeight(150),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ', // TODO: Add to l10n
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.darkColor,
                                  ),
                        ),
                        InkWell(
                          child: Text(
                            'Login', // TODO: Add to l10n
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.accentColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          onTap: () {
                            context.router.pushLogin();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 36,
                  left: 24,
                  child: _buildBackButton(),
                ),
                Positioned(
                  bottom: 12,
                  left: 50,
                  right: 50,
                  child: _buildRegisterButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return BlocSelector<AuthCubit, AuthState, bool>(
      selector: (state) => state.registerStatus.isLoading,
      builder: (context, isLoading) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: context.proportionateWidth(20),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CustomButton(
                text: 'REGISTER',
                // TODO: Add to l10n
                color: AppColors.accentColor,
                processing: isLoading,
                enabled: isSubmitButtonEnabled,
                onTap: _register,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBackButton() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.accentColor,
        ),
        onPressed: () {
          context.router.maybePop();
        },
      ),
    );
  }
}
