import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mlops_app/features/predict_salary/domain/constants/app_settings.dart';
import 'package:mlops_app/features/predict_salary/domain/constants/education_levels.dart';
import 'package:mlops_app/features/predict_salary/domain/constants/genders.dart';
import 'package:mlops_app/features/predict_salary/domain/constants/jobs.dart';
import 'package:mlops_app/features/predict_salary/domain/constants/locations.dart';
import 'package:mlops_app/features/predict_salary/domain/entities/salary.dart';

import 'package:http/http.dart' as http;

int getDevisions(int min, int max) {
  return max - min + 1;
}

class SalaryPredictPage extends StatefulWidget {
  const SalaryPredictPage({super.key});

  @override
  State<SalaryPredictPage> createState() => _SalaryPredictPageState();
}

class _SalaryPredictPageState extends State<SalaryPredictPage> {
  late final Salary salary;

  static const requiredField = "Обязательное поле";

  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    salary = Salary.empty();
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  double mockSalary() {
    final randomSalary = Random.secure().nextDouble() * 1000000;
    return randomSalary;
  }

  Future<double> getSalaryFromServer() async {
     showLoaderDialog(context);
    final response = await http.post(
      Uri.parse('$serverUrl/api/salary_predict'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: json.encode(salary.toJson()),
    );
    Navigator.pop(context);

    double? salary_value;

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      salary_value = double.parse(data['salary']);
    } else {
      throw Exception(
          'Неуспешный запрос ${response.statusCode}: ${response.reasonPhrase}');
    }

    if (salary_value == null) {
      throw Exception(
          'Неуспешный запрос ${response.statusCode}: ${response.reasonPhrase}');
    }   
    return salary_value; 
  }

  void getPredictSalary(BuildContext context, Salary salary) async {
    double salary_value = await getSalaryFromServer();
    
    setState(() {
      // final randomSalary = Random.secure().nextDouble() * 1000000;
      salary.salary = num.parse(salary_value.toStringAsFixed(2)) as double?;
    });
  }

  @override
  Widget build(BuildContext context) {
    // double? dropdownSize = null;
    // double? titleSize = null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 40),
          child: Text(
            "Предиктивная система оценки заработной платы",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Center(
          child: Form(
            key: _formKey,
            child: Table(
              textDirection: TextDirection.ltr,
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: MaxColumnWidth(
                    FractionColumnWidth(0.2), IntrinsicColumnWidth()),
                1: MaxColumnWidth(
                    FractionColumnWidth(0.7), IntrinsicColumnWidth()),
              },
              children: [
                TableRow(
                  children: [
                    const Text("Уровень образования:"),
                    DropdownButtonFormField(
                        validator: (value) =>
                            value != null ? null : requiredField,
                        isExpanded: true,
                        value: salary.educationLevel,
                        items: educationLevels
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            salary.educationLevel = value;
                          });
                        })
                  ],
                ),
                                TableRow(
                  children: [
                    const Text("Локация:"),
                    DropdownButtonFormField(
                        validator: (value) =>
                            value != null ? null : requiredField,
                        isExpanded: true,
                        value: salary.location,
                        items: locations
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            salary.location = value;
                          });
                        })
                  ],
                ),
                TableRow(
                  children: [
                    const Text("Профессия:"),
                    DropdownButtonFormField(
                        validator: (value) =>
                            value != null ? null : requiredField,
                        isExpanded: true,
                        value: salary.jobTitle,
                        items: jobs
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            salary.jobTitle = value;
                          });
                        })
                  ],
                ),
                TableRow(
                  children: [
                    const Text("Пол:"),
                    DropdownButtonFormField<String>(
                        validator: (value) =>
                            value != null ? null : requiredField,
                        isExpanded: true,
                        value: salary.gender,
                        items: genders
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            salary.gender = value;
                          });
                        }),
                  ],
                ),

                TableRow(
                  children: [
                    const Text("Количество полных лет"),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: salary.age?.toDouble() ?? 12,
                            min: 12,
                            max: 110,
                            divisions: getDevisions(12, 110),
                            // divisions: 5,
                            label: salary.age.toString() ?? '12',
                            onChanged: (double value) {
                              setState(() {
                                salary.age = value.toInt();
                              });
                            },
                          ),
                        ),
                         SizedBox(
                          width: 40,
                          child: Text(salary.age?.toString() ?? '12'),
                        )
                      ],
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text("Опыт работы в годах"),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: salary.yearsOfExperience ?? 0,
                            min: 0,
                            max: 100,
                            divisions: 1000,
                            label:
                                salary.yearsOfExperience?.toStringAsFixed(1) ??
                                    '0',
                            onChanged: (double value) {
                              setState(() {
                                salary.yearsOfExperience = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: Text(salary.yearsOfExperience?.toStringAsFixed(1) ?? "0.0"),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentContext != null &&
                    _formKey.currentState!.validate()) {
                  getPredictSalary(context, salary);
                }
              },
              child: const Text("Рассчитать зарплату")),
        ),
        if (salary.salary != null)
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    child: Text(
                  "Прогнозирумая зарплата: ${salary.salary}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ],
            ),
          ),
      ],
    );
  }
}
