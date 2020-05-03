**3 способа**  
1 - копирование табличных файлов  
2 - создание SQL образов таблиц  
3 - создание форматированных текстовых файлов
### hot backup Percona XtraBackup(mariabackup)
#### Full backup
**backup**  
mariabackup --backup --target-dir /home/mariadb_backup -u root -p password  
**Подготовка**  
mariabackup --prepare --target-dir=/var/mariadb/backup/  
**Востановление**  
mariabackup --copy-back --target-dir=/var/mariadb/backup/
#### Incremantal backup
**Делаем сначала полный бекап**  
mariabackup --backup --target-dir=/var/mariadb/backup/ 
--user=mariabackup --password=mypassword 
**Incremental**  
mariabackup --backup --target-dir=/var/mariadb/inc1/   --incremental-basedir=/var/mariadb/backup/ --user=mariabackup --password=mypassword

#### Востановление инкрементного backupa
**MariaDB starting with 10.2**
1. mariabackup --prepare --target-dir=/var/mariadb/backup  
2. mariabackup --prepare \
   --target-dir=/var/mariadb/backup \
   --incremental-dir=/var/mariadb/inc1

**MariaDB until 10.1** 
1. mariabackup --prepare --apply-log-only \
   --target-dir=/var/mariadb/backup
2. mariabackup --prepare --apply-log-only \
   --target-dir=/var/mariadb/backup \
   --incremental-dir=/var/mariadb/inc1

==================================================  
3. mariabackup --copy-back \
   --target-dir=/var/mariadb/backup/

4. chown -R mysql:mysql /var/lib/mysql/



### mysqlhotcopy для MyISAM
**mysqlhotcopy db1 db2 db3 /home/backup**

### mysqldump 
mysqldump db -u root  -p > dump.sql


##  Отказ изменений с использованием бинарных логов
Для того, чтобы воспользоваться бинарными логами их следует пропустить через утилиту mysqlbinlog

      mysqlbinlog binlog.0000003 > binlog3.sql
      mysql -u root -p dbname < binlog3.sql