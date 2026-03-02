import 'package:dummyjson/core/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextInputField<T, V> extends ConsumerStatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool? readOnly;
  final String? initialValue;
  final StateNotifierProvider<StateNotifier<T>, T>? provider;
  final V Function(T)? selector;
  final InputLanguageType inputLanguage;
  final List<TextInputFormatter>? inputFormatters; // add this

  const TextInputField({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.readOnly,
    this.initialValue,
    this.provider,
    this.selector,
    this.inputLanguage = InputLanguageType.none,
    this.inputFormatters,
  });

  @override
  ConsumerState<TextInputField<T, V>> createState() =>
      _TextInputFieldState<T, V>();
}

class _TextInputFieldState<T, V> extends ConsumerState<TextInputField<T, V>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    if (widget.controller != null) {
      _controller = widget.controller!;
    } else if (widget.provider != null && widget.selector != null) {
      final state = ref.read(widget.provider!);
      final value = widget.selector!(state)?.toString() ?? '';
      _controller = TextEditingController(text: value);
    } else {
      _controller = TextEditingController(text: widget.initialValue ?? '');
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  /// 🔹 Returns appropriate input formatter based on language type
  List<TextInputFormatter> _getInputFormatters() {
    if (widget.inputFormatters != null) {
      return widget.inputFormatters!;
    }

    switch (widget.inputLanguage) {
      case InputLanguageType.bangla:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'[\u0980-\u09FF\s]')),
          BanglaPhoneticInputFormatter(),
        ];
      case InputLanguageType.english:
        return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))];
      case InputLanguageType.none:
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sync with Riverpod provider value
    if (widget.provider != null && widget.selector != null) {
      ref.listen<T>(widget.provider!, (previous, next) {
        final newValue = widget.selector!(next)?.toString() ?? '';
        if (!_focusNode.hasFocus && newValue != _controller.text) {
          _controller.text = newValue;
        }
      });
    }

    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      readOnly: widget.readOnly ?? false,
      keyboardType: widget.keyboardType,
      inputFormatters: _getInputFormatters(),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        enabled: widget.readOnly != true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
        ),
      ),
      onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}

class BanglaPhoneticInputFormatter extends TextInputFormatter {
  final _banglaRegex = RegExp(r'[\u0980-\u09FF]');
  final _englishRegex = RegExp(r'^[a-zA-Z]+$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Detect if user just pressed space
    if (text.endsWith(' ')) {
      final words = text.trim().split(' ');
      if (words.isNotEmpty) {
        final lastWord = words.last;

        // If last word contains only English letters — remove it
        if (_englishRegex.hasMatch(lastWord) &&
            !_banglaRegex.hasMatch(lastWord)) {
          final newText = text.replaceFirst(RegExp(r'(\b[a-zA-Z]+\s)$'), '');
          return TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: newText.length),
          );
        }
      }
    }

    return newValue;
  }
}
