# Data Warehouse and Analytics Project

Цель проекта — собрать данные о клиентах, товарах и продажах из CRM и ERP и подготовить их для аналитики.

## Структура проекта

```
project/
├── datasets/               исходные CSV-файлы проекта
│   ├── source_crm/         три файла из CRM
│   └── source_erp/         три файла из ERP
├── docs/                   схема звезды (star schema)
├── scripts/                скрипты проекта, по уровням
│   ├── bronze/             загружает исходные файлы как есть
│   ├── silver/             очищает и готовит данные
│   └── gold/               строит представления для анализа
└── README.md
```

## Уровни: Bronze, Silver, Gold

Шесть исходных CSV из CRM и ERP загружаются в шесть таблиц схемы `bronze`. На этом этапе сохраняются исходные значения.

Данные из Bronze очищаются и приводятся к единому виду в схеме `silver`: убираются дубликаты и пустые ключи, нормализуются коды пола, семейного положения и стран, даты и числа приводятся к правильным типам.

В схеме `gold` — три представления для анализа: `dim_customers`, `dim_products` и `fact_sales`. Это звезда (star schema): таблица фактов ссылается на измерения по ключам `customer_key` и `product_key`. Схема — `docs/star_schema.svg`.

При повторном запуске каждая процедура очищает свои таблицы и загружает данные целиком.

## Как запустить

1. Скачай исходные CSV из папки `datasets`. Помести папки `source_crm` и `source_erp` в `C:\sql\crm_erp\` или укажи фактические пути в шести командах `BULK INSERT`.
2. Подключись к SQL Server через SSMS и выполни скрипты из папки `scripts/bronze` в этом порядке.
   1. `init_bronze.sql` создаёт базу `DataWarehouse` и схему `bronze`.
   2. `ddl_bronze.sql` создаёт шесть таблиц.
   3. `proc_load_bronze.sql` создаёт процедуру загрузки.
   4. `run_bronze.sql` запускает загрузку CSV.
3. Выполни скрипты из `scripts/silver`.
   1. `ddl_silver.sql` создаёт таблицы Silver.
   2. `proc_load_silver.sql` создаёт и запускает процедуру `silver.load_silver`.
4. Выполни `scripts/gold/ddl_gold.sql` — он создаёт схему `gold` и три представления.
5. Проверь, что количество строк в Bronze совпадает с количеством строк данных в соответствующем CSV без заголовка, а в Silver — не больше, чем в Bronze.

Дальше по плану — аналитические запросы поверх Gold: продажи по товарам, клиентам, странам и времени.

---

# Data Warehouse and Analytics Project

The project brings customer, product, and sales data from CRM and ERP sources into a warehouse for analysis.

## Project structure

```
project/
├── datasets/               the project's source CSV files
│   ├── source_crm/         three files from the CRM system
│   └── source_erp/         three files from the ERP system
├── docs/                   the star schema diagram
├── scripts/                the project scripts, by level
│   ├── bronze/             loads the raw source files
│   ├── silver/             cleans and prepares the data
│   └── gold/               builds the views for analysis
└── README.md
```

## Levels: Bronze, Silver, Gold

Six source CSV files are loaded into six tables in the `bronze` schema. This stage preserves the source values.

Data from Bronze is cleaned and standardized in the `silver` schema: duplicates and blank keys are removed, gender/marital-status/country codes are normalized, and dates and numbers are cast to proper types.

The `gold` schema holds three views for analysis: `dim_customers`, `dim_products`, and `fact_sales`. This is a star schema: the fact table references the dimensions through the `customer_key` and `product_key` keys. Diagram: `docs/star_schema.svg`.

Each rerun clears that level's tables and reloads the data in full.

## How to run

1. Download the source CSV files from the [Data with Baraa repository](https://github.com/DataWithBaraa/sql-data-warehouse-project), or use the copies in `datasets`. Place `source_crm` and `source_erp` in `C:\sql\crm_erp\` or update the paths in all six `BULK INSERT` statements.
2. Connect to SQL Server in SSMS and run the scripts in `scripts/bronze` in this order.
   1. `init_bronze.sql` creates the `DataWarehouse` database and the `bronze` schema.
   2. `ddl_bronze.sql` creates the six tables.
   3. `proc_load_bronze.sql` defines the loading procedure.
   4. `run_bronze.sql` runs the CSV load.
3. Run the scripts in `scripts/silver`.
   1. `ddl_silver.sql` creates the Silver tables.
   2. `proc_load_silver.sql` defines and runs the `silver.load_silver` procedure.
4. Run `scripts/gold/ddl_gold.sql` — it creates the `gold` schema and the three views.
5. Check row counts: Bronze should match the CSV row count (excluding the header); Silver should be at or below Bronze's count.

The next step is analytical queries on top of Gold: sales by product, customer, country, and time.
