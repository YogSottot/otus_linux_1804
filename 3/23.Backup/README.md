### Домашнее задание
#### Бэкап

1 **настроить политику бэкапа каталога /etc с обоих клиентов**  

1) полный раз в день  
2) инкремент каждые 10 минут  
3) дифференциал каждые полчаса  
```bash
Schedule {
Name = "otusCycle"
Run = Full daily at 15:00
Run = Differential hourly at 0:30
Run = Differential hourly at 0:00
Run = Incremental hourly at 0:05
Run = Incremental hourly at 0:15
Run = Incremental hourly at 0:25
Run = Incremental hourly at 0:35
Run = Incremental hourly at 0:45
Run = Incremental hourly at 0:55
}
```
Запустить систему на 2 часа  
Для сдачи ДЗ приложить:  

— list jobs  

```bash
[root@bacula-server vagrant]# sudo -u postgres -H -- psql -d bacula -c "SELECT DISTINCT Job.JobId,Job.Name,Job.StartTime,Job.Type, Job.Level,Job.JobFiles,Job.JobBytes,Job.JobStatus  FROM JobMedia,Job  WHERE JobMedia.JobId=Job.JobId  AND JobMedia.MediaId=1   ORDER by Job.StartTime;" 
could not change directory to "/home/vagrant"
 jobid |    name    |      starttime      | type | level | jobfiles | jobbytes | jobstatus 
-------+------------+---------------------+------+-------+----------+----------+-----------
     1 | etcClient1 | 2018-08-02 11:25:02 | B    | F     |     2351 | 12584208 | T
     2 | etcClient2 | 2018-08-02 11:26:39 | B    | F     |     2351 | 12584217 | T
     3 | etcClient1 | 2018-08-02 11:30:02 | B    | D     |        5 |     2492 | T
     5 | etcClient1 | 2018-08-02 11:35:02 | B    | I     |        7 |     7345 | T
     6 | etcClient2 | 2018-08-02 11:35:05 | B    | I     |        2 |      340 | T
     7 | etcClient1 | 2018-08-02 11:45:02 | B    | I     |        1 |      358 | T
     8 | etcClient2 | 2018-08-02 11:45:05 | B    | I     |       10 |     9457 | T
     9 | etcClient1 | 2018-08-02 11:55:02 | B    | I     |       86 |   104334 | T
    10 | etcClient2 | 2018-08-02 11:55:05 | B    | I     |       51 |    30266 | T
    11 | etcClient1 | 2018-08-02 12:00:02 | B    | D     |       97 |   114193 | T
    12 | etcClient2 | 2018-08-02 12:00:05 | B    | D     |       62 |    40063 | T
    19 | etcClient1 | 2018-08-02 12:30:02 | B    | D     |       97 |   114193 | T
    20 | etcClient2 | 2018-08-02 12:30:05 | B    | D     |       62 |    40063 | T
    27 | etcClient1 | 2018-08-02 13:00:02 | B    | D     |       97 |   114193 | T
    28 | etcClient2 | 2018-08-02 13:00:05 | B    | D     |       62 |    40063 | T
    29 | etcClient1 | 2018-08-02 13:05:02 | B    | I     |       11 |     4507 | T
    31 | etcClient1 | 2018-08-02 13:15:02 | B    | I     |       10 |     4508 | T
    33 | etcClient1 | 2018-08-02 13:25:02 | B    | I     |        3 |     1766 | T
    35 | etcClient1 | 2018-08-02 13:30:02 | B    | D     |      107 |   119095 | T
    36 | etcClient2 | 2018-08-02 13:30:05 | B    | D     |       62 |    40063 | T
    43 | etcClient1 | 2018-08-02 14:00:02 | B    | D     |      107 |   119095 | T
    44 | etcClient2 | 2018-08-02 14:00:05 | B    | D     |       62 |    40063 | T
(22 rows)
```

— list files jobid=<idfullbackup>  

```bash
SELECT Path.Path,Filename.Name FROM File,Filename,Path WHERE File.JobId=%1 
 AND Filename.FilenameId=File.FilenameId 
 AND Path.PathId=File.PathId ORDER BY
 Path.Path,Filename.Name;
 ```
Приложил в отдельных файлах.  
Список из полного бэкапа:  
[client1_list_files_full.conf](https://github.com/YogSottot/otus_linux_1804/blob/master/3/23.Backup/client1_list_files_full.conf)  
[client2_list_files_full.conf](https://github.com/YogSottot/otus_linux_1804/blob/master/3/23.Backup/client2_list_files_full.conf)  

Список из дифф бэкапов.  
[client1_list_files_diff.conf](https://github.com/YogSottot/otus_linux_1804/blob/master/3/23.Backup/client1_list_files_diff.conf)  
[client2_list_files_diff.conf](https://github.com/YogSottot/otus_linux_1804/blob/master/3/23.Backup/client2_list_files_diff.conf)  

— настроенный конфиг  

Размещён в [vagrant-bacula/bacula-dir.conf](https://github.com/YogSottot/otus_linux_1804/blob/master/3/23.Backup/vagrant-bacula/bacula-dir.conf)


2 **настроить доп опции - сжатия, шифрования, дедупликация</idfullbackup>**  

```bash
FileSet {
  Name = "etc"
  Include {
    Options {
      signature = MD5
      compression=LZO
      noatime=yes 
    }
    File = /etc
  }
  Exclude {
  }
}
```
