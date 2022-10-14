/*
    ОПИСАНИЕ

        Строка source[] будет разделена на несколько подстрок
        с помощью символа delimiter. Нужная подстрока под номером (индексом)
        substrIndex будет помещена в строку dest[]


    ПАРАМЕТРЫ

        dest[]        сюда будет помещена нужная подстрока

        maxSize       макс. размер подстроки, которая будет помещена в dest[]
                      если длина подстроки больше maxSize, то она урежется

        source[]      исходная строка для разбиения и поиска в ней подстрок

        delimiter     символ, который будет делить исходную строку на подстроки

        substrIndex   порядковый номер (индекс) подстроки в исходной строке

        withRest      это логический флаг, если равен 1, то в dest[]
                      будут помещены все подстроки, начиная с указанного
                      индекса substrIndex. В том числе и все символы delimiter,
                      которые стоят между подстроками также будут включены в dest[]


    ВОЗВРАЩАЕТ

        ничего


    ПРИМЕРЫ

        new dest[128] = "something";

        sparam( dest, 20, "/register 123456", ' ', 0 ); // dest = "/register"
        sparam( dest, 20, "/register 123456", ' ', 1 ); // dest = "123456"
        sparam( dest,  5, "/register 123456", ' ', 0 ); // dest = "/reg"
        sparam( dest,  4, "/register 123456", ' ', 1 ); // dest = "123"

        sparam( dest, 20, "/pm 29 Как дела, бро?", ' ', 0 );    // dest = "/pm"
        sparam( dest,  4, "/pm 29 Как дела, бро?", ' ', 1 );    // dest = "29"
        sparam( dest, 10, "/pm 29 Как дела, бро?", ' ', 2 );    // dest = "Как"
        sparam( dest, 50, "/pm 29 Как дела, бро?", ' ', 2, 1 ); // dest = "Как дела, бро?"
        sparam( dest, 10, "/pm 29 Как дела, бро?", ' ', 3 );    // dest = "дела,"
        sparam( dest, 50, "/pm 29 Как дела, бро?", ' ', 3, 1 ); // dest = "дела, бро?"
        sparam( dest, 10, "/pm 29 Как дела, бро?", ' ', 4 );    // dest = "бро?"

        sparam( dest, 20, "91.235.141.89", '.', 0 );    // dest = "91"
        sparam( dest, 20, "91.235.141.89", '.', 1 );    // dest = "235"
        sparam( dest, 20, "91.235.141.89", '.', 2 );    // dest = "141"
        sparam( dest, 20, "91.235.141.89", '.', 3 );    // dest = "89"
        sparam( dest, 20, "91.235.141.89", '.', 1, 1 ); // dest = "235.141.89"
        sparam( dest, 20, "91.235.141.89", '.', 2, 1 ); // dest = "141.89"

        sparam( dest, 20, "/register 123456", ' ', -1 ); // dest = "", т.к. подстроки с таким индексом нет
        sparam( dest, 20, "/register 123456", ' ',  7 ); // dest = "", т.к. подстроки с таким индексом нет
*/

stock sparam
(
	dest[],				maxSize		= sizeof(dest),
	const source[],		delimiter	= ' ',
	substrIndex = 0,	withRest	= 0
)
{
	dest[0] = 0; // очистим строку назначения

	for ( new cur, pre, i = -1; ; cur++ ) // пробежимся по каждому символу в строке source
	{
		if ( source[cur] == 0 ) // если текущий символ в source - это символ конца строки
		{
			if ( ++i == substrIndex ) // если индекс текущей подстроки и есть sourceIndex
				// скопируем в dest нужную подстроку из source
				strmid( dest, source, pre, ( withRest ? strlen(source) : cur ), maxSize );

			return; // завершим работу функции
		}

		if ( source[cur] == delimiter ) // если текущий символ в source - это символ для разделения строки
		{
			if ( ++i == substrIndex ) // если индекс текущей подстроки и есть sourceIndex
			{
				// скопируем в dest нужную подстроку из source
				strmid( dest, source, pre, ( withRest ? strlen(source) : cur ), maxSize );
				return; // завершим работу функции
			}

			pre = cur + 1;
		}
	}
}





