### Домашнее задание
#### работаем с процессами

4) реализовать 2 конкурирующих процесса по IO. пробовать запустить с разными ionice

     Результат ДЗ - скрипт запускающий 2 процесса с разными ionice, замеряющий время выполнения и лог консоли
5) реализовать 2 конкурирующих процесса по CPU. пробовать запустить с разными nice

    Результат ДЗ - скрипт запускающий 2 процесса с разными nice и замеряющий время выполнения и лог консоли
    
    ```bash
    #!/usr/bin/env bash
    
    xargs -P 2 -I {} sh -c 'eval "$1"' - {} <<'EOF'
    time dd if=/dev/urandom of=/mnt/swapfile55 bs=1M count=2048
    time nice -n 19 ionice -c2 -n7 dd if=/dev/urandom of=/mnt/swapfile77 bs=1M count=2048
    EOF

    ```
    
    Скрипт запускает одновременно 2 процесса dd создающих файлы и заполняющих их из urandom.
    
    Лог запуска
    ```bash
    bash nice_test.sh
   
    # без nice и ionice   
                    
    2048+0 records in
    2048+0 records out
    2147483648 bytes (2,1 GB) copied, 43,3587 s, 49,5 MB/s
    
    real    0m43.362s
    user    0m0.010s
    sys     0m43.254s
 
    # с nice и ionice 
    2048+0 records in
    2048+0 records out
    2147483648 bytes (2,1 GB) copied, 43,5956 s, 49,3 MB/s
    
    real    0m43.602s
    user    0m0.008s
    sys     0m43.332s

    ```
    Процесс запущенный с nice выполнялся несколько дольше, как и ожидалось.