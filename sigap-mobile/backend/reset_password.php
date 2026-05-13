<?php
require_once 'db_config.php';

// Terima input JSON dari Flutter
$data = json_decode(file_get_contents("php://input"), true);

$email = $data['email'] ?? $_POST['email'] ?? '';
$newPassword = $data['newPassword'] ?? $_POST['newPassword'] ?? '';

if (empty($email) || empty($newPassword)) {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap."]);
    exit;
}

try {
    // Cek apakah email terdaftar
    $stmt = $pdo->prepare('SELECT id FROM users WHERE email = ?');
    $stmt->execute([$email]);
    $result = $stmt->fetch();

    if (!$result) {
        echo json_encode(["status" => "error", "message" => "Email tidak ditemukan."]);
        exit;
    }

    // Update password dengan fungsi hash bawaan database
    $updateStmt = $pdo->prepare('UPDATE users SET password = SHA2(?, 256) WHERE email = ?');
    $updateStmt->execute([$newPassword, $email]);

    echo json_encode(["status" => "success", "message" => "Password berhasil direset."]);

} catch (\PDOException $e) {
    echo json_encode(["status" => "error", "message" => "Gagal terhubung ke database. Detail: " . $e->getMessage()]);
}
?>
