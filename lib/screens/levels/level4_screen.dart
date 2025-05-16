import 'package:flutter/material.dart';
import 'package:toilet_training/models/step.dart';
import 'package:toilet_training/widgets/header.dart';
import 'package:toilet_training/widgets/background.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class LevelFourScreen extends StatefulWidget {
  const LevelFourScreen({super.key});

  @override
  State<LevelFourScreen> createState() => _LevelFourScreenState();
}

class _LevelFourScreenState extends State<LevelFourScreen> {
  List<ToiletStep> _steps = [];
  String currentGender = 'laki-laki';
  int currentStepIndex = 0;
  ToiletStep? _droppedStepOnTarget; // To store the step dropped on the target

  @override
  void initState() {
    super.initState();
    loadSteps();
  }

  @override
  Widget build(BuildContext context) {
    if (_steps.isEmpty) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentStep = _steps[currentStepIndex];
    final nextStep =
        (currentStepIndex + 1 < _steps.length)
            ? _steps[currentStepIndex + 1]
            : null;

    List<ToiletStep> options = [];
    if (nextStep != null) {
      options.add(nextStep);
      final others =
          _steps
              .where((s) => s.id != nextStep.id && s.id != currentStep.id)
              .toList();
      others.shuffle();
      options.addAll(others.take(2));
      options.shuffle();
    } else {
      // Handle level completion scenario - perhaps show different UI or options
      // For now, if no next step, options list will be empty, which might need UI handling.
    }

    return Scaffold(
      body: Background(
        gender: currentGender,
        child: Stack(
          children: [
            Column(
              children: [
                Header(title: "Level 4"), // Changed title to Level 4
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Apa Langkah Selanjutnya?",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B5A2B),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStepCard(currentStep),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Color(0xFFF9A6A6),
                                size: 60,
                              ),
                            ),
                            // Card kanan: drop area
                            DragTarget<ToiletStep>(
                              builder: (context, candidateData, rejectedData) {
                                if (_droppedStepOnTarget != null) {
                                  return _buildStepCard(_droppedStepOnTarget!);
                                }
                                return Container(
                                  width: 100,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color:
                                        candidateData.isNotEmpty
                                            ? Color(0xFFFFF6E6).withOpacity(0.7)
                                            : Color(0xFFFFF6E6),
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                      color:
                                          candidateData.isNotEmpty
                                              ? Color(0xFFF9A6A6)
                                              : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Ayo tarik\njawaban mu\nkesini",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4A2C2A),
                                        shadows: [
                                          Shadow(
                                            color: Colors.white,
                                            offset: Offset(1, 2),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              onWillAccept: (data) {
                                return _droppedStepOnTarget ==
                                    null; // Accept if target is empty
                              },
                              onAccept: (droppedStep) {
                                if (nextStep != null &&
                                    droppedStep.id == nextStep.id) {
                                  setState(() {
                                    _droppedStepOnTarget = droppedStep;
                                  });
                                  // Play success sound (optional)
                                  Future.delayed(Duration(seconds: 1), () {
                                    if (mounted) {
                                      if (currentStepIndex + 1 <
                                          _steps.length) {
                                        setState(() {
                                          currentStepIndex++;
                                          _droppedStepOnTarget =
                                              null; // Reset for next step
                                        });
                                      } else {
                                        // Handle game completion
                                        // For example, show a dialog or navigate
                                        showDialog(
                                          context: context,
                                          builder:
                                              (ctx) => AlertDialog(
                                                title: Text("Selamat!"),
                                                content: Text(
                                                  "Level 4 Selesai!",
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                      // Potentially navigate to next level or home
                                                      // Navigator.of(context).pop(); // Go back from Level 4
                                                    },
                                                    child: Text("OK"),
                                                  ),
                                                ],
                                              ),
                                        );
                                      }
                                    }
                                  });
                                } else {
                                  // Play incorrect sound/feedback (optional)
                                  // Item will snap back automatically if onWillAccept was true.
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20), // Added space
                        if (nextStep !=
                            null) // Only show options if there is a next step
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                options
                                    .map(
                                      (step) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: _buildOptionCard(step),
                                      ),
                                    )
                                    .toList(),
                          )
                        else
                          Padding(
                            // Message when level is complete before dialog
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _steps.isNotEmpty &&
                                      currentStepIndex >= _steps.length - 1 &&
                                      _droppedStepOnTarget != null
                                  ? "Kerja Bagus!"
                                  : "Pilih langkah yang benar!",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF8B5A2B),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(ToiletStep step) {
    return Container(
      width: 100,
      height: 140,
      decoration: BoxDecoration(
        color: Color(0xFFFFF6E6),
        borderRadius: BorderRadius.circular(
          40,
        ), // Increased for more rounded look if desired
      ),
      child: Center(
        // To ensure the inner card is centered if the outer one is larger
        child: Container(
          width: 100, // Match outer width
          height: 140, // Match outer height
          decoration: BoxDecoration(
            // color: Color(0xFFFFF6E6), // Inner container can have its own bg or be transparent
            border: Border.all(color: Color(0xFFFFB84A), width: 6),
            borderRadius: BorderRadius.circular(20), // Original border radius
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(step.image, fit: BoxFit.contain),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  step.name.toUpperCase(),
                  textAlign:
                      TextAlign.center, // Ensure text is centered if it wraps
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A2C2A),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackCard(ToiletStep step) {
    return Material(
      elevation: 4.0,
      color: Colors.transparent,
      child: Container(
        width: 100,
        height: 140,
        decoration: BoxDecoration(
          color: Color(0xFFFFF6E6).withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFFFFB84A), width: 4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(step.image, fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                step.name.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C2A),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(ToiletStep step) {
    return Draggable<ToiletStep>(
      data: step,
      feedback: _buildFeedbackCard(step),
      childWhenDragging: Container(
        width: 100,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 4),
        ),
      ),
      child: Container(
        width: 100,
        height: 140,
        decoration: BoxDecoration(
          color: Color(0xFFFFF6E6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFFFFB84A), width: 4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(step.image, fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                step.name.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C2A),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadSteps() async {
    final String response = await rootBundle.loadString(
      'lib/models/static/step-static.json',
    );
    final List<dynamic> data = json.decode(response);
    if (mounted) {
      // Check if the widget is still in the tree
      setState(() {
        _steps =
            data
                .map((e) => ToiletStep.fromJson(e))
                .where((step) => step.gender == currentGender && step.focus)
                .toList();
        // Ensure currentStepIndex is valid after loading steps
        if (_steps.isEmpty) {
          currentStepIndex = 0;
        } else {
          currentStepIndex = currentStepIndex.clamp(0, _steps.length - 1);
        }
      });
    }
  }
}
