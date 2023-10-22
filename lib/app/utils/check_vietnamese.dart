import 'package:intl/intl.dart';

String removeVietnameseAccent(String str) {
  String normalized = str
      .replaceAll('á', 'a')
      .replaceAll('à', 'a')
      .replaceAll('ả', 'a')
      .replaceAll('ã', 'a')
      .replaceAll('ạ', 'a')
      .replaceAll('ă', 'a')
      .replaceAll('ắ', 'a')
      .replaceAll('ằ', 'a')
      .replaceAll('ẳ', 'a')
      .replaceAll('ẵ', 'a')
      .replaceAll('ặ', 'a')
      .replaceAll('â', 'a')
      .replaceAll('ấ', 'a')
      .replaceAll('ầ', 'a')
      .replaceAll('ẩ', 'a')
      .replaceAll('ẫ', 'a')
      .replaceAll('ậ', 'a')
      .replaceAll('đ', 'd')
      .replaceAll('é', 'e')
      .replaceAll('è', 'e')
      .replaceAll('ẻ', 'e')
      .replaceAll('ẽ', 'e')
      .replaceAll('ẹ', 'e')
      .replaceAll('ê', 'e')
      .replaceAll('ế', 'e')
      .replaceAll('ề', 'e')
      .replaceAll('ể', 'e')
      .replaceAll('ễ', 'e')
      .replaceAll('ệ', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ì', 'i')
      .replaceAll('ỉ', 'i')
      .replaceAll('ĩ', 'i')
      .replaceAll('ị', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ò', 'o')
      .replaceAll('ỏ', 'o')
      .replaceAll('õ', 'o')
      .replaceAll('ọ', 'o')
      .replaceAll('ô', 'o')
      .replaceAll('ố', 'o')
      .replaceAll('ồ', 'o')
      .replaceAll('ổ', 'o')
      .replaceAll('ỗ', 'o')
      .replaceAll('ộ', 'o')
      .replaceAll('ơ', 'o')
      .replaceAll('ớ', 'o')
      .replaceAll('ờ', 'o')
      .replaceAll('ở', 'o')
      .replaceAll('ỡ', 'o')
      .replaceAll('ợ', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ù', 'u')
      .replaceAll('ủ', 'u')
      .replaceAll('ũ', 'u')
      .replaceAll('ụ', 'u')
      .replaceAll('ư', 'u')
      .replaceAll('ứ', 'u')
      .replaceAll('ừ', 'u')
      .replaceAll('ử', 'u')
      .replaceAll('ữ', 'u')
      .replaceAll('ự', 'u')
      .replaceAll('ý', 'y')
      .replaceAll('ỳ', 'y')
      .replaceAll('ỷ', 'y')
      .replaceAll('ỹ', 'y')
      .replaceAll('ỵ', 'y');
  return normalized;
}

String calculateTimeDifference(String createdAt) {
  DateTime now = DateTime.now();
  DateTime createdAtDateTime = DateTime.parse(createdAt);

  const viLocale = 'vi_VN'; // Locale của Việt Nam

  Duration difference = now.difference(createdAtDateTime);

  if (difference.inMinutes < 1) {
    return "Vừa mới đây";
  } else if (difference.inHours < 1) {
    return "${difference.inMinutes} phút trước";
  } else if (difference.inDays < 1) {
    return "${difference.inHours} giờ trước";
  } else if (difference.inDays < 30) {
    return "${difference.inDays} ngày trước";
  } else {
    final formattedDate = DateFormat.yMMMd(viLocale).format(createdAtDateTime);
    return "vào lúc $formattedDate";
  }
}
