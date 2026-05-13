CREATE DATABASE IF NOT EXISTS sigap_db;
USE sigap_db;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    name VARCHAR(255) DEFAULT '',
    phone VARCHAR(50) DEFAULT '',
    nip VARCHAR(100) DEFAULT ''
);

INSERT INTO users (email, password, role, name, phone, nip) VALUES
('admin@sigap.go.id', 'password123', 'Admin', 'Admin SIGAP', '08111111111', '198001012005011001'),
('pimpinan@sigap.go.id', 'password123', 'Pimpinan', 'Pimpinan SIGAP', '08222222222', '197002022000011002'),
('teknisi@sigap.go.id', 'password123', 'Teknisi', 'Budi Teknisi', '08333333333', '199003032015011003'),
('barang@sigap.go.id', 'password123', 'Pengelola Barang', 'Pengelola Barang', '08444444444', '198504042010011004'),
('ruangan@sigap.go.id', 'password123', 'Pengelola Ruangan', 'Pengelola Ruang', '08555555555', '198805052012011005'),
('user@sigap.go.id', 'password123', 'User', 'Siti Pengguna', '08666666666', '199506062020012006');
