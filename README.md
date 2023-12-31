# Тест 20к подключений к fastapi+uvicorn

Тест асинхронного сервиса с целью выяснить требуемые настройки сервера для обработки 20к запросов в секунду

## Дополнительные условия

Максимальное время ответа сервера 200мс. В тестовом сервере поставим заглушку ровно на 200мс. 

## Утилита для тестирования

[wrk - a HTTP benchmarking tool](https://github.com/wg/wrk#wrk---a-http-benchmarking-tool)

Утилита управляется передаваемыми в консоль параметрами.

```shell
Usage: wrk <options> <url>  
  Options:                                            
    -c, --connections <N>  Connections to keep open   
    -d, --duration    <T>  Duration of test           
    -t, --threads     <N>  Number of threads to use   
                                                      
    -s, --script      <S>  Load Lua script file       
    -H, --header      <H>  Add header to request      
        --latency          Print latency statistics   
        --timeout     <T>  Socket/request timeout     
    -v, --version          Print version details
```

Нас интересуют параметры `-c`, `-d`, `-t`


## Установка утилиты для тестирования

### Копируем себе
```shell
mkdir ~/delete_me/
cd ~/delete_me/
git clone https://github.com/wg/wrk.git
```

### Собираем
```shell
cd wrk/
make
```

На этапе сборки может чего-то не хватать, ищем как это называется, устанавливаем

### Копируем бинарник и даем права
```shell
cp ./wrk ~/.local/bin/wrk
chmod +x ~/.local/bin/wrk
```

### Проверяем, знает ли наш shell, где лежит утилита
```shell
which wrk
```

Должно вывестись что-то вроде
```shell
/home/grm/.local/bin/wrk
```

Если этого не произошло - надо перелогиниться

## Запуск сервера

Запуск сервера в один или несколько потоков осуществляется с помощью утилиты `make`.

Например:
* make run-one-thread - запуск сервера в 1 потоке
* make run-four-threads - запуск сервера в 4 потоках
* ...

## Запуск теста

Запуск нагрузочного теста в один или несколько потоков осуществляется с помощью утилиты `make`.

Например:
* make test-one-thread - запуск теста в 1 потоке
* make test-four-threads - запуск теста в 4 потоках
* ...

## Предварительные результаты:

### Запуск в один поток:

```shell
Running 30s test @ http://localhost:8000/ping/
  1 threads and 20000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     0.00us    0.00us   0.00us    -nan%
    Req/Sec     4.21k     1.37k    5.42k    85.11%
  20000 requests in 30.06s, 2.48MB read
  Socket errors: connect 0, read 0, write 0, timeout 20000
Requests/sec:    665.23
Transfer/sec:     84.45KB
```

665.23 запросов в секунду - пока до результата далеко )))

### Запуск в 4 потока:

```shell
  4 threads and 20000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     1.36s   495.06ms   2.00s    59.62%
    Req/Sec     2.85k     2.43k   12.72k    70.47%
  187444 requests in 30.07s, 23.26MB read
  Socket errors: connect 0, read 0, write 0, timeout 168480
Requests/sec:   6234.22
Transfer/sec:    792.20KB
```

6234.22 запросов в секунду - уже ближе - но еще не целевой показатель

## Промежуточный итог

К сожалению на своей рабочей машине я не могу провести более нагруженный тест, однако, 
имея результаты для 1 и 4 процессов, целевой показатель в 20к запросов в секунду кажется достижимым


