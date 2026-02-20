# Transacciones y Bloqueos en PostgreSQL

**Autor:** Kevin Denilson Cax Coc  
**Curso:** Base de Datos II  
**Universidad:** Universidad Mariano Gálvez  

---

## 📌 Descripción

Este repositorio contiene la implementación práctica y documentación
sobre el manejo de **transacciones, niveles de aislamiento y bloqueos**
en PostgreSQL.

El objetivo es analizar el comportamiento del motor de base de datos
bajo distintos escenarios de concurrencia utilizando:

- MVCC (Multiversion Concurrency Control)
- SAVEPOINT
- LOCK TABLE
- Niveles de aislamiento:
  - READ COMMITTED
  - REPEATABLE READ
  - SERIALIZABLE

---

## 🗂 Contenido del repositorio

- `Transactions-DB-II.sql` → Script principal con todos los experimentos
- Documento académico en formato ACM
- Ejemplos reproducibles paso a paso
- Simulación de conflictos y pruebas de aislamiento

---

## 🧪 Escenarios implementados

### 1️⃣ Creación de tabla base

Se crea la tabla `cuentas` con datos iniciales para pruebas controladas.

### 2️⃣ Uso de SAVEPOINT

Demostración de rollback parcial dentro de una transacción.

### 3️⃣ Bloqueos explícitos

Uso de:

```sql
LOCK TABLE cuentas IN ROW EXCLUSIVE MODE NOWAIT;