import 'package:flutter_test/flutter_test.dart';
import 'package:mlops_app/features/predict_salary/data/datasources/salary_remote_datasource.dart';
import 'package:mlops_app/features/predict_salary/domain/entities/salary.dart';

void main() {
  SalaryRemoteDatasource salaryRemoteDatasource = SalaryRemoteDatasource();

  test("Тестирование извлечения данных", () async {
    List<Salary> salaries = await salaryRemoteDatasource.getSalaries();
    print(salaries[0]);
  });
}