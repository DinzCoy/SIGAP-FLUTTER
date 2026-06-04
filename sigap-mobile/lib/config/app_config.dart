class AppConfig {
  /// Base URL API Laravel Anda.
  /// Mengarah ke server cPanel production
  static const String baseUrl = "https://sigap.makagang.stat7300.net/api";

  /// API KEY untuk keamanan komunikasi antara Flutter dan Laravel.
  /// Pastikan nilai ini sama dengan yang dikonfigurasi di middleware Laravel Anda.
  static const String apiKey = "SIGAP_SECRET_API_KEY_2026";

  /// Header standar untuk semua request API
  static Map<String, String> getHeaders([String? token]) {
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "SUPER-API-KEY": apiKey,
    };

    if (token != null) {
      // Menggunakan header custom X-Auth-Token karena server cPanel/Apache
      // memblokir header 'Authorization: Bearer' sebelum sampai ke PHP.
      headers["X-Auth-Token"] = token;
    }

    return headers;
  }
}
