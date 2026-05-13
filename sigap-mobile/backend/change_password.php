<?php
require_once 'db_config.php';

// Terima input JSON dari Flutter
$data = json_decode(file_get_contents("php://input"), true);

$id = $data['id'] ?? $_POST['id'] ?? '';
$old_password = $data['old_password'] ?? $_POST['old_password'] ?? '';
$new_password = $data['new_password'] ?? $_POST['new_password'] ?? '';

if (empty($id) || empty($old_password) || empty($new_password)) {
    echo json_encode(["status" => "error", "message" => "ID, Password Lama, dan Password Baru tidak boleh kosong."]);
    exit;
}

try {
    // Ambil password lama dari database
    $stmt = $pdo->prepare('SELECT password FROM users WHERE id = ?');
    $stmt->execute([$id]);
    $user = $stmt->fetch();

    if (!$user) {
        echo json_encode(["status" => "error", "message" => "Pengguna tidak ditemukan."]);
        exit;
    }

    $db_password = $user['password'];
    $is_password_valid = false;

    // Cek kecocokan password lama
    if ($old_password === $db_password || hash('sha256', $old_password) === $db_password) {
        $is_password_valid = true;
    }

    if (!$is_password_valid) {
        echo json_encode(["status" => "error", "message" => "Password lama tidak sesuai."]);
        exit;
    }

    // Hash password baru sebelum disimpan
    $hashed_new_password = hash('sha256', $new_password);
    $stmtUpdate = $pdo->prepare('UPDATE users SET password = ? WHERE id = ?');
    $stmtUpdate->execute([$hashed_new_password, $id]);

    echo json_encode(["status" => "success", "message" => "Password berhasil diubah."]);

} catch (\PDOException $e) {
    echo json_encode(["status" => "error", "message" => "Gagal mengubah password. Detail: " . $e->getMessage()]);
}
?>
