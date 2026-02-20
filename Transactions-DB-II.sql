-- ================================================================
-- PRACTICA: Transacciones y Bloqueos en PostgreSQL
-- Autor   : Kevin Denilson Cax Coc
-- ================================================================



DROP TABLE IF EXISTS cuentas;

CREATE TABLE cuentas (
    id     SERIAL        PRIMARY KEY,
    nombre VARCHAR(50)   NOT NULL,
    saldo  NUMERIC(12,2) NOT NULL
);

select * FROM cuentas;

INSERT INTO cuentas (nombre, saldo) VALUES
    ('Alice', 1000.00),
    ('Bob',   2000.00),
    ('Carol',  500.00);


SELECT id, nombre, saldo FROM cuentas ORDER BY id;



BEGIN;

    -- Paso 1: operacion valida
    UPDATE cuentas SET saldo = saldo - 100 WHERE id = 1;

    SELECT '-- Tras descontar 100 a Alice:' AS paso;
    SELECT id, nombre, saldo FROM cuentas WHERE id = 1;
    -- Esperado: 900.00

    -- Crear punto de guardado
    SAVEPOINT sp1;

    -- Paso 2: operacion erronea
    UPDATE cuentas SET saldo = saldo - 5000 WHERE id = 1;

    SELECT id, nombre, saldo FROM cuentas WHERE id = 1;
    -- Esperado: -4100.00 (incorrecto)

    -- Revertir solo el paso erroneo
    ROLLBACK TO SAVEPOINT sp1;

    SELECT id, nombre, saldo FROM cuentas WHERE id = 1;
    -- Esperado: 900.00 (se conservo el descuento valido)

COMMIT;

SELECT id, nombre, saldo FROM cuentas ORDER BY id;
-- Alice: 900.00 | Bob: 2000.00 | Carol: 500.00




BEGIN;
    LOCK TABLE cuentas IN ROW EXCLUSIVE MODE NOWAIT;

    UPDATE cuentas SET saldo = saldo + 10 WHERE id = 2;

    SELECT id, nombre, saldo FROM cuentas WHERE id = 2;
    -- Esperado: 2010.00
COMMIT;




-- Restablecer saldo de Alice
UPDATE cuentas SET saldo = 1000.00 WHERE id = 1;

BEGIN;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

    SELECT id, nombre, saldo FROM cuentas WHERE id = 1;
    -- Esperado: 1000.00

-- Simular cambio "externo": actualizamos y hacemos visible
-- dentro de la misma transaccion usando un savepoint intermedio.
    SAVEPOINT sim_externo;
        UPDATE cuentas SET saldo = 9999.00 WHERE id = 1;
    RELEASE SAVEPOINT sim_externo;

    SELECT id, nombre, saldo FROM cuentas WHERE id = 1;
    -- Esperado: 9999.00  -> lectura no repetible demostrada

ROLLBACK;
-- Revertimos para mantener el estado base limpio

SELECT id, nombre, saldo FROM cuentas WHERE id = 1;
-- Esperado: 1000.00




-- Restablecer saldo de Alice
UPDATE cuentas SET saldo = 1000.00 WHERE id = 1;

BEGIN;
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

    SELECT id, nombre, saldo FROM cuentas WHERE id = 1;
    -- Esperado: 1000.00


    SELECT id, nombre, saldo FROM cuentas WHERE id = 1;
    -- Esperado: 1000.00  -> a diferencia de READ COMMITTED, no cambia

COMMIT;


-- Restablecer saldos
UPDATE cuentas SET saldo = 1000.00 WHERE id = 1;
UPDATE cuentas SET saldo = 2000.00 WHERE id = 2;

BEGIN;
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

    SELECT SUM(saldo) AS suma_total FROM cuentas;
    -- Esperado: 3500.00 (1000 + 2000 + 500)

    UPDATE cuentas SET saldo = saldo - 100 WHERE id = 1;

    SELECT id, nombre, saldo FROM cuentas WHERE id = 1;
    -- Esperado: 900.00

COMMIT;

SELECT id, nombre, saldo FROM cuentas ORDER BY id;


SELECT id, nombre, saldo FROM cuentas ORDER BY id;

