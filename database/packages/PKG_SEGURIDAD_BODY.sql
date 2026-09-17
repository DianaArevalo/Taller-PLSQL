CREATE OR REPLACE PACKAGE BODY PKG_SEGURIDAD AS


    /* ============================================================
       PROCEDIMIENTO PRIVADO
       Valida la relación entre ROL y AFILIADO / EMPRESA
       ============================================================ */

    PROCEDURE VALIDAR_RELACION_ROL(
        P_ROL_ID      IN NUMBER,
        P_AFILIADO_ID IN NUMBER,
        P_EMPRESA_ID  IN NUMBER
    ) AS
        V_ROL_NOMBRE ROL.NOMBRE_USUARIO%TYPE;
        V_EXISTE     NUMBER;
    BEGIN

        /* --------------------------------------------------------
           1. Validar que el rol exista
           -------------------------------------------------------- */

        BEGIN
            SELECT nombre_usuario
            INTO V_ROL_NOMBRE
            FROM ROL
            WHERE ROL_ID = P_ROL_ID;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(
                    -20001,
                    'El rol indicado no existe.'
                );
        END;


        /* --------------------------------------------------------
           2. Validar campos obligatorios dependiendo del rol
           -------------------------------------------------------- */

        IF V_ROL_NOMBRE IN ('ADMIN', 'OPERADOR') THEN

            IF P_AFILIADO_ID IS NOT NULL
               OR P_EMPRESA_ID IS NOT NULL THEN

                RAISE_APPLICATION_ERROR(
                    -20002,
                    'ADMIN y OPERADOR no deben estar asociados a un afiliado ni a una empresa.'
                );

            END IF;


        ELSIF V_ROL_NOMBRE = 'AFILIADO' THEN

            IF P_AFILIADO_ID IS NULL THEN

                RAISE_APPLICATION_ERROR(
                    -20003,
                    'El rol AFILIADO requiere un AFILIADO_ID.'
                );

            END IF;

            IF P_EMPRESA_ID IS NOT NULL THEN

                RAISE_APPLICATION_ERROR(
                    -20004,
                    'Un acceso con rol AFILIADO no puede tener EMPRESA_ID.'
                );

            END IF;


        ELSIF V_ROL_NOMBRE = 'EMPRESA' THEN

            IF P_EMPRESA_ID IS NULL THEN

                RAISE_APPLICATION_ERROR(
                    -20005,
                    'El rol EMPRESA requiere un EMPRESA_ID.'
                );

            END IF;

            IF P_AFILIADO_ID IS NOT NULL THEN

                RAISE_APPLICATION_ERROR(
                    -20006,
                    'Un acceso con rol EMPRESA no puede tener AFILIADO_ID.'
                );

            END IF;


        ELSE

            RAISE_APPLICATION_ERROR(
                -20007,
                'El rol indicado no está permitido para un acceso.'
            );

        END IF;


        /* --------------------------------------------------------
           3. Validar que el AFILIADO exista
           -------------------------------------------------------- */

        IF P_AFILIADO_ID IS NOT NULL THEN

            SELECT COUNT(*)
            INTO V_EXISTE
            FROM AFILIADO
            WHERE AFILIADO_ID = P_AFILIADO_ID;

            IF V_EXISTE = 0 THEN

                RAISE_APPLICATION_ERROR(
                    -20008,
                    'El afiliado indicado no existe.'
                );

            END IF;

        END IF;


        /* --------------------------------------------------------
           4. Validar que la EMPRESA exista
           -------------------------------------------------------- */

        IF P_EMPRESA_ID IS NOT NULL THEN

            SELECT COUNT(*)
            INTO V_EXISTE
            FROM EMPRESA
            WHERE EMPRESA_ID = P_EMPRESA_ID;

            IF V_EXISTE = 0 THEN

                RAISE_APPLICATION_ERROR(
                    -20009,
                    'La empresa indicada no existe.'
                );

            END IF;

        END IF;

    END VALIDAR_RELACION_ROL;



    /* ============================================================
       SP_ADD_ACCESO
       ============================================================ */

    PROCEDURE SP_ADD_ACCESO(
        P_NOMBRE_USUARIO   IN VARCHAR2,
        P_CONTRASENA_HASH  IN VARCHAR2,
        P_ROL_ID           IN NUMBER,
        P_AFILIADO_ID      IN NUMBER DEFAULT NULL,
        P_EMPRESA_ID       IN NUMBER DEFAULT NULL,
        P_ACCESO_ID        OUT NUMBER
    ) AS
        V_ID NUMBER;
    BEGIN

        P_ACCESO_ID := NULL;


        /* --------------------------------------------------------
           Validar campos obligatorios
           -------------------------------------------------------- */

        IF P_NOMBRE_USUARIO IS NULL
           OR P_CONTRASENA_HASH IS NULL
           OR P_ROL_ID IS NULL THEN

            RAISE_APPLICATION_ERROR(
                -20010,
                'Los campos obligatorios no pueden estar vacíos.'
            );

        END IF;


        /* --------------------------------------------------------
           Validar relación entre rol y entidad
           -------------------------------------------------------- */

        VALIDAR_RELACION_ROL(
            P_ROL_ID,
            P_AFILIADO_ID,
            P_EMPRESA_ID
        );


        /* --------------------------------------------------------
           Generar ID
           -------------------------------------------------------- */

        SELECT NVL(MAX(ACCESO_ID), 0) + 1
        INTO V_ID
        FROM ACCESO;


        /* --------------------------------------------------------
           Insertar acceso
           -------------------------------------------------------- */

        INSERT INTO ACCESO (
            ACCESO_ID,
            nombre_usuario,
            CONTRASENA_HASH,
            ROL_ID,
            AFILIADO_ID,
            EMPRESA_ID,
            ESTADO,
            FECHA_CREACION
        )
        VALUES (
            V_ID,
            P_NOMBRE_USUARIO,
            P_CONTRASENA_HASH,
            P_ROL_ID,
            P_AFILIADO_ID,
            P_EMPRESA_ID,
            'ACTIVO',
            SYSDATE
        );


        P_ACCESO_ID := V_ID;


    EXCEPTION

        WHEN DUP_VAL_ON_INDEX THEN

            RAISE_APPLICATION_ERROR(
                -20011,
                'El nombre de usuario ya se encuentra registrado.'
            );

    END SP_ADD_ACCESO;



    /* ============================================================
       SP_UPDATE_ACCESO
       ============================================================ */

    PROCEDURE SP_UPDATE_ACCESO(
        P_ACCESO_ID        IN NUMBER,
        P_NOMBRE_USUARIO   IN VARCHAR2,
        P_ROL_ID           IN NUMBER,
        P_AFILIADO_ID      IN NUMBER DEFAULT NULL,
        P_EMPRESA_ID       IN NUMBER DEFAULT NULL
    ) AS
        V_EXISTE NUMBER;
    BEGIN

        /* --------------------------------------------------------
           Validar campos obligatorios
           -------------------------------------------------------- */

        IF P_ACCESO_ID IS NULL
           OR P_NOMBRE_USUARIO IS NULL
           OR P_ROL_ID IS NULL THEN

            RAISE_APPLICATION_ERROR(
                -20012,
                'Los campos obligatorios no pueden estar vacíos.'
            );

        END IF;


        /* --------------------------------------------------------
           Validar que el acceso exista
           -------------------------------------------------------- */

        SELECT COUNT(*)
        INTO V_EXISTE
        FROM ACCESO
        WHERE ACCESO_ID = P_ACCESO_ID;

        IF V_EXISTE = 0 THEN

            RAISE_APPLICATION_ERROR(
                -20013,
                'El acceso indicado no existe.'
            );

        END IF;


        /* --------------------------------------------------------
           Validar relación entre rol y entidad
           -------------------------------------------------------- */

        VALIDAR_RELACION_ROL(
            P_ROL_ID,
            P_AFILIADO_ID,
            P_EMPRESA_ID
        );


        /* --------------------------------------------------------
           Actualizar
           -------------------------------------------------------- */

        UPDATE ACCESO
        SET nombre_usuario    = P_NOMBRE_USUARIO,
            ROL_ID            = P_ROL_ID,
            AFILIADO_ID       = P_AFILIADO_ID,
            EMPRESA_ID        = P_EMPRESA_ID
        WHERE ACCESO_ID       = P_ACCESO_ID;


    EXCEPTION

        WHEN DUP_VAL_ON_INDEX THEN

            RAISE_APPLICATION_ERROR(
                -20014,
                'El nombre de usuario ya pertenece a otro acceso.'
            );

    END SP_UPDATE_ACCESO;



    /* ============================================================
       SP_DISABLE_ACCESO
       ============================================================ */

    PROCEDURE SP_DISABLE_ACCESO(
        P_ACCESO_ID IN NUMBER
    ) AS
        V_ESTADO ACCESO.ESTADO%TYPE;
    BEGIN

        BEGIN

            SELECT ESTADO
            INTO V_ESTADO
            FROM ACCESO
            WHERE ACCESO_ID = P_ACCESO_ID;

        EXCEPTION

            WHEN NO_DATA_FOUND THEN

                RAISE_APPLICATION_ERROR(
                    -20015,
                    'El acceso indicado no existe.'
                );

        END;


        IF V_ESTADO = 'INACTIVO' THEN

            RAISE_APPLICATION_ERROR(
                -20016,
                'El acceso ya se encuentra inactivo.'
            );

        END IF;


        UPDATE ACCESO
        SET ESTADO = 'INACTIVO'
        WHERE ACCESO_ID = P_ACCESO_ID;

    END SP_DISABLE_ACCESO;



    /* ============================================================
       SP_ENABLE_ACCESO
       ============================================================ */

    PROCEDURE SP_ENABLE_ACCESO(
        P_ACCESO_ID IN NUMBER
    ) AS
        V_ESTADO ACCESO.ESTADO%TYPE;
    BEGIN

        BEGIN

            SELECT ESTADO
            INTO V_ESTADO
            FROM ACCESO
            WHERE ACCESO_ID = P_ACCESO_ID;

        EXCEPTION

            WHEN NO_DATA_FOUND THEN

                RAISE_APPLICATION_ERROR(
                    -20017,
                    'El acceso indicado no existe.'
                );

        END;


        IF V_ESTADO = 'ACTIVO' THEN

            RAISE_APPLICATION_ERROR(
                -20018,
                'El acceso ya se encuentra activo.'
            );

        END IF;


        UPDATE ACCESO
        SET ESTADO = 'ACTIVO'
        WHERE ACCESO_ID = P_ACCESO_ID;

    END SP_ENABLE_ACCESO;



    /* ============================================================
       SP_GET_ACCESO
       ============================================================ */

    PROCEDURE SP_GET_ACCESO(
        P_ACCESO_ID IN NUMBER,
        P_CURSOR    OUT RC
    ) AS
        V_EXISTE NUMBER;
    BEGIN

        SELECT COUNT(*)
        INTO V_EXISTE
        FROM ACCESO
        WHERE ACCESO_ID = P_ACCESO_ID;

        IF V_EXISTE = 0 THEN

            RAISE_APPLICATION_ERROR(
                -20019,
                'El acceso indicado no existe.'
            );

        END IF;


        OPEN P_CURSOR FOR
            SELECT
                ACCESO_ID,
                NOMBRE_USUARIO,
                ROL_ID,
                AFILIADO_ID,
                EMPRESA_ID,
                ESTADO,
                FECHA_CREACION
            FROM ACCESO
            WHERE ACCESO_ID = P_ACCESO_ID
            ORDER BY ACCESO_ID;

    END SP_GET_ACCESO;



    /* ============================================================
       SP_GET_ACCESOS
       ============================================================ */

    PROCEDURE SP_GET_ACCESOS(
        P_CURSOR OUT RC
    ) AS
    BEGIN

        OPEN P_CURSOR FOR
            SELECT
                ACCESO_ID,
                nombre_usuario,
                ROL_ID,
                AFILIADO_ID,
                EMPRESA_ID,
                ESTADO,
                FECHA_CREACION
            FROM ACCESO
            ORDER BY ACCESO_ID;

    END SP_GET_ACCESOS;



    /* ============================================================
       SP_GET_ACCESOS_ROL
       ============================================================ */

    PROCEDURE SP_GET_ACCESOS_ROL(
        P_ROL_ID  IN NUMBER,
        P_CURSOR  OUT RC
    ) AS
        V_EXISTE NUMBER;
    BEGIN

        /* --------------------------------------------------------
           Validar que el rol exista
           -------------------------------------------------------- */

        SELECT COUNT(*)
        INTO V_EXISTE
        FROM ROL
        WHERE ROL_ID = P_ROL_ID;

        IF V_EXISTE = 0 THEN

            RAISE_APPLICATION_ERROR(
                -20020,
                'El rol indicado no existe.'
            );

        END IF;


        /* --------------------------------------------------------
           Consultar accesos
           -------------------------------------------------------- */

        OPEN P_CURSOR FOR
            SELECT
                ACCESO_ID,
                nombre_usuario,
                ROL_ID,
                AFILIADO_ID,
                EMPRESA_ID,
                ESTADO,
                FECHA_CREACION
            FROM ACCESO
            WHERE ROL_ID = P_ROL_ID
            ORDER BY ACCESO_ID;

    END SP_GET_ACCESOS_ROL;



    /* ============================================================
       FN_TIENE_ROL
       ============================================================ */

    FUNCTION FN_TIENE_ROL(
        P_ACCESO_ID IN NUMBER,
        P_ROL       IN VARCHAR2
    ) RETURN VARCHAR2 AS

        V_ROL_ACCESO ROL.NOMBRE_USUARIO%TYPE;
        V_EXISTE     NUMBER;

    BEGIN

        /* --------------------------------------------------------
           Validar acceso
           -------------------------------------------------------- */

        SELECT COUNT(*)
        INTO V_EXISTE
        FROM ACCESO
        WHERE ACCESO_ID = P_ACCESO_ID;

        IF V_EXISTE = 0 THEN

            RAISE_APPLICATION_ERROR(
                -20021,
                'El acceso indicado no existe.'
            );

        END IF;


        /* --------------------------------------------------------
           Validar rol solicitado
           -------------------------------------------------------- */

        SELECT COUNT(*)
        INTO V_EXISTE
        FROM ROL
        WHERE UPPER(NOMBRE_USUARIO) = UPPER(P_ROL);

        IF V_EXISTE = 0 THEN

            RAISE_APPLICATION_ERROR(
                -20022,
                'El rol indicado no existe.'
            );

        END IF;


        /* --------------------------------------------------------
           Obtener rol del acceso
           -------------------------------------------------------- */

        SELECT R.NOMBRE_USUARIO
        INTO V_ROL_ACCESO
        FROM ACCESO A
        INNER JOIN ROL R
            ON R.ROL_ID = A.ROL_ID
        WHERE A.ACCESO_ID = P_ACCESO_ID;


        /* --------------------------------------------------------
           Comparar
           -------------------------------------------------------- */

        IF UPPER(V_ROL_ACCESO) = UPPER(P_ROL) THEN
            RETURN 'SI';
        ELSE
            RETURN 'NO';
        END IF;

    END FN_TIENE_ROL;



    /* ============================================================
       FN_ROL_ACCESO
       ============================================================ */

    FUNCTION FN_ROL_ACCESO(
        P_ACCESO_ID IN NUMBER
    ) RETURN VARCHAR2 AS

        V_ROL ROL.NOMBRE_USUARIO%TYPE;

    BEGIN

        BEGIN

            SELECT R.NOMBRE_USUARIO
            INTO V_ROL
            FROM ACCESO A
            INNER JOIN ROL R
                ON R.ROL_ID = A.ROL_ID
            WHERE A.ACCESO_ID = P_ACCESO_ID;

        EXCEPTION

            WHEN NO_DATA_FOUND THEN

                RAISE_APPLICATION_ERROR(
                    -20023,
                    'El acceso indicado no existe.'
                );

        END;


        RETURN V_ROL;

    END FN_ROL_ACCESO;


END PKG_SEGURIDAD;
/