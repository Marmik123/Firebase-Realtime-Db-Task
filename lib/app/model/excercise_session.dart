class Session {
  String? sessionName;
  String? imageSource;
  DateTime? performedTime;
  bool? sessionStatus;
  bool? performedAt;

  Session.fromJson(Map<dynamic, dynamic> json)
      : performedTime = json['time'] == null
            ? DateTime.now()
            : DateTime.parse(json['time'] as String),
        sessionName = json['name'] == null ? '-' : json['name'] as String,
        imageSource = json['img'] as String,
        performedAt =
            json['performed'] == null ? false : json['performed'] as bool,
        sessionStatus = json['status'] == null ? false : json['status'] as bool;

  /*Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'date': performedTime.toString(),
    'name':sessionName,
    'img':imageSource,
    'status':sessionStatus,
  };*/

}
