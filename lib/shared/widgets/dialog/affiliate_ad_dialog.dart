import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AffiliateAdDialog extends StatefulWidget {
  final String affiliateUrl;
  final String imagePath;

  const AffiliateAdDialog({
    super.key,
    this.affiliateUrl =
        'https://www.facebook.com/profile.php?id=61562907176900',
    this.imagePath = 'assets/images/affiliate_ad.png',
  });

  @override
  State<AffiliateAdDialog> createState() => _AffiliateAdDialogState();
}

class _AffiliateAdDialogState extends State<AffiliateAdDialog> {
  int _countdown = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_countdown > 0) {
            _countdown--;
          } else {
            _timer?.cancel();
            _openAffiliateLink();
          }
        });
      }
    });
  }

  Future<void> _openAffiliateLink() async {
    final Uri url = Uri.parse(widget.affiliateUrl);
    if (await canLaunchUrl(url)) {
      bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(url, mode: LaunchMode.platformDefault);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _countdown == 0,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://scontent.fhan14-1.fna.fbcdn.net/v/t39.30808-6/468545225_122130434822430239_6873916394716162930_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=ekeg5QYczeQQ7kNvwEiirDQ&_nc_oc=Adkr_1UwFE1MmWR_izrJu22-swmeEGym21ssUx8CDUqyNYGqcDfb4gQIPmvafKxCA3I&_nc_zt=23&_nc_ht=scontent.fhan14-1.fna&_nc_gid=g_GD9V4AFhmPRLSzs2n96g&oh=00_AfofQ3Fv0_djjMoSKbb4U-_5b3vUYfHy0-8ZFXLLAXKEYg&oe=6964FC76',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title/Button
                  const Text(
                    'Like + Share',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _openAffiliateLink,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'MỞ ỨNG DỤNG FACEBOOK',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Countdown Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        size: 16,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _countdown > 0
                            ? 'Tự động mở sau $_countdown giây'
                            : 'Đang mở Facebook...',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_countdown == 0)
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
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
