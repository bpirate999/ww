﻿
&После("ОбработкаЗаполнения")
Процедура Расш_ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ЗаполнениеКладовщиком") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
		СуммыКорректировки = ДанныеЗаполнения.СуммыКорректировки;
		
		Работники.Загрузить(ДанныеЗаполнения.РаботникиТЧ.Выгрузить()); 
		
		РаспределитьСуммуПоУчастникам(СуммыКорректировки);
	
	КонецЕсли; 
		
КонецПроцедуры

Процедура РаспределитьСуммуПоУчастникам(СуммыКорректировки) Экспорт
	
	Если Не ИспользоватьКТУ 
		И Не ИспользоватьТарифныеСтавки
		И Не ИспользоватьОтработанноеВремя Тогда
		Возврат;
	КонецЕсли;
	
	//КРаспределению = ВидыРабот.Итог("Сумма"); 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВидыРабот.НомерСтроки КАК НомерСтроки,
		|	ВидыРабот.Сумма КАК Сумма
		|ПОМЕСТИТЬ ВТВидыРабот
		|ИЗ
		|	&ВидыРабот КАК ВидыРабот
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СуммыКорректировки.НомерСтроки КАК НомерСтроки,
		|	СуммыКорректировки.СуммаКорректировки КАК СуммаКорректировки
		|ПОМЕСТИТЬ ВТСуммыКорректировки
		|ИЗ
		|	&СуммыКорректировки КАК СуммыКорректировки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(ВЫБОР
		|			КОГДА ВТСуммыКорректировки.СуммаКорректировки = 0
		|				ТОГДА ВТВидыРабот.Сумма
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК Сумма,
		|	СУММА(ВТСуммыКорректировки.СуммаКорректировки) КАК СуммаКорректировки
		|ИЗ
		|	ВТВидыРабот КАК ВТВидыРабот
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСуммыКорректировки КАК ВТСуммыКорректировки
		|		ПО ВТВидыРабот.НомерСтроки = ВТСуммыКорректировки.НомерСтроки";
	
	Запрос.УстановитьПараметр("ВидыРабот", ВидыРабот.Выгрузить());
	Запрос.УстановитьПараметр("СуммыКорректировки", СуммыКорректировки);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаКРаспределению = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаКРаспределению.Следующий() Цикл
		КРаспределению = ВыборкаКРаспределению.Сумма - ВыборкаКРаспределению.СуммаКорректировки;
	КонецЦикла;
		
	Коэффициенты = Новый Массив;
	
	Для Каждого Строка Из Работники Цикл
		
		Коэффициент = 1;
		
		Если ИспользоватьКТУ Тогда
			Коэффициент = Коэффициент * Строка.КТУ;
		КонецЕсли;
		
		Если ИспользоватьТарифныеСтавки Тогда
			Коэффициент = Коэффициент * Строка.ТарифнаяСтавка;
		КонецЕсли;
		
		Если ИспользоватьОтработанноеВремя Тогда
			Коэффициент = Коэффициент * Строка.ОтработаноЧасов;
		КонецЕсли;
		
		Коэффициенты.Добавить(Коэффициент);
		
	КонецЦикла;
	
	Результат = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(КРаспределению, Коэффициенты);
	
	Индекс = 0;
	Для Каждого Строка Из Работники Цикл
		
		Если Результат <> Неопределено Тогда
			Строка.Сумма = Результат[Индекс];
		Иначе
			Строка.Сумма = 0;
		КонецЕсли;
		
		Индекс = Индекс + 1;
	КонецЦикла;
	
КонецПроцедуры