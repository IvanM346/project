# Хранилище данных о продажах

Учебный проект для портфолио на **SQL Server и T-SQL**. Цель проекта — собрать данные о клиентах, товарах и продажах из CRM и ERP и подготовить их для аналитики.

## Текущий этап — Bronze

Шесть исходных CSV из CRM и ERP загружаются в шесть таблиц схемы `bronze`. На этом этапе сохраняются исходные значения. При повторном запуске процедура очищает таблицы Bronze и загружает файлы целиком.

## Как запустить

1. Скачай исходные CSV из [репозитория Data with Baraa](https://github.com/DataWithBaraa/sql-data-warehouse-project). Помести папки `source_crm` и `source_erp` в `C:\sql\crm_erp\` или укажи фактические пути в шести командах `BULK INSERT`.
2. Подключись к SQL Server через SSMS и выполни скрипты из папки [`scripts/bronze`](scripts/bronze) в этом порядке.
   1. [`init_bronze.sql`](scripts/bronze/init_bronze.sql) создаёт базу `DataWarehouse` и схему `bronze`.
   2. [`ddl_bronze.sql`](scripts/bronze/ddl_bronze.sql) создаёт шесть таблиц.
   3. [`proc_load_bronze.sql`](scripts/bronze/proc_load_bronze.sql) создаёт процедуру загрузки.
   4. [`run_bronze.sql`](scripts/bronze/run_bronze.sql) запускает загрузку CSV.
3. Проверь, что количество строк в каждой таблице совпадает с количеством строк данных в соответствующем CSV без заголовка.

Дальше по плану — очистка и стандартизация данных в **Silver**, затем модель продаж и аналитические запросы в **Gold**.

---

# Sales Data Warehouse

A **SQL Server and T-SQL** portfolio project. The project brings customer, product, and sales data from CRM and ERP sources into a warehouse for analysis.

## Current stage — Bronze

Six source CSV files are loaded into six tables in the `bronze` schema. This stage preserves the source values. Each rerun clears the Bronze tables and reloads the full files.

## How to run

1. Download the source CSV files from the [Data with Baraa repository](https://github.com/DataWithBaraa/sql-data-warehouse-project). Place `source_crm` and `source_erp` in `C:\sql\crm_erp\` or update the paths in all six `BULK INSERT` statements.
2. Connect to SQL Server in SSMS and run the scripts in [`scripts/bronze`](scripts/bronze) in this order.
   1. [`init_bronze.sql`](scripts/bronze/init_bronze.sql) creates the `DataWarehouse` database and the `bronze` schema.
   2. [`ddl_bronze.sql`](scripts/bronze/ddl_bronze.sql) creates the six tables.
   3. [`proc_load_bronze.sql`](scripts/bronze/proc_load_bronze.sql) defines the loading procedure.
   4. [`run_bronze.sql`](scripts/bronze/run_bronze.sql) runs the CSV load.
3. Check that each table's row count matches the number of data rows in its CSV, excluding the header.

The next stages are data cleaning and standardization in **Silver**, followed by sales modeling and analytical queries in **Gold**.
