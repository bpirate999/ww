
&После("ПриОпределенииКомандПодключенныхКОбъекту")
Процедура Расш_ПриОпределенииКомандПодключенныхКОбъекту(НастройкиФормы, Источники, ПодключенныеОтчетыИОбработки, Команды)
	
	Если НастройкиФормы.МетаданныеФормы = Метаданные.Обработки.РабочееМесто.Формы.РабочееМестоСтаршегоСмены Тогда
		
		МассивКомандОтчетов = Команды.НайтиСтроки(Новый Структура("Вид", "Отчеты"));
		
		Для каждого ТекКоманда Из МассивКомандОтчетов Цикл
			
			Команды.Удалить(ТекКоманда);
			
		КонецЦикла;
		
		МассивКомандСозданиеНаОсновании = Команды.НайтиСтроки(Новый Структура("Вид", "СозданиеНаОсновании"));
		
		Для каждого ТекКоманда Из МассивКомандСозданиеНаОсновании Цикл
			
			Команды.Удалить(ТекКоманда);
			
		КонецЦикла; 
				
	КонецЕсли;

КонецПроцедуры
