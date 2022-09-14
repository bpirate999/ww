﻿&НаКлиенте
Перем КэшированныеЗначения;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Обработка.Дата = ТекущаяДатаСеанса();
	Обработка.Организация = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.Организации", "96bb4f3f-9f2f-11e9-90f2-d850e65181da"); 
	Обработка.Подразделение = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.СтруктураПредприятия", "c5905b09-9f32-11e9-90f2-d850e65181da");
	Обработка.ТребуетсяПроверка = Истина; 
	
	//ПараметрыСеанса.ПроводитьБезКонтроляОстатковТоваровОрганизаций = Истина;
	
	Кладовая1 = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.Склады", "1eb17a6c-bb4d-11ea-85c1-d850e65181da");
	Кладовая2 = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.Склады", "057ba585-d6cb-11ea-a200-ac1f6be2fed5");
	
	Элементы.ЦеховаяКладовая.СписокВыбора.Добавить(Кладовая1, Кладовая1);
	Элементы.ЦеховаяКладовая.СписокВыбора.Добавить(Кладовая2, Кладовая2);
	
	ПорезанныеБлоки = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.Номенклатура", "5434f3de-6171-11ec-a227-ac1f6be2fed5");
	УтеплительОтГазоблоковШапка = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.Номенклатура", "59d3417c-dee3-11eb-a206-ac1f6be2fed5");
	УтеплительОтГазоблоков = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.Номенклатура", "054c622a-b844-11e9-8d60-d850e65181da");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
	СписокДокументов,
	"Ссылка",
	СформированныеДокументы,
	ВидСравненияКомпоновкиДанных.ВСписке,
	,
	Истина);  
	
	Элементы.ВыкладкаНоменклатура.ТолькоПросмотр = Истина;
	
	//Добавим по одной строке в табличной части	
	НовСтр = Обработка.Нарезка.Добавить();
	НовСтр.Номенклатура = ПорезанныеБлоки;
	НовСтр = Обработка.Утеплитель.Добавить();
	НовСтр.Номенклатура = УтеплительОтГазоблоковШапка;
	НовСтр = Обработка.Утеплитель.Добавить();
	НовСтр.Номенклатура = УтеплительОтГазоблоков;
	
	//Бригады		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Бригады.Ссылка КАК Ссылка,
	|	Бригады.Представление КАК Представление
	|ИЗ
	|	Справочник.Бригады КАК Бригады
	|ГДЕ
	|	НЕ Бригады.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Элементы.Бригада.СписокВыбора.Добавить(ВыборкаДетальныеЗаписи.Ссылка, ВыборкаДетальныеЗаписи.Представление);
	КонецЦикла;
	
	//Характеристики  
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ХарактеристикиНоменклатуры.Ссылка КАК Ссылка,
	|	ХарактеристикиНоменклатуры.Представление КАК Представление
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|ГДЕ
	|	ХарактеристикиНоменклатуры.Владелец = &Владелец";
	
	Полуфабрикаты = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.ВидыНоменклатуры", "e9cc9447-6162-11ec-a227-ac1f6be2fed5");
	Запрос.УстановитьПараметр("Владелец", Полуфабрикаты);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Элементы.ЗаливкаХарактеристика.СписокВыбора.Добавить(ВыборкаДетальныеЗаписи.Ссылка, ВыборкаДетальныеЗаписи.Представление);
		Элементы.НарезкаХарактеристика.СписокВыбора.Добавить(ВыборкаДетальныеЗаписи.Ссылка, ВыборкаДетальныеЗаписи.Представление);
		Элементы.ВыкладкаХарактеристика.СписокВыбора.Добавить(ВыборкаДетальныеЗаписи.Ссылка, ВыборкаДетальныеЗаписи.Представление);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьСмену(Команда) 
	
	Если ПроверитьЗаполнение() Тогда
		
		Этапы = Новый Массив;
		Этапы.Добавить("ЗаливкаТЧ");		
		
		СформироватьДокументы(Этапы); 
				
		Этапы = Новый Массив;
		Этапы.Добавить("НарезкаТЧ");
		Этапы.Добавить("ВыкладкаТЧ");
		Этапы.Добавить("УтеплительТЧ");
		
		СформироватьДокументы(Этапы);
		
	КонецЕсли;
	
