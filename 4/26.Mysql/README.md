### Домашнее задание
#### Развернуть базу из дампа и настроить для нее реплику

— базу развернуть на мастере  
— настроить чтобы реплицировались таблицы:  
| bookmaker |  
| competition |  
| market |  
| odds |  
| outcome |  

— настроить GTID репликацию  

Варианты которые принимаются к сдаче:  

- **рабочий вагрантафайл**  

Добавлен playbook разворачивающий master-slave GTID-репликацию на базе percona-server-5.7  


- **скрины или логи SHOW TABLES**  

```bash
slave mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: master
                  Master_User: replication
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: master-bin.000002
          Read_Master_Log_Pos: 92647
               Relay_Log_File: slave-relay-bin.000003
                Relay_Log_Pos: 92862
        Relay_Master_Log_File: master-bin.000002
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: bet.bookmaker,bet.competition,bet.outcome,bet.odds,bet.market
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 92647
              Relay_Log_Space: 93528
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 28262
                  Master_UUID: 3f3ef507-a075-11e8-85af-08002701ab81
             Master_Info_File: /var/lib/mysql/master.info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind: 
      Last_IO_Error_Timestamp: 
     Last_SQL_Error_Timestamp: 
               Master_SSL_Crl: 
           Master_SSL_Crlpath: 
           Retrieved_Gtid_Set: 3f3ef507-a075-11e8-85af-08002701ab81:1-38
            Executed_Gtid_Set: 0b3038d5-a076-11e8-8c47-08002701ab81:1,
3f3ef507-a075-11e8-85af-08002701ab81:1-38
                Auto_Position: 1
         Replicate_Rewrite_DB: 
                 Channel_Name: 
           Master_TLS_Version: 
1 row in set (0.01 sec)

slave mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| bet                |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.00 sec)

slave mysql> use bet
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed

slave mysql> show tables;
+---------------+
| Tables_in_bet |
+---------------+
| bookmaker     |
| competition   |
| market        |
| odds          |
| outcome       |
+---------------+
5 rows in set (0.00 sec)

slave mysql> select * from bookmaker;
+----+----------------+
| id | bookmaker_name |
+----+----------------+
|  4 | betway         |
|  5 | bwin           |
|  6 | ladbrokes      |
|  3 | unibet         |
+----+----------------+
4 rows in set (0.00 sec)
```



- **конфиги**  

Конфиг для мастера. Для slave тот же, только другой id и prompt.

```bash
[mysqld]
query_cache_size = 0
query_cache_type = 0
innodb_buffer_pool_size = 128M
performance_schema = False
innodb_log_file_size = 64M
innodb_flush_method = O_DIRECT
innodb_flush_log_at_trx_commit = 2
datadir = /var/lib/mysql
log_error = /var/log/mysqld.log
pid-file = /var/run/mysql/mysqld.pid
innodb_file_per_table

skip-character-set-client-handshake 
character-set-server = utf8
collation-server = utf8_general_ci
init_connect='SET collation_connection = utf8_general_ci'
init_connect='SET NAMES utf8'

validate_password_policy=0
validate_password_length=4

server_id = 28841
log_bin=master-bin
relay-log=slave-relay-bin
binlog-format = ROW
log-slave-updates = True
gtid-mode = on
enforce-gtid-consistency=true

replicate-do-table=bet.bookmaker
replicate-do-table=bet.competition
replicate-do-table=bet.market
replicate-do-table=bet.odds
replicate-do-table=bet.outcome

[mysql]
prompt = "master mysql> "
default-character-set = utf8

[client]
user = root
```

- **пример в логе изменения строки и появления строки на реплике**  

Проверка:  
```bash
master mysql> insert into bookmaker (bookmaker_name) value ('neko');
Query OK, 1 row affected (0.03 sec)

master mysql> select * from bookmaker;
+----+----------------+
| id | bookmaker_name |
+----+----------------+
|  4 | betway         |
|  5 | bwin           |
|  6 | ladbrokes      |
|  7 | neko           |
|  3 | unibet         |
+----+----------------+
5 rows in set (0.00 sec)


slave mysql> select * from bookmaker;
+----+----------------+
| id | bookmaker_name |
+----+----------------+
|  4 | betway         |
|  5 | bwin           |
|  6 | ladbrokes      |
|  7 | neko           |
|  3 | unibet         |
+----+----------------+
5 rows in set (0.00 sec)

```

