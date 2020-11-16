import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// import 'input_decorator.dart';
// import 'text_field.dart';

/// A [FormField] that contains a [TextField].
///
/// This is a convenience widget that simply wraps a [TextField] widget in a
/// [FormField].
///
/// A [Form] ancestor is not required. The [Form] simply makes it easier to
/// save, reset, or validate multiple fields at once. To use without a [Form],
/// pass a [GlobalKey] to the constructor and use [GlobalKey.currentState] to
/// save or reset the form field.
///
/// For a documentation about the various parameters, see [TextField].
///
/// See also:
///
///  * <https://material.google.com/components/text-fields.html>
///  * [TextField], which is the underlying text field without the [Form]
///    integration.
///  * [InputDecorator], which shows the labels and other visual elements that
///    surround the actual text editing widget.
class TextInputFormField extends FormField<String> {
  /// Creates a [FormField] that contains a [TextField].
  ///
  /// For documentation about the various parameters, see the [TextField] class
  /// and [new TextField], the constructor.
  TextInputFormField({
    Key key,
    TextEditingController controller,
    FocusNode focusNode,
    InputDecoration decoration: const InputDecoration(),
    TextInputType keyboardType: TextInputType.text,
    TextStyle style,
    bool autofocus: false,
    bool obscureText: false,
    bool autocorrect: true,
    int maxLines: 1,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    List<TextInputFormatter> inputFormatters,
  })  : assert(autofocus != null),
        assert(obscureText != null),
        assert(autocorrect != null),
        assert(maxLines == null || maxLines > 0),
        super(
          key: key,
          initialValue: controller != null ? controller.value.text : '',
          validator: validator,
          builder: (FormFieldState<String> field) {
            /*if (Form.of(field.context).widget.autovalidate) {
            field.validate();
          }*/

            return new TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: decoration.copyWith(errorText: field.errorText),
              keyboardType: keyboardType,
              style: style,
              autofocus: autofocus,
              obscureText: obscureText,
              autocorrect: autocorrect,
              maxLines: maxLines,
              onChanged: field.didChange,
              inputFormatters: inputFormatters,
            );
          },
        );
}
