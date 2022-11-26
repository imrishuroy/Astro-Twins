import '/constants/constants.dart';
import 'package:flutter/material.dart';

class ProgressContainer extends StatelessWidget {
  final int progress;

  const ProgressContainer({
    Key? key,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _canvas = MediaQuery.of(context).size;
    print('Sizes --- ${(_canvas.width - 25) / 11} ');
    final _progressSize = (_canvas.width - 68) / 10;
    return Column(
      children: [
        Container(
          height: 9.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xffEEEEEE),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            children: [
              Container(
                height: 9.0,
                width: _progressSize * progress,
                decoration: BoxDecoration(
                  color: Contants.primaryColor,
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        Center(
          child: Text(
            '${progress * 10} % Completed',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
