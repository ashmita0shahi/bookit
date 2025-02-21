class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  static const String baseUrl = "http://10.0.2.2:3000/api/";
  // static const String baseUrl = "http://192.168.1.76:3000/api/";
  // static const String baseUrl = "http://192.168.101.21:3000/api/";

  // For iPhone
  //static const String baseUrl = "http://localhost:3000/api/v1/";

  // ====================== Auth Routes ======================
  static const String login = "users/login";
  static const String register = "users/register";
  static const String verifyEmail = "users/verify-otp";
  static const String imageUrl = "http://10.0.2.2:3000/uploads/";
  static const String uploadImage = "users/uploadImage";
  static const String getuser = "users/";

  // ====================== Booking Routes ======================
  static const String bookRoom = "bookings/book";
  static const String getAllBookings = "bookings/all";
  static const String getUserBookings = "bookings/getbooking";
  static const String confirmBooking = "bookings/confirm";

  // ====================== Room Routes ======================
  static const String getAllRooms = "rooms/";
  static const String getRoomById = "rooms/";
  static const String createRoom = "rooms/";
  static const String updateRoomAvailability = "rooms/";
  static const String deleteRoom = "rooms/";
}
