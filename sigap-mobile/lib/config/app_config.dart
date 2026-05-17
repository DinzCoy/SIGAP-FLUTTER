class AppConfig {
  /// Base URL API Laravel Anda. 
  /// Menggunakan IP NetBird PC/Laptop lokal untuk koneksi yang konsisten
  static const String baseUrl = "http://100.71.121.127:8000/api";

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
      headers["Authorization"] = "Bearer $token";
    }
    
    return headers;
  }
}
