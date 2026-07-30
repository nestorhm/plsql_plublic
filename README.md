Bloque anónimo que genera automáticamente una sentencia MERGE de Oracle para combinar o actualizar una tabla.

*Uso:*
  BEGIN
    pr_merge(p_tabla_update VARCHAR2, p_tabla_origen VARCHAR2);
  END;

*Parametros:*
  p_tabla_update => Es la tabla que se va a actualizar.
  p_tabla_origen >= Tabla origen de los datos, está puede ser reemplazada por un QUERY.

*Ventajas:*
*Mayor velocidad:* Lee las tablas una sola vez para actualizar o insertar datos, lo que gasta menos recursos que usar comandos separados.
*Menos código:* Hace el trabajo de un INSERT y un UPDATE al mismo tiempo en un solo bloque claro y fácil de leer.
__Procesos seguros:__ Ayuda a mantener los datos limpios y sin duplicados en tareas grandes como procesos ETL o cargas masivas
