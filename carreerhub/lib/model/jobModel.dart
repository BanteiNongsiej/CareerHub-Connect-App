class JobModel {
  int id;
  String title;
  String? company_name;
  String salary;
  String location;
  String job_type;
  String description;

  JobModel(
      {required this.id,
      required this.title,
      this.company_name,
      required this.salary,
      required this.location,
      required this.job_type,
      required this.description});
}
