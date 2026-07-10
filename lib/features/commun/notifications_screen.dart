import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _allRead = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.bg : AppTheme.bgLight;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final accentColor = isDark ? AppTheme.accent : AppTheme.accentLight;
    final goldColor = isDark ? AppTheme.gold : AppTheme.goldLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 6, 22, 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconBtn(
                        onTap: () => context.pop(),
                        icon: Icons.arrow_back_ios_new,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          fontFamily: 'Space Grotesk',
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => _allRead = true);
                      // showToast(context, 'Toutes les notifications sont marquées comme lues');
                    },
                    child: Text(
                      'Tout marquer lu',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: accentColor,
                        fontFamily: 'Space Grotesk',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _buildNotification(
                'Le collecteur Ibrahim arrive dans 15 min',
                'Il y a 2 min',
                accentColor,
                false,
              ),
              const SizedBox(height: 10),
              _buildNotification(
                '+25 points crédités — tri organique',
                'Aujourd\'hui, 09:14',
                goldColor,
                false,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => context.push('/suivi_signalement'),
                child: _buildNotification(
                  'Votre signalement a été traité',
                  'Hier, 17:40',
                  textColor.withValues(alpha: 0.35),
                  true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotification(
      String title, String time, Color dotColor, bool read) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.text : AppTheme.textLight;
    final cardColor = isDark ? AppTheme.card : AppTheme.cardLight;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: dotColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: read ? textColor.withValues(alpha: 0.3) : dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor.withValues(alpha: read ? 0.6 : 1),
                    fontFamily: 'Space Grotesk',
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w400,
                    color: textColor.withValues(alpha: 0.5),
                    fontFamily: 'Space Grotesk',
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
