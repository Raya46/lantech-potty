import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // Diperlukan untuk class Paint

class Header extends StatelessWidget {
  final VoidCallback?
  onTapBack; // Fungsi yang dipanggil saat tombol kembali diklik
  final VoidCallback?
  onTapSettings; // Fungsi yang dipanggil saat tombol pengaturan diklik
  final String title; // Judul yang ditampilkan di tengah

  const Header({
    Key? key,
    this.onTapBack,
    this.onTapSettings,
    this.title = "Pilih Level!", // Nilai default jika tidak disediakan
  }) : super(key: key);

  // Fungsi untuk menampilkan modal setting
  void _showSettingsModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pengaturan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.music_note),
                title: const Text('Musik'),
                trailing: Switch(
                  value: true, // Default value
                  onChanged: (value) {
                    // Logic untuk toggle musik
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.volume_up),
                title: const Text('Suara'),
                trailing: Switch(
                  value: true, // Default value
                  onChanged: (value) {
                    // Logic untuk toggle suara
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mendefinisikan warna berdasarkan gambar
    const Color buttonBackgroundColor = Color(
      0xFF3498DB,
    ); // Perkiraan warna biru untuk tombol lingkaran
    const Color buttonOutlineColor = Color(
      0xFF2C3E50,
    ); // Perkiraan warna outline tombol (biru tua/abu-abu)
    const Color textFillColor = Color(0xFFFFA07A);
    const Color textOutlineColor = Color(0xFF808080);

    return Container(
      height: 80.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      color: Colors.transparent,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: onTapBack,
            customBorder:
                const CircleBorder(), // Pastikan area tap dan riak berbentuk lingkaran
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: buttonOutlineColor, // Warna outline
                  width: 2.0, // Ketebalan outline
                ),
                color: buttonBackgroundColor, // Warna isi lingkaran
              ),
              padding: const EdgeInsets.all(
                8.0,
              ), // Padding di dalam lingkaran untuk ikon
              child: const Icon(
                Icons.arrow_back, // Ikon kembali
                size: 24, // Ukuran ikon, sesuaikan
                color: Colors.white, // Warna ikon
              ),
            ),
          ),

          // Teks Judul di Tengah dengan Stack untuk efek outline
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Text untuk outline (stroke)
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    foreground:
                        Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2.0
                          ..color = textOutlineColor,
                  ),
                ),
                // Text untuk fill
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textFillColor,
                  ),
                ),
              ],
            ),
          ),

          // Tombol Kanan (Pengaturan)
          InkWell(
            // Membuat lingkaran bisa diklik dengan efek riak
            onTap: () {
              // Panggil fungsi callback jika disediakan, atau tampilkan modal jika tidak
              if (onTapSettings != null) {
                onTapSettings!();
              } else {
                _showSettingsModal(context);
              }
            },
            customBorder:
                const CircleBorder(), // Pastikan area tap dan riak berbentuk lingkaran
            child: Container(
              // Container untuk membuat lingkaran dengan outline
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: buttonOutlineColor, // Warna outline
                  width: 2.0, // Ketebalan outline
                ),
                color: buttonBackgroundColor, // Warna isi lingkaran
              ),
              padding: const EdgeInsets.all(
                8.0,
              ), // Padding di dalam lingkaran untuk ikon
              child: const Icon(
                Icons.settings, // Ikon pengaturan (gear)
                size: 24, // Ukuran ikon, sesuaikan
                color: Colors.white, // Warna ikon
              ),
            ),
          ),
        ],
      ),
    );
  }
}
