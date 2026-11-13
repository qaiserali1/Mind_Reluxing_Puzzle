import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../painters/sand_painter.dart';
import '../providers/garden_provider.dart';
import '../services/community_service.dart';
import '../services/haptic_service.dart';
import 'premium_screen.dart';

/// Community Gallery screen presenting moderated creations from Zen practitioners worldwide.
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<CommunityPatternItem> _patterns = [];
  bool _isLoading = true;
  final Set<String> _likedIds = {};

  @override
  void initState() {
    super.initState();
    _loadCommunity();
  }

  Future<void> _loadCommunity() async {
    setState(() => _isLoading = true);
    final items = await CommunityService.fetchPatterns();
    if (mounted) {
      setState(() {
        _patterns = items;
        _isLoading = false;
      });
    }
  }

  void _onLike(CommunityPatternItem item) {
    if (_likedIds.contains(item.id)) return;
    HapticService.lightTap();
    setState(() {
      _likedIds.add(item.id);
    });
    CommunityService.likePattern(item.id);
  }

  void _onReport(CommunityPatternItem item) {
    HapticService.softPulse();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Report Pattern',
          style: GoogleFonts.cormorantGaramond(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Inappropriate content', 'Spam', 'Offensive design'].map((reason) {
            return ListTile(
              title: Text(reason, style: GoogleFonts.inter(fontSize: 14)),
              onTap: () {
                CommunityService.reportPattern(item.id, reason);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thank you. Content reported for review.')),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = context.watch<GardenProvider>().isPremium;
    final displayPatterns = isPremium ? _patterns : _patterns.take(5).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Community Zen',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : RefreshIndicator(
              color: AppColors.accent,
              onRefresh: _loadCommunity,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: displayPatterns.length,
                    itemBuilder: (context, index) {
                      final item = displayPatterns[index];
                      final isLiked = _likedIds.contains(item.id);
                      final patternTheme = SandTheme.getById(item.theme);

                      return Container(
                        decoration: BoxDecoration(
                          color: patternTheme.sandBase,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: patternTheme.borderLight),
                          boxShadow: [
                            BoxShadow(
                              color: patternTheme.sandShadow.withOpacity(0.2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Thumbnail image or programmatic render
                              if (item.base64Thumbnail != null)
                                Image.memory(
                                  base64Decode(item.base64Thumbnail!),
                                  fit: BoxFit.cover,
                                )
                              else
                                CustomPaint(
                                  painter: SandPainter(
                                    strokes: item.strokes,
                                    grains: const [],
                                    theme: patternTheme,
                                  ),
                                ),

                              // Bottom info bar overlay
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.65),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.authorName,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => _onLike(item),
                                        child: Row(
                                          children: [
                                            Icon(
                                              isLiked
                                                  ? Icons.favorite_rounded
                                                  : Icons.favorite_border_rounded,
                                              size: 16,
                                              color: isLiked ? Colors.redAccent : Colors.white70,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${item.likes + (isLiked ? 1 : 0)}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Report flag (top right)
                              Positioned(
                                top: 6,
                                right: 6,
                                child: IconButton(
                                  icon: const Icon(Icons.flag_outlined, size: 16, color: Colors.black38),
                                  onPressed: () => _onReport(item),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Free tier upsell
                  if (!isPremium && _patterns.length > 5) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.all_inclusive_rounded, size: 32, color: AppColors.accent),
                          const SizedBox(height: 8),
                          Text(
                            'Explore Endless Calm',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Unlock full community access and share your own designs with Rake Premium.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const PremiumScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text('Unlock Community'),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}

