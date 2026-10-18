--1. Insertar Cliente
DELIMITER $$
CREATE PROCEDURE InsertarCliente (IN c_cliente VARCHAR(100), IN c_direccion VARCHAR(100), IN c_correoElectronico VARCHAR(100) )
BEGIN
    INSERT INTO clientes (nombre, direccion, correoElectronico)
    SELECT c_cliente, c_direccion, c_correoElectronico;
END $$
DELIMITER;

call InsertarCliente ("Bryan Galdamez", "15 calle zona 3", "Gordo@gmail.com");

--2. Actualizar estado del cliente

DELIMITER $$
CREATE PROCEDURE ActualizarEstado (IN c_ID INT, IN c_estado VARCHAR(20))
BEGIN
    SET c_estado = LOWER(c_estado); 
    
    IF c_estado = 'activo' THEN
        UPDATE clientes
        SET activo = 1
        WHERE ID = c_ID;
        
    ELSEIF c_estado = 'inactivo' THEN
        UPDATE clientes
        SET activo = 0
        WHERE ID = c_ID;
        
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ESTADO INVÁLIDO. Use "activo" o "inactivo".';
    END IF;
END $$

DELIMITER ;

CALL ActualizarEstado (1, "INACTIVO");

--3. Contar mascotas por cliente 

DELIMITER $$

CREATE Procedure ContarMascotas (IN C_ID INT, OUT numero_mascotas INT )
BEGIN
    SELECT COUNT(ID_cliente) INTO numero_mascotas
    FROM mascotas
    WHERE ID_cliente = c_ID;
END $$

DELIMITER ;

set @numero_mascotas = 0 ;
CALL ContarMascotas (2,@numero_mascotas);
SELECT @numero_mascotas as Total_macotas;



--4. Listar servicios de una mascota 

DELIMITER $$
CREATE PROCEDURE ServiciosMascotas (IN s_ID_mascota INT)
BEGIN
    SELECT m.nombre as nombre_mascota, s.nombre AS servicio_realizado
    FROM mascotas_servicio ms 
    INNER JOIN servicios s on ms.ID_servicio = s.ID
    INNER JOIN mascotas m on ms.ID_servicio = m.ID 
    WHERE ms.ID_mascota = s_ID_mascota;

END $$

DELIMITER ; 

CALL ServiciosMascotas(2);

--5. Registrar servicio a mascota

DELIMITER $$

CREATE PROCEDURE RegistrarServicio (IN r_ID_mascota INT, IN r_ID_servicio INT, IN r_fecha DATE)
BEGIN
    INSERT INTO mascotas_servicio (ID_mascota, ID_servicio, fecha)
    SELECT r_ID_mascota, r_ID_servicio, r_fecha;
END $$

DELIMITER ; 

CALL RegistrarServicio (2,5,'2026-10-05');

SELECT * FROM mascotas_servicio;

--6. Eliminar Mascota

DELIMITER $$

CREATE PROCEDURE EliminarMascota (IN e_ID INT)
BEGIN

    DELETE FROM mascotas_servicio
    WHERE ID_mascota = e_ID;

    DELETE FROM mascotas
    WHERE ID = e_ID;
END $$

DELIMITER ; 

CALL  EliminarMascota(11);

select * from mascotas;

--7. Actualizar precio de servicio

DELIMITER $$

CREATE PROCEDURE ActualizarPrecio (IN a_ID INT ,IN a_precio DECIMAL(10,2))
BEGIN
    UPDATE servicios
    SET precio = a_precio
    WHERE ID = a_ID;
END $$

DELIMITER ;

CALL ActualizarPrecio (3, 150.00)

select * FROM servicios ; 

--8. Contar servicios por mascota

DELIMITER $$

CREATE PROCEDURE ContarServicios (IN c_ID INT, OUT C_serviciosM INT)
BEGIN
    SELECT COUNT(*) INTO C_serviciosM
    FROM mascotas_servicio 
    WHERE ID_mascota = c_ID;
END $$

DELIMITER ;


SET @total_servicios = 0;

CALL ContarServicios(3, @total_servicios);

SELECT @total_servicios AS TotalServicios;

--9. Incrementar precio de servicios

DELIMITER $$

CREATE PROCEDURE IncrementarPrecios (IN i_Precios DECIMAL(10,2))
BEGIN   
    UPDATE servicios
    SET precio = ((precio * i_precios) / 100 ) + precio
    WHERE ID > 0;
END $$

DELIMITER ;

CALL  IncrementarPrecios (10);

--10. Repetir Registro de servicio

DELIMITER $$

CREATE PROCEDURE RepetirRegistros (IN R_ID INT, IN R_ID_servicio INT, IN R_fecha DATE, IN R_cantidad INT)
BEGIN

    DECLARE contador INT DEFAULT 0;

    REPEAT
        SET contador = contador + 1;
        INSERT INTO mascotas_servicio (ID_mascota, ID_servicio, fecha)
        VALUES (R_ID, R_ID_servicio, R_fecha);
    UNTIL contador = R_cantidad
    END REPEAT;
END $$

DELIMITER ;

call RepetirRegistros (1,6,'2026-10-18',5);

--11. verificar existencia de correo electronico

DELIMITER $$

