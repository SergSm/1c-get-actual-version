﻿# 1c-get-actual-version

![](https://github.com/SergSm/1c-get-actual-version/blob/master/screen1.png)

A simple 1C:Enterprise configuration for parsing the "ibases.v8i" file (it contains the list of entries to "1C" databases) 
and extracting the information from 1Cv8.1CD files 

The configuration is able to retrieve properties: 
  1) 1Cv8.1CD change date
  2) The version of the database configuration (via COM-connection) 
  3) Configuration comment
  
The simple interace provides search by:
  1) database name
  2) folder name from the launcher's tree-view 
Example:
I have a group called "Super client"
And a 5 database entries inside of the launcher's folder
By entering data in the search field I can retrieve the all described properties 1Cv8.1CD files 


Works ONLY for file-versions
______________________________________________________________________________________________________________________
Простая конфигурация на платформе 1С:Предприятия для разбора файла ibases.v8i(который содержит список точек входа в базы "1С") 
и извлечения информации из файлов 1Cv8.1CD

Конфигурация может получать свойства:
  1) Дату изменения файла 1Cv8.1CD
  2) Версию конфигурации базы данных (с помощью COM-соединения)
  3) Комментарий конфигурации
  
 Простой интерфейс дает возможность осуществлять поиск
  1) По имени базы данных
  2) По имени папки из древовидного просмотра списка баз
Например:
У меня есть группа с именем "Супер клиент"
и 5 точек входа в базы внутри группы
Вводя данные в строку поиска я могу получить все описанные свойства файлов 1Cv8.1CD

Работает ТОЛЬКО для файловых версий
