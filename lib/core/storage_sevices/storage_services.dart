import 'package:imageconvertor/core/storage_sevices/storage_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {
  static const convertedFileKey = "converted_files";

  Future<void> addToStorage(StorageModel storageModel) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> files = prefs.getStringList(convertedFileKey) ?? [];
    files.add(storageModel.toJson());

    prefs.setStringList(convertedFileKey, files);
  }

  Future<List<StorageModel>> getFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final convertedFiles = prefs.getStringList(convertedFileKey) ?? [];
    return convertedFiles.map((e) => StorageModel.FromJson(e)).toList();
  }

  Future<void> deleteFiles(String imagePath) async {
    
    final prefs = await SharedPreferences.getInstance();
    final List<String> files = prefs.getStringList(convertedFileKey) ?? [];
    files.removeWhere((item){
      final file = StorageModel.FromJson(item);
      return file.imagePath == imagePath;
    });
    prefs.setStringList(convertedFileKey, files);
  }

  Future<void> clearAllFile() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(convertedFileKey);
  }
}
