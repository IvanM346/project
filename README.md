# Data Warehouse and Analytics Project

Цель проекта — собрать данные о клиентах, товарах и продажах из CRM и ERP и подготовить их для аналитики.

## Структура проекта

```
project/
├── datasets/               исходные CSV-файлы проекта
│   ├── source_crm/         три файла из CRM
│   └── source_erp/         три файла из ERP
├── docs/                   схемы архитектуры и данных
├── scripts/                скрипты проекта, по уровням
│   ├── analytics/          13 запросов для анализа слоя Gold
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

## Аналитика

В `scripts/analytics` лежат 13 SQL-файлов для анализа данных из Gold. Они помогают изучить продажи, клиентов и товары: от простых показателей до сравнений по времени и отчётов. Комментарии в SQL написаны на английском, а перевод дан в скобках.

| Файл | Что делает |
|---|---|
| `01_database_exploration.sql` | Изучает таблицы и столбцы Gold. |
| `02_dimensions_exploration.sql` | Показывает значения в справочниках. |
| `03_date_range_exploration.sql` | Находит диапазон дат заказов и возраст клиентов. |
| `04_measures_exploration.sql` | Считает основные показатели продаж. |
| `05_magnitude_analysis.sql` | Группирует клиентов, товары и продажи. |
| `06_ranking_analysis.sql` | Строит рейтинги товаров и клиентов. |
| `07_change_over_time_analysis.sql` | Показывает продажи по месяцам. |
| `08_cumulative_analysis.sql` | Считает накопительные продажи. |
| `09_performance_analysis.sql` | Сравнивает продажи товаров по годам. |
| `10_part_to_whole_analysis.sql` | Считает долю каждой категории в продажах. |
| `11_data_segmentation.sql` | Делит товары и клиентов на группы. |
| `12_report_customers.sql` | Строит запрос с показателями по клиентам. |
| `13_report_products.sql` | Создаёт представление с показателями по товарам. |

Для запуска нужна база `DataWarehouseAnalytics` с представлениями `gold.dim_customers`, `gold.dim_products` и `gold.fact_sales`. Скрипты `01`–`12` выполняются как запросы. Скрипт `13_report_products.sql` создаёт или обновляет представление; после него результат можно посмотреть через `SELECT * FROM gold.report_products;`.

---

# Data Warehouse and Analytics Project

The project brings customer, product, and sales data from CRM and ERP sources into a warehouse for analysis.

## Project structure

```
project/
├── datasets/               the project's source CSV files
│   ├── source_crm/         three files from the CRM system
│   └── source_erp/         three files from the ERP system
├── docs/                   architecture and data diagrams
├── scripts/                the project scripts, by level
│   ├── analytics/          13 queries for analyzing the Gold layer
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

## Analytics

The `scripts/analytics` folder contains 13 SQL files for analyzing Gold data. They cover sales, customers, and products, from basic measures to time comparisons and reports. SQL comments are in English with Russian translations in parentheses.

| File | Purpose |
|---|---|
| `01_database_exploration.sql` | Explore Gold tables and columns. |
| `02_dimensions_exploration.sql` | Explore dimension values. |
| `03_date_range_exploration.sql` | Find order date ranges and customer ages. |
| `04_measures_exploration.sql` | Calculate key sales measures. |
| `05_magnitude_analysis.sql` | Group customers, products, and sales. |
| `06_ranking_analysis.sql` | Rank products and customers. |
| `07_change_over_time_analysis.sql` | Show monthly sales. |
| `08_cumulative_analysis.sql` | Calculate cumulative sales. |
| `09_performance_analysis.sql` | Compare product sales across years. |
| `10_part_to_whole_analysis.sql` | Calculate each category's share of sales. |
| `11_data_segmentation.sql` | Segment products and customers. |
| `12_report_customers.sql` | Query customer metrics. |
| `13_report_products.sql` | Create a view of product metrics. |

Run these scripts against `DataWarehouseAnalytics`, which needs the `gold.dim_customers`, `gold.dim_products`, and `gold.fact_sales` views. Scripts `01`–`12` are queries. `13_report_products.sql` creates or updates a view; check its result with `SELECT * FROM gold.report_products;`.
