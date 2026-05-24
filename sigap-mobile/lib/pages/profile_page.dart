import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/common/fade_in.dart';
import '../widgets/common/logout_dialog.dart';
import 'edit_profile_page.dart';
import 'change_password_page.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String email = '';
  String role = '';
  String phone = '';
  String nip = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('user_name') ?? 'Pengguna';
      email = prefs.getString('user_email') ?? 'email@bps.go.id';
      role = prefs.getString('user_role') ?? 'User';
      phone = prefs.getString('user_phone') ?? '-';
      nip = prefs.getString('user_nip') ?? '-';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      // Putih: agar celah sub-pixel antara SliverAppBar (ungu) dan
      // body tidak menampilkan warna primer yang "bocor".
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ─── HEADER ────────────────────────────────────────────────
          _ProfileSliverHeader(name: name, role: role),

          // ─── BODY (background putih menyambung dari header) ────────
          SliverToBoxAdapter(
            child: Transform.translate(
              // Geser 1px ke atas untuk menutup celah sub-pixel rendering.
              // Transform.translate aman karena tidak menggunakan margin.
              offset: const Offset(0, -1),
              child: Container(
                color: AppColors.background,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info Section
                      FadeIn(
                        delay: const Duration(milliseconds: 200),
                        child: _ProfileInfoSection(
                          email: email,
                          phone: phone,
                          nip: nip,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Settings Section
                      FadeIn(
                        delay: const Duration(milliseconds: 400),
                        child: _ProfileSettingsSection(
                          onEdit: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const EditProfilePage()),
                            );
                            if (result == true) _loadProfileData();
                          },
                          onChangePassword: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                          ),
                          onAppSettings: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SettingsPage()),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Logout Button
                      FadeIn(
                        delay: const Duration(milliseconds: 600),
                        child: _LogoutButton(onTap: () => LogoutDialog.show(context)),
                      ),

                      // Bottom padding (untuk nav bar)
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SLIVER HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileSliverHeader extends StatelessWidget {
  final String name;
  final String role;

  const _ProfileSliverHeader({required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    // Tinggi curve putih di bawah header
    const double curveHeight = 32.0;

    return SliverAppBar(
      pinned: true,
      expandedHeight: 280,
      backgroundColor: AppColors.primary,
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      leading: const SizedBox.shrink(),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          children: [
            // 1. Mesh gradient background
            Positioned.fill(
              child: CustomPaint(painter: HeaderMeshPainter()),
            ),

            // 2. Profile info — dipastikan tidak tertindih curve di bawah
            Positioned(
              left: 0,
              right: 0,
              // Beri ruang untuk curve di bawah agar tidak overlap
              bottom: curveHeight + 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      name,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Role Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      role.toUpperCase(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. "Zero-Leak" White Curve — menempel persis di bawah header
            //    Dibuat sedikit lebih lebar (left/right -2) untuk anti-aliasing gap
            Positioned(
              left: -2,
              right: -2,
              bottom: 0,
              child: Container(
                height: curveHeight,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INFO SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileInfoSection extends StatelessWidget {
  final String email;
  final String phone;
  final String nip;

  const _ProfileInfoSection({
    required this.email,
    required this.phone,
    required this.nip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text('Informasi Personal', style: AppTextStyles.titleMedium),
            ],
          ),
          const SizedBox(height: 20),
          _InfoTile(icon: Icons.email_outlined, label: 'Email', value: email),
          const _CustomDivider(),
          _InfoTile(icon: Icons.phone_outlined, label: 'Telepon', value: phone),
          const _CustomDivider(),
          _InfoTile(icon: Icons.badge_outlined, label: 'NIP / ID', value: nip),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SETTINGS SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileSettingsSection extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onChangePassword;
  final VoidCallback onAppSettings;

  const _ProfileSettingsSection({
    required this.onEdit,
    required this.onChangePassword,
    required this.onAppSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _SettingTile(
            icon: Icons.edit_note_rounded,
            title: 'Edit Profil',
            onTap: onEdit,
          ),
          const _CustomDivider(),
          _SettingTile(
            icon: Icons.lock_person_outlined,
            title: 'Ubah Password',
            onTap: onChangePassword,
          ),
          const _CustomDivider(),
          _SettingTile(
            icon: Icons.settings_suggest_outlined,
            title: 'Pengaturan Aplikasi',
            onTap: onAppSettings,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED SMALL WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: AppTextStyles.titleSmall),
      trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.ruby.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.ruby.withValues(alpha: 0.1), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: AppColors.ruby, size: 20),
            const SizedBox(width: 12),
            Text(
              'Keluar dari Aplikasi',
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.ruby,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: AppColors.border.withValues(alpha: 0.5),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HEADER MESH PAINTER
// ─────────────────────────────────────────────────────────────────────────────

class HeaderMeshPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Base gradient
    final rect = Offset.zero & size;
    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.primary,
        AppColors.primary.withValues(alpha: 0.85),
      ],
    ).createShader(rect);
    canvas.drawRect(rect, paint);

    // Decorative circles (mesh effect)
    paint.shader = null;
    paint.color = Colors.white.withValues(alpha: 0.04);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.15), 100, paint);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.7), 80, paint);

    paint.color = Colors.white.withValues(alpha: 0.03);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.05), 130, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
