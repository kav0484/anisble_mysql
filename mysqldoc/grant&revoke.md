GRANT & REVOKE
работают с таблицами 
user Подключающиеся к черверу пользователи и все их глобальные привилигии
db Привилегии уровня базы  данных
tables_priv Привилегии уровня таблицы
columns_priv Привилегии уровня столбца

GRAND privileges(columns)
ON what
TO user IDENTIFIED BY "password"
WITH GRANT OPTION

Привилегии(privileges)
USER - Подлючающиеся к серверу пользователи и всех их глобальные привилегии
ALTER - Изменение таблиц и индексов
CREATE - Создание баз данных и таблиц
DELETE - Удаление существующих записей из таблиц
DROP - Удаление баз данных и таблиц
INDEX - Создание и удаление индексов
INSERT - Вставка новых записей в таблицы
REFERENCES - Не используется
SELECT - Извление существующих записей из таблицы
UPDATE - Изменение существующих записей таблиц
FILE - Чтение и запись файлов сервера
PROCESS - Просмотр информации о внутренних потоках сервера и их удаление
RELOAD - Перезагрузка таблица разрешений или обновление журналов, кеша компьютера или кеша таблицы
REPLICATION SLAVE
SHUTDOWN - Завершение работы сервера
ALL - Все операции. Аналог -  ALL PRIVILEGES
USAGE - Полное отсутствие привилегий

GRANT ALL ON samp_db.* to to boris@localhost IDENTIFIED BY "ruby"
GRANT ALL ON samp_db.* to max@% IDENTIFIED BY "diamond"

REVOKE privileges(columns) ON what FOM user
УДАЛЕНИК ПОЛЬЗОВАТЕЛЯ
mydql>DELETE FROM user WHERE User="user_name" and Host="host";
mysql>FLUSH PRIVILEGES;