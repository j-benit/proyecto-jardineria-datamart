
-- ========================================
-- Script completo: Modelo Estrella Jardinería + Staging + ETL
-- ========================================

-- === CREAR BASE DE DATOS PRINCIPAL ===
CREATE DATABASE Jardineria;
GO

USE Jardineria;
GO

-- === CREACIÓN DE TABLAS EN MODELO ESTRELLA ===

CREATE TABLE Dim_Producto (
  id_producto INT PRIMARY KEY,
  nombre_producto VARCHAR(100),
  codigo_producto VARCHAR(50),
  precio_venta DECIMAL(15,2)
);

CREATE TABLE Dim_Categoria (
  id_categoria INT PRIMARY KEY,
  desc_categoria VARCHAR(100)
);

CREATE TABLE Dim_Tiempo (
  id_tiempo INT PRIMARY KEY,
  fecha DATE,
  año INT,
  mes VARCHAR(20),
  trimestre VARCHAR(20)
);

CREATE TABLE Hechos_Ventas (
  id_venta INT PRIMARY KEY,
  id_producto INT,
  id_categoria INT,
  id_tiempo INT,
  cantidad_vendida INT,
  precio_unidad DECIMAL(15,2),
  total_venta DECIMAL(15,2),
  FOREIGN KEY (id_producto) REFERENCES Dim_Producto(id_producto),
  FOREIGN KEY (id_categoria) REFERENCES Dim_Categoria(id_categoria),
  FOREIGN KEY (id_tiempo) REFERENCES Dim_Tiempo(id_tiempo)
);

-- === INSERTAR DATOS DE EJEMPLO EN JARDINERIA ===
INSERT INTO Dim_Producto VALUES
(1, 'Tijeras de podar', 'PROD001', 25.50),
(2, 'Maceta decorativa', 'PROD002', 40.00),
(3, 'Abono orgánico', 'PROD003', 15.75);

INSERT INTO Dim_Categoria VALUES
(1, 'Herramientas'),
(2, 'Decoración'),
(3, 'Fertilizantes');

INSERT INTO Dim_Tiempo VALUES
(1, '2024-03-15', 2024, 'Marzo', 'Q1'),
(2, '2024-04-10', 2024, 'Abril', 'Q2'),
(3, '2024-05-05', 2024, 'Mayo', 'Q2');

INSERT INTO Hechos_Ventas VALUES
(1, 1, 1, 1, 10, 25.50, 255.00),
(2, 2, 2, 2, 5, 40.00, 200.00),
(3, 3, 3, 3, 20, 15.75, 315.00);

-- === CREAR BASE DE DATOS STAGING ===
CREATE DATABASE Staging_Jardineria;
GO

USE Staging_Jardineria;
GO

-- === CREAR TABLAS STAGING ===
CREATE TABLE Stg_Dim_Producto (
  id_producto INT,
  nombre_producto VARCHAR(100),
  codigo_producto VARCHAR(50),
  precio_venta DECIMAL(15,2)
);

CREATE TABLE Stg_Dim_Categoria (
  id_categoria INT,
  desc_categoria VARCHAR(100)
);

CREATE TABLE Stg_Dim_Tiempo (
  id_tiempo INT,
  fecha DATE,
  año INT,
  mes VARCHAR(20),
  trimestre VARCHAR(20)
);

CREATE TABLE Stg_Hechos_Ventas (
  id_venta INT,
  id_producto INT,
  id_categoria INT,
  id_tiempo INT,
  cantidad_vendida INT,
  precio_unidad DECIMAL(15,2),
  total_venta DECIMAL(15,2)
);

-- === INSERTAR DATOS DE EJEMPLO EN STAGING ===
INSERT INTO Stg_Dim_Producto VALUES
(4, 'Rastrillo de mano', 'PROD004', 18.90),
(5, 'Guantes de jardinería', 'PROD005', 12.50);

INSERT INTO Stg_Dim_Categoria VALUES
(4, 'Accesorios'),
(5, 'Ropa');

INSERT INTO Stg_Dim_Tiempo VALUES
(4, '2024-06-10', 2024, 'Junio', 'Q2'),
(5, '2024-07-05', 2024, 'Julio', 'Q3');

INSERT INTO Stg_Hechos_Ventas VALUES
(4, 4, 4, 4, 7, 18.90, 132.30),
(5, 5, 5, 5, 12, 12.50, 150.00);

-- === ETL: MIGRAR DATOS DE STAGING A JARDINERIA ===
USE Jardineria;
GO

INSERT INTO Dim_Producto
SELECT * FROM Staging_Jardineria.dbo.Stg_Dim_Producto;

INSERT INTO Dim_Categoria
SELECT * FROM Staging_Jardineria.dbo.Stg_Dim_Categoria;

INSERT INTO Dim_Tiempo
SELECT * FROM Staging_Jardineria.dbo.Stg_Dim_Tiempo;

INSERT INTO Hechos_Ventas
SELECT * FROM Staging_Jardineria.dbo.Stg_Hechos_Ventas;

-- FIN DEL SCRIPT
