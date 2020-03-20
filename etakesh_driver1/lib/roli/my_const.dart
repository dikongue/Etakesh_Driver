
import 'package:intl/intl.dart';

class MyConst {
  static String MAPS_API_KEY = "AIzaSyBNm8cnYw5inbqzgw8LjXyt3rMhFhEVTjY";
  static String MAKERS_ID_POST_DEST = "position_destination";
  static String MAKERS_ID_POST_PRISE = "position_prise_en_charge";
  static String MAKERS_ID_POST_CURR = "current_position";

  static String amountFormat(double value) {
    final oCcy = new NumberFormat("#,##0", "en_US");

    return oCcy.format(value);
  }
}