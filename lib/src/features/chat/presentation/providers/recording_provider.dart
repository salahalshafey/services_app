import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../core/util/builders/custom_snack_bar.dart';

class RecordingProvider with ChangeNotifier {
  final _recorder = FlutterSoundRecorder();

  bool _recordingFromTextField = false;
  bool get recordingFromTextField => _recordingFromTextField;
  set recordingFromTextField(bool value) {
    _recordingFromTextField = value;
    notifyListeners();
  }

  bool _recordingFrombottomSheet = false;
  bool get recordingFrombottomSheet => _recordingFrombottomSheet;
  set recordingFrombottomSheet(bool value) {
    _recordingFrombottomSheet = value;
    _recordingFromTextField = false;

    notifyListeners();
  }

  bool _isRecording = false;
  bool _isStarted = false;
  DateTime _lastRecordingTime = DateTime.now();
  Duration _lastRecordingDuration = Duration.zero;
  Icon _micOrPauseIcon =
      const Icon(Icons.pause, size: 35, color: Colors.red, key: ValueKey(2));

  String? _recorderFilePath;
  final _toFilePath =
      'audio.aac'; //"${DateTime.now().toString().hashCode}.aac";

  bool get isRecording => _isRecording;
  bool get isStarted => _isStarted;
  DateTime get lastRecordingTime => _lastRecordingTime;
  Duration get lastRecordingDuration => _lastRecordingDuration;
  Icon get micOrPauseIcon => _micOrPauseIcon;
  String? get recorderFilePath => _recorderFilePath;

  Stream<RecordingDisposition>? get recorderOnProgress => _recorder.onProgress;

  final List<double> _decibelsProgress = [];
  List<double> getCurrentdecibelsProgress(double decibels) {
    if (_decibelsProgress.length < 70) {
      _decibelsProgress.add(decibels);
    } else {
      _decibelsProgress.insert(0, decibels);
      _decibelsProgress.removeLast();
    }

    return _decibelsProgress;
  }

  Future<void> initTheRecorder(BuildContext context) async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      showCustomSnackBar(
        context: context,
        content: 'We need microphone permission to send the recorder.',
      );
      return;
    }

    await _recorder.openRecorder();
    _recorder.setSubscriptionDuration(const Duration(milliseconds: 20));
  }

  Future<void> startTheRecorder() async {
    await _recorder.startRecorder(toFile: _toFilePath);

    WakelockPlus.enable();

    _isRecording = true;
    _isStarted = true;
    _lastRecordingTime = DateTime.now();

    notifyListeners();
  }

  Future<String> stopTheRecorder() async {
    final path = await _recorder.stopRecorder();

    WakelockPlus.disable();

    _isRecording = false;
    _isStarted = false;
    _lastRecordingDuration = Duration.zero;
    _recorderFilePath = path;

    _recordingFromTextField = false;
    _recordingFrombottomSheet = false;

    notifyListeners();

    return path!;
  }

  Future<void> resumeRecorder() async {
    await _recorder.resumeRecorder();

    _isRecording = true;
    _lastRecordingTime = DateTime.now();

    notifyListeners();
  }

  Future<void> pauseRecorder() async {
    await _recorder.pauseRecorder();
    final path = await _recorder.getRecordURL(path: _toFilePath);

    _isRecording = false;
    _recorderFilePath = path;
    _lastRecordingDuration += DateTime.now().difference(_lastRecordingTime);

    notifyListeners();
  }

  Future<void> toggoleAudioRecording() async {
    if (_isStarted && _isRecording) {
      await pauseRecorder();
    } else if (_isStarted && !_isRecording) {
      await resumeRecorder();
    } else {
      await startTheRecorder();
    }

    _micOrPauseIcon = _isRecording
        ? const Icon(Icons.pause, size: 35, color: Colors.red, key: ValueKey(2))
        : const Icon(Icons.mic, size: 35, color: Colors.red, key: ValueKey(1));

    notifyListeners();
  }

  Future<void> deleteRecording() async {
    await _recorder.stopRecorder();

    WakelockPlus.disable();

    _isRecording = false;
    _isStarted = false;
    _lastRecordingDuration = Duration.zero;
    _recorderFilePath = null;

    _recordingFromTextField = false;
    _recordingFrombottomSheet = false;

    notifyListeners();
  }

  void closeTheRecorder() {
    _recorder.closeRecorder();

    WakelockPlus.disable();
  }
}
