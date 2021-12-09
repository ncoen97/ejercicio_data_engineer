-- a-
CREATE MATERIALIZED VIEW Reporte_Movimientos AS
  SELECT Data_Movimientos.Fecha,
    Data_Clientes.Descripcion AS "Descripción de Cliente",
    Data_Proveeedores.Descripcion AS "Descripción de Proveedor",
    Data_Productos.Descripcion AS "Descripción de Producto",
    Data_Marcas.Descripcion AS "Descripción de Marca",
    Data_Movimientos.Cantidad,
    Data_Movimientos.Costo,
    Data_Movimientos.Venta,
    (Data_Movimientos.Venta - Data_Movimientos.Costo) AS "Ganancia Neta"
  FROM Data_Movimientos
  JOIN Data_Clientes ON Data_Clientes.Cod_Cliente = Dada_Movimientos.Cod_Cliente
  JOIN Data_Productos ON Data_Productos.Cod_Prod = Dada_Movimientos.Cod_Prod
  JOIN Data_Marcas ON Data_Marcas.Cod_Marca = Data_Productos.Cod_Marca
  JOIN Data_Proveeedores ON Data_Proveeedores.Cod_Proveedor = Data_Productos.Cod_Proveedor
-- b-
SELECT Data_Marcas.Descripcion
FROM Data_Marcas
JOIN Data_Productos ON Data_Productos.Cod_Marca = Data_Marcas.Cod_Marca
RIGHT JOIN Data_Movimientos ON Data_Productos.Cod_Prod = Data_Movimientos.Cod_Prod 
WHERE Data_Movimientos.Cod_Prod IS NULL
-- c- TBD