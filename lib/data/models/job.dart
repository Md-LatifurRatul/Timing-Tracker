class Job {
  final String name;
  final int ratePerHour;

  Job({required this.name, required this.ratePerHour});

  factory Job.fromMap(Map<String, dynamic> data) {
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(name: name, ratePerHour: ratePerHour);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
