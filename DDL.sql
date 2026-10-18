CREATE DATABASE Taller_Veterinaria;
use Taller_Veterinaria;
CREATE Table clientes (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    correoElectronico VARCHAR(100) NOT NULL,
    activo TINYINT(1)  DEFAULT 1
);

CREATE Table mascotas (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_cliente INT,
    nombre VARCHAR(20) NOT NULL,
    nPatas INT NOT NULL,
    estatura FLOAT,
    FOREIGN KEY (ID_cliente) REFERENCES clientes (ID)

);

CREATE Table servicios (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    precio DECIMAL(10,2) DEFAULT(0.00)
);

CREATE Table mascotas_servicio(
    ID_mascota INT,
    ID_servicio INT,
    fecha DATE NOT NULL,
    FOREIGN KEY (ID_mascota) REFERENCES mascotas(ID),
    FOREIGN KEY (ID_servicio) REFERENCES servicios(ID)
);

