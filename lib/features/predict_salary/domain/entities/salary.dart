class Salary {
  int? age;
  String? gender;
  String? jobTitle;
  String? educationLevel;
  double? yearsOfExperience;
  double? salary;

  Salary({
    this.age,
    this.gender,
    this.jobTitle,
    this.educationLevel,
    this.yearsOfExperience,
    this.salary,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'age': age,
      'gender': gender,
      'jobTitle': jobTitle,
      'educationLevel': educationLevel,
      'yearsOfExperience': yearsOfExperience,
      'salary': salary,
    };
  }

  factory Salary.empty() {
    return Salary();
  }

  factory Salary.fromJson(Map<String, dynamic> map) {
    Salary(
      age: map['age'] ?? -1,
      gender: map['gender'] ?? "",
      jobTitle: map['jobTitle'] ?? "",
      educationLevel: map['educationLevel'] ?? "",
      yearsOfExperience: (map['yearsOfExperience'] as num?)?.toDouble() ?? 0,
      salary: (map['salary'] as num?)?.toDouble() ?? 0.0,
    );

    return Salary(
      age: map['age'] ?? -1,
      gender: map['gender'] ?? "",
      jobTitle: map['jobTitle'] ?? "",
      educationLevel: map['educationLevel'] ?? "",
      yearsOfExperience: (map['yearsOfExperience'] as num?)?.toDouble() ?? 0,
      salary: (map['salary'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  String toString() {
    return 'Salary(age: $age, gender: $gender, jobTitle: $jobTitle, educationLevel: $educationLevel, yearsOfExperience: $yearsOfExperience, salary: $salary)';
  }
}