КонецПроцедуры    

&НаСервере
Функция СформироватьДокументы(Этапы)
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("ЗаполнениеКладовщиком");
	ДанныеЗаполнения.Вставить("Дата", Обработка.Дата);
	ДанныеЗаполнения.Вставить("ГруппировкаЗатрат", ПредопределенноеЗначение("Перечисление.ГруппировкиЗатратВПроизводствеБезЗаказа.ПоСпецификациям"));		
	ДанныеЗаполнения.Вставить("Организация", Обработка.Организация);
	ДанныеЗаполнения.Вставить("Подразделение", ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.СтруктураПредприятия", "c5905b09-9f32-11e9-90f2-d850e65181da"));		
	Если ЗначениеЗаполнено(Заливка) Тогда	
		ДанныеЗаполнения.Вставить("Заливка",    Заливка);		
	КонецЕсли;	
	ДанныеЗаполнения.Вставить("ПорезанныеБлоки", ПорезанныеБлоки);
	ДанныеЗаполнения.Вставить("Печь1",           Печь1);
	ДанныеЗаполнения.Вставить("Печь2",           Печь2);
	ДанныеЗаполнения.Вставить("Газоблоки",       Газоблоки);
	
	ДанныеЗаполнения.Вставить("Бригада",         Обработка.Бригада);
	ДанныеЗаполнения.Вставить("ЦеховаяКладовая", Обработка.ЦеховаяКладовая);
	
	ДанныеЗаполнения.Вставить("ЗаливкаТЧ",    Обработка.Заливка);
	ДанныеЗаполнения.Вставить("НарезкаТЧ",    Обработка.Нарезка);
	ДанныеЗаполнения.Вставить("ВыкладкаТЧ",   Обработка.Выкладка);
	ДанныеЗаполнения.Вставить("УтеплительТЧ", Обработка.Утеплитель);
	ДанныеЗаполнения.Вставить("Этапы",        Этапы);
	
	ДокПроизводствоБезЗаказа = Документы.ПроизводствоБезЗаказа.СоздатьДокумент();
	ДокПроизводствоБезЗаказа.Заполнить(ДанныеЗаполнения);
	
	Если ДокПроизводствоБезЗаказа.ВыходныеИзделия.Количество() Тогда
		
		Попытка   
			
			ДокПроизводствоБезЗаказа.Записать(РежимЗаписиДокумента.Проведение);
			
		Исключение 
			
			ДокПроизводствоБезЗаказа.Записать(РежимЗаписиДокумента.Запись);
			
			// Запись события в журнал регистрации для системного администратора.
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Выполнение операции'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ВызватьИсключение;
			
		КонецПопытки;      
		
	КонецЕсли;
	
	СформированныеДокументы.Добавить(ДокПроизводствоБезЗаказа.Ссылка);
	
	Если ДокПроизводствоБезЗаказа.Проведен Тогда
		
		СтруктураОтбора = Новый Структура;
		
		СтруктураОтбора.Вставить("Распоряжения", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДокПроизводствоБезЗаказа.Ссылка));
		
		ДанныеЗаполнения = ОперативныйУчетПроизводстваВызовСервера.ПараметрыОформленияВыработкиСотрудников(СтруктураОтбора);
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И Не ДанныеЗаполнения.Свойство("Комментарий") Тогда	
			
			ДанныеЗаполнения.Вставить("ЗаполнениеКладовщиком");
			ДанныеЗаполнения.Вставить("Дата", Обработка.Дата);
			ДанныеЗаполнения.Вставить("Организация", Обработка.Организация);
			ДанныеЗаполнения.Вставить("РаботникиТЧ", Обработка.Работники);	
			ДанныеЗаполнения.Вставить("Комментарий", Обработка.Комментарий);		
			
		КонецЕсли;
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И Не ДанныеЗаполнения.Свойство("ЗаполнитьПоОтбору") Тогда	
			
			ДанныеЗаполнения.Вставить("ЗаполнитьПоОтбору");
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВыходныеИзделия.НомерСтроки КАК НомерСтроки,
			|	ВЫБОР
			|		КОГДА ВыходныеИзделия.Характеристика = &ХарактеристикаВысшийСорт
			|			ТОГДА 0
			|		ИНАЧЕ ВыходныеИзделия.КоличествоУпаковок * ВыходныеИзделия.Количество * 1500
			|	КОНЕЦ КАК СуммаКорректировки
			|ИЗ
			|	Документ.ПроизводствоБезЗаказа.ВыходныеИзделия КАК ВыходныеИзделия
			|ГДЕ
			|	ВыходныеИзделия.Ссылка = &Ссылка"; 
			
			Запрос.УстановитьПараметр("Ссылка", ДокПроизводствоБезЗаказа.Ссылка);
			
			ХарактеристикаВысшийСорт = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.ХарактеристикиНоменклатуры", 
				"09462966-962d-11ec-a234-ac1f6be2fed5");
			
			Запрос.УстановитьПараметр("ХарактеристикаВысшийСорт", ХарактеристикаВысшийСорт);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			СуммыКорректировки = РезультатЗапроса.Выгрузить();
			
			ДокВыработкаСотрудников = Документы.ВыработкаСотрудников.СоздатьДокумент();
			ДанныеЗаполнения.Вставить("СуммыКорректировки", СуммыКорректировки);
			ДокВыработкаСотрудников.Заполнить(ДанныеЗаполнения);
			
			Попытка
				
				ДокВыработкаСотрудников.Записать(РежимЗаписиДокумента.Проведение); 
								
			Исключение 
				
				ДокВыработкаСотрудников.Записать(РежимЗаписиДокумента.Запись);
				
				// Запись события в журнал регистрации для системного администратора.
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Выполнение операции'"),
				УровеньЖурналаРегистрации.Ошибка,,,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				ВызватьИсключение;
				
			КонецПопытки;
			
			СформированныеДокументы.Добавить(ДокВыработкаСотрудников.Ссылка);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
	СписокДокументов,
	"Ссылка",
	СформированныеДокументы,
	ВидСравненияКомпоновкиДанных.ВСписке,
	,
	Истина);		 
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ) 
	
	Печь1 = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.Склады", "556062b7-6185-11ec-a227-ac1f6be2fed5"); //ПЕЧЬ1
	Печь2 = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.Склады", "632c0f80-6185-11ec-a227-ac1f6be2fed5"); //ПЕЧЬ2
	ПорезанныеБлоки = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.Номенклатура", "5434f3de-6171-11ec-a227-ac1f6be2fed5");
	
