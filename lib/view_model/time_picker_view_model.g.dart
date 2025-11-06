// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_picker_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TimePickerViewModel)
const timePickerViewModelProvider = TimePickerViewModelProvider._();

final class TimePickerViewModelProvider
    extends $NotifierProvider<TimePickerViewModel, Map<String, int>> {
  const TimePickerViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timePickerViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timePickerViewModelHash();

  @$internal
  @override
  TimePickerViewModel create() => TimePickerViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, int>>(value),
    );
  }
}

String _$timePickerViewModelHash() =>
    r'd3f63e0c74315125bd9b675ee14bf41a8da44a0c';

abstract class _$TimePickerViewModel extends $Notifier<Map<String, int>> {
  Map<String, int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Map<String, int>, Map<String, int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, int>, Map<String, int>>,
              Map<String, int>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
