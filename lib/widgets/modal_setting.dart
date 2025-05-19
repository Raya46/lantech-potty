import 'package:flutter/material.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/services/player_service.dart';

class _SettingOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  const _SettingOption({
    required this.icon,
    required this.label,
    this.onTap,
    this.isActive = false,
  });

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
              backgroundColor:
                  isActive ? Color(0xFF2ECC71) : const Color(0xFF3498DB),
              child: Icon(icon, size: 30, color: Colors.white),
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

class SettingsModalContent extends StatefulWidget {
  final VoidCallback? onClose;
  final VoidCallback? onTapSound;
  final VoidCallback? onTapMusic;

  const SettingsModalContent({
    Key? key,
    this.onClose,
    this.onTapSound,
    this.onTapMusic,
  }) : super(key: key);

  @override
  State<SettingsModalContent> createState() => _SettingsModalContentState();
}

class _SettingsModalContentState extends State<SettingsModalContent> {
  Player? _player;
  bool _isLoadingPlayer = true;
  bool _isUpdatingFocus = false;

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
  }

  Future<void> _loadPlayerData() async {
    setState(() {
      _isLoadingPlayer = true;
    });
    try {
      Player p = await getPlayer();
      if (mounted) {
        setState(() {
          _player = p;
          _isLoadingPlayer = false;
        });
      }
    } catch (e) {
      Player newPlayer = Player(null);
      newPlayer.isFocused = false;
      await savePlayer(newPlayer);
      if (mounted) {
        setState(() {
          _player = newPlayer;
          _isLoadingPlayer = false;
        });
      }
    }
  }

  Future<void> _toggleFocusMode() async {
    if (_isUpdatingFocus) return;

    if (_player != null) {
      final bool originalFocusValue = _player!.isFocused ?? false;

      setState(() {
        _isUpdatingFocus = true;
        _player!.isFocused = !originalFocusValue;
      });

      try {
        await updatePlayer(_player!);
      } catch (e) {
        if (mounted) {
          setState(() {
            _player!.isFocused = originalFocusValue;
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            _isUpdatingFocus = false;
          });
        }
      }
    } else {
      await _loadPlayerData();
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color cardBackgroundColor = Color(0xFFFFF8E1);
    const Color titleFillColor = Color(0xFFFFA07A);
    const Color titleOutlineColor = Color(0xFF808080);
    const Color closeButtonColor = Colors.redAccent;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 400,
          height: 250,
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              _isLoadingPlayer
                  ? CircularProgressIndicator()
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _SettingOption(
                        icon: Icons.volume_up,
                        label: "Suara",
                        onTap: widget.onTapSound,
                      ),
                      _SettingOption(
                        icon: Icons.music_note,
                        label: "Musik",
                        onTap: widget.onTapMusic,
                      ),
                      _SettingOption(
                        icon: Icons.center_focus_strong,
                        label: "Mode Fokus",
                        onTap:
                            _isLoadingPlayer || _isUpdatingFocus
                                ? null
                                : _toggleFocusMode,
                        isActive: _player?.isFocused ?? false,
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
            onTap: widget.onClose,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: closeButtonColor,
              child: const Icon(Icons.close, size: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
