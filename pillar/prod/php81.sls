php:
  use_external_repo: True
  external_repo_name: 'ondrej/php'

  version: '8.1'
  lookup:
    pkgs:
      curl:
        - php8.1-curl
        - curl
      cli:
        - php8.1-cli
        - php8.1-common
      modules:
        - php8.1-xml
        - php8.1-soap
        - php8.1-bcmath
        
    fpm:
      conf: /etc/php/8.1/fpm/php-fpm.conf
      ini: /etc/php/8.1/fpm/php.ini
      pools: /etc/php/8.1/fpm/pool.d
      service: php8.1-fpm.service

      defaults:
        global:
          pid: /run/php/php8.1-fpm.pid

    cli:
      ini: /etc/php/8.1/cli/php.ini

  fpm:
    service:
      enabled: True
      opts:
        reload: True

    config:
      ini:
        opts:
          recurse: True
        settings:
          PHP:
            engine: 'On'
            expose_php: 'Off'
            extension_dir: '/usr/lib/php/20210902/'
      conf:
        opts:
          recurse: True
        settings:
          global:
            pid: /run/php/php8.1-fpm.pid
            error_log: /var/log/php8.1-fpm.log

    # settings for fpm-pools
    pools:
      'opensourcewebsite.org.conf':
        enabled: True
        opts:
           replace: True

        settings:
          opensourcewebsite.org:
            user: opensourcewebsite.org
            group: opensourcewebsite.org
            listen: /run/php/php8.1-opensourcewebsite.org.sock
            listen.owner: opensourcewebsite.org
            listen.group: opensourcewebsite.org
            listen.mode: 0660
            pm: dynamic
            pm.max_children: 5
            pm.start_servers: 2
            pm.min_spare_servers: 2
            pm.max_spare_servers: 5
            slowlog: /www/opensourcewebsite.org/logs/slow.log
            request_slowlog_timeout: 5s
            'php_admin_value[memory_limit]': 4096M

      'www.conf':
        enabled: True
        opts:
           replace: True

        settings:
          www:
            user: www-data
            group: www-data
            listen: /run/php/php8.1-fpm.sock
            listen.owner: www-data
            listen.group: www-data
            listen.mode: 0660
            pm: dynamic
            pm.max_children: 5
            pm.start_servers: 2
            pm.min_spare_servers: 2
            pm.max_spare_servers: 5
            slowlog: /var/log/php8.1-fpm.slow.log
            request_slowlog_timeout: 5s
            'php_admin_value[memory_limit]': 128M

  # php-cli settings
  cli:
    ini:
      opts:
        replace: False
      settings:
        PHP:
          engine: 'On'
          expose_php: 'Off'

  # global php.ini settings
  ini:
    defaults:
      PHP:
        engine: on
        output_buffering: 4096
        disable_functions:
          - pcntl_alarm
          - pcntl_fork
          - pcntl_wait
        post_max_size: '210M'
        upload_max_filesize: '200M'
        max_execution_time: 360
        max_input_time: 360
        default_socket_timeout: 360
      'CLI Server':
        cli_server_color: 'On'
      'Date':
        'date.timezone': 'UTC'
