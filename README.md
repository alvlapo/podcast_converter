podcast_converter
=================

_Маленький скрипт изменения битрейта у mp3 файлов из подкаста vesti.net_

Мой плеер не мог проигрывать подкасты с подкаст терминала podfm.ru, проигрывалось только заставка podfm,
несколько секунд в начале файла. Гуглени и сторонние кодеки и плееры не помогли, и родилось решение в лоб.

* Каждый день загружает rss фид 
* В фиде ищет ссылки на mp3 файлы и выбирает последние N файлов
* Скачивает и конвертирует mp3 изменяя их битрейт
* Заменяет ссылки в rss фиде на конвертированные файлы
* Новый фид готов ;)
