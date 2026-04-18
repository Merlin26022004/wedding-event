import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'rsvp_screen.dart';

const Color kOliveGreen = Color(0xFF6B7A57);
const Color kCreamBg = Color(0xFFF7F4EF);
const Color kDarkText = Color(0xFF4A4E41);

class InviteScreen extends StatefulWidget {
  const InviteScreen({Key? key}) : super(key: key);

  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;
  final DateTime _weddingDate = DateTime(2026, 8, 30, 12, 0, 0);

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeLeft();
    });
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    if (_weddingDate.isAfter(now)) {
      setState(() {
        _timeLeft = _weddingDate.difference(now);
      });
    } else {
      if (_timeLeft != Duration.zero) {
        setState(() {
          _timeLeft = Duration.zero;
        });
        _timer.cancel();
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _launchMapsUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open map.')));
      }
    }
  }

  void _showRsvpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RsvpPopup();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCreamBg,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            // 1. Envelope Header
            ClipPath(
              clipper: EnvelopeClipper(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 80, bottom: 80),
                color: kOliveGreen,
                child: Column(
                  children: [
                    Text(
                      "John\n&\nCarmel",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        fontSize: 55,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "30.08.2026",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            // 2. Main Image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(10),
                
                child: Image.asset(
                  'assets/couple.png',
                  fit: BoxFit.cover,
                  height: 380,
                  width: double.infinity,
                ),
              ),
            ),

            const SizedBox(height: 50),

            // 3. Countdown Widget (Green Box)
            Container(
              width: double.infinity,
              color: kOliveGreen,
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Column(
                children: [
                  const Text(
                    "SAVE THE DATE",
                    style: TextStyle(
                      fontFamily: 'serif',
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDateUnit("AUG"),
                      const SizedBox(width: 15),
                      const Text(
                        "30",
                        style: TextStyle(
                          fontFamily: 'serif',
                          color: Colors.white,
                          fontSize: 55,
                        ),
                      ),
                      const SizedBox(width: 15),
                      _buildDateUnit("2026"),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "COUNTDOWN",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTimeUnit(_timeLeft.inDays, "Days"),
                      const Text(":", style: TextStyle(color: Colors.white, fontSize: 24)),
                      _buildTimeUnit(_timeLeft.inHours.remainder(24), "Hrs"),
                      const Text(":", style: TextStyle(color: Colors.white, fontSize: 24)),
                      _buildTimeUnit(_timeLeft.inMinutes.remainder(60), "Min"),
                      const Text(":", style: TextStyle(color: Colors.white, fontSize: 24)),
                      _buildTimeUnit(_timeLeft.inSeconds.remainder(60), "Sec"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // 4. Ceremony Details
            const Icon(Icons.church_outlined, color: kOliveGreen, size: 35),
            const SizedBox(height: 15),
            const Text(
              "Religious Ceremony",
              style: TextStyle(
                fontFamily: 'serif',
                fontStyle: FontStyle.italic,
                fontSize: 28,
                color: kDarkText,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "11:30 AM\nMount Carmel Church\nChathiath",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 25),
            OutlinedButton(
              onPressed: () => _launchMapsUrl("https://www.google.com/maps/search/?api=1&query=Mount+Carmel+Church,+Chathiath,+Kochi,+Kerala"),
              style: OutlinedButton.styleFrom(
                foregroundColor: kOliveGreen,
                side: const BorderSide(color: kOliveGreen, width: 1.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text("View Location", style: TextStyle(letterSpacing: 1)),
            ),

            const SizedBox(height: 60),

            // 5. Reception Details
            const Icon(Icons.wine_bar_outlined, color: kOliveGreen, size: 35),
            const SizedBox(height: 15),
            const Text(
              "Reception",
              style: TextStyle(
                fontFamily: 'serif',
                fontStyle: FontStyle.italic,
                fontSize: 28,
                color: kDarkText,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "12:30 PM\nCarmel Hall\nPachalam, Kochi",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 25),
            OutlinedButton(
              onPressed: () => _launchMapsUrl("https://www.google.com/maps/place/Carmel+Hall/@9.9914413,76.279609,17z/data=!4m10!1m2!2m1!1sCarmel+Hall,+Pachalam,+Ernakulam,+Kerala!3m6!1s0x3b080d5cc431d5ab:0xd606c141305a14ae!8m2!3d9.9914413!4d76.2817977!15sCihDYXJtZWwgSGFsbCwgUGFjaGFsYW0sIEVybmFrdWxhbSwgS2VyYWxhkgEEaGFsbOABAA!16s%2Fg%2F1q5bkk9nj?entry=ttu&g_ep=EgoyMDI2MDQxNS4wIKXMDSoASAFQAw%3D%3D"),
              style: OutlinedButton.styleFrom(
                foregroundColor: kOliveGreen,
                side: const BorderSide(color: kOliveGreen, width: 1.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text("View Location", style: TextStyle(letterSpacing: 1)),
            ),

            const SizedBox(height: 70),

            // 6. Confirmation / RSVP
            Container(
              width: double.infinity,
              color: kOliveGreen,
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Column(
                children: [
                  const Icon(Icons.favorite_border, color: Colors.white, size: 35),
                  const SizedBox(height: 20),
                  const Text(
                    "Confirmation",
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "We kindly request you to confirm your\nattendance to help us prepare.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 35),
                  ElevatedButton(
                    onPressed: _showRsvpDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      "Click Here",
                      style: TextStyle(
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
      ),
    );
  }

  Widget _buildDateUnit(String val) {
    return Column(
      children: [
        Container(width: 40, height: 1.5, color: Colors.white54),
        const SizedBox(height: 8),
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 13, letterSpacing: 2)),
        const SizedBox(height: 8),
        Container(width: 40, height: 1.5, color: Colors.white54),
      ],
    );
  }

  Widget _buildTimeUnit(int val, String label) {
    return Column(
      children: [
        Text(
          val.toString().padLeft(2, '0'),
          style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 1.5),
        )
      ],
    );
  }
}

class EnvelopeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}