import 'dart:convert';

class FleetOwners {
  int sNo;
  String city;
  String commission;
  String company;
  String email;
  String gst;
  String image;
  int joining;
  String mobile;
  String name;
  bool notification;
  String registration;
  String state;
  String token;
  String uid;
  String upiId;

  FleetOwners({
    required this.sNo,
    required this.city,
    required this.commission,
    required this.company,
    required this.email,
    required this.gst,
    required this.image,
    required this.joining,
    required this.mobile,
    required this.name,
    required this.notification,
    required this.registration,
    required this.state,
    required this.token,
    required this.uid,
    required this.upiId,
  });

  FleetOwners copyWith({
    int? sNo,
    String? city,
    String? commission,
    String? company,
    String? email,
    String? gst,
    String? image,
    int? joining,
    String? mobile,
    String? name,
    bool? notification,
    String? registration,
    String? state,
    String? token,
    String? uid,
    String? upiId,
  }) {
    return FleetOwners(
      sNo: sNo ?? this.sNo,
      city: city ?? this.city,
      commission: commission ?? this.commission,
      company: company ?? this.company,
      email: email ?? this.email,
      gst: gst ?? this.gst,
      image: image ?? this.image,
      joining: joining ?? this.joining,
      mobile: mobile ?? this.mobile,
      name: name ?? this.name,
      notification: notification ?? this.notification,
      registration: registration ?? this.registration,
      state: state ?? this.state,
      token: token ?? this.token,
      uid: uid ?? this.uid,
      upiId: upiId ?? this.upiId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sNo': sNo,
      'city': city,
      'commission': commission,
      'company': company,
      'email': email,
      'gst': gst,
      'image': image,
      'joining': joining,
      'mobile': mobile,
      'name': name,
      'notification': notification,
      'registration': registration,
      'state': state,
      'token': token,
      'uid': uid,
      'upiId': upiId,
    };
  }

  factory FleetOwners.fromMap(Map<String, dynamic> map) {
    return FleetOwners(
      sNo: map['sNo'],
      city: map['city'],
      commission: map['commission'],
      company: map['company'],
      email: map['email'],
      gst: map['gst'],
      image: map['image'],
      joining: map['joining'],
      mobile: map['mobile'],
      name: map['name'],
      notification: map['notification'],
      registration: map['registration'],
      state: map['state'],
      token: map['token'],
      uid: map['uid'],
      upiId: map['upiId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FleetOwners.fromJson(String source) =>
      FleetOwners.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FleetOwners(sNo: $sNo, city: $city, commission: $commission, company: $company, email: $email, gst: $gst, image: $image, joining: $joining, mobile: $mobile, name: $name, notification: $notification, registration: $registration, state: $state, token: $token, uid: $uid, upiId: $upiId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FleetOwners &&
        other.sNo == sNo &&
        other.city == city &&
        other.commission == commission &&
        other.company == company &&
        other.email == email &&
        other.gst == gst &&
        other.image == image &&
        other.joining == joining &&
        other.mobile == mobile &&
        other.name == name &&
        other.notification == notification &&
        other.registration == registration &&
        other.state == state &&
        other.token == token &&
        other.uid == uid &&
        other.upiId == upiId;
  }

  @override
  int get hashCode {
    return sNo.hashCode ^
        city.hashCode ^
        commission.hashCode ^
        company.hashCode ^
        email.hashCode ^
        gst.hashCode ^
        image.hashCode ^
        joining.hashCode ^
        mobile.hashCode ^
        name.hashCode ^
        notification.hashCode ^
        registration.hashCode ^
        state.hashCode ^
        token.hashCode ^
        uid.hashCode ^
        upiId.hashCode;
  }
}
