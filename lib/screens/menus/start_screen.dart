import 'package:flutter/material.dart';
import 'package:toilet_training/screens/menus/choose_gender_screen.dart';
import 'package:toilet_training/widgets/background.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        gender: 'male', // Default gender adalah laki-laki
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Sisi Kiri: Ilustrasi
            Expanded(
              flex: 3, // Beri lebih banyak ruang untuk ilustrasi
              child: Container(
                padding: const EdgeInsets.only(bottom: 0),
                child: Image.asset(
                  'lib/assets/images/male-goto-toilet.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Sisi Kanan: Teks dan Tombol
            Expanded(
              flex: 3, // Beri ruang yang lebih kecil untuk teks
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Teks "APLIKASI INTERAKTIF"
                    Stack(
                      children: [
                        // Outline text
                        Text(
                          "APLIKASI INTERAKTIF",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            foreground:
                                Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1.5
                                  ..color = const Color(0xFF4A2C2A),
                          ),
                        ),
                        // Fill text
                        Text(
                          "APLIKASI INTERAKTIF",
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFA07A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8), // Spasi antar baris teks
                    // Teks "POTTYFUN KID'S"
                    Stack(
                      children: [
                        // Outline text
                        Text(
                          "POTTYFUN KID'S",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            foreground:
                                Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1.5
                                  ..color = const Color(0xFF4A2C2A),
                          ),
                        ),
                        // Fill text
                        Text(
                          "POTTYFUN KID'S",
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00FFFF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20), // Spasi antara teks dan tombol
                    // Tombol Play (Bentuk Lingkaran)
                    Padding(
                      padding: const EdgeInsets.only(right: 100.0),
                      child: Center(
                        child: GestureDetector(
                          // Menggunakan GestureDetector untuk area tap kustom
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                opaque:
                                    false, // Jika ingin transparan saat navigasi
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const ChooseGenderScreen(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            // Menggunakan CircleAvatar untuk latar belakang lingkaran
                            radius: 35, // Sesuaikan ukuran lingkaran
                            backgroundColor: const Color(
                              0xFF52AACA,
                            ), // Warna lingkaran (sama dengan latar bawah)
                            child: const Icon(
                              Icons.play_arrow,
                              size: 45, // Sesuaikan ukuran ikon play
                              color: Colors.white, // Warna ikon play
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
