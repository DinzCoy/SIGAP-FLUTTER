<?php
require_once 'db_config.php';

// Terima input JSON dari Flutter
$data = json_decode(file_get_contents("php://input"), true);

// Fallback ke POST biasa jika tidak ada JSON
$email = $data['email'] ?? $_POST['email'] ?? '';
$password = $data['password'] ?? $_POST['password'] ?? '';
$role = $data['role'] ?? $_POST['role'] ?? '';

if (empty($email) || empty($password) || empty($role)) {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap. Pastikan email, password, dan role terisi."]);
    exit;
}

try {
    // Mengecek apakah ada pengguna dengan role tersebut
    $stmt = $pdo->prepare('SELECT id, email, password, name, phone, nip FROM users WHERE role = ?');
    $stmt->execute([$role]);
    $results = $stmt->fetchAll();

    if (count($results) === 0) {
        echo json_encode(["status" => "error", "message" => "Role tidak ditemukan atau belum ada akun untuk role ini."]);
        exit;
    }

    $emailFound = false;
    $passwordMatch = false;

    $userData = null;

    // Verifikasi berdasarkan logika yang sama di Flutter sebelumnya
    foreach ($results as $row) {
        if ($row['email'] === $email) {
            $emailFound = true;
            // Cek password: bisa berupa teks biasa (default) ATAU hash (jika sudah direset)
            if ($row['password'] === $password || hash('sha256', $password) === $row['password']) {
                $passwordMatch = true;
                $userData = $row;
            }
            break; // Berhenti mencari jika email cocok
        }
    }

    if (!$emailFound) {
        echo json_encode(["status" => "error", "message" => "Email salah untuk role $role."]);
        exit;
    }

    if (!$passwordMatch) {
        echo json_encode(["status" => "error", "message" => "Password yang dimasukkan salah."]);
        exit;
    }

    echo json_encode([
        "status" => "success", 
        "message" => "Login berhasil.",
        "user" => [
            "id" => $userData['id'],
            "email" => $userData['email'],
            "role" => $role,
            "name" => $userData['name'] ?? '',
            "phone" => $userData['phone'] ?? '',
            "nip" => $userData['nip'] ?? ''
        ]
    ]);

} catch (\PDOException $e) {
    echo json_encode(["status" => "error", "message" => "Gagal mengeksekusi query. Detail: " . $e->getMessage()]);
}
?>
