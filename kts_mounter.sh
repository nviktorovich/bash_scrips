#!/bin/bash

# Скрипт предназначен для удобного монтирования/размонтирования флешк-карты МПК.
# В переменной subnet содержится информация о подседи, таким образом, 
# скрипт будет всегда отрабатывать, вносить правки не нужно.

# Для корректной работы, необходимо, чтобы в файле /etc/network/interfaces 
# содержалось описание интерфейса, предназначенного для работы с сетью МПК.
# В моем случае такой интерфейс имеет IP адресс, который заканчивается на 200.
# Поиск необходимого интерфейса среди прочих осуществляется с использованием регулярных выражений.

# Для более удобной работы рекомендуется создать alias, в файле ~/.bashrc прописать строки:
# alias ktsmount='sudo ~/Documents/scripts_bash/kts_mounter.sh'
# alias mktsmount='sudo ~/Documents/scripts_bash/kts_mounter.sh -m'
# alias rktsmount='sudo ~/Documents/scripts_bash/kts_mounter.sh -r'
# alias uktsmount='sudo ~/Documents/scripts_bash/kts_mounter.sh -u'

# Данный файл скрипта поместить в директорию ~/Documents/scripts_bash


subnet=$(cat /etc/network/interfaces | grep "\([0-9]\{1,3\}\.[0-9]\{1,3\}\.\)\([0-9]\{1,3\}\)\(\.200\)" | cut -d . -f 3)

if [ "$(id -u)" != "0" ]; then
	echo "------------------ Запуск требует привелегий суперпользователя"
	exit
fi

if [ "$1" == '' ]; then
	echo "------------------ необходим аргумент:"
	echo "-m - монтировать основной комплект;"
	echo "-r - монтировать резервный комплект;"
	echo "-u - отмонтировать устройство МПК."
	exit 1
fi

# в случае, если выбран ключ '-u' необходимо отмонтировать флеш-карту
if [ "$1" == '-u' ]; then
	umount /media/mnt/sys/
	echo "------------------ флеш-карта МПК отмонтирована"
	exit 1
fi

# в случае, если выбран ключ '-m' необходимо монтировать флеш-карту основного комплекта
if [ "$1" == '-m' ]; then
	mount 192.168.${subnet}.126:/mnt/sys /media/mnt/sys
	echo "------------------ основной комплект МПК примонтирован /media/mnt/sys/"
	exit 1
fi

# в случае, если выбран ключ '-m' необходимо монтировать флеш-карту основного комплекта
if [ "$1" == '-r' ]; then
	mount 192.168.${subnet}.125:/mnt/sys /media/mnt/sys
	echo "------------------ основной комплект МПК примонтирован /media/mnt/sys/"
	exit 1
fi

echo "------------------ введен некоректный аргумент $1"
echo "-m монтировать основной комплект МПК;"
echo "-r монтировать резервный комплект МПК;"
echo "-u отмонтировать устройство МПК."
exit 1