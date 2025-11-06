import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_model/time_picker_view_model.dart';
import '../widgets/circular_time_picker.dart';

class TimePickerScreen extends ConsumerWidget {
  const TimePickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(timePickerViewModelProvider);
    final notifier = ref.read(timePickerViewModelProvider.notifier);

    final selectedHour = viewModel["hour"]!;
    final selectedMinute = viewModel["minute"]!;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.9),
                  blurRadius: 20,
                  offset: const Offset(-8, -8),
                ),
                BoxShadow(
                  color: const Color(0xFFD1D9E6).withOpacity(0.6),
                  blurRadius: 20,
                  offset: const Offset(8, 8),
                ),
              ],
            ),
            child: SizedBox(
              height: 360,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  _buildHeader(context, notifier),
                  Positioned(
                    top: 40,
                    child: CircularTimePicker(
                      selectedHour: selectedHour,
                      selectedMinute: selectedMinute,
                      onTimeChanged: notifier.setTime,
                    ),
                  ),
                  _buildContinueButton(selectedHour, selectedMinute),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TimePickerViewModel notifier) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.close, size: 28, color: Color(0xFF4A5568)),
              onPressed: () => Navigator.pop(context),
            ),
            const Text(
              'Select travel time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A5568),
              ),
            ),
            TextButton(
              onPressed: notifier.resetTime,
              child: const Text(
                'Reset',
                style: TextStyle(
                  color: Color(0xFF4A5568),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(int hour, int minute) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        width: double.infinity,
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFB366), Color(0xFFFF9933)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFFF9933).withOpacity(0.4),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              debugPrint(
                'Selected Time: ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
              );
            },
            child: const Center(
              child: Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