КонецПроцедуры   

&НаСервере
Функция ПолучитьДоступнуюНоменклатуруГазоблоки(ВидНоменклатурыГазоблоки)
	
	сзГазоблоки = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка,
	|	Номенклатура.Представление КАК Представление
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.ВидНоменклатуры = &ВидНоменклатуры
	|	И Номенклатура.Ссылка <> &НепорезанныеБлоки";
	
	Запрос.УстановитьПараметр("ВидНоменклатуры",   ВидНоменклатурыГазоблоки);
	
	НепорезанныеБлоки = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.Номенклатура", "bc50fb9a-9851-11eb-a21e-ac1f6be2fed4");
	
	Запрос.УстановитьПараметр("НепорезанныеБлоки", НепорезанныеБлоки);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		сзГазоблоки.Добавить(Выборка.Ссылка, Выборка.Представление);	
		
	КонецЦикла;
	
	Возврат сзГазоблоки;
	
КонецФункции

&НаКлиенте
Процедура ЗаливкаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Не Копирование Тогда  
		
		ТекущаяСтрока = Элемент.ТекущиеДанные;
		ТекущаяСтрока.Номенклатура = Заливка;
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
		СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
		СтруктураДействий.Вставить("ПроверитьЗаполнитьОбеспечение", Новый Структура("ЗаполнитьОбособленно", Ложь));
		
		ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);		
		
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура НарезкаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Не Копирование Тогда  
		
		ТекущаяСтрока = Элемент.ТекущиеДанные;
		ТекущаяСтрока.Номенклатура = ПорезанныеБлоки;
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
		СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
		СтруктураДействий.Вставить("ПроверитьЗаполнитьОбеспечение", Новый Структура("ЗаполнитьОбособленно", Ложь));
		
		ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);	
		
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура БригадаПриИзменении(Элемент)
	
	БригадаПриИзмененииНаСервере(); 
	
