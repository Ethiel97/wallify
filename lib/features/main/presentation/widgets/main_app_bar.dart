import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wallinice/features/auth/auth.dart';
import 'package:wallinice/features/settings/settings.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        // Top left user button
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 52,
              left: 10,
            ),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    if (state.user()?.isAuthenticated ?? false) {
                      _showAuthenticatedUserBottomSheet(
                        context,
                        state.user.data,
                      );
                    } else {
                      _showGuestUserBottomSheet(context);
                    }
                  },
                  icon: Icon(
                    Iconsax.user_octagon,
                    size: 28,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                );
              },
            ),
          ),
        ),

        // Top right theme toggle
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 52,
              right: 10,
            ),
            child: IconButton(
              onPressed: () {
                context.read<SettingsCubit>().toggleThemeMode();
              },
              icon: Icon(
                theme.brightness == Brightness.dark
                    ? Iconsax.sun_1
                    : Iconsax.moon,
                size: 28,
                color: theme.iconTheme.color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showGuestUserBottomSheet(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.secondary,
              radius: 50,
              child: Icon(
                Iconsax.user,
                size: 40,
                color: theme.colorScheme.onSecondary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Guest User',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to save your favorite wallpapers',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyLarge?.color?.withValues(
                  alpha: .7,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.router.back();
                context.router.pushNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Sign In',
                style: theme.textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                context.router.back();
                context.router.pushNamed('/register');
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAuthenticatedUserBottomSheet(BuildContext context, User user) {
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.secondary,
              radius: 50,
              child: Text(
                user.username?.toUpperCase().substring(0, 1) ?? 'U',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              user.username ?? 'User',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.user,
                  color: theme.textTheme.bodyLarge?.color,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    user.email ?? 'No email',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () {
                context.router.back();
                context.read<AuthCubit>().signOut();
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Logout'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.router.back();
                // Show confirmation dialog for account deletion
                _showDeleteAccountDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.router.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.router.back();
              // TODO: Implement account deletion
              context.read<AuthCubit>().signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
