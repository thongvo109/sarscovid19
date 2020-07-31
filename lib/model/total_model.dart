class TotalModel {
  int timeUpdate;
  int totalCase;
  int todayCase;
  int death;
  int todayDeath;
  int recovered;
  int todayRecovered;
  int active;
  int critical;
  TotalModel({
    this.timeUpdate,
    this.totalCase,
    this.todayCase,
    this.death,
    this.todayDeath,
    this.recovered,
    this.todayRecovered,
    this.active,
    this.critical,
  });
  TotalModel.fromJson(Map<String, dynamic> json)
      : timeUpdate = json['updated'],
        totalCase = json['cases'],
        todayCase = json['todayCases'],
        death = json['deaths'],
        todayDeath = json['todayDeaths'],
        recovered = json['recovered'],
        todayRecovered = json['todayRecovered'],
        active = json['active'],
        critical = json['critical'];
}
