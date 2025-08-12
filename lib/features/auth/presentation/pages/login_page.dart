import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallinice/core/di/di.dart';
import 'package:wallinice/features/auth/auth.dart';
import 'package:wallinice/shared/routing/routing.dart';
import 'package:wallinice/shared/theme/theme.dart';
import 'package:wallinice/shared/utils/utils.dart';
import 'package:wallinice/shared/widgets/widgets.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = getIt<AuthCubit>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      _authCubit.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authCubit,
      child: SafeArea(
        maintainBottomViewPadding: true,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.zero,
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                previous.loginStatus != current.loginStatus,
            listener: (context, state) {
              if (state.loginStatus.isSuccess) {
                _authCubit.clearLoginStatus();
                context.router.goToMain();
              } else if (state.loginStatus.isError) {
                final errorMessage = state.loginStatus.error?.message ?? '';
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
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.proportionateWidth(25),
                  ),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: context.proportionateWidth(10),
                              top: context.screenHeight * 0.04,
                            ),
                            child: Image.asset(
                              'assets/images/ico.png',
                              fit: BoxFit.contain,
                              height: context.screenHeight / 4,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                Icons.wallpaper,
                                size: context.screenHeight / 4,
                                color: AppColors.accentColor,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              bottom: context.proportionateWidth(10),
                              top: context.screenHeight * 0.05,
                            ),
                            child: Text(
                              'Login', // TODO: Add to l10n
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          TextFormField(
                            decoration: customInputDecoration(
                              'Username or Email', // TODO: Add to l10n
                              context,
                            ),
                            controller: _emailController,
                            validator: Validators.usernameValidator,
                            style: Theme.of(context).textTheme.bodyLarge,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: context.proportionateWidth(15),
                          ),
                          TextFormField(
                            decoration: customInputDecoration(
                              'Password', // TODO: Add to l10n
                              context,
                            ),
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            validator: Validators.passwordValidator,
                            obscureText: true,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          _buildSignInButtons(),
                          SizedBox(
                            height: context.proportionateWidth(20),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?", // TODO: Add to l10n
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: InkWell(
                                  child: Text(
                                    'Create Account', // TODO: Add to l10n
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.accentColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  onTap: () {
                                    context.router.pushRegister();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 36,
                  left: 24,
                  child: _buildBackButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButtons() {
    return BlocSelector<AuthCubit, AuthState, bool>(
      selector: (state) => state.loginStatus.isLoading,
      builder: (context, isLoading) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: context.proportionateWidth(34),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CustomButton(
                text: 'VALIDATE', // TODO: Add to l10n
                processing: isLoading,
                color: AppColors.accentColor,
                onTap: _login,
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
        color: AppColors.accentColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          context.router.maybePop();
        },
      ),
    );
  }
}
