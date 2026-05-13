<?php
require_once 'db_config.php';

// Terima input JSON dari Flutter
$data = json_decode(file_get_contents("php://input"), true);

$id = $data['id'] ?? $_POST['id'] ?? '';
$name = $data['name'] ?? $_POST['name'] ?? '';
$email = $data['email'] ?? $_POST['email'] ?? '';
$phone = $data['phone'] ?? $_POST['phone'] ?? '';
$nip = $data['nip'] ?? $_POST['nip'] ?? '';

if (empty($id) || empty($email) || empty($name)) {
    echo json_encode(["status" => "error", "message" => "ID, Nama, dan Email tidak boleh kosong."]);
    exit;
}

try {
    // Check if the new email is already used by another user
    $stmtCheck = $pdo->prepare('SELECT id FROM users WHERE email = ? AND id != ?');
    $stmtCheck->execute([$email, $id]);
    if ($stmtCheck->rowCount() > 0) {
        echo json_encode(["status" => "error", "message" => "Email sudah digunakan oleh akun lain."]);
        exit;
    }

    $stmt = $pdo->prepare('UPDATE users SET name = ?, email = ?, phone = ?, nip = ? WHERE id = ?');
    $stmt->execute([$name, $email, $phone, $nip, $id]);

    echo json_encode(["status" => "success", "message" => "Profil berhasil diperbarui."]);

} catch (\PDOException $e) {
    echo json_encode(["status" => "error", "message" => "Gagal memperbarui profil. Detail: " . $e->getMessage()]);
}
?>
