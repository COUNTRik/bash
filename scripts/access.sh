alline=$(wc -l access-4560-644067.log | cut -d ' ' -f 1)
numline=$(grep -n $(cat time) access-4560-644067.log | awk -F: '{print $1}' | head -n 1)
line=$(($alline - $numline))
tail -n $line access-4560-644067.log
# awk '{print $1,$4,$6,$9}' access-4560-644067.log > access.log
# awk 'END{print $2}' access.log | cut -c 2- > time
# cat time
# awk '/(GET|POST)/{print $1}' access.log | sort -n | uniq -c | sort -n -r > get-post-ip.log
# awk '/GET/{print $1}' access.log | sort -n | uniq -c | sort -n -r > post-ip.log
# awk '! /(GET|POST)/{print $1}' access.log > ip-error.log
# awk '/(GET|POST)/{print $4}' access.log | sort -n | uniq -c | sort -n -r > code.log
