use Taller_Veterinaria;
INSERT INTO clientes (nombre, direccion, correoElectronico, activo) VALUES
('Carlos Pérez', '10a Avenida 5-33 Zona 1, Guatemala', 'carlos.perez@gmail.com', 1),
('María Rodríguez', '3a Calle 2-15 Zona 4, Mixco', 'maria.rodz@gmail.com', 1),
('Juan Tzul', 'Colonia El Naranjo Zona 4, Mixco', 'jtzul@gmail.com', 1),
('Ana García', '15 Avenida 16-24 Zona 10, Guatemala', 'anagarcia123@gmail.com', 1),
('Luis Morales', 'Residenciales Planes de Bárcenas, Villa Nueva', 'lmorales.vn@gmail.com', 1),
('Rosa Chajón', 'Calle Principal Lote 45, San Juan Sacatepéquez', 'rosachajon@gmail.com', 0),
('Pedro Xicay', 'Cantón Exposición Zona 4, Guatemala', 'pxicay.z4@gmail.com', 1),
('Carmen López', 'Boulevard Vista Hermosa 22-10 Zona 15', 'clopez.vh@gmail.com', 1),
('Jorge Asturias', 'Kilómetro 14.5 Carretera a El Salvador', 'jorgeasturias@gmail.com', 1),
('Marta Pineda', 'Residenciales Los Olivos Zona 18, Guatemala', 'martapineda.18@gmail.com', 1);

INSERT INTO mascotas (ID_cliente, nombre, nPatas, estatura) VALUES
(1, 'Firulais', 4, 0.45),
(2, 'Pelusa', 4, 0.25),
(3, 'Max', 4, 0.60),
(4, 'Luna', 4, 0.30),
(5, 'Rocky', 4, 0.55),
(6, 'Michi', 4, 0.22),
(7, 'Pepe', 2, 0.15),
(8, 'Coco', 4, 0.35),
(9, 'Boster', 4, 0.65),
(10, 'Princesa', 4, 0.28),
(1, 'Toto', 4, 0.30);

INSERT INTO servicios (nombre, precio) VALUES
('Consulta General', 150.00),
('Vacunación Múltiple', 125.00),
('Vacunación Antirrábica', 85.00),
('Desparasitación', 50.00),
('Baño y Peluquería', 120.00),
('Corte de Uñas', 35.00),
('Esterilización Canina', 450.00),
('Esterilización Felina', 350.00),
('Limpieza Dental', 250.00),
('Examen de Sangre', 175.00);

INSERT INTO mascotas_servicio (ID_mascota, ID_servicio, fecha) VALUES
(1, 1, '2023-05-01'),
(2, 5, '2025-10-02'),
(3, 2, '2023-11-03'),
(4, 3, '2025-12-04'),
(5, 7, '2024-12-05'),
(6, 8, '2023-11-06'),
(7, 6, '2023-03-07'),
(8, 4, '2026-09-08'),
(9, 10, '2022-12-09'),
(10, 9, '2020-01-10');