/*
    ОПИСАНИЕ

        Строка source[] будет разделена на несколько подстрок
        с помощью символа delimiter. И нужная подстрока под номером (индексом)
        substrIndex будет возвращена функцией как число


    ПАРАМЕТРЫ

        source[]      исходная строка для разбиения и поиска в ней подстрок

        delimiter     символ, который будет делить исходную строку на подстроки

        substrIndex   порядковый номер (индекс) подстроки в исходной строке


    ВОЗВРАЩАЕТ

        целочисленное значение подстроки


    ПРИМЕРЫ

        new number = 555;

        number = iparam( "/givecash 23 50000", ' ', -1 ); // number = 0, т.к. подстроки с таким индексом нет
        number = iparam( "/givecash 23 50000", ' ',  0 ); // number = 0
        number = iparam( "/givecash 23 50000", ' ',  1 ); // number = 23
        number = iparam( "/givecash 23 50000", ' ',  2 ); // number = 50000
        number = iparam( "/givecash 23 50000", ' ',  3 ); // number = 0, т.к. подстроки с таким индексом нет


stock iparam ( const source[], delimiter = ' ', substrIndex = 0)
{
	for ( new dest[12], cur, pre, i = -1; ; cur++ ) // пробежимся по каждому символу в строке source
	{
		if ( source[cur] == 0 ) // если текущий символ в source - это символ конца строки
		{
			if ( ++i == substrIndex ) // если индекс текущей подстроки и есть sourceIndex
				strmid( dest, source, pre, cur, 12 ); // скопируем в dest нужную подстроку из source

			return strval(dest); // завершим работу функции и вернем целочисленное значение подстроки
		}

		if ( source[cur] == delimiter ) // если текущий символ в source - это символ для разделения строки
		{
			if ( ++i == substrIndex ) // если индекс текущей подстроки и есть sourceIndex
			{
				strmid( dest, source, pre, cur, 12 );// скопируем в dest нужную подстроку из source
				return strval(dest); // завершим работу функции и вернем целочисленное значение подстроки
			}

			pre = cur + 1;
		}
	}
  
}*/

stock iparam(const source[], delimiter = ' ', substrIndex = 0)
{
    new dest[12], cur, pre, i = -1;

    for( ; ; cur++) // пробежимся по каждому символу в строке source
    {
        if(source[cur] == 0) // если текущий символ в source - это символ конца строки
        {
            if(++i == substrIndex) // если индекс текущей подстроки и есть sourceIndex
                strmid(dest, source, pre, cur, 12); // скопируем в dest нужную подстроку из source

            goto iparam_end;
        }

        if(source[cur] == delimiter) // если текущий символ в source - это символ для разделения строки
        {
            if(++i == substrIndex) // если индекс текущей подстроки и есть sourceIndex
            {
                strmid(dest, source, pre, cur, 12);// скопируем в dest нужную подстроку из source
                goto iparam_end;
            }

            pre = cur + 1;
        }
    }

    iparam_end:
    return strval(dest); // завершим работу функции и вернем целочисленное значение подстроки
} 



/*
    ОПИСАНИЕ

        Строка source[] будет разделена на несколько подстрок
        с помощью символа delimiter. И нужная подстрока под номером (индексом)
        substrIndex будет возвращена функцией как дробное число


    ПАРАМЕТРЫ

        source[]      исходная строка для разбиения и поиска в ней подстрок

        delimiter     символ, который будет делить исходную строку на подстроки

        substrIndex   порядковый номер (индекс) подстроки в исходной строке


    ВОЗВРАЩАЕТ

        дробное численное значение подстроки


    ПРИМЕРЫ

        new Float: float = 555.5;

        float = iparam( "/goto -157.2 1248.25 10", ' ', -1 ); // float = 0.0, т.к. подстроки с таким индексом нет
        float = iparam( "/goto -157.2 1248.25 10", ' ',  0 ); // float = 0.0, т.к. подстрока "/goto" это не число
        float = iparam( "/goto -157.2 1248.25 10", ' ',  1 ); // float = -157.2
        float = iparam( "/goto -157.2 1248.25 10", ' ',  2 ); // float = 1248.25
        float = iparam( "/goto -157.2 1248.25 10", ' ',  3 ); // float = 10.0
        float = iparam( "/goto -157.2 1248.25 10", ' ',  4 ); // float = 0.0, т.к. подстроки с таким индексом нет
*/

stock Float: fparam ( const source[], delimiter = ' ', substrIndex = 0 )
{
	for ( new dest[40], cur, pre, i = -1; ; cur++ ) // пробежимся по каждому символу в строке source
	{
		if ( source[cur] == 0 ) // если текущий символ в source - это символ конца строки
		{
			if ( ++i == substrIndex ) // если индекс текущей подстроки и есть sourceIndex
				strmid( dest, source, pre, cur, 40 ); // скопируем в dest нужную подстроку из source

			return floatstr(dest); // завершим работу функции и вернем дробное численное значение подстроки
		}

		if ( source[cur] == delimiter ) // если текущий символ в source - это символ для разделения строки
		{
			if ( ++i == substrIndex ) // если индекс текущей подстроки и есть sourceIndex
			{
				strmid( dest, source, pre, cur, 40 );// скопируем в dest нужную подстроку из source
				return floatstr(dest); // завершим работу функции и вернем дробное численное значение подстроки
			}

			pre = cur + 1;
		}
	}
}
