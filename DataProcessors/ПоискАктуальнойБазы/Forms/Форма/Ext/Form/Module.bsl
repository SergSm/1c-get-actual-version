﻿
&НаКлиенте
// Перенумерация строк
Процедура НайденныеБазыПриИзменении(Элемент)
	Для Каждого СтрокаТаблицы Из НайденныеБазы Цикл
		СтрокаТаблицы.НомерСтроки = НайденныеБазы.Индекс(СтрокаТаблицы) + 1
	КонецЦикла;
КонецПроцедуры


#Область Команды


&НаКлиенте
Процедура Поиск(Команда)
	
	// Пример блока
	/////////////////////////////////////////////////////////////
	//[Городская больница 27.09.18]
	//Connect=File="I:\ГорБол 27.09.18";
	//ID=9a0fb660-7848-4db7-8f9c-592456432bc9
	//OrderInList=2.015232
	//Folder=/ГорБол/Старые Архивы ГорБол
	//OrderInTree=81920
	//External=0
	//ClientConnectionSpeed=Normal
	//App=Auto
	//WA=1
	//Version=8.3
	/////////////////////////////////////////////////////////////
	
	// Папка в параметре Folder
	// Folder=/ГорБол/Старые Архивы ГорБол
	
	// сама группа обозначается так
	// [ГорБол]
	
	// Инициализация
	НайденныеБазы.Очистить();
	ЧислоБаз = 0;
	
	ВременныйКаталог = КаталогВременныхФайлов();
	ИмяФайла = "ibases.v8i";
	ВременныйКаталог = СтрЗаменить(ВременныйКаталог, "\Local\Temp\", "\Roaming\1C\1CEStart\");
	
	ФайлЗапуска1С = Новый Файл(ВременныйКаталог + ИмяФайла);
	
	Если НЕ ФайлЗапуска1С.Существует() Тогда
		Сообщить("Файл со списком баз не найден");
		Возврат; 
	КонецЕсли;
	
	ТекстовыйДокИзФайла = Новый ТекстовыйДокумент;
	ТекстовыйДокИзФайла.Прочитать(ФайлЗапуска1С.ПолноеИмя);
	
	// Цикл по строкам
	Для НомерСтроки = 1 По ТекстовыйДокИзФайла.КоличествоСтрок() Цикл
		
		СтрокаТекста = ТекстовыйДокИзФайла.ПолучитьСтроку(НомерСтроки); // из ibases
		
		////////////////////////////////////////////////////////////////////////////////////////////
		// Парсинг строки с заполнением ТЗ на форме
		Если Лев(СтрокаТекста, 1) = "[" Тогда //Это имя в списке
			
			СтруктураБазы = Новый Структура;
			СтруктураБазы.Вставить("ИмяБазы", Сред(СтрокаТекста, 2, СтрДлина(СтрокаТекста) - 2));
		ИначеЕсли СтрЧислоВхождений(СтрокаТекста, "Connect=File=") > 0 Тогда  // это путь к базе
			
			Путь = СтрЗаменить(СтрокаТекста, "Connect=File=", "");
			
			Путь = СтрЗаменить(Путь, ";", "");
			Путь = СтрЗаменить(Путь, """", "");
			
			СтруктураБазы.Вставить("ПутьКБазе", Путь);
			// СтруктураБазы =
			// 					ИмяБазы	"TO TEST" 
			// 					ПутьКБазе	"E:\\InfoBase3"
		ИначеЕсли  СтрЧислоВхождений(СтрокаТекста, "Folder=/") > 0 Тогда  // это группа базы в списке
			ГруппаБазы = СтрЗаменить(СтрокаТекста, "Folder=", "");
			СтруктураБазы.Вставить("ГруппаБазы", ГруппаБазы);
		ИначеЕсли  СтрЧислоВхождений(СтрокаТекста, "Version=") > 0 Тогда  // это версия платформы для запуска
			ВерсияПлатформы = СтрЗаменить(СтрокаТекста, "Version=", "");
			СтруктураБазы.Вставить("ВерсияПлатформы", ВерсияПлатформы);
		КонецЕсли;
		// Парсинг строки  к
		////////////////////////////////////////////////////////////////////////////////////////////
		
		// Если НЕ заполнены все 3 парамтера, то идем дальше
		Если НЕ СтруктураБазы.Свойство("ИмяБазы")
			ИЛИ НЕ СтруктураБазы.Свойство("ГруппаБазы") 
			ИЛИ НЕ СтруктураБазы.Свойство("ПутьКБазе")
			ИЛИ НЕ СтруктураБазы.Свойство("ВерсияПлатформы") Тогда
			Продолжить;
		КонецЕсли; 
		
		// Если заполнены, то добавляе строку в результирующую таблицу
		Если ЗначениеЗАполнено(СтруктураБазы.ИмяБазы)
			И ЗначениеЗАполнено(СтруктураБазы.ГруппаБазы)
			И ЗначениеЗАполнено(СтруктураБазы.ПутьКБазе) 
			И ЗначениеЗАполнено(СтруктураБазы.ВерсияПлатформы) Тогда
			
			// если отбор установлен
			Если ЗначениеЗаполнено(СтрокаПоиска) Тогда    // проверка имени базы
				
				Если СтрНайти(ВРЕГ(СтруктураБазы.ИмяБазы), ВРЕГ(СтрокаПоиска)) = 0 Тогда 
					СтруктураБазы = Новый Структура;
					Продолжить;
				КонецЕсли; 
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаПоискаГруппаБаз) Тогда    // проверка имени базы
				Если СтрНайти(ВРЕГ(СтруктураБазы.ГруппаБазы), ВРЕГ(СтрокаПоискаГруппаБаз)) = 0 Тогда 
					СтруктураБазы = Новый Структура;
					Продолжить;
				КонецЕсли; 
			КонецЕсли;
			
			//Проверяем, что ещё не добавили эту строку в таблицу
			Если НайденныеБазы.НайтиСтроки(Новый Структура("ИмяБазы", СтруктураБазы.ИмяБазы)).Количество() = 0 Тогда
				ЧислоБаз = ЧислоБаз + 1;
				СтрокаБазы = НайденныеБазы.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаБазы, СтруктураБазы);
				СтрокаБазы.НомерСтроки = ЧислоБаз;
				
				
				//Доп свойства
				Если НЕ ПолучатьДатуПоследнегоИзменения Тогда
					Продолжить;
				КонецЕсли; 
				
				ФайлБД = Новый Файл(СтруктураБазы.ПутьКБазе+"\1Cv8.1CD");
				
				// проверим, что файл существует
				Если НЕ ФайлБД.Существует() Тогда
					СтрокаБазы.СуществуетФайлБД	= Ложь;
					Продолжить;
				Иначе
					СтрокаБазы.СуществуетФайлБД = Истина;
				КонецЕсли; 
				
				//получим свойства файла:
				СтрокаБазы.ДатаИзмененияФайлаБазы = ФайлБД.ПолучитьВремяИзменения();
				
			КонецЕсли;
		КонецЕсли; 
		
		
	КонецЦикла;
	
	
КонецПроцедуры


#Область ПолучитьВерсиюКонфигурации

&НаКлиенте
Процедура ПолучитьВерсиюКонфигурации(Команда)
	ПолучитьВерсиюКонфигурацииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПолучитьВерсиюКонфигурацииНаСервере()
	
	ЧислоБаз = НайденныеБазы.Количество();
	
	
	// Для получения версии конфигурации
	// проверим что хоть 1 строка с логино и паролем занесена на соседнюю закладку
	Если ДанныеАвторизации.Количество() = 0 Тогда
		Сообщить("Пожалуйста внесите хоть одну строку с данными авторизации на закладке ""Данные авторизации""");
		Возврат;
	КонецЕсли; 
	
	Сч= 0;
	Для Каждого База Из НайденныеБазы Цикл
		Сч = Сч + 1;
		Сообщить("Обработка базы "+Сч+"/"+ЧислоБаз);
		Если ЗначениеЗаполнено(База.ПутьКБазе)
			
			И ЗначениеЗаполнено(База.ВерсияПлатформы) Тогда
			ОшибкаПриПолученииДанных=ложь;
			ВерсияБД = ПолучитьВерсиюБД(База.ПутьКБазе, База.ВерсияПлатформы, ОшибкаПриПолученииДанных, База.Пользователь, База.Пароль);
			Если ОшибкаПриПолученииДанных Тогда
				База.Пользователь 	= "нет данных";
				База.Пароль 		= "нет данных";
			КонецЕсли; 
			База.ВерсияКонфигурации = ВерсияБД;
			
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры

Функция ПолучитьВерсиюБД(ПутьКБазе, ВерсияПлатформы, ОшибкаПриПолученииДанных, Пользователь, Пароль)
	
	// Определим версию коннектора
	Если СтрНайти(ВерсияПлатформы, "8.2") > 0 Тогда
		ВерсияКомКоннектора ="V82.COMConnector";
	ИначеЕсли СтрНайти(ВерсияПлатформы, "8.3") > 0 Тогда
		ВерсияКомКоннектора ="V83.COMConnector";
	Иначе // другие мне не нужны
		Возврат "Неизвестная версия 1C";
	КонецЕсли; 
	
	#Область СоздаемКОМОбъект
	
	Попытка
		VCOMConnector= Новый COMОбъект(ВерсияКомКоннектора);
		КоннекторИнициализирован = Истина;
	Исключение
		ОшибкаПриПолученииДанных = Истина;
		Инфо = ИнформацияОбОшибке();
		текстОшибки = "";
		текстОшибки = текстОшибки + Инфо.ИмяМодуля + Символы.ПС + 
		Инфо.ИсходнаяСтрока + Символы.ПС + 
		Инфо.НомерСтроки + Символы.ПС + 
		Инфо.Описание + Символы.ПС + 
		Инфо.Причина + Символы.ПС + ""; 
		Подробности = ПодробноеПредставлениеОшибки(Инфо);								
		
		Сообщить(Подробности);
		Сообщить("Ошибка создания КОМ подключения к базе "+ПутьКБазе);
		Сообщить("ВерсияКомКоннектора: "+ВерсияКомКоннектора);
		
		Возврат "Ошибка создания КОМ";
	КонецПопытки;
	
	#КонецОбласти 
	
	
	// Перебор паролей из табличной части обработки и ком-соединение
	УспешнаяАвторизация = Ложь;
	Для Каждого СтрокаАвторизации Из ДанныеАвторизации Цикл
		ПараметрыПодключения = "File="""+ПутьКБазе+"""";
		
		Если УспешнаяАвторизация Тогда
			Прервать;
		КонецЕсли; 
		
		// Строка параметров подключения
		Usr= """"+СтрокаАвторизации.Пользователь+"""";
		Pwd= """"+СтрокаАвторизации.Пароль+"""";
		
		ПараметрыПодключения = ПараметрыПодключения + ";Usr="+Usr;
		ПараметрыПодключения = ПараметрыПодключения + ";Pwd="+Pwd;
		
		#Область ПодключаемсяЧерезКОМ
		Попытка
			Соединение =  VCOMConnector.Connect(ПараметрыПодключения);
			УспешнаяАвторизация = Истина;
			ВерсияКонфигурации = Соединение.Метаданные.Версия;
			ОшибкаПриПолученииДанных = ложь;
			Пользователь = СтрокаАвторизации.Пользователь;
			Пароль = СтрокаАвторизации.Пароль;
			
		Исключение
			УспешнаяАвторизация = Ложь;
			ОшибкаПриПолученииДанных = Истина;
			Инфо = ИнформацияОбОшибке();
			текстОшибки = "";
			текстОшибки = текстОшибки + Инфо.ИмяМодуля + Символы.ПС + 
			Инфо.ИсходнаяСтрока + Символы.ПС + 
			Инфо.НомерСтроки + Символы.ПС + 
			Инфо.Описание + Символы.ПС + 
			Инфо.Причина + Символы.ПС + ""; 
			Подробности = ПодробноеПредставлениеОшибки(Инфо);								
			
			Сообщить(Подробности);
			Сообщить("Ошибка подключения! "+ПутьКБазе);
			Сообщить("Строка подключения: "+ПараметрыПодключения);
			
			Если СтрНайти(Инфо.Причина.Описание, "Идентификация пользователя не выполнена") > 0 Тогда
				ВерсияКонфигурации = "Идентификация пользователя не выполнена";
			Иначе
				ВерсияКонфигурации = "Ошибка подключения!";	
			КонецЕсли; 
			
			ОшибкаПриПолученииДанных = Истина;
			
		КонецПопытки;
		#КонецОбласти	
		
	КонецЦикла; 
	
	
	Возврат ВерсияКонфигурации;
	
КонецФункции

#КонецОбласти


#КонецОбласти

