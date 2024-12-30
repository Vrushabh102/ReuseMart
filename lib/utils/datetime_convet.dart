import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateAndTime {
  String convertToTime(Timestamp timestamp) {
    // converting timestamp to datetime
    DateTime datetime = timestamp.toDate();
    // format the datetime
    return DateFormat.yMMMMd().add_jm().format(datetime);
  }
}


/*

  // Example timestamp (seconds=1716371301, nanoseconds=158329000)
    Timestamp timestamp = Timestamp(1716371301, 158329000);

    // Convert Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format the DateTime to a friendly string
    String formattedDate = DateFormat.yMMMMd().add_jm().format(dateTime);
*/