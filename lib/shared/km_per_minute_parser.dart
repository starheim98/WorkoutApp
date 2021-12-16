import 'package:workout_app/models/running/run_workout.dart';

Duration parseDuration(String s) {
  int hours = 0;
  int minutes = 0;
  int micros;
  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
  return Duration(hours: hours, minutes: minutes, microseconds: micros);
}

String timePerKm(RunWorkout runWorkout) {
  var formatting = const Duration(hours: 0, minutes: 0, seconds: 0);
  if (runWorkout.distance != "0" && runWorkout.distance != "0.0" && runWorkout.distance != null) {
    Duration duration = parseDuration(runWorkout.duration);
    int inseconds = duration.inSeconds;
    double secondsPerKm = 0.0;
    if (inseconds != 0) {
      secondsPerKm = inseconds / double.parse(runWorkout.distance);
      formatting = parseDuration(secondsPerKm.toString());
    }
    return printDuration(formatting);
  } else {
    return printDuration(formatting);
  }
}

String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  if(twoDigits(duration.inHours) == "00"){
    return "${twoDigits(duration.inMinutes)}’$twoDigitSeconds”";
  } else {
    return "${twoDigits(duration.inHours)}’$twoDigitMinutes’$twoDigitSeconds”";
  }
}

String timePerKmWithoutRunworkout(String distance, String durationString) {
  var formatting = const Duration(hours: 0, minutes: 0, seconds: 0);
  if (distance != "0" && distance != "0.0" && distance != null) {
    Duration duration = parseDuration(durationString);
    int inseconds = duration.inSeconds;
    double secondsPerKm = 0.0;
    if (inseconds != 0) {
      secondsPerKm = inseconds / double.parse(distance);
      formatting = parseDuration(secondsPerKm.toString());
    }
    return printDuration(formatting);
  } else {
    return printDuration(formatting);
  }
}