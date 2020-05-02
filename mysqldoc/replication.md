# Горизонтальное масштабирование 
Масштабирование для чтение решается добавлением подчиненных серверов.  
Масштабирование для записи - шардинг.  

### Шардинг
1. статический
2. динамический


#  Типы репликации
1. Master - Slave
2. Master - Master

## Master - Slave
### Master
Добавить в my.cnf(my.cnf.d/server.cnf)  
[mysqld]  
server-id = 1 # уникальный ИД сервера  
expire_logs_days = 2 # время жизни бинлогов в днях  
max_binlog_size = 100M # макс размер бинлогов  
binlog_do_db = mydb # БД для реплицирования ("экспорта" в бинлог)  
log_bin = /var/lib/mysql/mydb-bin.log # путь к бинлогу

$ systemctl restart mariadb  
mysql> SHOW MASTER STATUS\G;   
**запоминаем значения File и Position из результата**
329
Далее создаем пользователя для репликации  
mysql> CREATE USER 'repl_user'@'%';  
mysql> GRANT REPLICATION SLAVE on *.* TO 'repl_user'@'%' IDENTIFIED BY 'password';

mysql> USE mydb; # выбираем нашу реплицируемую БД  
mysql> FLUSH TABLES WITH READ LOCK; # блокируем запись во все таблицы  
mysql> \q # пока выходим  

user@master$ mysqldump -u root -p mydb > mydb.sql # делаем полный дамп БД в файл и копируем на slave

user@master$ mysql -u root -p # заходим в mysql  
mysql> USE mydb; # выбираем нашу реплицируемую БД  
mysql> UNLOCK TABLES; # снимаем блокировки с таблиц, пусть пишется дальше  
mysql> \q # выходим

### Slave
Настраиваем кофиг (my.cnf)   
[mysqld]  
server-id = 2 # уникальный ИД сервера  
master-host = <Master-IP> # адрес мастера  
master-user = repl_user # юзер БД  
master-password = password # пароль юзера БД  
master-port = 3306 # порт mysql мастера  
expire_logs_days = 2 # время жизни логов в днях  
replicate_do_db = mydb # БД для реплицирования   ("импорта" из лога)  
relay-log = /var/lib/mysql/mydb-relay-bin # путь к логу  
relay-log-index = /var/lib/mysql/mydb-relay-bin.index # путь к индексу лога

root@slave# service mysql reload # **перезапускаем mysql**  
user@slave$ mysql -u root -p # заходим в mysql  
mysql> CREATE DATABASE mydb; # создаём БД  
mysql> USE mydb; # переходим к ней  
mysql> SOURCE ~/mydb.sql # импорт БД из дампа (допустим, он лежит в дом. папке)    
mysql> CHANGE MASTER TO MASTER_LOG_FILE = '**File**', MASTER_LOG_POS = '**Position**'; # указываем настройки мастера и доступа к нему  
mysql> START SLAVE; # стартуем репликацию  
mysql> \q # выходим из мускуля  

## Master - Master