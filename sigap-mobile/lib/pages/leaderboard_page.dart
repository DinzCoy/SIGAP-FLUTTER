import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/common/premium_background.dart';
import '../widgets/common/glass_card.dart';
import '../services/gamification_service.dart';
import '../widgets/common/fade_in.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Halaman Leaderboard Gamifikasi IT Heroes SIGAP.
/// Menyajikan peringkat Top 3 dengan bingkai berkilau dan menampilkan
/// apresiasi berbasis keahlian spesifik (Badges) tanpa unsur merendahkan.
class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _leaderboard = [];

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    setState(() => _isLoading = true);
    final data = await GamificationService.fetchLeaderboard();
    if (mounted) {
      setState(() {
        _leaderboard = data ?? [];
        _isLoading = false;
      });
    }
  }

  /// Menampilkan lembar informasi (Sheet) berisi kamus penjelasan semua lencana/badges.
  void _showBadgesDictionary() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return GlassCard(
          borderRadius: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          margin: const EdgeInsets.only(top: 60),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Garis pemegang atas sheet
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.amber,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Kamus Lencana Penghargaan",
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                "Setiap lencana diberikan secara otomatis oleh sistem berdasarkan dedikasi dan keahlian nyata dari IT Guardian.",
                style: AppTextStyles.bodySmall.copyWith(
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const Divider(height: 24),

              _buildDictionaryItem(
                "⚡",
                "Speedrunner",
                "#EAB308",
                "Diberikan kepada teknisi yang menyelesaikan setidaknya 2 perbaikan dalam batas waktu SLA tanggapan dengan persentase di atas 75%.",
              ),
              const SizedBox(height: 16),
              _buildDictionaryItem(
                "🌐",
                "Network Guru",
                "#38BDF8",
                "Diberikan kepada pahlawan IT yang sukses menyelesaikan minimal 2 kendala koneksi, internet, wifi, router, atau kabel LAN.",
              ),
              const SizedBox(height: 16),
              _buildDictionaryItem(
                "🖥️",
                "Hardware Doctor",
                "#F47920",
                "Spesialisasi andalan dalam merawat dan mereparasi fisik perangkat keras komputer, printer, scanner, dan aset BMN lainnya.",
              ),
              const SizedBox(height: 16),
              _buildDictionaryItem(
                "🌟",
                "Rising Star",
                "#A855F7",
                "Bintang tangguh yang sedang melesat aktif menyelesaikan tiket kerusakan pertamanya bulan ini.",
              ),
              const SizedBox(height: 16),
              _buildDictionaryItem(
                "🛡️",
                "System Shield",
                "#22C55E",
                "Penghargaan loyalitas tinggi setelah sukses mengamankan stabilitas pelayanan IT minimal 5 laporan terselesaikan.",
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Mengerti",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDictionaryItem(
    String emoji,
    String title,
    String hexColor,
    String desc,
  ) {
    final color = Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(emoji, style: const TextStyle(fontSize: 20)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? color : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                desc,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 11.5,
                  height: 1.35,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: PremiumBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Dynamic premium AppBar
            SliverAppBar(
              pinned: true,
              expandedHeight: 110,
              backgroundColor: isDark
                  ? AppColors.canvasSoft.withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.85),
              elevation: 0,
              scrolledUnderElevation: 1,
              title: Text(
                "IT Guardian Leaderboard",
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  tooltip: 'Penjelasan Lencana',
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  onPressed: _showBadgesDictionary,
                ),
                const SizedBox(width: 12),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child: Text(
                      "Merayakan dedikasi & keahlian IT Guardian secara harmonis",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            if (_isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_leaderboard.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.sentiment_dissatisfied_rounded,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Belum ada data prestasi teknisi.",
                        style: AppTextStyles.titleMedium,
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- PODIUM HIGHLIGHT (Top 3) ---
                      _buildPodiumSection(),
                      const SizedBox(height: 24),

                      // --- DAFTAR HEROES LAIN (Rank 4+) ---
                      Text(
                        "Daftar IT Guardian Lainnya",
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _leaderboard.length > 3
                            ? _leaderboard.length - 3
                            : 0,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          // Indeks di leaderboard dimulai dari 3 (Peringkat 4)
                          final item = _leaderboard[index + 3];
                          return FadeIn(
                            delay: Duration(milliseconds: 100 * index),
                            child: _buildLeaderboardListItem(item),
                          );
                        },
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Membangun visualisasi Podium Top 3 (Emas, Perak, Perunggu)
  Widget _buildPodiumSection() {
    final top1 = _leaderboard.isNotEmpty ? _leaderboard[0] : null;
    final top2 = _leaderboard.length > 1 ? _leaderboard[1] : null;
    final top3 = _leaderboard.length > 2 ? _leaderboard[2] : null;

    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.stars_rounded, color: Colors.amber, size: 22),
              SizedBox(width: 8),
              Text(
                "Pemenang Bulan Ini",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // PERINGKAT 2 (Kiri)
              if (top2 != null) Expanded(child: _buildPodiumPod(top2, 2)),

              // PERINGKAT 1 (Tengah)
              if (top1 != null) Expanded(child: _buildPodiumPod(top1, 1)),

              // PERINGKAT 3 (Kanan)
              if (top3 != null) Expanded(child: _buildPodiumPod(top3, 3)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumPod(Map<String, dynamic> item, int rank) {
    final double avatarSize = rank == 1 ? 76.0 : (rank == 2 ? 60.0 : 54.0);
    final String name = item['name'] ?? 'T';
    final int xp = item['xp'] ?? 0;
    final int level = item['level'] ?? 1;

    // Aksen warna ring glowing
    final Color glowColor = rank == 1
        ? const Color(0xFFF59E0B) // Emas
        : (rank == 2
              ? const Color(0xFF94A3B8)
              : const Color(0xFFD97706)); // Perak & Perunggu

    final String rankCrown = rank == 1 ? "👑" : (rank == 2 ? "🥈" : "🥉");

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar dengan Glowing Ring
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: avatarSize + 8,
              height: avatarSize + 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withValues(alpha: 0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: glowColor,
                child: Padding(
                  padding: const EdgeInsets.all(2.5),
                  child:
                      item['photo_url'] != null &&
                          item['photo_url'].toString().isNotEmpty
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: item['photo_url'],
                            width: avatarSize,
                            height: avatarSize,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(color: Colors.white10),
                            errorWidget: (context, url, error) =>
                                _buildInitialsAvatar(name, avatarSize),
                          ),
                        )
                      : _buildInitialsAvatar(name, avatarSize),
                ),
              ),
            ),

            // Crown/Rank Badge
            Positioned(
              top: rank == 1 ? -16 : -10,
              child: Text(
                rankCrown,
                style: TextStyle(fontSize: rank == 1 ? 26 : 20),
              ),
            ),

            // Level Badge di bawah avatar
            Positioned(
              bottom: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Text(
                  "Lv. $level",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Nama & XP
        Text(
          name.trim().split(' ').first,
          style: TextStyle(
            fontWeight: rank == 1 ? FontWeight.w900 : FontWeight.bold,
            fontSize: rank == 1 ? 14 : 12.5,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          "$xp XP",
          style: AppTextStyles.microCap.copyWith(
            color: glowColor,
            fontWeight: FontWeight.w900,
            fontSize: rank == 1 ? 11 : 10,
          ),
        ),

        // Dynamic badges list for Top 3 (Show simple badge tags)
        if (item['earned_badges'] != null &&
            (item['earned_badges'] as List).isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Wrap(
              spacing: 3,
              runSpacing: 3,
              alignment: WrapAlignment.center,
              children: (item['earned_badges'] as List).take(2).map<Widget>((
                b,
              ) {
                final emoji = b['icon'] == 'zap'
                    ? '⚡'
                    : (b['icon'] == 'globe'
                          ? '🌐'
                          : (b['icon'] == 'monitor'
                                ? '🖥'
                                : (b['icon'] == 'star' ? '🌟' : '🛡️')));
                return Tooltip(
                  message: b['description'],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse(
                          b['color'].toString().replaceFirst('#', '0x1A'),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Color(
                          int.parse(
                            b['color'].toString().replaceFirst('#', '0x4D'),
                          ),
                        ),
                      ),
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 10)),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildInitialsAvatar(String name, double size) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: AppColors.canvas,
      child: Text(
        strtoupper(substr(name, 0, 1)),
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: size * 0.4,
          color: AppColors.primary,
        ),
      ),
    );
  }

  /// Membangun list item berperingkat di bawah Top 3 menggunakan GlassCard transparan
  Widget _buildLeaderboardListItem(Map<String, dynamic> item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String name = item['name'] ?? 'T';
    final int xp = item['xp'] ?? 0;
    final int level = item['level'] ?? 1;
    final String levelName = item['level_name'] ?? 'Junior support';
    final int progressPct = item['level_progress_pct'] ?? 0;
    final List badges = item['earned_badges'] ?? [];

    return GlassCard(
      borderRadius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Peringkat
          Container(
            width: 26,
            alignment: Alignment.center,
            child: Text(
              "#${item['rank']}",
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Avatar Bulat Kecil
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            backgroundImage:
                item['photo_url'] != null &&
                    item['photo_url'].toString().isNotEmpty
                ? CachedNetworkImageProvider(item['photo_url'])
                : null,
            child:
                item['photo_url'] == null ||
                    item['photo_url'].toString().isEmpty
                ? Text(
                    strtoupper(substr(name, 0, 1)),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                      fontSize: 13,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),

          // Detail Performa & Lencana
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),

                // Lencana Spesialisasi Positif
                if (badges.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: badges.map<Widget>((b) {
                        final color = Color(
                          int.parse(
                            b['color'].toString().replaceFirst('#', '0xFF'),
                          ),
                        );
                        final emoji = b['icon'] == 'zap'
                            ? '⚡'
                            : (b['icon'] == 'globe'
                                  ? '🌐'
                                  : (b['icon'] == 'monitor'
                                        ? '🖥'
                                        : (b['icon'] == 'star'
                                              ? '🌟'
                                              : '🛡️')));
                        return Tooltip(
                          message: b['description'],
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: color.withValues(alpha: 0.3),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 9.5),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  b['name'],
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                else
                  Text(
                    "Lv. $level - $levelName",
                    style: AppTextStyles.microCap.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Status Progress XP
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$xp XP",
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              // Tiny progress bar
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 60.0 * (progressPct / 100.0),
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Lv. $level",
                style: TextStyle(fontSize: 8.5, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper substring kustom untuk mencegah inkonsistensi string index
  String substr(String string, int start, int length) {
    if (string.length <= start) return '';
    if (string.length <= start + length) return string.substring(start);
    return string.substring(start, start + length);
  }

  // Helper uppercase kustom
  String strtoupper(String string) => string.toUpperCase();
}
