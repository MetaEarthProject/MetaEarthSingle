class Country {
  int? id;
  String code;
  String name;
  int population;
  double gdp;
  String governmentSystem;

  Country({
    this.id,
    required this.code,
    required this.name,
    required this.population,
    required this.gdp,
    required this.governmentSystem,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'population': population,
      'gdp': gdp,
      'government_system': governmentSystem,
    };
  }

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      id: map['id'],
      code: map['code'],
      name: map['name'],
      population: map['population'],
      gdp: map['gdp'],
      governmentSystem: map['government_system'],
    );
  }
}
