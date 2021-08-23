class CancelledBookings{
  String id;
  String agent;
  var amount;
  String cBy;
  String reason;
  var time;
  String user;
  CancelledBookings({
   required this.agent,
   required this.user,
   required this.id,
   required this.time,
   required this.amount,
   required this.cBy,
   required this.reason
});
}