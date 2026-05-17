import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Header profil: avatar inisial + nama + badge role.
class ProfileHeader extends StatelessWidget {
  final String name;
  final String role;

  const ProfileHeader({super.key, required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.only(top: 20, bottom: 40),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(name, style: AppTextStyles.headlineSmall.copyWith(color: Colors.white)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(role, style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

/// Card informasi profil: email, telepon, NIP.
class ProfileInfoCard extends StatelessWidget {
  final String email;
  final String phone;
  final String nip;

  const ProfileInfoCard({
    super.key,
    required this.email,
    required this.phone,
    required this.nip,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Informasi Profil', style: AppTextStyles.titleLarge),
            const SizedBox(height: 20),
            _InfoRow(icon: Icons.email_outlined, label: 'Email', value: email),
            const Divider(height: 30),
            _InfoRow(icon: Icons.phone_outlined, label: 'Nomor Telepon', value: phone),
            const Divider(height: 30),
            _InfoRow(icon: Icons.badge_outlined, label: 'NIP / ID', value: nip),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text(value.isEmpty ? '-' : value, style: AppTextStyles.titleMedium),
            ],
          ),
        ),
      ],
    );
  }
}

/// Card aksi profil: edit profil, ubah password, pengaturan.
class ProfileActionCard extends StatelessWidget {
  final List<ProfileActionItem> items;

  const ProfileActionCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(items[i].icon, color: AppColors.textPrimary, size: 20),
              ),
              title: Text(items[i].title, style: AppTextStyles.titleSmall),
              trailing: const Icon(Icons.chevron_right, color: AppColors.textHint),
              onTap: items[i].onTap,
            ),
          ],
        ],
      ),
    );
  }
}

class ProfileActionItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileActionItem({required this.icon, required this.title, required this.onTap});
}
