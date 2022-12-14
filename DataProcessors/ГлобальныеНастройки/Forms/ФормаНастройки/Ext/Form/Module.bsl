
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИдентификаторНастройки = Параметры.ИдентификаторНастройки;
	
	Если Параметры.Свойство("ДопПараметры") = Истина Тогда
		ДопПараметры = Параметры["ДопПараметры"];
		Если ДопПараметры.Свойство("СписокЗначений") Тогда
			СписокСсылок.Очистить();
			Для Каждого Элем Из ДопПараметры["СписокЗначений"] Цикл
				СписокСсылок.Добавить(Элем.Значение, Элем.Представление);
			КонецЦикла;
		КонецЕсли;
	Иначе
		
		РеквизитОбъект = РеквизитФормыВЗначение("Объект"); 
		РеквизитОбъект.ЗаполнитьСписок(СписокСсылок, ИдентификаторНастройки);
	КонецЕсли;
	
	УстановитьПометкиСписка();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПометкиСписка()
	
	СохраненныеНачисления = F1_ОбщегоНазначенияСервер.ПрочитатьГлобальнуюНастройку(ИдентификаторНастройки);
	Если СохраненныеНачисления = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементСохраненногоСписка Из СохраненныеНачисления Цикл
		ЭлементСписка = СписокСсылок.НайтиПоЗначению(ЭлементСохраненногоСписка);
		Если ЭлементСписка <> Неопределено Тогда
			ЭлементСписка.Пометка = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)

	МассивНачислений = Новый Массив;
	Для Каждого ЭлементСписка Из СписокСсылок Цикл
		Если ЭлементСписка.Пометка Тогда
			МассивНачислений.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	F1_ОбщегоНазначенияСервер.СохранитьГлобальнуюНастройку(ИдентификаторНастройки, МассивНачислений);
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура БазаНачисленийПометкаПриИзменении(Элемент)

	Модифицированность = Истина;
	
КонецПроцедуры
