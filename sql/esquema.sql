-- ============================================
-- Sistema de Facturación - Esquema completo
-- ============================================

-- Creamos la base de datos
CREATE DATABASE IF NOT EXISTS sistema_facturacion;
USE sistema_facturacion;

-- ============================================
-- Tabla: categorias
-- Agrupa los productos 
-- ============================================
CREATE TABLE categorias (
  categoria_id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL
);

-- ============================================
-- Tabla: clientes
-- Guarda a las personas que compran
-- ============================================
CREATE TABLE clientes (
  cliente_id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE,
  telefono VARCHAR(20),
  fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Tabla: productos
-- Guarda lo que se vende, con su categoría y stock
-- ============================================
CREATE TABLE productos (
  producto_id INT PRIMARY KEY AUTO_INCREMENT,
  categoria_id INT NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  stock INT NOT NULL DEFAULT 0,
  FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id)
);

-- ============================================
-- Tabla: facturas
-- Encabezado de cada venta
-- ============================================
CREATE TABLE facturas (
  factura_id INT PRIMARY KEY AUTO_INCREMENT,
  cliente_id INT NOT NULL,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  total DECIMAL(10,2) NOT NULL DEFAULT 0,
  FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

-- ============================================
-- Tabla: detalle_factura
-- Líneas de cada factura (qué se compró y cuánto)
-- ============================================
CREATE TABLE detalle_factura (
  detalle_id INT PRIMARY KEY AUTO_INCREMENT,
  factura_id INT NOT NULL,
  producto_id INT NOT NULL,
  cantidad INT NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (factura_id) REFERENCES facturas(factura_id),
  FOREIGN KEY (producto_id) REFERENCES productos(producto_id)
);

-- ============================================
-- Tabla: pagos
-- Registra cómo y cuándo se paga cada factura
-- ============================================
CREATE TABLE pagos (
  pago_id INT PRIMARY KEY AUTO_INCREMENT,
  factura_id INT NOT NULL,
  monto DECIMAL(10,2) NOT NULL,
  metodo_pago VARCHAR(50) NOT NULL,
  fecha_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (factura_id) REFERENCES facturas(factura_id)
);


-- ============================================
-- DATOS DE PRUEBA
-- ============================================

-- Categorías
INSERT INTO categorias (nombre) VALUES
  ('Bebidas'),
  ('Abarrotes'),
  ('Limpieza'),
  ('Papelería');

-- Clientes
INSERT INTO clientes (nombre, email, telefono) VALUES
  ('Ana López', 'ana.lopez@email.com', '3312345678'),
  ('Carlos Ramírez', 'carlos.ramirez@email.com', '3323456789'),
  ('María Torres', 'maria.torres@email.com', NULL);

-- Productos 
INSERT INTO productos (categoria_id, nombre, precio, stock) VALUES
  (1, 'Coca-Cola 600ml', 18.50, 50),
  (1, 'Agua natural 1L', 12.00, 100),
  (2, 'Arroz 1kg', 25.00, 30),
  (2, 'Frijol 1kg', 28.50, 20),
  (3, 'Cloro 1L', 22.00, 15),
  (3, 'Jabón en polvo 1kg', 45.00, 10);

-- Facturas y su detalle 
INSERT INTO facturas (cliente_id, total) VALUES (1, 0);
INSERT INTO detalle_factura (factura_id, producto_id, cantidad, subtotal) VALUES
  (1, 1, 3, 55.50),
  (1, 3, 2, 50.00);
UPDATE facturas SET total = (SELECT SUM(subtotal) FROM detalle_factura WHERE factura_id = 1) WHERE factura_id = 1;

-- Pago completo de la factura 1
INSERT INTO pagos (factura_id, monto, metodo_pago) VALUES (1, 105.50, 'Tarjeta');


-- ============================================
-- CONSULTAS DE NEGOCIO
-- ============================================

SELECT 
  c.cliente_id,
  c.nombre,
  SUM(f.total) AS total_comprado,
  COUNT(f.factura_id) AS numero_facturas
FROM clientes c
JOIN facturas f ON c.cliente_id = f.cliente_id
GROUP BY c.cliente_id, c.nombre
ORDER BY total_comprado DESC;