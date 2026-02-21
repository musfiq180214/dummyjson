import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNameInputField<T, V> extends ConsumerStatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  /// Riverpod provider + selector
  final StateNotifierProvider<StateNotifier<T>, T>? provider;
  final V Function(T)? selector;

  const UserNameInputField({
    super.key,
    this.controller,
    this.hintText,
    this.validator,
    this.onChanged,
    this.provider,
    this.selector,
  });

  @override
  ConsumerState<UserNameInputField<T, V>> createState() =>
      _UserNameInputFieldState<T, V>();
}

class _UserNameInputFieldState<T, V>
    extends ConsumerState<UserNameInputField<T, V>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = widget.controller ?? TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.provider != null && widget.selector != null) {
        final initialValue =
            widget.selector!(ref.read(widget.provider!))?.toString() ?? '';
        if (mounted) _controller.text = initialValue;
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

    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: widget.hintText ?? "Enter username",
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
        ),
      ),
      validator: widget.validator,
      onChanged: (val) {
        widget.onChanged?.call(val);
      },
    );
  }
}