﻿Процедура ДополнитьОписаниеМодифицирующегоПараметраОтбора(ИмяПараметра, ОписаниеПараметра, ИмяМодификации) Экспорт
	
	Если ПустаяСтрока(ИмяМодификации) Тогда
		Если ИмяПараметра = "Подразделение" Тогда
			ОписаниеПараметра.Вставить("ИмяМодификации", "ОтборПоПодразделению");
		КонецЕсли;
	Иначе
		ОписаниеПараметра.Вставить("ИмяМодификации", ИмяМодификации);
	КонецЕсли;
	
КонецПроцедуры

  Процедура НастроитьМодифицирующийПараметрОтбора(СтрокаПараметра, Список, МетаданныеОбъекта, Элементы) Экспорт
	
	Если Не ПустаяСтрока(СтрокаПараметра.ИмяМодификации) Тогда
		ЗаполнитьПараметрыВариантаМодификации(СтрокаПараметра, Список, МетаданныеОбъекта);
		ДобавитьПредставлениеПараметровМодификации(Элементы, СтрокаПараметра);
	КонецЕсли;

КонецПроцедуры    

Процедура ЗаполнитьПараметрыВариантаМодификации(СтрокаПараметра, Список, МетаданныеОбъекта)
	
	Если СтрокаПараметра.ИмяМодификации = "ОтборПоПодразделению" Тогда
		
		ИменаТиповДокументов = Новый Массив;
		
		Если ОбщегоНазначения.ЭтоЖурналДокументов(МетаданныеОбъекта) Тогда
			Для Каждого РегистрируемыйДокумент Из МетаданныеОбъекта.РегистрируемыеДокументы Цикл
				ИменаТиповДокументов.Добавить(РегистрируемыйДокумент.ПолноеИмя());
			КонецЦикла;
		ИначеЕсли ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъекта) Тогда
			ИменаТиповДокументов.Добавить(МетаданныеОбъекта.ПолноеИмя());
		КонецЕсли;
		
		Параметры = Новый Структура;
		
		ДобавитьПараметрМодификации(Параметры, "ИменаТиповДокументов", ИменаТиповДокументов);
		ДобавитьПараметрМодификации(Параметры, "ДинамическоеСчитываниеДанных", Список.ДинамическоеСчитываниеДанных);
		ДобавитьПараметрМодификации(Параметры, "Иерархия", Ложь);
		
		СтрокаПараметра.ПараметрыМодификации = Параметры;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьПредставлениеПараметровМодификации(Элементы, СтрокаПараметра)
	
	Если ЗарплатаКадрыРасширенныйКлиентСервер.ОбновитьПредставлениеПараметровМодификации(Элементы, СтрокаПараметра) Тогда
	
		Элемент = Элементы[СтрокаПараметра.ИмяЭлементаФормыПараметра];
		Элемент.РасширеннаяПодсказка.УстановитьДействие(
			"ОбработкаНавигационнойСсылки",
			"Подключаемый_ПараметрМодификацииВыбор");
		Элемент.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСправа;
		Элемент.РасширеннаяПодсказка.ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьПараметрМодификации(Параметры, Имя, Значение, Представление = Неопределено, БыстрыйДоступ = Ложь)
	
	Параметры.Вставить(Имя,
		Новый Структура("Значение,Представление,БыстрыйДоступ", Значение, Представление, БыстрыйДоступ));
		
КонецПроцедуры

