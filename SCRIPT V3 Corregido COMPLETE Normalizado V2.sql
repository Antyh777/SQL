
-- ========== 1. rol ==========
-- Tabla de roles de usuario (admin, vendedor, cliente, etc).
-- Relacionada con: usuario_rol (N:M con usuario).
-- Normalización: 3FN.
CREATE TABLE rol (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  descripcion TEXT,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 2. area ==========
-- Áreas internas de la empresa (Ej: Cocina, Ventas).
-- Relacionada con: empleado (1:N).
-- Normalización: 3FN.
CREATE TABLE area (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  descripcion TEXT,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 3. horario ==========
-- Definición de horarios de trabajo.
-- Relacionada con: turno (1:N).
-- Normalización: 3FN.
CREATE TABLE horario (
  id INT AUTO_INCREMENT PRIMARY KEY,
  hora_inicio TIME NOT NULL,
  hora_fin TIME NOT NULL,
  descripcion VARCHAR(100),
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 4. tipo_pago ==========
-- Tipos de pago admitidos (Efectivo, Tarjeta, etc).
-- Relacionada con: orden, transaccion (1:N).
-- Normalización: 3FN.
CREATE TABLE tipo_pago (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  descripcion TEXT,
  porcentaje_igv DECIMAL(5,4) UNSIGNED NOT NULL DEFAULT 0.18,
  igv_exento BOOLEAN NOT NULL DEFAULT FALSE,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 5. metodo_entrega ==========
-- Métodos de entrega (Recojo, Delivery).
-- Relacionada con: orden (1:N).
-- Normalización: 3FN.
CREATE TABLE metodo_entrega (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  descripcion TEXT,
  umbral_gratis DECIMAL(10,2) NOT NULL DEFAULT 60.00,
  costo_delivery DECIMAL(10,2) NOT NULL DEFAULT 5.00,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 6. categoria_producto ==========
-- Categorías de productos (Bebidas, Combos, etc).
-- Relacionada con: producto, promocion (1:N).
-- Normalización: 3FN.
CREATE TABLE categoria_producto (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  descripcion TEXT,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 7. marca ==========
-- Marca de productos.
-- Relacionada con: producto (1:N).
-- Normalización: 3FN.
CREATE TABLE marca (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 8. proveedor ==========
-- Proveedores externos.
-- Relacionada con: equipo, pedido_abastecimiento (1:N).
-- Normalización: 3FN.
CREATE TABLE proveedor (
  id INT AUTO_INCREMENT PRIMARY KEY,
  razon_social VARCHAR(100) NOT NULL,
  ruc VARCHAR(20) NOT NULL,
  direccion VARCHAR(150),
  telefono VARCHAR(20),
  email VARCHAR(100),
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 9. curso ==========
-- Cursos internos de capacitación.
-- Relacionada con: capacitacion (1:N).
-- Normalización: 3FN.
CREATE TABLE curso (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  duracion_horas INT NOT NULL,
  instructor VARCHAR(100),
  descripcion TEXT,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 10. sucursal ==========
-- Sucursales físicas.
-- Relacionada con: equipo, empleado, inventario, caja, pedido_abastecimiento (1:N).
-- Normalización: 3FN.
CREATE TABLE sucursal (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  direccion VARCHAR(150),
  telefono VARCHAR(20),
  horario_apertura TIME,
  horario_cierre TIME,
  responsable VARCHAR(100),
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 11. equipo ==========
-- Equipos físicos de la empresa.
-- Relacionada con: proveedor, sucursal, mantenimiento (1:N).
-- Normalización: 3FN.
CREATE TABLE equipo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  modelo VARCHAR(50),
  serial VARCHAR(50),
  fecha_adquisicion DATE NOT NULL,
  estado ENUM('Operativo','Averiado','DadoBaja') NOT NULL DEFAULT 'Operativo',
  id_proveedor INT,
  id_sucursal INT,
  FOREIGN KEY (id_proveedor) REFERENCES proveedor(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (id_sucursal) REFERENCES sucursal(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 12. persona ==========
-- Datos generales de personas (base para cliente/empleado).
-- Relacionada con: cliente, empleado (1:1).
-- Normalización: 3FN.
CREATE TABLE persona (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombres VARCHAR(100) NOT NULL,
  apellidos VARCHAR(100) NOT NULL,
  razon_social VARCHAR(150),
  documento_identidad VARCHAR(20) NOT NULL UNIQUE,
  fecha_registro DATE NOT NULL,
  email VARCHAR(100),
  telefono VARCHAR(20),
  direccion_principal VARCHAR(150),
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 13. cliente ==========
-- Clientes (hereda de persona).
-- Relacionada con: persona (1:1), usuario, orden, reclamo, respuesta_encuesta, cliente_puntos (1:1).
-- Normalización: 3FN.
CREATE TABLE cliente (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_persona INT NOT NULL UNIQUE,
  usuario_web VARCHAR(50) UNIQUE,
  FOREIGN KEY (id_persona) REFERENCES persona(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 14. empleado ==========
-- Empleados (hereda de persona lógicamente, pero tabla separada).
-- Relacionada con: area, sucursal, usuario, mantenimiento, turno, asistencia, capacitacion, evaluacion_empleado.
-- Normalización: 3FN.
CREATE TABLE empleado (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombres VARCHAR(100) NOT NULL,
  apellidos VARCHAR(100) NOT NULL,
  documento_identidad VARCHAR(20) NOT NULL UNIQUE,
  fecha_nacimiento DATE NOT NULL,
  fecha_ingreso DATE NOT NULL,
  email VARCHAR(100),
  telefono VARCHAR(20),
  id_area INT,
  id_sucursal INT,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
  FOREIGN KEY (id_area) REFERENCES area(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (id_sucursal) REFERENCES sucursal(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 15. mantenimiento ==========
-- Mantenimientos de equipo (programados o correctivos).
-- Relacionada con: equipo, empleado (técnico).
-- ON DELETE SET NULL para evitar borrar mantenimientos si se elimina el equipo o técnico.
CREATE TABLE mantenimiento (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_equipo INT,
  tipo ENUM('Preventivo','Correctivo') NOT NULL,
  descripcion TEXT,
  fecha_programada DATE NOT NULL,
  fecha_ejecutado DATE,
  frecuencia VARCHAR(20),
  id_tecnico INT,
  costo DECIMAL(10,2),
  estado ENUM('Programado','Ejecutado','Cancelado') NOT NULL DEFAULT 'Programado',
  FOREIGN KEY (id_equipo) REFERENCES equipo(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (id_tecnico) REFERENCES empleado(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 16. receta ==========
-- Recetas de productos compuestos (ejemplo: menú).
-- Relacionada con: producto, receta_ingrediente.
CREATE TABLE receta (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  fecha_creacion DATE NOT NULL,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 17. ingrediente ==========
-- Ingredientes de recetas/productos.
-- Relacionada con: receta_ingrediente.
CREATE TABLE ingrediente (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  unidad_medida VARCHAR(20) NOT NULL,
  costo_unitario DECIMAL(12,2) NOT NULL,
  stock_minimo DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 18. receta_ingrediente ==========
-- Relación N:M entre receta e ingrediente.
-- ON DELETE CASCADE para limpiar automáticamente ingredientes/recetas eliminados.
CREATE TABLE receta_ingrediente (
  id_receta INT NOT NULL,
  id_ingrediente INT NOT NULL,
  cantidad DECIMAL(10,2) NOT NULL,
  unidad_medida VARCHAR(20),
  PRIMARY KEY (id_receta, id_ingrediente),
  FOREIGN KEY (id_receta) REFERENCES receta(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (id_ingrediente) REFERENCES ingrediente(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 19. producto ==========
-- Productos comercializados (menú, extra, combo, etc).
-- Relacionada con: categoria_producto, receta, marca, inventario, detalle_orden, promocion_producto, resena_producto.
-- ON DELETE SET NULL para id_receta y id_marca, ON DELETE RESTRICT para id_categoria.
CREATE TABLE producto (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  tipo ENUM('SIMPLE','EXTRA','MENU','COMBO') NOT NULL,
  descripcion TEXT,
  precio_base DECIMAL(12,2) NOT NULL,
  puntos INT NOT NULL DEFAULT 0,
  id_categoria INT NOT NULL,
  id_receta INT,
  id_marca INT,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
  imagen_url VARCHAR(255),
  FOREIGN KEY (id_categoria) REFERENCES categoria_producto(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  FOREIGN KEY (id_receta) REFERENCES receta(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (id_marca) REFERENCES marca(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 20. promocion ==========
-- Promociones activas (por producto, por categoría, global).
-- ON DELETE SET NULL para id_categoria.
CREATE TABLE promocion (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  tipo ENUM('Porcentaje','MontoFijo','EnvioGratis') NOT NULL,
  valor DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  aplica_a ENUM('Producto','Categoria','General') NOT NULL,
  id_categoria INT,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
  FOREIGN KEY (id_categoria) REFERENCES categoria_producto(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 21. cupon ==========
-- Cupones de descuento ligados a promociones.
-- Relacionada con: promocion, cliente (asignado), orden.
-- ON DELETE SET NULL para mantener historial aunque el cliente o promoción sea borrado.
CREATE TABLE cupon (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_promocion INT NOT NULL,
  codigo VARCHAR(50) NOT NULL UNIQUE,
  uso_maximo INT NOT NULL DEFAULT 1,
  usos_realizados INT NOT NULL DEFAULT 0,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  id_cliente_asignado INT,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
  FOREIGN KEY (id_promocion) REFERENCES promocion(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (id_cliente_asignado) REFERENCES cliente(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 22. encuesta ==========
-- Encuestas de satisfacción.
-- Relacionada con: pregunta_encuesta, respuesta_encuesta.
CREATE TABLE encuesta (
  id INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(100) NOT NULL,
  descripcion TEXT,
  fecha_creacion DATE NOT NULL,
  fecha_inicio_vigencia DATE NOT NULL,
  fecha_fin_vigencia DATE NOT NULL,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 23. pregunta_encuesta ==========
-- Preguntas de una encuesta.
-- Relacionada con: encuesta, respuesta_encuesta.
CREATE TABLE pregunta_encuesta (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_encuesta INT NOT NULL,
  texto TEXT NOT NULL,
  tipo ENUM('Rating','Texto','OpcionMultiple') NOT NULL,
  opciones TEXT,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
  FOREIGN KEY (id_encuesta) REFERENCES encuesta(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 24. respuesta_encuesta ==========
-- Respuestas de clientes a encuestas.
-- Relacionada con: encuesta, pregunta_encuesta, cliente.
CREATE TABLE respuesta_encuesta (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_encuesta INT NOT NULL,
  id_pregunta INT NOT NULL,
  id_cliente INT NOT NULL,
  valor VARCHAR(255) NOT NULL,
  fecha_contestacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_encuesta) REFERENCES encuesta(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (id_pregunta) REFERENCES pregunta_encuesta(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 25. tipo_reclamo ==========
-- Tipos de reclamos (demora, producto, etc).
-- Relacionada con: reclamo (1:N).
CREATE TABLE tipo_reclamo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  descripcion TEXT,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 26. usuario ==========
-- Usuarios del sistema (pueden representar empleados o clientes).
-- Relacionada con: usuario_rol, notificacion, configuracion_usuario, reporte.
-- Puede estar asociado a un empleado o cliente.
CREATE TABLE usuario (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
  id_empleado INT,
  id_cliente INT,
  FOREIGN KEY (id_empleado) REFERENCES empleado(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE usuario 
ADD CONSTRAINT chk_usuario_asociacion 
CHECK (id_empleado IS NOT NULL OR id_cliente IS NOT NULL);

-- ========== 27. turno ==========
-- Turnos asignados a empleados.
-- Relacionada con: empleado, horario, asistencia.
CREATE TABLE turno (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_empleado INT NOT NULL,
  id_horario INT NOT NULL,
  fecha DATE NOT NULL,
  estado ENUM('Programado','Confirmado','Cancelado') NOT NULL DEFAULT 'Programado',
  FOREIGN KEY (id_empleado) REFERENCES empleado(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (id_horario) REFERENCES horario(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 28. caja ==========
-- Cajas registradoras de sucursal.
-- Relacionada con: sucursal, orden, transaccion.
CREATE TABLE caja (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  id_sucursal INT NOT NULL,
  monto_inicial DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  estado ENUM('Abierta','Cerrada') NOT NULL DEFAULT 'Abierta',
  FOREIGN KEY (id_sucursal) REFERENCES sucursal(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 29. orden ==========
-- Cabecera de órdenes de venta.
-- Relacionada con: cliente, sucursal, caja, empleado, metodo_entrega, tipo_pago, cupon, promocion, detalle_orden, envio, devolucion_pedido, reclamo, transaccion, orden_promocion.
CREATE TABLE orden (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  id_sucursal INT,
  id_caja INT,
  id_empleado INT,
  id_metodo_entrega INT NOT NULL,
  id_tipo_pago INT NOT NULL,
  id_cupon INT,
  id_promocion INT,
  total_bruto DECIMAL(12,2) NOT NULL DEFAULT 0.00,        
  total_descuento DECIMAL(12,2) NOT NULL DEFAULT 0.00,    
  delivery_fee DECIMAL(12,2) NOT NULL DEFAULT 0.00,       
  subtotal_con_delivery DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  igv DECIMAL(12,2) NOT NULL DEFAULT 0.00,               
  total_neto DECIMAL(12,2) NOT NULL DEFAULT 0.00,         
  estado ENUM('Pendiente','EnProceso','Entregada','Cancelada') NOT NULL DEFAULT 'Pendiente',
  FOREIGN KEY (id_cliente) REFERENCES cliente(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (id_sucursal) REFERENCES sucursal(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (id_caja) REFERENCES caja(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (id_empleado) REFERENCES empleado(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (id_metodo_entrega) REFERENCES metodo_entrega(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  FOREIGN KEY (id_tipo_pago) REFERENCES tipo_pago(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  FOREIGN KEY (id_cupon) REFERENCES cupon(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (id_promocion) REFERENCES promocion(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 30. reclamo ==========
-- Reclamos de clientes sobre órdenes.
-- Relacionada con: cliente, orden, tipo_reclamo.
CREATE TABLE reclamo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  id_orden INT,
  id_tipo_reclamo INT NOT NULL,
  descripcion TEXT NOT NULL,
  fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  estado ENUM('Pendiente','EnProceso','Resuelto','Cerrado') NOT NULL DEFAULT 'Pendiente',
  fecha_cierre DATE,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (id_orden) REFERENCES orden(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (id_tipo_reclamo) REFERENCES tipo_reclamo(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 31. reporte ==========
-- Reportes generados por el sistema.
-- Relacionada con: usuario.
CREATE TABLE reporte (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  tipo ENUM('Ventas','Inventario','RRHH','Reclamos','Otros') NOT NULL,
  fecha_generacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  id_usuario INT NOT NULL,
  parametros TEXT,
  ruta_archivo VARCHAR(255),
  FOREIGN KEY (id_usuario) REFERENCES usuario(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 32. capacitacion ==========
-- Capacitaciones realizadas por empleados.
-- Relacionada con: empleado, curso.
CREATE TABLE capacitacion (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_empleado INT NOT NULL,
  id_curso INT NOT NULL,
  fecha_inscripcion DATE NOT NULL,
  fecha_finalizacion DATE,
  estado ENUM('Inscripto','EnCurso','Finalizado','Reprobado') NOT NULL DEFAULT 'Inscripto',
  calificacion DECIMAL(5,2),
  FOREIGN KEY (id_empleado) REFERENCES empleado(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (id_curso) REFERENCES curso(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 33. asistencia ==========
-- Asistencias de empleados a sus turnos.
-- Relacionada con: empleado, turno.
CREATE TABLE asistencia (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_empleado INT NOT NULL,
  id_turno INT NOT NULL,
  hora_entrada TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  hora_salida TIMESTAMP,
  estado ENUM('Presente','Tarde','Ausente') NOT NULL,
  FOREIGN KEY (id_empleado) REFERENCES empleado(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (id_turno) REFERENCES turno(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 34. evaluacion_empleado ==========
-- Evaluaciones de desempeño de empleados.
-- Relacionada con: empleado (como evaluado y como evaluador).
CREATE TABLE evaluacion_empleado (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_empleado INT NOT NULL,
  id_evaluador INT NOT NULL,
  fecha_evaluacion DATE NOT NULL,
  criterios TEXT NOT NULL,
  comentarios TEXT,
  FOREIGN KEY (id_empleado) REFERENCES empleado(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (id_evaluador) REFERENCES empleado(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 35. inventario ==========
-- Stock de productos por sucursal.
-- Relacionada con: sucursal, producto, movimiento_stock.
CREATE TABLE inventario (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_sucursal INT NOT NULL,
  id_producto INT NOT NULL,
  stock_actual DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  stock_minimo DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
  FOREIGN KEY (id_sucursal) REFERENCES sucursal(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (id_producto) REFERENCES producto(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  UNIQUE KEY uq_inventario (id_sucursal, id_producto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 36. pedido_abastecimiento ==========
-- Pedidos de productos a proveedores.
-- Relacionada con: proveedor, sucursal, detalle_pedido_abastecimiento.
CREATE TABLE pedido_abastecimiento (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_proveedor INT NOT NULL,
  fecha_pedido DATE NOT NULL,
  fecha_esperada_entrega DATE,
  id_sucursal_destino INT,
  estado ENUM('Creado','Enviado','Recibido','Cancelado') NOT NULL DEFAULT 'Creado',
  observaciones TEXT,
  FOREIGN KEY (id_proveedor) REFERENCES proveedor(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (id_sucursal_destino) REFERENCES sucursal(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 37. detalle_pedido_abastecimiento ==========
-- Detalle de cada producto solicitado en un pedido de abastecimiento.
-- Relacionada con: pedido_abastecimiento, producto.
CREATE TABLE detalle_pedido_abastecimiento (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido_abastecimiento INT NOT NULL,
  id_producto INT NOT NULL,
  cantidad_solicitada DECIMAL(10,2) NOT NULL,
  precio_unitario DECIMAL(12,2) NOT NULL,
  subtotal DECIMAL(12,2) NOT NULL,
  estado_linea ENUM('Pendiente','Parcial','Recibido','Anulado') NOT NULL DEFAULT 'Pendiente',
  FOREIGN KEY (id_pedido_abastecimiento) REFERENCES pedido_abastecimiento(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (id_producto) REFERENCES producto(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 38. usuario_rol ==========
-- Relación N:M entre usuario y rol.
CREATE TABLE usuario_rol (
  id_usuario INT NOT NULL,
  id_rol INT NOT NULL,
  fecha_asignacion DATE NOT NULL,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
  PRIMARY KEY (id_usuario, id_rol),
  FOREIGN KEY (id_usuario) REFERENCES usuario(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (id_rol) REFERENCES rol(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 39. promocion_producto ==========
-- Relación N:M entre promoción y producto.
CREATE TABLE promocion_producto (
  id_promocion INT NOT NULL,
  id_producto INT NOT NULL,
  descuento_especifico DECIMAL(12,2),
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
  PRIMARY KEY (id_promocion, id_producto),
  FOREIGN KEY (id_promocion) REFERENCES promocion(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (id_producto) REFERENCES producto(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 40. detalle_orden ==========
-- Detalle de productos de una orden.
-- Incluye triggers para calcular subtotal y puntos por línea.
CREATE TABLE detalle_orden (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_orden INT NOT NULL,
  id_producto INT NOT NULL,
  cantidad INT NOT NULL DEFAULT 1,
  precio_unitario DECIMAL(12,2) NOT NULL,
  subtotal DECIMAL(12,2) NOT NULL,
  puntos_linea INT NOT NULL DEFAULT 0,
  descripcion_extra VARCHAR(255),
  FOREIGN KEY (id_orden) REFERENCES orden(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (id_producto) REFERENCES producto(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DELIMITER //
CREATE TRIGGER trg_detalle_orden_subtotal
BEFORE INSERT ON detalle_orden
FOR EACH ROW
SET NEW.subtotal = NEW.cantidad * NEW.precio_unitario;
CREATE TRIGGER trg_detalle_orden_puntos
BEFORE INSERT ON detalle_orden
FOR EACH ROW
BEGIN
  DECLARE v_puntos INT;
  SELECT puntos INTO v_puntos FROM producto WHERE id = NEW.id_producto;
  SET NEW.puntos_linea = NEW.cantidad * v_puntos;
END //
DELIMITER ;

-- ========== 41. transaccion ==========
-- Registro de pagos realizados para una orden.
CREATE TABLE transaccion (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_orden INT NOT NULL,
  fecha_pago TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  monto DECIMAL(12,2) NOT NULL,  
  id_tipo_pago INT NOT NULL,
  estado ENUM('Pagado','Pendiente','Devuelto') NOT NULL DEFAULT 'Pendiente',
  referencia VARCHAR(100),
  id_caja INT,
  FOREIGN KEY (id_orden) REFERENCES orden(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (id_tipo_pago) REFERENCES tipo_pago(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  FOREIGN KEY (id_caja) REFERENCES caja(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 42. cliente_puntos ==========
-- Puntos acumulados y redimidos por cliente.
CREATE TABLE cliente_puntos (
  id_cliente INT PRIMARY KEY,
  puntos_acumulados INT NOT NULL DEFAULT 0,  
  puntos_redimidos INT NOT NULL DEFAULT 0,
  fecha_ultima_actualizacion DATE NOT NULL,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 43. envio ==========
-- Envíos realizados para una orden.
CREATE TABLE envio (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_orden INT NOT NULL,
  fecha_envio DATE NOT NULL,
  transportista VARCHAR(100),
  numero_guia VARCHAR(50),
  estado ENUM('EnTransito','Entregado','Devuelto') NOT NULL DEFAULT 'EnTransito',
  FOREIGN KEY (id_orden) REFERENCES orden(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 44. devolucion_pedido ==========
-- Devoluciones solicitadas por órdenes.
CREATE TABLE devolucion_pedido (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_orden INT NOT NULL,
  fecha_solicitud DATE NOT NULL,
  motivo TEXT NOT NULL,
  estado ENUM('Solicitado','Aprobado','Rechazado','Completado') NOT NULL DEFAULT 'Solicitado',
  fecha_resolucion DATE,
  FOREIGN KEY (id_orden) REFERENCES orden(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 45. movimiento_stock ==========
-- Movimientos de inventario (entrada, salida, ajuste).
CREATE TABLE movimiento_stock (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_inventario INT NOT NULL,
  tipo ENUM('Entrada','Salida','Ajuste') NOT NULL,
  cantidad DECIMAL(10,2) NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  referencia VARCHAR(100),
  FOREIGN KEY (id_inventario) REFERENCES inventario(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 46. orden_promocion ==========
-- Relación N:M entre orden y promoción aplicada.
CREATE TABLE orden_promocion (
  id_orden INT NOT NULL,
  id_promocion INT NOT NULL,
  PRIMARY KEY (id_orden, id_promocion),
  FOREIGN KEY (id_orden) REFERENCES orden(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (id_promocion) REFERENCES promocion(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 47. resena_producto ==========
-- Reseñas de clientes sobre productos.
CREATE TABLE resena_producto (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_producto INT NOT NULL,
  id_cliente INT NOT NULL,
  calificacion TINYINT NOT NULL,
  comentario TEXT,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
  FOREIGN KEY (id_producto) REFERENCES producto(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 48. notificacion ==========
-- Notificaciones enviadas a usuario.
CREATE TABLE notificacion (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  mensaje TEXT NOT NULL,
  leido BOOLEAN NOT NULL DEFAULT FALSE,
  fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_usuario) REFERENCES usuario(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 49. configuracion_usuario ==========
-- Preferencias/configuraciones de usuario.
CREATE TABLE configuracion_usuario (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  clave VARCHAR(100) NOT NULL,
  valor VARCHAR(255) NOT NULL,
  UNIQUE KEY uq_config_usuario (id_usuario, clave),
  FOREIGN KEY (id_usuario) REFERENCES usuario(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========== 50. regla_descuento ==========
-- Reglas de aplicación de descuentos.
CREATE TABLE regla_descuento (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  tipo ENUM('Cantidad','Monto','Fecha') NOT NULL,
  valor DECIMAL(12,2) NOT NULL,
  umbral DECIMAL(12,2),
  fecha_inicio DATE,
  fecha_fin DATE,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
