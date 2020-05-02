 mysqlcheck -u root -p --optimize --auto-repair --all-databases

Назначение параметров:
--optimize – Оптимизируем все базы.
--auto-repair – Ремонтируем все базы.
--all-databases – Проверяем ошибки у всех баз.

## Проверка отдельной таблицы в базе данных:
mysqlcheck -r имя_базы имя_таблицы_в_базе -u root -p