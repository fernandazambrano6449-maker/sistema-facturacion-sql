# Sistema de Facturación — Proyecto Integrador de Bases de Datos

Proyecto que diseña, construye y expone una base de datos relacional para optimizar procesos de contaduría (facturación, inventario y pagos), incluyendo una API sencilla y una justificación de por qué se eligió un modelo relacional sobre uno NoSQL.


## Tecnologías usadas

- **MySQL** — base de datos relacional
- **Python + FastAPI** — API que expone los datos

## Diseño de la base de datos

El sistema modela el flujo completo de una venta: un cliente compra productos (organizados por categoría), se genera una factura con sus líneas de detalle, y esa factura recibe uno o más pagos (permitiendo pagos parciales).

**Tablas:**

| Tabla | Descripción |
|---|---|
| `clientes` | Personas que compran |
| `categorias` | Agrupan los productos |
| `productos` | Catálogo, con precio y stock |
| `facturas` | Encabezado de cada venta |
| `detalle_factura` | Líneas de cada factura (qué se compró) |
| `pagos` | Pagos asociados a una factura (soporta pagos parciales) |

**Decisión de diseño clave:** `pagos` es una tabla separada de `facturas` (relación 1 a N), en vez de una sola columna de estatus, para poder representar pagos parciales — un caso real y común en contaduría.

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

Esta consulta usa un `JOIN` para conectar clientes con sus facturas, y `GROUP BY` para resumir el total comprado por cada uno — resolviendo una pregunta real que haría cualquier área de contaduría o ventas.

## API


| Endpoint | Descripción |
|---|---|
| `GET /clientes` | Lista todos los clientes |
| `GET /productos` | Lista todos los productos con su stock |




## MySQL vs MongoDB — ¿por qué relacional?

Para este proyecto se eligió MySQL (relacional) sobre MongoDB (NoSQL) por las siguientes razones:

- **Integridad de datos**: un sistema de facturación necesita que los totales, cantidades y relaciones entre tablas sean siempre consistentes. Las `FOREIGN KEY` de MySQL garantizan que, por ejemplo, no pueda existir una factura sin un cliente válido.
- **Consultas que cruzan varias entidades**: preguntas como "¿cuánto compró cada cliente?" o "¿qué facturas están pendientes de pago?" requieren cruzar información de varias tablas — el `JOIN` relacional está diseñado exactamente para esto.
- **Datos con estructura fija y predecible**: una factura siempre tiene los mismos campos (cliente, fecha, total) — no hay necesidad de la flexibilidad de esquema que ofrece MongoDB.

MongoDB sería una mejor opción en escenarios con datos de estructura variable entre registros (por ejemplo, catálogos de productos con atributos muy distintos entre sí) o donde la prioridad es la velocidad de lectura de documentos completos por encima de consultas relacionales complejas.


Fernanda Zambrano — estudiante de Licenciatura en Inteligencia Artificial y Ciencia de Datos
