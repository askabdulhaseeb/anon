import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PickerFunctions {
  Future<File?> image() async {
    final bool isGranted = await _request();
    if (!isGranted) return null;
    final FilePickerResult? file = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (file == null) return null;
    return File(file.paths.first!);
  }

  Future<List<File>> images() async {
    final bool isGranted = await _request();
    if (!isGranted) return <File>[];
    final FilePickerResult? file = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);
    if (file == null) return <File>[];
    List<File> temp = <File>[];
    for (PlatformFile element in file.files) {
      if (element.path != null) {
        temp.add(File(element.path!));
      }
    }
    return temp;
  }

  Future<List<File>> videos() async {
    final bool isGranted = await _request();
    if (!isGranted) return <File>[];
    final FilePickerResult? file = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.video);
    if (file == null) return <File>[];
    List<File> temp = <File>[];
    for (PlatformFile element in file.files) {
      temp.add(File(element.path!));
    }
    return temp;
  }

  Future<File?> camera() async {
    final bool isGranted = await _request();
    if (!isGranted) return null;
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.camera);
    if (file == null) return null;
    return File(file.path);
  }

  Future<File?> video() async {
    final bool isGranted = await _request();
    if (!isGranted) return null;
    final FilePickerResult? file =
        await FilePicker.platform.pickFiles(type: FileType.video);
    if (file == null) return null;
    return File(file.files.first.path!);
  }

  Future<File?> limitedVideo() async {
    final bool isGranted = await _request();
    if (!isGranted) return null;
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 30),
    );
    if (file == null) return null;
    return File(file.path);
  }

  Future<bool> _request() async {
    if (await Permission.photos.status != PermissionStatus.granted) {
      await Permission.photos.request();
    }
    if (await Permission.mediaLibrary.status != PermissionStatus.granted) {
      await Permission.mediaLibrary.request();
    }
    if (await Permission.storage.status != PermissionStatus.granted) {
      await Permission.storage.request();
    }
    if (await Permission.videos.status != PermissionStatus.granted) {
      await Permission.videos.request();
    }
    // final PermissionStatus status1 = await Permission.photos.status;
    // final PermissionStatus status2 = await Permission.mediaLibrary.status;
    final PermissionStatus status3 = await Permission.storage.status;
    return status3.isGranted;
  }
}