КонецПроцедуры   

&НаСервере
Процедура БригадаПриИзмененииНаСервере()
	
	Обработка.Работники.Очистить();
	
	СоставБригады = СоставыБригад(Обработка.Дата, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Обработка.Бригада));
	СписокСотрудников = КадровыйУчетРасширенный.СотрудникиФизическихЛиц(СоставБригады, Обработка.Организация, Истина); 
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;	
	КадровыйУчет.СоздатьНаДатуВТКадровыеДанныеСотрудников(Запрос.МенеджерВременныхТаблиц, Истина, СписокСотрудников, "Должность, ДатаУвольнения", Обработка.Дата);	
	Запрос.Текст = "ВЫБРАТЬ
	|	КадровыеДанныеСотрудников.Сотрудник КАК Сотрудник,
	|	КадровыеДанныеСотрудников.ФизическоеЛицо КАК Работник,
	|	КадровыеДанныеСотрудников.Должность КАК Должность,
	|	КадровыеДанныеСотрудников.ДатаУвольнения КАК ДатаУвольнения,
	|	1 КАК КТУ
	|ИЗ
	|	ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
	|ГДЕ
	|	КадровыеДанныеСотрудников.ДатаУвольнения = ДАТАВРЕМЯ(1, 1, 1)";
	
	Обработка.Работники.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Функция СоставыБригад(Период, Бригады)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ВыработкаСотрудников.Дата) КАК Дата,
	|	ВыработкаСотрудников.Бригада КАК Бригада
	|ПОМЕСТИТЬ втДатыАктуальности
	|ИЗ
	|	Документ.ВыработкаСотрудников КАК ВыработкаСотрудников
	|ГДЕ
	|	ВыработкаСотрудников.Дата <= &Период
	|	И ВыработкаСотрудников.Бригада В(&Бригады)
	|	И ВыработкаСотрудников.Проведен
	|
	|СГРУППИРОВАТЬ ПО
	|	ВыработкаСотрудников.Бригада
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ВыработкаСотрудников.Ссылка) КАК Ссылка,
	|	втДатыАктуальности.Бригада КАК Бригада
	|ПОМЕСТИТЬ ДокументыСостава
	|ИЗ
	|	втДатыАктуальности КАК втДатыАктуальности
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВыработкаСотрудников КАК ВыработкаСотрудников
	|		ПО втДатыАктуальности.Дата = ВыработкаСотрудников.Дата
	|			И втДатыАктуальности.Бригада = ВыработкаСотрудников.Бригада
	|ГДЕ
	|	ВыработкаСотрудников.Проведен
	|
	|СГРУППИРОВАТЬ ПО
	|	втДатыАктуальности.Бригада
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Работники.Работник КАК Работник
	|ИЗ
	|	ДокументыСостава КАК ДокументыСостава
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВыработкаСотрудников.Работники КАК Работники
	|		ПО ДокументыСостава.Ссылка = Работники.Ссылка";
	
	Запрос.УстановитьПараметр("Бригады", Бригады);
	Запрос.УстановитьПараметр("Период", Период);
	
	Результат = Запрос.Выполнить();
	
	Возврат ОбщегоНазначения.ВыгрузитьКолонку(Результат.Выгрузить(), "Работник", Истина);
	
