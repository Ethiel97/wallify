import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallinice/features/auth/auth.dart';
import 'package:wallinice/features/main/main.dart';
import 'package:wallinice/shared/routing/routing.dart';

class NavItem extends StatelessWidget {
  const NavItem({
    required this.icon,
    required this.index,
    super.key,
  });

  final IconData icon;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        final isSelected = currentIndex == index;

        return AnimatedScale(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(milliseconds: 500),
          scale: isSelected ? 1.02 : 0.9,
          child: AnimatedContainer(
            curve: Curves.fastLinearToSlowEaseIn,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .08),
                  offset: const Offset(0, 20),
                  blurRadius: 40,
                  spreadRadius: 20,
                ),
              ],
              borderRadius: BorderRadius.circular(160),
              color: isSelected
                  ? theme.brightness == Brightness.dark
                      ? theme.textTheme.bodyLarge?.color
                      : Colors.white
                  : theme.colorScheme.onSurface.withValues(alpha: .9),
            ),
            duration: const Duration(milliseconds: 300),
            child: isSelected
                ? ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        theme.primaryColor,
                        theme.colorScheme.secondary,
                      ],
                      tileMode: TileMode.mirror,
                    ).createShader(bounds),
                    child: _buildIconButton(context, isSelected),
                  )
                : _buildIconButton(context, isSelected),
          ),
        );
      },
    );
  }

  Widget _buildIconButton(BuildContext context, bool isSelected) {
    final theme = Theme.of(context);
    return IconButton(
      icon: Icon(
        icon,
        size: isSelected ? 32 : 24,
        color: theme.colorScheme.surface.withValues(alpha: .9),
      ),
      onPressed: () {
        // Check if trying to access favorites (index 2) without authentication
        if (index == 2) {
          final authState = context.read<AuthCubit>().state;
          if (!(authState.user()?.isAuthenticated ?? false)) {
            // Redirect to login instead of navigating to favorites
            context.router.pushNamed(AppRoutes.login);
            return;
          }
        }

        // Navigate to the selected tab
        context.read<NavigationCubit>().navigateToTab(index);
      },
    );
  }
}
