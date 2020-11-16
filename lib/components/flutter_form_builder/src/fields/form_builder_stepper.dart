import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:anad_magicar/components/flutter_form_builder/flutter_form_builder.dart';
import 'package:anad_magicar/components/flutter_form_builder/src/widgets/touch_spin.dart';

//TODO: Field should be renamed to FormBuilderTouchSpin. Stepper is conflicts with Flutter internal widget of same name
class FormBuilderStepper extends StatefulWidget {
  final String attribute;
  final List<FormFieldValidator> validators;
  final num initialValue;
  final bool readOnly;
  final InputDecoration decoration;
  final ValueChanged onChanged;
  final ValueTransformer valueTransformer;
  final num step;
  final num min;
  final num max;
  final num size;
  final FormFieldSetter onSaved;

  FormBuilderStepper({
    Key key,
    @required this.attribute,
    this.initialValue,
    this.validators = const [],
    this.readOnly = false,
    this.decoration = const InputDecoration(),
    this.step,
    this.min,
    this.max,
    this.size = 24.0,
    this.onChanged,
    this.valueTransformer,
    this.onSaved,
  }) : super(key: key);

  @override
  _FormBuilderStepperState createState() => _FormBuilderStepperState();
}

class _FormBuilderStepperState extends State<FormBuilderStepper> {
  bool _readOnly = false;
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();
  FormBuilderState _formState;
  num _initialValue;

  @override
  void initState() {
    _formState = FormBuilder.of(context);
    _formState?.registerFieldKey(widget.attribute, _fieldKey);
    _initialValue = widget.initialValue ??
        (_formState.initialValue.containsKey(widget.attribute)
            ? _formState.initialValue[widget.attribute]
            : null);
    _readOnly = (_formState?.readOnly == true) ? true : widget.readOnly;
    super.initState();
  }

  @override
  void dispose() {
    _formState?.unregisterFieldKey(widget.attribute);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      enabled: !_readOnly,
      key: _fieldKey,
      initialValue: _initialValue,
      validator: (val) {
        for (int i = 0; i < widget.validators.length; i++) {
          if (widget.validators[i](val) != null)
            return widget.validators[i](val);
        }
        return null;
      },
      onSaved: (val) {
        var transformed;
        if (widget.valueTransformer != null) {
          transformed = widget.valueTransformer(val);
          _formState?.setAttributeValue(widget.attribute, transformed);
        } else
          _formState?.setAttributeValue(widget.attribute, val);
        if (widget.onSaved != null) {
          widget.onSaved(transformed ?? val);
        }
      },
      builder: (FormFieldState<dynamic> field) {
        return InputDecorator(
          decoration: widget.decoration.copyWith(
            enabled: !_readOnly,
            errorText: field.errorText,
          ),
          child: TouchSpin(
            onChange: _readOnly
                ? null
                : (value) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    field.didChange(value);
                    if (widget.onChanged != null) widget.onChanged(value);
                  },
            value: field.value,
            step: widget.step ?? 1,
            min: widget.min ?? 1,
            max: widget.max ?? 99999,
            size: widget.size ?? 24,
          ),
        );
      },
    );
  }
}
