class Job {
  final String name;
  final int ratePerHour;

  Job({required this.name, required this.ratePerHour, required this.id});

  final String id;

  factory Job.fromMap(Map<String, dynamic> data, String documnentId) {
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(name: name, ratePerHour: ratePerHour, id: documnentId);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
