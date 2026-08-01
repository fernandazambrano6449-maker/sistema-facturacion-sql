# Sistema de Facturación — Proyecto Integrador de Bases de Datos

Proyecto que diseña, construye y expone una base de datos relacional para optimizar procesos de contaduría (facturación, inventario y pagos), incluyendo una API.


## Tecnologías usadas

- **MySQL** — base de datos relacional
- **Python + FastAPI** — API que expone los datos

## Diseño de la base de datos

El sistema modela el flujo completo de una venta: un cliente compra productos (organizados por categoría), se genera una factura con sus líneas de detalle, y esa factura recibe uno o más pagos.

**Tablas:**

| Tabla | Descripción |
|---|---|
| `clientes` | Personas que compran |
| `categorias` | Agrupan los productos |
| `productos` | Catálogo, con precio y stock |
| `facturas` | Encabezado de cada venta |
| `detalle_factura` | Líneas de cada factura (qué se compró) |
| `pagos` | Pagos asociados a una factura (soporta pagos parciales) |


## Consultas de negocio

**¿Cuánto ha comprado cada cliente en total?**

```sql
SELECT 
  c.cliente_id,
  c.nombre,
  SUM(f.total) AS total_comprado,
  COUNT(f.factura_id) AS numero_facturas
FROM clientes c
JOIN facturas f ON c.cliente_id = f.cliente_id
GROUP BY c.cliente_id, c.nombre
ORDER BY total_comprado DESC;
```

Esta consulta usa un `JOIN` para conectar clientes con sus facturas, y `GROUP BY` para resumir el total comprado por cada uno.
## API


| Endpoint | Descripción |
|---|---|
| `GET /clientes` | Lista todos los clientes |
| `GET /productos` | Lista todos los productos con su stock |







Fernanda Zambrano — estudiante de Licenciatura en Inteligencia Artificial y Ciencia de Datos
