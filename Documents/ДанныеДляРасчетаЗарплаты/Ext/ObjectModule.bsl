﻿
&Вместо("ОбработкаЗаполнения")
Процедура Расш_ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ЗаполнениеКладовщиком") Тогда

		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
		ВыработкаСотрудников = ДанныеЗаполнения.ВыработкаСотрудников;
		РаботникиТЧ          = ДанныеЗаполнения.РаботникиТЧ;
		
		ПолучитьДанныеДляРасчетаЗарплаты(ВыработкаСотрудников, РаботникиТЧ);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ЗаполнениеОбработкойРасчетМотивации") Тогда

		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);	
		ЗначенияПоказателей.Загрузить(ДанныеЗаполнения.ЗначенияПоказателей);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьДанныеДляРасчетаЗарплаты(ВыработкаСотрудников, РаботникиТЧ)     
			
	Запрос = Новый Запрос;
	Запрос.Текст =  
	
	"ВЫБРАТЬ
	|	ВидыРабот.ВидРабот КАК ВидРабот,
	|	ВидыРабот.Количество КАК Количество
	|ПОМЕСТИТЬ ВТ_ВидыРабот
	|ИЗ
	|	Документ.ВыработкаСотрудников.ВидыРабот КАК ВидыРабот
	|ГДЕ
	|	ВидыРабот.Ссылка = &Ссылка
	|	И ВЫБОР
	|			КОГДА НЕ ВидыРабот.ВидРабот.Наименование ПОДОБНО &ВысшийСорт
	|				ТОГДА ИСТИНА
	|		КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасценкиРаботСотрудниковСрезПоследних.ВидРабот КАК ВидРабот,
	|	РасценкиРаботСотрудниковСрезПоследних.Расценка КАК Расценка,
	|	ВТ_ВидыРабот.Количество КАК ОбъемВыполненныхРабот,
	|	-ВТ_ВидыРабот.Количество * РасценкиРаботСотрудниковСрезПоследних.Расценка КАК Сумма
	|ИЗ
	|	ВТ_ВидыРабот КАК ВТ_ВидыРабот,
	|	РегистрСведений.РасценкиРаботСотрудников.СрезПоследних(
	|			,
	|			ВидРабот В
	|				(ВЫБРАТЬ
	|					ВТ_ВидыРабот.ВидРабот
	|				ИЗ
	|					ВТ_ВидыРабот)) КАК РасценкиРаботСотрудниковСрезПоследних";
	
	Запрос.УстановитьПараметр("Ссылка", ВыработкаСотрудников);
	Запрос.УстановитьПараметр("ВысшийСорт", "%в/с%");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыполненныеРаботы.Загрузить(РезультатЗапроса.Выгрузить());  
	
	ТаблицаРаботники = РаботникиТЧ.Выгрузить();
	ТаблицаРаботники.Колонки.Сотрудник.Имя = "Объект";
	ТаблицаРаботники.Колонки.КТУ.Имя = "Коэффициент";
	
	ЗначенияПоказателей.Загрузить(ТаблицаРаботники);	
	РаспределитьСтоимостьРаботПоСотрудникам(); 
	
КонецПроцедуры      

&НаСервере
Процедура РаспределитьСтоимостьРаботПоСотрудникам(ОтменятьИсправления = Ложь)
	
	УчитыватьКоэффициенты        = Ложь;
	УчитыватьТарифныеСтавки      = Ложь;
	УчитыватьОтработанноеВремя   = Ложь;
	РаспределятьСуммуСверхТарифа = Ложь;
	
	РаспределяемаяСумма = -ВыполненныеРаботы.Итог("Сумма");
	КоэффициентыРаспределения = Новый Массив;
	СтрокиРаспределения = Новый Массив;
	Для Каждого СтрокаТаблицы Из ЗначенияПоказателей Цикл
		Если ОтменятьИсправления Тогда
			СтрокаТаблицы.ФиксЗначение = Ложь;
		ИначеЕсли СтрокаТаблицы.ФиксЗначение Тогда
			СуммаПоТарифу = 0;
			РаспределяемаяСумма = РаспределяемаяСумма - СтрокаТаблицы.Значение;
			Продолжить;
		КонецЕсли;
		СтрокиРаспределения.Добавить(СтрокаТаблицы);
		ОтработанноеВремя = ?(СтрокаТаблицы.ВремяВЧасах, СтрокаТаблицы.ОтработаноЧасов, СтрокаТаблицы.ОтработаноДней);
		КоэффициентРаспределения = 1;
		Если УчитыватьКоэффициенты Тогда
			КоэффициентРаспределения = КоэффициентРаспределения * СтрокаТаблицы.Коэффициент;
		КонецЕсли;
		Если УчитыватьТарифныеСтавки Тогда
			КоэффициентРаспределения = КоэффициентРаспределения * СтрокаТаблицы.ТарифнаяСтавка;
		КонецЕсли;
		Если УчитыватьОтработанноеВремя Тогда
			КоэффициентРаспределения = КоэффициентРаспределения * ОтработанноеВремя;
		КонецЕсли;
		КоэффициентыРаспределения.Добавить(КоэффициентРаспределения);
		Если РаспределятьСуммуСверхТарифа Тогда
			СуммаПоТарифу = СтрокаТаблицы.ТарифнаяСтавка * ОтработанноеВремя;
		КонецЕсли;
	КонецЦикла;
	
	СуммаПоТарифам = ВыполненныеРаботы.Итог("Сумма");
	РаспределяетсяСуммаСверхТарифа = РаспределятьСуммуСверхТарифа И СуммаПоТарифам > 0 И РаспределяемаяСумма > СуммаПоТарифам;
	Если РаспределяетсяСуммаСверхТарифа Тогда
		РаспределяемаяСумма = РаспределяемаяСумма - СуммаПоТарифам;
	КонецЕсли;
	
	РаспределенныеСуммы = ЗарплатаКадрыКлиентСервер.РаспределитьПропорциональноКоэффициентам(Макс(РаспределяемаяСумма, 0), КоэффициентыРаспределения);
	
	Если РаспределенныеСуммы = Неопределено Тогда
		Если РаспределяемаяСумма <= 0 Тогда
			Для Каждого СтрокаРаспределения Из СтрокиРаспределения Цикл
				СтрокаРаспределения.Значение = 0;
			КонецЦикла;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Индекс = 0;
	Для Каждого СтрокаТаблицы Из СтрокиРаспределения Цикл
		СтрокаТаблицы.Значение = -РаспределенныеСуммы[Индекс];
		Индекс = Индекс + 1;
	КонецЦикла;
КонецПроцедуры