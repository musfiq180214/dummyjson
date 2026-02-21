import 'package:dummyjson/core/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneInputField<T, V> extends ConsumerStatefulWidget {
  final TextEditingController? controller;
  final String countryCode;
  final String? hintText;
  final bool showCountryCode;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool allowLeadingZero;

  /// Riverpod provider + selector
  final StateNotifierProvider<StateNotifier<T>, T>? provider;
  final V Function(T)? selector;

  const PhoneInputField({
    super.key,
    this.controller,
    this.countryCode = "+880",
    this.hintText,
    this.showCountryCode = true,
    this.validator,
    this.onChanged,
    this.provider,
    this.selector,
    required this.allowLeadingZero,
  });

  @override
  ConsumerState<PhoneInputField<T, V>> createState() =>
      _PhoneInputFieldState<T, V>();
}

class _PhoneInputFieldState<T, V> extends ConsumerState<PhoneInputField<T, V>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // Initialize controller with initialValue only
    _controller = widget.controller ?? TextEditingController();

    // Delay setting initial value to build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.provider != null && widget.selector != null) {
        final initialValue =
            widget.selector!(ref.read(widget.provider!))?.toString() ?? '';
        if (mounted) {
          _controller.text = initialValue;
        }
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only update controller if user is not typing
    if (widget.provider != null && widget.selector != null) {
      ref.listen<T>(widget.provider!, (previous, next) {
        final newValue = widget.selector!(next)?.toString() ?? '';
        if (!_focusNode.hasFocus && newValue != _controller.text) {
          final oldSelection = _controller.selection;
          _controller.text = newValue;
          _controller.selection = oldSelection.isValid
              ? oldSelection
              : TextSelection.collapsed(offset: newValue.length);
        }
      });
    }

    return Row(
      children: [
        if (widget.showCountryCode)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400, width: 1.5),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Text(
              widget.countryCode,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              if (!widget.allowLeadingZero) NoLeadingZeroFormatter(),
            ],
            decoration: InputDecoration(
              hintText: widget.hintText ?? "0 00 00 00 00",
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
              ),
            ),
            validator: widget.validator,
            onChanged: (val) {
              widget.onChanged?.call(val);
            },
          ),
        ),
      ],
    );
  }
}
