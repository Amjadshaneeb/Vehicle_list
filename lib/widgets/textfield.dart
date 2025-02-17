import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextInputType? keyboardType;
  final String? initialValue;
  final FormFieldSetter<String> onSaved;
  final String? Function(String?)? validator;

  const CustomTextField({
    required this.label,
    this.keyboardType,
    this.initialValue,
    required this.onSaved,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w400),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        keyboardType: keyboardType ?? TextInputType.text, 
        validator: validator ?? (value) => value!.isEmpty ? 'Enter $label' : null,
        onSaved: onSaved,
        style: GoogleFonts.montserrat(fontSize: 16),
      ),
    );
  }
}
