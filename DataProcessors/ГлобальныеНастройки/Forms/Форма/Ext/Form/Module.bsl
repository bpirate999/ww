﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаАвтоматическоеФормированиеБизнесПроцессовПоСудебнойРаботе(Команда)
	ИдентификаторНастройки = "Настройка автоматического Формирования Бизнес-процессов по судебной работе";
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИдентификаторНастройки", ИдентификаторНастройки);
	ОткрытьФорму("ВнешняяОбработка.ГлобальныеНастройки.Форма.ФормаНастройкиАвтоматическогоФормированияБизнесПроцессовПоСудебнойРаботе",
	ПараметрыФормы, ЭтотОбъект, Истина);
КонецПроцедуры

&НаКлиенте
Процедура НадписьНастройкаСпискаЮристовНажатие(Команда)
	
	ИдентификаторНастройки = "Настройки списка юристов";
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИдентификаторНастройки", ИдентификаторНастройки);
	ОткрытьФорму("ВнешняяОбработка.ГлобальныеНастройки.Форма.ФормаНастройкиЮристов",
	ПараметрыФормы, ЭтотОбъект, Истина);

КонецПроцедуры