КонецФункции

&НаКлиенте
Процедура БригадаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ЗаливкаХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура НарезкаХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВыкладкаХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Функция ПараметрыЗаполнения(Объект)
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Организация");
	ПараметрыЗаполнения.Вставить("Подразделение");
	ПараметрыЗаполнения.Вставить("ВидНаряда");
	ПараметрыЗаполнения.Вставить("НачалоПериода");
	ПараметрыЗаполнения.Вставить("КонецПериода");
	ПараметрыЗаполнения.Вставить("Количество");
	Если Объект.ВидНаряда = ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.Бригадный")
		Или Объект.ВидНаряда = ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.Ремонт")
		Или Объект.ВидНаряда = ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.БригадныйБезЗаказа21")
		Или Объект.ВидНаряда = ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.БригадныйПоЗаказу21") Тогда
		ПараметрыЗаполнения.Вставить("Бригада");
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ПараметрыЗаполнения, Объект);
	
	ПараметрыЗаполнения.НачалоПериода = НачалоДня(ПараметрыЗаполнения.НачалоПериода);
	ПараметрыЗаполнения.КонецПериода = ?(ЗначениеЗаполнено(ПараметрыЗаполнения.КонецПериода), КонецДня(ПараметрыЗаполнения.КонецПериода), ПараметрыЗаполнения.КонецПериода);
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

&НаКлиенте
Процедура Печать(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		
		ТабДок = СформироватьТабДокНаСервере();
		
		КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("Выполненные работы");
		
		КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДок;
		
		КоллекцияПечатныхФорм[0].Экземпляров = 1;
		КоллекцияПечатныхФорм[0].СинонимМакета = "Выполненные работы"; 
		
		УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, Неопределено, ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры       

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Отказ = Истина;
КонецПроцедуры

&НаСервере
Функция СформироватьТабДокНаСервере()
	
	ТабДок = Новый ТабличныйДокумент;
	
	МассивТЧ = Новый Массив;
	МассивТЧ.Добавить("Заливка");
	МассивТЧ.Добавить("Нарезка");
	МассивТЧ.Добавить("Выкладка");
	МассивТЧ.Добавить("Утеплитель");
	
	Макет = Обработки.РабочееМесто.ПолучитьМакет("Макет");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьЗаголовок.Параметры.Дата = Формат(ТекущаяДата(),"ДФ=dd.MM.yyyy");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");	
	
	Для каждого Этап Из МассивТЧ Цикл 
		
		ОбластьЗаголовок.Параметры.Операция = Этап;
		ТабДок.Вывести(ОбластьЗаголовок);
		ТабДок.Вывести(ОбластьШапкаТаблицы);
		
		Для каждого ТекСтр Из Обработка[Этап] Цикл
			
			ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");
			ОбластьДетальныхЗаписей.Параметры.Заполнить(ТекСтр);
			Если ЗначениеЗаполнено(ТекСтр.Упаковка) Тогда		
				ОбластьДетальныхЗаписей.Параметры.Упаковка = ТекСтр.Упаковка;		
			Иначе	
				ОбластьДетальныхЗаписей.Параметры.Упаковка = ТекСтр.Номенклатура.ЕдиницаИзмерения;		
			КонецЕсли;
			
			ТабДок.Вывести(ОбластьДетальныхЗаписей);
			
		КонецЦикла;
		
		ОбластьПодвал.Параметры.Бригада = Обработка.Бригада;
		ТабДок.Вывести(ОбластьПодвал);
		
		ОбластьДетальныхЗаписей1 = Макет.ПолучитьОбласть("Детали1");
		
		Для каждого Работник Из Обработка.Работники Цикл
			
			ОбластьДетальныхЗаписей1.Параметры.Заполнить(Работник);
			ТабДок.Вывести(ОбластьДетальныхЗаписей1);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

&НаКлиенте
Процедура ЦеховаяКладоваяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
	СписокДокументов,
	"Ссылка",
	СформированныеДокументы,
	ВидСравненияКомпоновкиДанных.ВСписке,
	,
	Истина);
	
