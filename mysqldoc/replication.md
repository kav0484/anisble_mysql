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

Далее создаем пользователя для репликации  
mysql> CREATE USER 'repl'@'%';  
mysql> GRANT REPLICATION SLAVE on *.* TO 'repl'@'%' IDENTIFIED BY 'password';

    mariabackup --backup \
    --target-dir=/var/mariadb/backup/ \
    --user=mariabackup --password=mypassword

**If the source database server is a replication slave**

    mariabackup --backup \
        --slave-info --safe-slave-backup \
        --target-dir=/var/mariadb/backup/ \
        --user=mariabackup --password=mypassword

**Копируем на слейв**

    rsync -avP /var/mariadb/backup dbserver2:/var/mariadb/backup


### Slave
Настраиваем кофиг (my.cnf)   
[mysqld]  
server-id = 2 # уникальный ИД сервера  
replicate_do_db = mydb # БД для реплицирования   ("импорта" из лога)  
relay-log = /var/lib/mysql/mydb-relay-bin # путь к логу  
relay-log-index = /var/lib/mysql/mydb-relay-bin.index # путь к индексу лога  
#если необходимо сделать базу доступной только для чтения  
#read_only = 1

**Востанавливаем БД**

    mariabackup --copy-back --target-dir=/var/mariadb/backup/
    chown -R mysql:mysql /var/lib/mysql/

 .

    $ cat xtrabackup_binlog_info
    mariadb-bin.000096 568 0-1-2

.

    CHANGE MASTER TO MASTER_HOST='192.168.0.1', MASTER_USER='repl', MASTER_PASSWORD='password', MASTER_LOG_FILE = 'mariadb-bin.000096', MASTER_LOG_POS = 568;
    mysql> START SLAVE; # стартуем репликацию  


