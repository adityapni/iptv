import 'package:flutter/material.dart';

class ErrorLoaded extends StatelessWidget {
  final String errorMsg;
  const ErrorLoaded({super.key, required this.errorMsg});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,

        ),
        child: Text(
          errorMsg,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