```bash
[root@master vagrant]# mysqlbinlog /var/lib/mysql/master-bin.000004
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#180815 12:04:31 server id 28841  end_log_pos 123 CRC32 0x7722de47      Start: binlog v 4, server v 5.7.22-22-log created 180815 12:04:31 at startup
# Warning: this binlog is either in use or was not closed properly.
ROLLBACK/*!*/;
BINLOG '
zxZ0Ww+pcAAAdwAAAHsAAAABAAQANS43LjIyLTIyLWxvZwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAADPFnRbEzgNAAgAEgAEBAQEEgAAXwAEGggAAAAICAgCAAAACgoKKioAEjQA
AUfeInc=
'/*!*/;
# at 123
#180815 12:04:31 server id 28841  end_log_pos 194 CRC32 0x67639747      Previous-GTIDs
# bfdde688-a07b-11e8-93a0-5254005f9478:1-38
# at 194
#180815 12:30:12 server id 28841  end_log_pos 259 CRC32 0x78fb19de      GTID    last_committed=0        sequence_number=1       rbr_only=yes
/*!50718 SET TRANSACTION ISOLATION LEVEL READ COMMITTED*//*!*/;
SET @@SESSION.GTID_NEXT= 'bfdde688-a07b-11e8-93a0-5254005f9478:39'/*!*/;
# at 259
#180815 12:30:12 server id 28841  end_log_pos 332 CRC32 0x3d87d288      Query   thread_id=3     exec_time=0     error_code=0
SET TIMESTAMP=1534336212/*!*/;
SET @@session.pseudo_thread_id=3/*!*/;
SET @@session.foreign_key_checks=1, @@session.sql_auto_is_null=0, @@session.unique_checks=1, @@session.autocommit=1/*!*/;
SET @@session.sql_mode=1436549152/*!*/;
SET @@session.auto_increment_increment=1, @@session.auto_increment_offset=1/*!*/;
/*!\C utf8 *//*!*/;
SET @@session.character_set_client=33,@@session.collation_connection=33,@@session.collation_server=33/*!*/;
SET @@session.lc_time_names=0/*!*/;
SET @@session.collation_database=DEFAULT/*!*/;
BEGIN
/*!*/;
# at 332
#180815 12:30:12 server id 28841  end_log_pos 386 CRC32 0x2b23e4a9      Table_map: `bet`.`bookmaker` mapped to number 108
# at 386
#180815 12:30:12 server id 28841  end_log_pos 432 CRC32 0xc788d1af      Write_rows: table id 108 flags: STMT_END_F

BINLOG '
1Bx0WxOpcAAANgAAAIIBAAAAAGwAAAAAAAMAA2JldAAJYm9va21ha2VyAAIDDwL9AgKp5CMr
1Bx0Wx6pcAAALgAAALABAAAAAGwAAAAAAAEAAgAC//wHAAAABABuZWtvr9GIxw==
'/*!*/;
# at 432
#180815 12:30:12 server id 28841  end_log_pos 463 CRC32 0x475bec41      Xid = 27
COMMIT/*!*/;
SET @@SESSION.GTID_NEXT= 'AUTOMATIC' /* added by mysqlbinlog */ /*!*/;
DELIMITER ;
# End of log file
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;

```



```bash
[root@slave vagrant]# mysqlbinlog /var/lib/mysql/slave-relay-bin.000006
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#180815 12:05:03 server id 20592  end_log_pos 123 CRC32 0x5a8a6b3c      Start: binlog v 4, server v 5.7.22-22-log created 180815 12:05:03
# This Format_description_event appears in a relay log and was generated by the slave thread.
# at 123
#180815 12:05:03 server id 20592  end_log_pos 194 CRC32 0x240d78f9      Previous-GTIDs
# bfdde688-a07b-11e8-93a0-5254005f9478:1-38
# at 194
#700101  0:00:00 server id 28841  end_log_pos 0 CRC32 0x7817fee0        Rotate to master-bin.000004  pos: 4
# at 242
#180815 12:04:31 server id 28841  end_log_pos 123 CRC32 0x7722de47      Start: binlog v 4, server v 5.7.22-22-log created 180815 12:04:31 at startup
ROLLBACK/*!*/;
BINLOG '
zxZ0Ww+pcAAAdwAAAHsAAAAAAAQANS43LjIyLTIyLWxvZwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAADPFnRbEzgNAAgAEgAEBAQEEgAAXwAEGggAAAAICAgCAAAACgoKKioAEjQA
AUfeInc=
'/*!*/;
# at 361
#180815 12:05:03 server id 0  end_log_pos 409 CRC32 0xce7bfb3d  Rotate to master-bin.000004  pos: 194
# at 409
#180815 12:30:12 server id 28841  end_log_pos 259 CRC32 0x78fb19de      GTID    last_committed=0        sequence_number=1       rbr_only=yes
/*!50718 SET TRANSACTION ISOLATION LEVEL READ COMMITTED*//*!*/;
SET @@SESSION.GTID_NEXT= 'bfdde688-a07b-11e8-93a0-5254005f9478:39'/*!*/;
# at 474
#180815 12:30:12 server id 28841  end_log_pos 332 CRC32 0x3d87d288      Query   thread_id=3     exec_time=0     error_code=0
SET TIMESTAMP=1534336212/*!*/;
SET @@session.pseudo_thread_id=3/*!*/;
SET @@session.foreign_key_checks=1, @@session.sql_auto_is_null=0, @@session.unique_checks=1, @@session.autocommit=1/*!*/;
SET @@session.sql_mode=1436549152/*!*/;
SET @@session.auto_increment_increment=1, @@session.auto_increment_offset=1/*!*/;
/*!\C utf8 *//*!*/;
SET @@session.character_set_client=33,@@session.collation_connection=33,@@session.collation_server=33/*!*/;
SET @@session.lc_time_names=0/*!*/;
SET @@session.collation_database=DEFAULT/*!*/;
BEGIN
/*!*/;
# at 547
#180815 12:30:12 server id 28841  end_log_pos 386 CRC32 0x2b23e4a9      Table_map: `bet`.`bookmaker` mapped to number 108
# at 601
#180815 12:30:12 server id 28841  end_log_pos 432 CRC32 0xc788d1af      Write_rows: table id 108 flags: STMT_END_F

BINLOG '
1Bx0WxOpcAAANgAAAIIBAAAAAGwAAAAAAAMAA2JldAAJYm9va21ha2VyAAIDDwL9AgKp5CMr
1Bx0Wx6pcAAALgAAALABAAAAAGwAAAAAAAEAAgAC//wHAAAABABuZWtvr9GIxw==
'/*!*/;
# at 647
#180815 12:30:12 server id 28841  end_log_pos 463 CRC32 0x475bec41      Xid = 27
COMMIT/*!*/;
SET @@SESSION.GTID_NEXT= 'AUTOMATIC' /* added by mysqlbinlog */ /*!*/;
DELIMITER ;
# End of log file
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;


```
