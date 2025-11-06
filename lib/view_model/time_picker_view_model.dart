import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'time_picker_view_model.g.dart';

@riverpod
class TimePickerViewModel extends _$TimePickerViewModel {
  @override
  Map<String, int> build() => {"hour": 0, "minute": 0};

  void setTime(int hour, int minute) {
    state = {"hour": hour, "minute": minute};
  }

  void resetTime() {
    state = {"hour": 0, "minute": 0};
  }

  int get hour => state["hour"]!;
  int get minute => state["minute"]!;
}
