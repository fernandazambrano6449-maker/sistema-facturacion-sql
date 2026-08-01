# main.py
# API sencilla para el sistema de facturación.
# Expone los datos de MySQL a través de endpoints HTTP usando FastAPI.

from fastapi import FastAPI, HTTPException
import mysql.connector

# Creamos la aplicación de FastAPI. Esta variable "app" es el corazón de la API.
app = FastAPI(title="API Sistema de Facturación")


# Esta función se encarga de abrir una conexión a MySQL cada vez que la necesitamos.
def obtener_conexion():
    return mysql.connector.connect(
        host="localhost",
        user="root",               # Ajusta esto a tu usuario real de MySQL Workbench
        password="Liz760611",    # Ajusta esto a tu contraseña real de MySQL
        database="sistema_facturacion"
    )


# ---------------------------------------------------------
# Endpoint 1: obtener todos los clientes
# ---------------------------------------------------------
@app.get("/clientes")
def listar_clientes():
    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)
    cursor.execute("SELECT cliente_id, nombre, email, telefono FROM clientes")
    resultado = cursor.fetchall()
    cursor.close()
    conexion.close()
    return resultado


# ---------------------------------------------------------
# Endpoint 2: obtener todos los productos
# ---------------------------------------------------------
@app.get("/productos")
def listar_productos():
    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)
    cursor.execute("SELECT producto_id, nombre, precio, stock FROM productos")
    resultado = cursor.fetchall()
    cursor.close()
    conexion.close()
    return resultado