КонецПроцедуры 

&НаКлиенте
Процедура ДобавитьУтеплитель(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура УтеплительПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаСервере
Процедура РаботникиСотрудникПриИзмененииНаСервере(ИдентификаторСтроки) 
	
	ТекСтрока = Обработка.Работники.НайтиПоИдентификатору(ИдентификаторСтроки);	
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;	
	
	КадровыйУчет.СоздатьНаДатуВТКадровыеДанныеСотрудников(Запрос.МенеджерВременныхТаблиц, Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТекСтрока.Сотрудник), "Должность, ДатаУвольнения, ФизическоеЛицо", Обработка.Дата);	
	
	Запрос.Текст = "ВЫБРАТЬ
	|	КадровыеДанныеСотрудников.Сотрудник КАК Сотрудник,
	|	КадровыеДанныеСотрудников.ФизическоеЛицо КАК Работник,
	|	КадровыеДанныеСотрудников.ДатаУвольнения КАК ДатаУвольнения,
	|	КадровыеДанныеСотрудников.Должность КАК Должность,
	|	1 КАК КТУ
	|ИЗ
	|	ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
	|ГДЕ
	|	КадровыеДанныеСотрудников.ДатаУвольнения = ДАТАВРЕМЯ(1, 1, 1)";
	
	РезультатЗапроса = Запрос.Выполнить();  
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(ТекСтрока, Выборка);	
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РаботникиСотрудникПриИзменении(Элемент)
	
	ИдентификаторСтроки = Элементы.Работники.ТекущаяСтрока;	
	РаботникиСотрудникПриИзмененииНаСервере(ИдентификаторСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦеховаяКладоваяПриИзменении(Элемент)
	
	Обработка.Заливка.Очистить();
	
	Если Обработка.ЦеховаяКладовая = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.Склады", "1eb17a6c-bb4d-11ea-85c1-d850e65181da") Тогда  //  Кладовая 1 (старая линия)
		
		Заливка = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.Номенклатура", "674382b3-6163-11ec-a227-ac1f6be2fed5"); //Заливка Цех 1 (смесь)			
		Элементы.ДекорацияЗаливка.Заголовок = Заливка;
		
	ИначеЕсли Обработка.ЦеховаяКладовая = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.Склады", "057ba585-d6cb-11ea-a200-ac1f6be2fed5") Тогда // Кладовая 2 (новая линия)
		
		Заливка = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.Номенклатура", "fecc6d9a-87c8-11ec-a232-ac1f6be2fed5"); //Заливка Цех 2(смесь)			
		Элементы.ДекорацияЗаливка.Заголовок = Заливка;
		
	КонецЕсли; 
	
	НовСтр = Обработка.Заливка.Добавить();
	НовСтр.Номенклатура = Заливка;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаливкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не ЗначениеЗаполнено(Обработка.ЦеховаяКладовая) Тогда
		
		Отказ = Истина;
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не указана цеховая кладовая!";
		Сообщение.Поле = "Обработка.ЦеховаяКладовая"; 
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();	
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПоказатьЗначение(, Элементы.СписокДокументов.ТекущиеДанные.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ВыкладкаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		Газоблоки = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.ВидыНоменклатуры", "23cd89fa-9f38-11e9-90f2-d850e65181da");
		
		СписокГазоблоков = ПолучитьДоступнуюНоменклатуруГазоблоки(Газоблоки); 
		
		Оповещение = Новый ОписаниеОповещения("ВыборИзСпискаЗавершение", ЭтаФорма);
		
		СписокГазоблоков.ПоказатьВыборЭлемента(Оповещение, "Газоблоки");	
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборИзСпискаЗавершение(Элемент, ДопПар) Экспорт
	
	Если Элемент <> Неопределено Тогда	
		Если ЗначениеЗаполнено(Элемент.Значение) Тогда
			ТекущиеДанные = Элементы.Выкладка.ТекущиеДанные;
			ТекущиеДанные.Номенклатура = Элемент.Значение;	
		Иначе 	
			ТекущаяСтрока = Элементы.Выкладка.ТекущаяСтрока;
			Обработка.Выкладка.Удалить(ТекущаяСтрока - 1);	
		КонецЕсли; 	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаливкаУпаковкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка) 
	
	СтандартнаяОбработка = Ложь;
	
	Тележки = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.НаборыУпаковок", "35991d43-7292-11ec-a22f-ac1f6be2fed5");
	
	СписокУпаковок = ПолучитьУпаковки(Тележки); 
	
	Оповещение = Новый ОписаниеОповещения("ВыборИзСпискаУпаковокВыкладкаЗавершение", ЭтаФорма);
	
	СписокУпаковок.ПоказатьВыборЭлемента(Оповещение, "Тележки");	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборИзСпискаУпаковокВыкладкаЗавершение(Элемент, ДопПар) Экспорт
	
	Если Элемент <> Неопределено Тогда	
		Если ЗначениеЗаполнено(Элемент.Значение) Тогда
			ТекущиеДанные = Элементы.Заливка.ТекущиеДанные;
			ТекущиеДанные.Упаковка = Элемент.Значение;	
		Иначе 	
			ТекущаяСтрока = Элементы.Заливка.ТекущаяСтрока;
			Обработка.Заливка.Удалить(ТекущаяСтрока - 1);	
		КонецЕсли; 	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьУпаковки(Тележки)
	
	сзУпаковоки = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УпаковкиЕдиницыИзмерения.Ссылка КАК Ссылка,
	|	УпаковкиЕдиницыИзмерения.Представление КАК Представление
	|ИЗ
	|	Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмерения
	|ГДЕ
	|	УпаковкиЕдиницыИзмерения.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец",   Тележки);
		
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		сзУпаковоки.Добавить(Выборка.Ссылка, Выборка.Представление);	
		
	КонецЦикла;
	
	Возврат сзУпаковоки;
	
КонецФункции

&НаКлиенте
Процедура НарезкаУпаковкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Тележки = ИнтерфейсРаботникаСклада.ПолучитьСсылкуПоГуид("Справочник.НаборыУпаковок", "35991d43-7292-11ec-a22f-ac1f6be2fed5");
	
	СписокУпаковок = ПолучитьУпаковки(Тележки); 
	
	Оповещение = Новый ОписаниеОповещения("ВыборИзСпискаУпаковокНарезкаЗавершение", ЭтаФорма);
	
	СписокУпаковок.ПоказатьВыборЭлемента(Оповещение, "Тележки");	

КонецПроцедуры 

&НаКлиенте
Процедура ВыборИзСпискаУпаковокНарезкаЗавершение(Элемент, ДопПар) Экспорт
	
	Если Элемент <> Неопределено Тогда	
		Если ЗначениеЗаполнено(Элемент.Значение) Тогда
			ТекущиеДанные = Элементы.Нарезка.ТекущиеДанные;
			ТекущиеДанные.Упаковка = Элемент.Значение;	
		Иначе 	
			ТекущаяСтрока = Элементы.Нарезка.ТекущаяСтрока;
			Обработка.Нарезка.Удалить(ТекущаяСтрока - 1);	
		КонецЕсли; 	
	КонецЕсли;
	
КонецПроцедуры
