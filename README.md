# 🐾 Sistema de Gestión de Taller Veterinaria

Este proyecto consiste en el diseño, implementación y desarrollo de la base de datos relacional para el sistema de gestión de una **Veterinaria**, utilizando **MySQL**. Incluye la creación del esquema relacional, datos de prueba y un conjunto de **Procedimientos Almacenados (Stored Procedures)** que implementan lógica de negocio avanzada (bucles, estructuras condicionales, parámetros `IN`/`OUT` y control de excepciones).

---

## 🎥 Video Demonstrativo

A continuación se adjunta el enlace a la demostración en video donde se explica el funcionamiento y ejecución de cada procedimiento almacenado:

📌 **[Ver Video de Demostración del Proyecto en Google Drive](https://drive.google.com/file/d/1LNpvR-SaIsvQx42a17hiN6V9pQkQwNKP/view?usp=sharing)**

---

## 📐 Estructura de la Base de Datos

La base de datos `Taller_Veterinaria` consta de 4 tablas principales vinculadas mediante llaves foráneas:

1. **`clientes`**: Almacena la información de los dueños de las mascotas.
   * `ID` (PK, AUTO_INCREMENT)
   * `nombre` (VARCHAR)
   * `direccion` (VARCHAR)
   * `correoElectronico` (VARCHAR, UNIQUE)
   * `activo` (TINYINT)
2. **`mascotas`**: Registra los datos de los animales atendidos.
   * `ID` (PK, AUTO_INCREMENT)
   * `ID_cliente` (FK -> clientes.ID)
   * `nombre` (VARCHAR)
   * `nPatas` (INT)
   * `estatura` (FLOAT)
3. **`servicios`**: Catálogo de servicios ofrecidos y sus precios.
   * `ID` (PK, AUTO_INCREMENT)
   * `nombre` (VARCHAR)
   * `precio` (DECIMAL)
4. **`mascotas_servicio`**: Tabla intermedia que guarda el historial de atenciones.
   * `ID_mascota` (FK -> mascotas.ID)
   * `ID_servicio` (FK -> servicios.ID)
   * `fecha` (DATE)

---

## ⚙️ Procedimientos Almacenados Desarrollados

A continuación se resume la lista de procedimientos almacenados incluidos en el script principal:

### 1. Gestión de Clientes y Estado
* **`ActualizarEstado(c_ID, c_estado)`**: Modifica el estado activo/inactivo de un cliente validando el texto ingresado y lanzando un error con `SIGNAL SQLSTATE` si el parámetro es inválido.
* **`VerificarCorreo(v_correo)`**: Valida si un correo electrónico ya existe en el sistema antes de registrarlo utilizando `EXISTS`.
* **`ContarClientesActivos(OUT total_activos)`**: Cuenta mediante un parámetro de salida el total de clientes marcados como activos (`activo = 1`).

### 2. Gestión de Mascotas
* **`ActualizarMascota(a_ID, a_nombre, a_estatura)`**: Actualiza el nombre y la estatura de una mascota por su ID.
* **`ClasificarMascotas(c_ID)`**: Evalúa la estatura de una mascota mediante condicionales `IF/ELSE` y determina si es de estatura "ALTA" o "BAJA".
* **`aumentarEstatura(a_aumento)`**: Utiliza un bucle `WHILE` para iterar registro por registro y aumentar la estatura de todas las mascotas registradas.
* **`TransferirMascota(t_ID_mascota, t_ID_cliente)`**: Reasigna la propiedad de una mascota a un nuevo cliente/dueño.
* **`EliminarMascota(e_ID)`**: Realiza la eliminación en cascada manual, borrando primero los registros en `mascotas_servicio` y luego la mascota.

### 3. Servicios e Historial
* **`Servicios_mascotas(s_ID_mascota)`**: Utiliza `INNER JOIN` para mostrar el historial completo de servicios recibidos por una mascota específica (Mascota, Servicio, Fecha).
* **`ActualizarPrecio(a_ID, a_precio)`**: Permite modificar el precio de un servicio del catálogo.
* **`ContarServicios(c_ID, OUT C_serviciosM)`**: Devuelve mediante un parámetro `OUT` la cantidad total de servicios que ha recibido una mascota.
* **`EliminarServicio(e_servicio)`**: Elimina un servicio y sus registros asociados evitando bloqueos del modo `SQL_SAFE_UPDATES`.
* **`RepetirRegistros(R_ID, R_ID_servicio, R_fecha, R_cantidad)`**: Utiliza un bucle `REPEAT` para insertar de forma automatizada un mismo servicio múltiples veces.
* **`RegistrarMultiplesServicios(p_ID_mascota, p_lista_servicios, p_fecha)`**: Recibe una lista de IDs delimitada por comas (ej. `'1,3,5'`) y utiliza un bucle `LOOP` con manejo de cadenas (`SUBSTRING_INDEX`) para registrar múltiples servicios en un solo llamado.

---

## 🚀 Instrucciones de Ejecución

1. Abrir **MySQL Workbench** u otro cliente de MySQL de preferencia.
2. Ejecutar el script DDL para crear la base de datos y sus tablas:
   ```sql
   CREATE DATABASE Taller_Veterinaria;
   USE Taller_Veterinaria;
   ```
3. Ejecutar los scripts con los datos de inserción iniciales.
4. Cargar los scripts de creación de **Procedimientos Almacenados**.
5. Realizar las pruebas llamando a los procedimientos mediante consultas `CALL`:
   ```sql
   -- Ejemplo de prueba:
   CALL Servicios_mascotas(1);
   
   SET @total = 0;
   CALL ContarClientesActivos(@total);
   SELECT @total AS ClientesActivos;
   ```