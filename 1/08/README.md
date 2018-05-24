### Домашнее задание
#### Размещаем свой RPM в своем репозитории
1) создать свой RPM (можно взять свое приложение, либо собрать к примеру апач с определенными опциями)
    
    Решено собрать nginx с модулем Pagespeed
    
    Устанавливаем зависимости.  
    ```bash
    yum install gcc-c++ pcre-devel zlib-devel make unzip \ 
    wget openssl-devel libxml2-devel libxslt-devel gd-devel \ 
    perl-ExtUtils-Embed GeoIP-devel gperftools-devel rpm-build \
    redhat-lsb-core libuuid-devel -y
    ```
    Добавляем пользователя под которым будем собирать.
    ```bash
    useradd -m otus
    ```
    Скачиваем свежий сорс [отсюда](https://nginx.org/packages/centos/7/SRPMS/)
    ```bash
    rpm -Uvh https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.0-1.el7_4.ngx.src.rpm
    ```
    Перемещаем исходники в директорию пользователя под которым будем производить сборку.
    ```bash
    mv /root/rpmbuild /home/otus/ && chown -R otus. /home/otus/rpmbuild
    ```
    Заходим под пользователем.
    ```bash
    su otus
    cd ~/rpmbuild/SOURCES/
    ```
    Скачиваем [последнюю](https://github.com/apache/incubator-pagespeed-ngx/releases) версию Pagespeed
    
    Структура переменных взята из [официального руководства](https://www.modpagespeed.com/doc/build_ngx_pagespeed_from_source)
    ```bash
    NPS_VERSION=1.13.35.2-stable
    wget https://github.com/apache/incubator-pagespeed-ngx/archive/v${NPS_VERSION}.zip
    unzip v${NPS_VERSION}.zip
    rm v${NPS_VERSION}.zip
    ```
    В распакованную директорию Pagespeed скачиваем требуемую библиотеку PSOL.
   ```bash
    nps_dir=$(find . -name "*pagespeed-ngx-${NPS_VERSION}" -type d)
    cd "$nps_dir"
    NPS_RELEASE_NUMBER=${NPS_VERSION/beta/}
    NPS_RELEASE_NUMBER=${NPS_VERSION/stable/}
    psol_url=https://dl.google.com/dl/page-speed/psol/${NPS_RELEASE_NUMBER}.tar.gz
    [ -e scripts/format_binary_url.sh ] && psol_url=$(scripts/format_binary_url.sh PSOL_BINARY_URL)
    wget ${psol_url}
    tar -xzvf $(basename ${psol_url})
    rm $(basename ${psol_url})   
    ```
    Запаковываем Pagespeed и PSOL в один архив
    ```bash
    cd ..
    tar -zcvf incubator-pagespeed-ngx-${NPS_VERSION}.tar.gz incubator-pagespeed-ngx-${NPS_VERSION}
    rm -r incubator-pagespeed-ngx-${NPS_VERSION}
    cd ~
    ```
    Редактируем spec-файл nginx
    ```bash
    nano ~/rpmbuild/SPECS/nginx.spec
    ``` 
    Ищем ```%define main_release 1%{?dist}.ngx``` и добавляем следующую строку ниже:
    ```bash
    %define pagespeed_version 1.13.35.2-stable
    ```
    Должно выглядеть примерно так
    ```bash
    %define main_version 1.14.0  
    %define main_release 1%{?dist}.ngx
    %define pagespeed_version 1.13.35.2-stable
    ```
    Ищем ```--with-stream_ssl_preread_module``` и добавляем следующую строку после неё:
    ```bash
    --add-module=%{_builddir}/%{name}-%{main_version}/incubator-pagespeed-ngx-%{pagespeed_version}
    ```
    Должно выглядеть примерно так
    ```bash
    %define BASE_CONFIGURE_ARGS $(echo "--prefix=%{_sysconfdir}/nginx --sbin-path=%{_sbindir}/nginx --modules-path=%{_libdir}/nginx/modules --conf-path=%{_sysconfdir}/nginx/nginx.conf --error-log-path=%{_localstatedir}/log/nginx/error.log --http-log-path=%{_localstatedir}/log/nginx/access.log --pid-path=%{_localstatedir}/run/nginx.pid --lock-path=%{_localstatedir}/run/nginx.lock --http-client-body-temp-path=%{_localstatedir}/cache/nginx/client_temp --http-proxy-temp-path=%{_localstatedir}/cache/nginx/proxy_temp --http-fastcgi-temp-path=%{_localstatedir}/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=%{_localstatedir}/cache/nginx/uwsgi_temp --http-scgi-temp-path=%{_localstatedir}/cache/nginx/scgi_temp --user=%{nginx_user} --group=%{nginx_group} --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --add-module=%{_builddir}/%{name}-%{main_version}/incubator-pagespeed-ngx-%{pagespeed_version}")
    ```
    Ищем ```Source13: nginx.check-reload.sh``` и добавляем под неё:
    ```bash
    Source14: incubator-pagespeed-ngx-%{pagespeed_version}.tar.gz
    ```
    Должно выглядеть примерно так
    ```bash
    Source13: nginx.check-reload.sh
    Source14: incubator-pagespeed-ngx-%{pagespeed_version}.tar.gz
    ```
    Ищем ```%setup -q``` и добавляем под неё:
    ```bash
    tar zxvf %SOURCE14
    %setup -T -D -a 14
    ```
    Должно выглядеть примерно так
    ```bash
    %prep
    %setup -q
    tar zxvf %SOURCE14
    %setup -T -D -a 14
    cp %{SOURCE2} .
    sed -e 's|%%DEFAULTSTART%%|2 3 4 5|g' -e 's|%%DEFAULTSTOP%%|0 1 6|g' \
    ```
    Собираем пакет
    ```bash
    rpmbuild -ba ~/rpmbuild/SPECS/nginx.spec
    ```
    Во время стадии конфигурирования появится приглашение с вопросом. Пишем ```Y```
    ```bash
    You have set --with-debug for building nginx, but precompiled Debug binaries for
        PSOL, which ngx_pagespeed depends on, aren't available.  If you're trying to
        debug PSOL you need to build it from source.  If you just want to run nginx with
        debug-level logging you can use the Release binaries.
        
        Use the available Release binaries? [Y/n] Y
        
    ```
    Откиньтесь на спинку кресла и отдохните, пока ~~Windows 98 устанавливается на ваш компьютер~~ собирается пакет.
    
2) создать свой репо и разместить там свой RPM
реализовать это все либо в вагранте, либо развернуть у себя через nginx и дать ссылку на репо 