CREATE PROCEDURE VerificarCorreo (IN v_correo VARCHAR(100))
BEGIN

    IF EXISTS (SELECT 1 FROM clientes WHERE correoElectronico = v_correo) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CORREO ELECTRÓNICO YA ESTÁ REGISTRADO';
    ELSE
        SELECT 'CORREO NO REGISTRADO' AS Mensaje;
    END IF;
END $$

DELIMITER ;

CALL VerificarCorreo ("carlos.perez@gmail.com");
   
--12.  Aumentar estatura de mascotas

DELIMITER $$

CREATE PROCEDURE aumentarEstatura ( IN a_mascotas DECIMAL(10,2) )
BEGIN
    DECLARE c_min INT;
    DECLARE c_max INT;

    SELECT MIN(ID), MAX(ID) INTO c_min, c_max
    FROM mascotas;

    WHILE c_min <= c_max DO 

        UPDATE mascotas
        SET estatura = estatura + a_mascotas
        WHERE ID = c_min;

        SET c_min = c_min + 1;
    
    END WHILE;

END $$

DELIMITER ;

CALL aumentarEstatura(0.05);

--13 Clasificar Mascotas 
DELIMITER $$

CREATE PROCEDURE ClasificarMascotas (IN c_ID INT)
BEGIN
    
    DECLARE m_estatura DECIMAL(10,2);

    SELECT estatura INTO m_estatura
    FROM mascotas
    WHERE ID = c_ID;

    IF m_estatura > 0.40 THEN
        SELECT 'MASCOTA CON ESTATURA "ALTA"' AS estatura ;
    
    ELSE
        SELECT 'MASCOTA CON ESTATURA "BAJA"' AS estatura ;
    
    END IF;

END$$

DELIMITER ; 

CALL ClasificarMascotas (3);

--14. Contar clientes activos

DELIMITER $$

CREATE PROCEDURE ContarClientes (OUT c_activos INT)
BEGIN
    SELECT COUNT(*) INTO c_activos
    FROM clientes
    WHERE activo = 1;
END $$

DELIMITER ;

CALL ContarClientes(@total);

SELECT @total AS Cantidad_Clientes_Activos;

--15. Actualizar mascota

DELIMITER $$ 

CREATE PROCEDURE ActualizarMascota (IN a_ID INT, IN a_nombre VARCHAR(20), IN a_estatura FLOAT)
BEGIN
    UPDATE mascotas
    SET nombre = a_nombre, estatura = a_estatura
    WHERE ID = a_ID;
END $$

DELIMITER ;

CALL ActualizarMascota (2,"Peludo",0.25);

--16. Eliminar servicios por nombre

DELIMITER $$

DELIMITER $$

CREATE PROCEDURE EliminarServicio (IN e_servicio VARCHAR(50))
BEGIN

    IF EXISTS( SELECT * FROM servicios WHERE nombre = e_servicio) THEN

        DELETE FROM mascotas_servicio 
        WHERE ID_servicio > 0 
          AND ID_servicio IN (SELECT ID FROM servicios WHERE nombre = e_servicio);

        DELETE FROM servicios 
        WHERE ID > 0 
          AND nombre = e_servicio;

    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'SERVICIO INEXISTENTE';
    END IF;

END $$

DELIMITER ;

CALL EliminarServicio ("Examen de Sangre");

--17. listar mascotas por cliente

DELIMITER $$

CREATE PROCEDURE ListarMascotas(IN l_ID INT, OUT l_total INT  )
BEGIN
    SELECT COUNT(*) INTO l_total
    FROM mascotas
    WHERE ID_cliente = l_ID;
END $$
DELIMITER ; 

CALL ListarMascotas(1, @total);

SELECT @total AS Toal_mascotas;

--18 Transferir mascota a otro cliente 

DELIMITER $$
CREATE PROCEDURE TransferirMascota (IN t_ID_mascota INT , IN t_ID_cliente INT)
BEGIN
    UPDATE mascotas
    SET ID_cliente = t_ID_cliente
    WHERE ID = t_ID_mascota;
END $$

DELIMITER ;

CALL TransferirMascota(2, 2);

--19. multiples servicios

DELIMITER $$

CREATE PROCEDURE RegistrarMultiplesServicios (IN p_ID_mascota INT, IN p_lista_servicios VARCHAR(255), IN p_fecha DATE)
BEGIN
    DECLARE v_item VARCHAR(50);
    DECLARE v_id_servicio INT;

    bucle: LOOP
    
        IF p_lista_servicios IS NULL OR LENGTH(TRIM(p_lista_servicios)) = 0 THEN
            LEAVE bucle;
        END IF;

        SET v_item = TRIM(SUBSTRING_INDEX(p_lista_servicios, ',', 1));
        SET v_id_servicio = CAST(v_item AS UNSIGNED);

  
        INSERT INTO mascotas_servicio (ID_mascota, ID_servicio, fecha)
        VALUES (p_ID_mascota, v_id_servicio, p_fecha);

   
        IF LOCATE(',', p_lista_servicios) > 0 THEN
            SET p_lista_servicios = SUBSTRING(p_lista_servicios, LOCATE(',', p_lista_servicios) + 1);
        ELSE
            SET p_lista_servicios = '';
        END IF;

    END LOOP bucle;
END $$

DELIMITER ;

CALL RegistrarMultiplesServicios(2, '1,3,5', CURDATE());

