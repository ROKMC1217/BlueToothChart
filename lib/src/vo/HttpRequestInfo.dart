class HttpRequestInfo {
  static final Map<String, String> header = {
    'Content-Type': 'application/json',
  };
  static final Uri obdTicksUri =
      Uri.parse("http://13.209.84.131:8000/obd-ticks");
  static final Uri myServerUri =
      Uri.parse("http://todayonofflab.herokuapp.com/medic");
}
