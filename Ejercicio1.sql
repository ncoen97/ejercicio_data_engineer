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
-- c-
-- Primer intento: Error al intentar retornar el valor de la ganancia de la funcion Obtener_Sumatoria_Ultimas_Operaciones
SELECT TRUNC(Fecha), "Descripción de Cliente", Obtener_Sumatoria_Ultimas_Operaciones(Fecha, "Descripción de Cliente", 7)
FROM Reporte_Movimientos
GROUP BY TRUNC(Fecha), "Descripción de Cliente"
ORDER BY FECHA, "Descripción de Cliente"

CREATE FUNCTION Obtener_Sumatoria_Ultimas_Operaciones (TIMESTAMP, TEXT, SMALLINT)
  RETURNS FLOAT
STABLE
AS $$
  SELECT SUM("Ganancia Neta")
  FROM Reporte_Movimientos
  WHERE  "Descripción de Cliente" = $2 AND Fecha <= $1
  ORDER BY Fecha DESC
  LIMIT $3
  END
$$ LANGUAGE SQL;

-- Segundo intento: Error por subquery
SELECT TRUNC(Fecha), "Descripción de Cliente", (SELECT SUM(Ganancias."Ganancia Neta")
  FROM (SELECT R."Ganancia Neta" FROM Reporte_Movimientos AS R
    WHERE  R."Descripción de Cliente" = Reporte_Movimientos."Descripción de Cliente" AND R.Fecha <= Reporte_Movimientos.Fecha
    ORDER BY R.Fecha DESC
    LIMIT 7) AS Ganancias)
FROM Reporte_Movimientos
GROUP BY TRUNC(Fecha), "Descripción de Cliente"
ORDER BY FECHA, "Descripción de Cliente"