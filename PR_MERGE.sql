create or replace NONEDITIONABLE PROCEDURE pr_merge(p_tabla_update VARCHAR2, p_tabla_origen VARCHAR2) IS
/* ----------------------------------------------------------------------------------------------
    Fecha: 18-ABR-2024
    Autor: nestor.hernandez2009@gmail.com
    Proposito: Permite construir dinámicamente una sentencia Merge para sincronizar y/o actualizar tablas.
               Utiliza el catalogo de la BD para obtener la PK y los campos de la tabla a sincronizar.
    Parametros: 
        lvc_tabla_update: Es la tabla a la cual se le realizará el update o la sincronización.
        lvc_tabla_origen: Es la tabla desde la cual se hará la actualización.
---------------------------------------------------------------------------------------------- */
lvc_pk              VARCHAR2(4096);
lvc_update          VARCHAR2(4096);
lvc_insert          VARCHAR2(4096);
lvc_values          VARCHAR2(4096);
lvc_sentencia       VARCHAR2(8192);
lvc_tabla_update    VARCHAR2(128) := p_tabla_update; /* Es la tabla a Actualizar */
lvc_tabla_origen    VARCHAR2(128) := p_tabla_origen; /* Desde donde se va a actualizar */

BEGIN
    -- Obtener la PK
    -----------------
    SELECT LISTAGG('a.'||cols.column_name||' = b.'||cols.column_name, ' and '||chr(13)) WITHIN GROUP (ORDER BY cols.position) AS PK
    INTO lvc_pk
    FROM all_constraints cons
    JOIN all_cons_columns cols ON CONS.CONSTRAINT_NAME = COLS.CONSTRAINT_NAME
      AND COLS.OWNER = CONS.OWNER
    WHERE CONS.TABLE_NAME = lvc_tabla_update
      AND CONS.CONSTRAINT_TYPE = 'P'
    ORDER BY COLS.POSITION;

    -- Generar el Update
    --------------------
    SELECT LISTAGG('a.'||cols.column_name ||' = b.' || cols.column_name, ', '||chr(13)) WITHIN GROUP (ORDER BY cols.column_id) AS lvc_update
    INTO lvc_update
    FROM ALL_TAB_COLUMNS cols
    WHERE COLS.COLUMN_NAME NOT IN (SELECT cols.column_name 
                                    FROM all_constraints cons
                                    JOIN all_cons_columns cols ON CONS.CONSTRAINT_NAME = COLS.CONSTRAINT_NAME
                                    AND COLS.OWNER = CONS.OWNER
                                    WHERE CONS.TABLE_NAME = lvc_tabla_update
                                       AND CONS.CONSTRAINT_TYPE = 'P')
     AND COLS.TABLE_NAME = lvc_tabla_update
     ORDER BY cols.column_id;
     
     -- Generar el Insert
     --------------------
     SELECT LISTAGG(cols.column_name, ', '||chr(13)) WITHIN GROUP ( ORDER BY cols.column_id ) AS lvc_insert,
            LISTAGG('b.' || cols.column_name, ', '||chr(13)) WITHIN GROUP (ORDER BY cols.column_id) AS lvc_values
        INTO lvc_insert, lvc_values
     FROM all_tab_columns cols 
     WHERE table_name = lvc_tabla_update
    ORDER BY COLS.COLUMN_ID;

    -- Genera la sentencia MERGE Completa
    ----------------------------------------
    lvc_sentencia := 'MERGE INTO ' || lvc_tabla_update || ' a' || CHR(13) ||
                      ' USING ' || lvc_tabla_origen || ' b ' || ' /* Puede Reemplazarse por un query entre parentesis conservando el alias b */ ' || CHR(13) ||
                      ' ON ' || '(' || lvc_pk || ')' || CHR(13) ||
                      ' WHEN MATCHED THEN ' || CHR(13) ||
                      ' UPDATE SET ' || lvc_update || CHR(13) ||
                      ' WHERE ' || lvc_pk || CHR(13) ||
                      ' WHEN NOT MATCHED THEN ' || CHR(13) ||
                      ' INSERT ' || '(' || lvc_insert || ')' ||
                      ' VALUES ' || '(' || lvc_values || ');';
                    
    dbms_output.put_line(lvc_sentencia);    
END;