import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:next_talents_working_app/theme.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(70)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.electricBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: AppColors.accent,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Next Talents',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
              const Spacer(),
              if (!isMobile)
                Row(
                  children: [
                    _NavItem(
                      title: 'Home',
                      onTap: () => Navigator.pushNamed(context, '/'),
                    ),
                    const SizedBox(width: 20),
                    _NavItem(
                      title: 'Wie es funktioniert',
                      onTap:
                          () => Navigator.pushNamed(context, '/how-it-works'),
                    ),
                    const SizedBox(width: 20),
                    _NavItem(
                      title: 'Kontakt',
                      onTap: () => Navigator.pushNamed(context, '/contact'),
                    ),
                    const SizedBox(width: 32),
                    if (user == null) ...[
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.electricBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Login'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed:
                            () => Navigator.pushNamed(context, '/register'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.electricBlue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Registrieren'),
                      ),
                    ] else ...[
                      PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'profil') {
                            Navigator.pushNamed(context, '/bewerberProfil');
                          } else if (value == 'logout') {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (_) => false,
                            );
                          }
                        },
                        itemBuilder:
                            (context) => [
                              const PopupMenuItem(
                                value: 'profil',
                                child: Text('Profil'),
                              ),
                              const PopupMenuItem(
                                value: 'logout',
                                child: Text('Logout'),
                              ),
                            ],
                        child: CircleAvatar(
                          backgroundColor: AppColors.electricBlue,
                          child: Text(
                            user.displayName != null &&
                                    user.displayName!.isNotEmpty
                                ? user.displayName![0].toUpperCase()
                                : 'U',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              if (isMobile)
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => const _MobileDrawer(),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _NavItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(title, style: const TextStyle(fontSize: 18)),
    );
  }
}

class _MobileDrawer extends StatelessWidget {
  const _MobileDrawer();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DrawerItem(
              title: 'Home',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/');
              },
            ),
            _DrawerItem(
              title: 'Wie es funktioniert',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/how-it-works');
              },
            ),
            _DrawerItem(
              title: 'Kontakt',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/contact');
              },
            ),
            const SizedBox(height: 24),
            if (user == null) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.electricBlue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(40),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/register');
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                ),
                child: const Text('Registrieren'),
              ),
            ] else ...[
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.electricBlue,
                  child: Text(
                    user.displayName != null && user.displayName!.isNotEmpty
                        ? user.displayName![0].toUpperCase()
                        : 'U',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(user.displayName ?? 'Benutzer'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/bewerberProfil');
                },
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                ),
                child: const Text('Logout'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: onTap,
        child: Text(title, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
