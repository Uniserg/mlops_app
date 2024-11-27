import 'dart:convert';
import 'dart:io';

import 'package:mlops_app/features/predict_salary/domain/entities/salary.dart';


class SalaryRemoteDatasource {
  Future<List<Salary>> readJsonFile() async {
    String filePath = "assets/data/salaryData.json";

    try {
      final file = File(filePath);
      final contents = await file.readAsString();
      final jsonData = jsonDecode(contents) as Iterable;
      int k = 1;
      final salaries = jsonData.map((e) => Salary.fromJson(e)).toList();

      return salaries;
    } catch (e) {
      print('Ошибка при чтении файла: $e');
      rethrow;
    }
  }

  Future<List<Salary>> getSalaries() async {
    return await readJsonFile();
  }
}
