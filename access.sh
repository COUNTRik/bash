# Получаем общее количество строк alline, номер строки numline по последней дате из файла time и высчитываем количство строк line нашего лога, которые мы будем обрабатывать
alline=$(wc -l access-4560-644067.log | cut -d ' ' -f 1)
numline=$(grep -n $(cat time) access-4560-644067.log | awk -F: '{print $1}' | head -n 1)
line=$(($alline - $numline))

# Сохраняем в отдельный файл все нужные нам поля лог файла, которые мы будем обрабатывать, для того чтобы не мешать записывать в основной файл логи 
tail -n $line access-4560-644067.log | awk '{print $1,$4,$6,$7,$9}' > access.log

# Записываем в файл time последнюю дату последней обрабатываемой строки, с помощью которой мы сможем начать обработку нашего лога в следующий запуск (раскоментировать для включения)
# awk 'END{print $2}' access.log | cut -c 2- > time

# Добавляем время начала и конец интервала обрабатваемого лога
startlog=$(head -n 1 access.log | awk '{print $2}' | cut -c 2-)
endlog=$(awk 'END{print $2}' access.log | cut -c 2-)

echo "Script start time $(date)" > weblog
echo "Log has been analyzed from  $startlog to $endlog" >> weblog
echo "-----------------------------------------------------------------------------------">> weblog

echo "The list of addresses with the most requests to the server (top 10 req-IP pairs)" >> weblog
awk '/(GET|POST)/{print $1}' access.log | sort -n | uniq -c | sort -n -r | head >> weblog
echo "-----------------------------------------------------------------------------------" >> weblog

echo "The list of server resources with the most requests from the clients (top 10 req-res pairs)" >> weblog
awk '{print $4}' access.log | sort -n | uniq -c | sort -n -r | head >> weblog
echo "-----------------------------------------------------------------------------------" >> weblog

echo "Total number of errors (status codes 4xx and 5xx, number-code pairs)" >> weblog
awk '/(GET|POST)/{print $5}' access.log | awk '/[45][0-9][0-9]/{print $1}' | sort -n | uniq -c | sort -n -r >> weblog
echo "-----------------------------------------------------------------------------------" >> weblog

echo "The list of status codes with their total number (number-code pairs)" >> weblog
awk '/(GET|POST)/{print $5}' access.log | sort -n | uniq -c | sort -n -r >> weblog
echo "-----------------------------------------------------------------------------------" >> weblog

# Отправляем файлы отчеты по почте
# echo "logs server" | mutt -s "logs server" -a weblog -- user@email.com
