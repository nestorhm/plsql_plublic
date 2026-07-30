Bloque anónimo que genera automáticamente una sentencia MERGE de Oracle para combinar o actualizar una tabla.

__Uso:__

  BEGIN
    pr_merge(p_tabla_update VARCHAR2, p_tabla_origen VARCHAR2);
  END;

__Parametros:__

  p_tabla_update => Es la tabla que se va a actualizar.
  p_tabla_origen >= Tabla origen de los datos, está puede ser reemplazada por un QUERY.

__Ventajas:__

__Mayor velocidad:__ Lee las tablas una sola vez para actualizar o insertar datos, lo que gasta menos recursos que usar comandos separados.

__Menos código:__ Hace el trabajo de un INSERT y un UPDATE al mismo tiempo en un solo bloque claro y fácil de leer.

__Procesos seguros:__ Ayuda a mantener los datos limpios y sin duplicados en tareas grandes como procesos ETL o cargas masivas

Al ejecutarlo en su BD producirá una salida como la siguiente:

![image_alt](https://github.com/nestorhm/plsql_plublic/blob/32a90571fcc1d36dc93651ae00f0f14b5d59c841/PR_MERGE.png)

Luego puedes copiar ese código generado e integrarlos a los procesos de su aplicación.
