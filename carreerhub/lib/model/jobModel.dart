class JobModel {
  int id;
  String title;
  String? name;
  String min_salary;
  String? max_salary;
  String salary_period;
  String address;
  String job_type;
  String? shift_type;
  String no_people;
  String? experience_req;
  String? qualification_req;
  String? skills;
  String description;

  JobModel(
      {required this.id,
      required this.title,
      this.name,
      required this.address,
      required this.min_salary,
      this.max_salary,
      required this.salary_period,
      required this.job_type,
      this.shift_type,
      required this.no_people,
      this.experience_req,
      this.qualification_req,
      this.skills,
      required this.description});
}
