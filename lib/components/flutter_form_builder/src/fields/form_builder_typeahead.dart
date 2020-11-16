import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:anad_magicar/components/flutter_form_builder/flutter_form_builder.dart';
import 'package:anad_magicar/components/flutter_form_builder/src/always_disabled_focus_node.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

typedef String SelectionToTextTransformer<T>(T suggestion);

class FormBuilderTypeAhead<T> extends StatefulWidget {
  final String attribute;
  final List<FormFieldValidator> validators;
  final T initialValue;
  final bool readOnly;
  final InputDecoration decoration;
  final ValueChanged onChanged;
  final ValueTransformer valueTransformer;

  final bool getImmediateSuggestions;
  final bool autovalidate;
  final ErrorBuilder errorBuilder;
  final WidgetBuilder noItemsFoundBuilder;
  final WidgetBuilder loadingBuilder;
  final Duration debounceDuration;
  final SuggestionsBoxDecoration suggestionsBoxDecoration;
  final SelectionToTextTransformer<T> selectionToTextTransformer;
  final ItemBuilder<T> itemBuilder;
  final SuggestionsCallback<T> suggestionsCallback;
  final double suggestionsBoxVerticalOffset;
  final TextFieldConfiguration textFieldConfiguration;
  final AnimationTransitionBuilder transitionBuilder;
  final Duration animationDuration;
  final double animationStart;
  final AxisDirection direction;
  final bool hideOnLoading;
  final bool hideOnEmpty;
  final bool hideOnError;
  final bool hideSuggestionsOnKeyboardHide;
  final bool keepSuggestionsOnLoading;
  final bool autoFlipDirection;
  final SuggestionsBoxController suggestionsBoxController;
  final bool keepSuggestionsOnSuggestionSelected;
  final SuggestionSelectionCallback<T> onSuggestionSelected;
  final TextEditingController controller;
  final FormFieldSetter<T> onSaved;

  FormBuilderTypeAhead({
    Key key,
    @required this.attribute,
    @required this.itemBuilder,
    @required this.suggestionsCallback,
    this.initialValue,
    this.validators = const [],
    this.readOnly = false,
    this.decoration = const InputDecoration(),
    this.getImmediateSuggestions = false,
    this.autovalidate = false,
    this.selectionToTextTransformer,
    this.errorBuilder,
    this.noItemsFoundBuilder,
    this.loadingBuilder,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.suggestionsBoxDecoration = const SuggestionsBoxDecoration(),
    this.suggestionsBoxVerticalOffset = 5.0,
    this.textFieldConfiguration = const TextFieldConfiguration(),
    this.transitionBuilder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationStart = 0.25,
    this.direction = AxisDirection.down,
    this.hideOnLoading = false,
    this.hideOnEmpty = false,
    this.hideOnError = false,
    this.hideSuggestionsOnKeyboardHide = true,
    this.keepSuggestionsOnLoading = true,
    this.autoFlipDirection = false,
    this.onChanged,
    this.valueTransformer,
    this.suggestionsBoxController,
    this.keepSuggestionsOnSuggestionSelected = false,
    this.onSuggestionSelected,
    this.controller,
    this.onSaved,
  })  : assert(T == String || selectionToTextTransformer != null),
        super(key: key);

  @override
  _FormBuilderTypeAheadState<T> createState() =>
      _FormBuilderTypeAheadState<T>();
}

class _FormBuilderTypeAheadState<T> extends State<FormBuilderTypeAhead<T>> {
  TextEditingController _typeAheadController;
  bool _readOnly = false;
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();
  FormBuilderState _formState;
  T _initialValue;
  String _initialText;

  TextEditingController get _effectiveController =>
      widget.controller ?? _typeAheadController;

  @override
  void initState() {
    super.initState();
    _formState = FormBuilder.of(context);
    _formState?.registerFieldKey(widget.attribute, _fieldKey);
    if (widget.controller == null) {
      _typeAheadController = TextEditingController();
    }
    _initialValue = widget.initialValue ??
        (_formState.initialValue.containsKey(widget.attribute)
            ? _formState.initialValue[widget.attribute]
            : null);

    _initialText = (widget.selectionToTextTransformer != null)
        ? widget.selectionToTextTransformer(_initialValue ?? '')
        : _initialValue?.toString() ?? '';

    _effectiveController.text = _initialText;

    if (T == String) {
      _effectiveController.addListener(_handleStringOnChanged);
    }
  }

  _handleStringOnChanged() {
    if (widget.onChanged != null) widget.onChanged(_effectiveController.text);
  }

  @override
  Widget build(BuildContext context) {
    _readOnly = (_formState?.readOnly == true) ? true : widget.readOnly;

    return TypeAheadFormField<T>(
      key: _fieldKey,
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
      autovalidate: widget.autovalidate,
      textFieldConfiguration: widget.textFieldConfiguration.copyWith(
        enabled: !_readOnly,
        controller: _effectiveController,
        style: _readOnly
            ? Theme.of(context).textTheme.subhead.copyWith(
                  color: Theme.of(context).disabledColor,
                )
            : widget.textFieldConfiguration.style,
        focusNode: _readOnly
            ? AlwaysDisabledFocusNode()
            : widget.textFieldConfiguration.focusNode,
        decoration: widget.decoration.copyWith(
          enabled: !_readOnly,
        ),
      ),
      suggestionsCallback: widget.suggestionsCallback,
      itemBuilder: widget.itemBuilder,
      transitionBuilder: (context, suggestionsBox, controller) =>
          suggestionsBox,
      onSuggestionSelected: (T suggestion) {
        if (widget.selectionToTextTransformer != null) {
          _effectiveController.text =
              widget.selectionToTextTransformer(suggestion);
        } else {
          _effectiveController.text =
              suggestion != null ? suggestion.toString() : '';
        }
        if (widget.onSuggestionSelected != null)
          widget.onSuggestionSelected(suggestion);
        if (widget.onChanged != null) widget.onChanged(suggestion);
      },
      getImmediateSuggestions: widget.getImmediateSuggestions,
      errorBuilder: widget.errorBuilder,
      noItemsFoundBuilder: widget.noItemsFoundBuilder,
      loadingBuilder: widget.loadingBuilder,
      debounceDuration: widget.debounceDuration,
      suggestionsBoxDecoration: widget.suggestionsBoxDecoration,
      suggestionsBoxVerticalOffset: widget.suggestionsBoxVerticalOffset,
      animationDuration: widget.animationDuration,
      animationStart: widget.animationStart,
      direction: widget.direction,
      hideOnLoading: widget.hideOnLoading,
      hideOnEmpty: widget.hideOnEmpty,
      hideOnError: widget.hideOnError,
      hideSuggestionsOnKeyboardHide: widget.hideSuggestionsOnKeyboardHide,
      keepSuggestionsOnLoading: widget.keepSuggestionsOnLoading,
      autoFlipDirection: widget.autoFlipDirection,
      suggestionsBoxController: widget.suggestionsBoxController,
      keepSuggestionsOnSuggestionSelected:
          widget.keepSuggestionsOnSuggestionSelected,
    );
  }

  @override
  void dispose() {
    _formState?.unregisterFieldKey(widget.attribute);
    _effectiveController.removeListener(_handleStringOnChanged);
    super.dispose();
  }
}
