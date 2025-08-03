class Report {
  final Map<String, Map<String, String>> data;

  Report(this.data);

  factory Report.fromJson(Map<dynamic, dynamic> json) {
    Map<String, Map<String, String>> newData = {};
    json.forEach((key, value) {
      Map<String, String> innerMap = {};
      value.forEach((innerKey, innerValue) {
        innerMap[innerKey] = innerValue.toString();
      });
      newData[key] = innerMap;
    });
    return Report(newData);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    data.forEach((key, value) {
      Map<String, String> innerMap = {};
      value.forEach((innerKey, innerValue) {
        innerMap[innerKey] = innerValue;
      });
      json[key] = innerMap;
    });
    return json;
  }
}
