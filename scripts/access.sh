# Получаем общее количество строк alline, номер строки numline по последней дате из файла time и высчитываем количство строк line нашего лога, которые мы будем обрабатывать
alline=$(wc -l access-4560-644067.log | cut -d ' ' -f 1)
numline=$(grep -n $(cat time) access-4560-644067.log | awk -F: '{print $1}' | head -n 1)
line=$(($alline - $numline))

# Сохраняем в отдельный файл все нужные нам поля лог файла, которые мы будем обрабатывать, для того чтобы не мешать записывать в основной файл логи 
tail -n $line access-4560-644067.log | awk '{print $1,$4,$6,$9}' > access.log

# Записываем в файл time последнюю дату последней обрабатываемой строки, с помощью которой мы сможем начать обработку нашего лога в следующий запуск
awk 'END{print $2}' access.log | cut -c 2- > time

# Фильтруем и сохраняем список всех ip адресов с количесвом запросов, кроме ошибок
awk '/(GET|POST)/{print $1}' access.log | sort -n | uniq -c | sort -n -r > get-post-ip.log

# Фильтруем и сохраняем список запрашиваемых ip адресов с количесвом запросов
awk '/GET/{print $1}' access.log | sort -n | uniq -c | sort -n -r > post-ip.log

# Фильтруем и сохраняем список всех ip адресов с ошибками
awk '! /(GET|POST)/{print $1}' access.log > ip-error.log

# Фильтруем и сохраняем список всех кодов возврата с указанием их количества
awk '/(GET|POST)/{print $4}' access.log | sort -n | uniq -c | sort -n -r > code.log

# Отправляем файлы отчеты по почте
# echo "logs server" | mutt -s "logs server" -a get-post-ip.log -- post-ip.log -- ip-error.log -- code.log -- user@email.com
