import 'package:flutter/material.dart';

class _SettingOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _SettingOption({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10), 
      child: Padding(
        padding: const EdgeInsets.all(8.0), 
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            CircleAvatar(
              radius: 25, 
              backgroundColor: const Color(
                0xFF3498DB,
              ),  
              child: Icon(
                icon,
                size: 30, 
                color: Colors.white
              ),
            ),
            const SizedBox(height: 4), 
            Text(
              label,
              style: const TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.bold,
                color: Colors.black87, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsModalContent extends StatelessWidget {
  final VoidCallback? onClose; 
  final VoidCallback? onTapSound;
  final VoidCallback? onTapMusic;
  final VoidCallback? onTapColor;

  const SettingsModalContent({
    Key? key,
    this.onClose,
    this.onTapSound,
    this.onTapMusic,
    this.onTapColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color cardBackgroundColor = Color(0xFFFFF8E1);

    const Color titleFillColor = Color(0xFFFFA07A);

    const Color titleOutlineColor = Color(0xFF808080);

    const Color closeButtonColor =
        Colors.redAccent; 

    return Stack(
      clipBehavior:
          Clip.none, 
      children: [
        Container(
          width: 400, 
          height: 250,
          padding: const EdgeInsets.fromLTRB(
            24,
            32,
            24,
            24,
          ), 
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(
              20,
            ), 
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, 
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    "Pengaturan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      foreground:
                          Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1.5
                            ..color = titleOutlineColor,
                    ),
                  ),
                  Text(
                    "Pengaturan",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: titleFillColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24), 
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceEvenly, 
                children: [
                  _SettingOption(
                    icon: Icons.volume_up, 
                    label: "Suara",
                    onTap: onTapSound,  
                  ),
                  _SettingOption(
                    icon: Icons.music_note, 
                    label: "Musik",
                    onTap: onTapMusic, 
                  ),
                  _SettingOption(
                    icon:
                        Icons
                            .color_lens, 
                    label: "Warna",
                    onTap: onTapColor, 
                  ),
                ],
              ),
            ],
          ),
        ),

        Positioned(
          top: -15,  
          right: -15, 
          child: GestureDetector(
            onTap: onClose, 
            child: CircleAvatar(
              radius: 18, 
              backgroundColor: closeButtonColor,
              child: const Icon(
                Icons.close, 
                size: 20, 
                color: Colors.white, 
              ),
            ),
          ),
        ),
      ],
    );
  }
}
