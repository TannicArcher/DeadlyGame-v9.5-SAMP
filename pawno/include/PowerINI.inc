/*
    ##################
        Power INI
    ##################
 
    Это библиотека функций для серверных скриптов мультиплеера SA:MP,
    которая позволяет создавать/читать/редактировать файлы INI формата.
 
    автор:   MX_Master
    версия:  0.2
    дата:    01/05/2010
 
    Список функций:
 
        ini_open ( file_name[] )
        ini_close ( file_id )
        ini_rename_file ( file_id, new_file_name[], delete_old_file = 1 )
 
        ini_get ( file_id, section[], key[], value[], max_value_size = sizeof(value) )
        ini_get_int ( file_id, section[], key[], & value )
        ini_get_float ( file_id, section[], key[], & Float: value )
 
        ini_set ( file_id, section[], key[], value[] )
        ini_set_int ( file_id, section[], key[], value )
        ini_set_float ( file_id, section[], key[], Float: value )
 
        ini_remove_key ( file_id, section[], key[] )
        ini_remove_section ( file_id, section[] )
 
*/
 
#define iniOpen ini_open
#define iniClose ini_close
#define iniRename ini_rename_file
#define iniGet ini_get
#define iniGetInt ini_get_int
#define iniGetFloat ini_get_float
#define iniSet ini_set
#define iniSetInt ini_set_int
#define iniSetFloat ini_set_float
#define iniRemoveKey ini_remove_key
 
 
 
 
//
// НАСТРОЙКИ
//
//  (?) эти константы удаляются в конце этого файла
//
const
    // рекомендуется изменить под свои задачи
    MAX_OPENED_FILES        = 2,            // макс открытых файлов
    MAX_SECTION_SIZE        = 20 * 1024,    // макс размер текста секции в байтах
    MAX_SECTIONS            = 50,           // макс секций в открытом файле
    MAX_SECTION_KEYS        = 200,          // макс ключей в секции
    MAX_SECTION_NAME_SIZE   = 1024,         // макс размер имени секции
    MAX_FILENAME_SIZE       = 255,          // макс размер имени файла
    MAX_STR_SIZE            = 2048,         // макс размер строки файла
 
    // нельзя менять
    INT_SIZE                = 12,           // размер строки с целочисленным значением
    FLOAT_SIZE              = 40,           // размер строки с дробным числовым значением
 
    // можно изменить на любое число больше 0
    STORE_MACHINE           = 1;            // ид абстрактной машины для хранения динамических данных
 
 
 
 
 
 
 
 
 
 
 
//
// ДИРЕКТИВЫ ДЛЯ КОМПИЛЯТОРА
//
//  (!) понадобится чуть больше памяти стека, чем обычно
//  (?) 128 ячеек - это запас
//
#pragma dynamic ( (MAX_SECTION_SIZE char) + (MAX_SECTION_NAME_SIZE char) + MAX_FILENAME_SIZE + (MAX_STR_SIZE char) + FLOAT_SIZE + 128 ) * MAX_OPENED_FILES
 
 
 
 
 
 
 
 
 
 
 
//
// СПИСКИ РАЗНЫХ СИМВОЛОВ ДЛЯ ПОИСКА ПО ТЕКСТУ
//
//  (?) эти макросы удаляются в конце этого файла
//  (!) рекомендуется не изменять
//
#define ANY_SPACE_CHAR  ' ', '\t', '\r', '\n'   // все пробельные символы
#define STR_SPACE_CHAR  ' ', '\t'               // только строковые пробельные символы
#define STR_CAR_RET     '\r'                    // символ сдвига каретки
#define STR_DELIM       '\n'                    // разделитель строк
#define KEY_VAL_DELIM   '='                     // разделитель ключа и значения
#define COMMENT_START   ';', '#'                // начало комента
#define SECTION_START   '['                     // начало имени секции
#define SECTION_END     ']'                     // конец имени секции
 
 
 
//
// МАКРОСЫ ДЛЯ ПРОСТОТЫ ВИДА КОДА
//
//  (?) эти макросы удаляются в конце этого файла
//
#define skCur[%0]    _section[file_id][sID][%0][skID]
#define sk[%0][%1]   _section[file_id][sID][%1][%0]
#define sCur[%0]     _section[file_id][sID][%0]
 
#define fChanged     _file[file_id][flChanged]
#define fUsed        _file[file_id][flUsed]
#define fKeys        _file[file_id][flKeys]
#define fSections    _file[file_id][flSections]
 
 
 
 
 
 
 
 
 
 
 
//
// КОДЫ, ВОЗВРАЩАЕМЫЕ ФУНКЦИЯМИ В СЛУЧАЕ ОШИБКИ
//
enum ( += -1 )
{
    INI_OK = 0,                 // функция успешно выполнена
 
    INI_WRONG_FILE_ID,          // указан неверный ИД открытого файла
 
    INI_FREAD_ERROR,            // ошибка чтения из файла
    INI_FWRITE_ERROR,           // ошибка при записи в файл
 
    INI_TOO_MANY_OPENED_FILES,  // достигнут макс открытых файлов
    INI_TOO_MANY_SECTIONS,
    INI_TOO_MANY_SECTION_KEYS,
 
    INI_KEY_NOT_FOUND,          // ключ в открытом файле не найден
    INI_SECTION_NOT_FOUND       // секция в открытом файле не найдена
}
 
 
 
//
// ПАРАМЕТРЫ ОДНОЙ СЕКЦИИ
//
enum iniSectionData
{
    sUsed,
    sKeys,
    sNameLen,
 
    skUsed          [MAX_SECTION_KEYS],
    skNamePos       [MAX_SECTION_KEYS],
    skNameLen       [MAX_SECTION_KEYS],
    skValueOffset   [MAX_SECTION_KEYS],
    skValueLen      [MAX_SECTION_KEYS]
}
 
 
 
//
// ПАРАМЕТРЫ ОДНОГО ОТКРЫТОГО ФАЙЛА
//
enum iniFileData
{
    flUsed,
    flChanged,
 
    flKeys,
    flSections
}
 
 
 
 
 
//
// ПРИВАТНЫЕ ПЕРЕМЕННЫЕ
//
//  (?) они не видны другим файлам и даже главному скрипту
//
static stock
    _section    [ MAX_OPENED_FILES ] [ MAX_SECTIONS + 1 ] [ iniSectionData ],   // данные каждой секции
    _file       [ MAX_OPENED_FILES ] [ iniFileData ];                           // данные каждого открытого файла
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
stock ini_open ( file_name[] )
{
    // поиск слота
    new file_id;
    for ( ; file_id < MAX_OPENED_FILES; file_id++ ) if ( !fUsed ) break;
    if ( file_id >= MAX_OPENED_FILES ) return INI_TOO_MANY_OPENED_FILES;
 
 
 
    // если файл не существует - выставим настройки файла и все
    if ( !fexist(file_name) )
    {
        // сохраним имя файла в propety массиве
        setproperty( STORE_MACHINE, _, file_id, file_name );
 
        fUsed       = 1;
        fChanged    = 1; // 1 - чтобы при закрытии создался новый пустой файл
        fKeys       = 0;
        fSections   = 1;
 
        return file_id;
    }
 
 
 
    // открываем файл
    new File: file = fopen( file_name, io_read );
    if ( !file ) return INI_FREAD_ERROR;
 
 
 
    // выставим начальные настройки файла
    fUsed       = 1;
    fChanged    = 0;
    fKeys       = 0;
    fSections   = 1;
 
    // сохраним имя файла в propety массиве
    setproperty( STORE_MACHINE, _, file_id, file_name );
 
    // создаем временные данные
    new sText [MAX_SECTION_SIZE char], // текст текущ секции
        sName [MAX_SECTION_NAME_SIZE char], // имя текущей секции
        fStr  [MAX_STR_SIZE char], // текущая строка, прочитанная из файла
        sID, // глобал ид текущ секции
        skID, // ид текущ ключа в секции
        sText_pos, // текущ поз в тексте секции
        prop_sName_offset = MAX_OPENED_FILES + file_id*MAX_SECTIONS*2, // начальный индекс в массиве property для имен секций
        prop_sText_offset = MAX_OPENED_FILES + file_id*MAX_SECTIONS*2 + MAX_SECTIONS; // начальный индекс в массиве property для текстов секций
 
    // сразу сохраним настройки 0 секции
    setproperty( STORE_MACHINE, _, prop_sName_offset + sID, sName );
    sCur[sNameLen] = 0;
 
 
 
    // читаем файл построчно, составляем карту позиций секций/ключей
    for
    (
        new fStr_endPos = fread( file, fStr, _, true ), fStr_pos, fStr_namePos, fStr_valuePos, fStr_delimPos;
        fStr_endPos > 0;
        fStr_endPos = fread( file, fStr, _, true )
    )
    {
        // поиск в прочитанной строке..
        for ( fStr_pos = 0; fStr_pos < fStr_endPos; fStr_pos++ )
        {
            switch ( fStr{fStr_pos} )
            {
                case STR_SPACE_CHAR : continue;
                // строки, начинающиеся с символов ; # = \r \n считаются коментами (отступы спереди не в счёт)
                case COMMENT_START, STR_CAR_RET, STR_DELIM, KEY_VAL_DELIM : break;
                // найдено начало секции ( [ )
                case SECTION_START :
                {
                    // переход к след строке, если уже макс секций
                    if ( fSections >= MAX_SECTIONS ) break;
 
 
                    // сохр поз начала секции ключа в текущей строке
                    fStr_namePos = fStr_pos + 1;
 
                    // найдем конец имени секции
                    for ( fStr_pos = fStr_endPos - 1; fStr_pos > fStr_namePos; fStr_pos-- )
                        if ( fStr{fStr_pos} == SECTION_END ) break;
 
                    // если нет символа конца секции или имя - пустая строка
                    if ( fStr_pos <= fStr_namePos ) break;
 
 
                    // сохраним текст и настройки послед секции
                    sText{sText_pos} = 0;
                    sText_pos        = 0;
                    setproperty( STORE_MACHINE, _, prop_sText_offset + sID, sText );
 
                    sCur[sUsed] = 1;
                    skID        = 0;
                    fSections++;
                    sID++;
 
 
                    // сохраним длину и имя новой секции
                    sCur[sNameLen] = fStr_pos - fStr_namePos;
 
                    fStr_valuePos = min( sCur[sNameLen], sizeof(sName)*4 - 1 ) - 1;
                    sName{fStr_valuePos + 1} = 0;
 
                    for ( fStr_pos--; fStr_valuePos >= 0; fStr_pos--, fStr_valuePos-- )
                        sName{fStr_valuePos} = fStr{fStr_pos};
 
                    setproperty( STORE_MACHINE, _, prop_sName_offset + sID, sName );
 
                    break;
                }
                // найдено начало ключа ( любой символ, кроме ; # = \r \n [ )
                default :
                {
                    // переход к след строке, если уже макс ключей в секции
                    if ( sCur[sKeys] >= MAX_SECTION_KEYS ) break;
 
                    // сохр поз начала имени ключа в текущей строке
                    fStr_namePos = fStr_pos;
 
                    // найдем =
                    for ( fStr_pos++; fStr_pos < fStr_endPos && fStr{fStr_pos} != KEY_VAL_DELIM; fStr_pos++ ) {}
                    if ( fStr_pos >= fStr_endPos ) break;
 
                    // сохр поз =
                    fStr_delimPos    = fStr_pos;
                    skCur[skNamePos] = fStr_namePos + sText_pos;
 
                    // найдем конец имени ключа
                    for ( fStr_pos--; fStr_pos >= fStr_namePos; fStr_pos-- )
                    {
                        switch ( fStr{fStr_pos} )
                        {
                            case STR_SPACE_CHAR : continue;
                            default:              break;
                        }
                    }
 
                    // сохр длину имени ключа
                    skCur[skNameLen] = fStr_pos - fStr_namePos + 1;
 
                    // найдем начало значения ключа
                    for ( fStr_pos = fStr_delimPos + 1; ; fStr_pos++ )
                    {
                        switch ( fStr{fStr_pos} )
                        {
                            case STR_SPACE_CHAR : continue;
                            default:              break;
                        }
 
                        if ( fStr_pos + 1 >= fStr_endPos ) break;
                    }
 
                    // сохр поз начала значения от начала строки
                    fStr_valuePos = fStr_pos;
 
                    // найдем конец значения ключа
                    for ( fStr_pos = fStr_endPos - 1;   fStr_pos >= fStr_valuePos;   fStr_pos-- )
                    {
                        switch ( fStr{fStr_pos} )
                        {
                            case ANY_SPACE_CHAR :  continue;
                            default: { fStr_pos++; break; }
                        }
                    }
                    if ( fStr_pos < fStr_valuePos ) fStr_pos++;
 
                    // сохр смещение начала значения и длину значения
                    skCur[skValueOffset] = fStr_valuePos - fStr_namePos;
                    skCur[skValueLen]    = fStr_pos - fStr_valuePos;
 
                    skCur[skUsed] = 1;
                    skID++;
                    sCur[sKeys]++;
                    fKeys++;
 
                    break;
                }
            }
        }
 
        // копируем строку в текст текущ секции, если в текущ секции
        if ( fStr_endPos + sText_pos < MAX_SECTION_SIZE )
        {
            for ( fStr_pos = 0; fStr_pos < fStr_endPos; fStr_pos++, sText_pos++ )
                sText{sText_pos} = fStr{fStr_pos};
        }
    }
 
 
 
    // сохраним текст и настройки последней секции
    if ( fSections <= MAX_SECTIONS )
    {
        sCur[sUsed]      = 1;
        sText{sText_pos} = 0;
        setproperty( STORE_MACHINE, _, prop_sText_offset + sID, sText );
    }
 
 
 
    fclose(file); // закроем файл
    return file_id;
}
 
 
 
 
 
stock ini_close ( file_id )
{
    // если указан неверный слот
    if ( file_id < 0 || file_id >= MAX_OPENED_FILES || fUsed == 0 )
        return INI_WRONG_FILE_ID;
 
 
    // если файл не был изменен
    if ( fChanged == 0 )
    {
        fUsed = 0;
        return INI_OK;
    }
 
 
    // узнаем имя файла
    new fName[MAX_FILENAME_SIZE];
    getproperty( STORE_MACHINE, _, file_id, fName );
    strunpack( fName, fName );
 
 
    // откроем файл
    new File: file = fopen( fName, io_write );
    if ( !file ) return INI_FWRITE_ERROR;
 
 
    // создаем временные данные
    new sText [MAX_SECTION_SIZE char], // текст текущ секции
        sID, // глобал ид текущ секции
        sSize, // длина текста текущей секции
        sCount, // кол-во найденных секции
        sText_pos, // текущ поз в тексте секции
        prop_sName_offset = MAX_OPENED_FILES + file_id*MAX_SECTIONS*2, // начальный индекс в массиве property для имен секций
        prop_sText_offset = MAX_OPENED_FILES + file_id*MAX_SECTIONS*2 + MAX_SECTIONS; // начальный индекс в массиве property для текстов секций
 
 
    // запишем в файл тексты всех секций
    if ( fSections > 0 )
    {
        for ( ; sID < MAX_SECTIONS; sID++ )
        {
            if ( sCur[sUsed] != 1 ) continue;
 
            // узнаем текст секции
            getproperty( STORE_MACHINE, _, prop_sText_offset + sID, sText );
 
            // посимвольно запишем текст секции в файл
            for ( sText_pos = 0, sSize = strlen(sText); sText_pos < sSize; sText_pos++ )
                fputchar( file, sText{sText_pos}, false );
 
            // удалим текст и имя секции
            deleteproperty( STORE_MACHINE, _, prop_sText_offset + sID );
            deleteproperty( STORE_MACHINE, _, prop_sName_offset + sID );
 
            if ( ++sCount >= fSections ) break;
        }
    }
 
 
    // удалим имя файла
    deleteproperty( STORE_MACHINE, _, file_id );
 
 
    // файл не используется и закрыт
    fUsed = 0;
    fclose(file);
 
 
    return INI_OK;
}
 
 
 
 
 
 
 
 
 
 
 
stock ini_rename_file ( file_id, new_file_name[], delete_old_file = 1 )
{
    // если указан неверный слот
    if ( file_id < 0 || file_id >= MAX_OPENED_FILES || fUsed == 0 )
        return INI_WRONG_FILE_ID;
 
    // если нужно удалить старый файл
    if ( delete_old_file )
    {
        // узнаем имя файла
        new fName[MAX_FILENAME_SIZE];
        getproperty( STORE_MACHINE, _, file_id, fName );
        strunpack( fName, fName );
 
        // удалим старый файл
        fremove(fName);
    }
 
    // сохраним новое имя файла в propety массиве
    setproperty( STORE_MACHINE, _, file_id, new_file_name );
 
    // выставим настройки файла
    fChanged = 1;
 
    return INI_OK;
}
 
 
 
 
 
 
 
 
 
 
 
stock ini_get ( file_id, section[], key[], value[], max_value_size = sizeof(value) )
{
    // если указан неверный слот
    if ( file_id < 0 || file_id >= MAX_OPENED_FILES || fUsed == 0 )
        return INI_WRONG_FILE_ID;
 
 
 
    // создаем временные данные
    new sName [MAX_SECTION_NAME_SIZE char], // имя текущей секции
        sID, // глобал ид текущ секции
        section_len = strlen(section),
        c, // текущая позиция в указанной секции/ключе
        count, // кол-во просмотренных секций/ключей во время поиска
        found, // флаг - найдена ли секция/ключ
        prop_sName_offset = MAX_OPENED_FILES + file_id*MAX_SECTIONS*2; // начальный индекс в массиве property для имен секций
 
 
 
    // поиск секции
    if ( fSections > 0 )
    {
        for ( ; sID < MAX_SECTIONS; sID++ )
        {
            if ( sCur[sUsed] != 1 ) continue;
 
            if ( sCur[sNameLen] == section_len )
            {
                // узнаем имя секции файла
                getproperty( STORE_MACHINE, _, prop_sName_offset + sID, sName );
 
                // сравним две секции
                for ( c = section_len - 1;   c >= 0;   c-- )
                    if ( sName{c} != section[c] ) break;
 
                // если секции идентичны
                if ( c < 0 ) { found = 1; break; }
            }
 
            // если лимит просмотренных секций равен кол-ву секций в файле - остановим поиск
            if ( ++count >= fSections ) break;
        }
    }
 
    if ( found < 1 ) return INI_SECTION_NOT_FOUND;
 
 
 
    // создаем временные данные
    new key_len = strlen(key),
        sText [MAX_SECTION_SIZE char], // текст текущ секции
        skID, // ид текущ ключа в секции
        sText_pos, // текущ поз в тексте секции
        prop_sText_offset = MAX_OPENED_FILES + file_id*MAX_SECTIONS*2 + MAX_SECTIONS; // начальный индекс в массиве property для текстов секций
 
    // узнаем текст секции
    getproperty( STORE_MACHINE, _, prop_sText_offset + sID, sText );
 
 
 
    // поиск ключа
    found = 0;
 
    if ( sCur[sKeys] > 0 )
    {
        for ( count = 0;   skID < MAX_SECTION_KEYS;   skID++ )
        {
            if ( skCur[skUsed] != 1 ) continue;
 
            if ( skCur[skNameLen] == key_len )
            {
                // сравним два ключа
                for ( c = 0, sText_pos = skCur[skNamePos]; c < key_len; c++, sText_pos++ )
                    if ( sText{sText_pos} != key[c] ) break;
 
                // если ключи идентичны
                if ( c >= key_len ) { found++; break; }
            }
 
            // если лимит просмотренных ключей равен кол-ву ключей в секции - остановим поиск ключа
            if ( ++count >= sCur[sKeys] ) break;
        }
    }
 
    if ( found < 1 ) return INI_KEY_NOT_FOUND;
 
 
 
    max_value_size = min( skCur[skValueLen], max_value_size - 1 ); // узнаем макс размер возвращ строки
    value[max_value_size] = 0; // выставим в ней символ конца строки в нужном месте
 
    // копируем значение ключа в переменную возврата
    for ( c = 0, sText_pos = skCur[skNamePos] + skCur[skValueOffset]; c < max_value_size; c++, sText_pos++ )
        value[c] = sText{sText_pos};
 
    return INI_OK;
}
 
 
 
 
 
stock ini_get_int ( file_id, section[], key[], & value )
{
    new strValue [ INT_SIZE ],
        returned = ini_get( file_id, section, key, strValue, INT_SIZE );
 
    value = strval(strValue);
 
    return returned;
}
 
 
 
 
 
stock ini_get_float ( file_id, section[], key[], & Float: value )
{
    new strValue [ FLOAT_SIZE ],
        returned = ini_get( file_id, section, key, strValue, FLOAT_SIZE );
 
    value = floatstr(strValue);
 
    return returned;
}
 
 
 
 
 
 
 
 
 
 
 
 
stock ini_set ( file_id, section[], key[], value[] )
{
    // проверка ИД файла
    if ( file_id < 0 || file_id >= MAX_OPENED_FILES || fUsed == 0 )
        return INI_WRONG_FILE_ID;
 
 
 
    // создаем временные данные
    new section_len = strlen(section), // длина указанной секции
        sName [MAX_SECTION_NAME_SIZE char], // имя текущей секции
        sText [MAX_SECTION_SIZE char], // текст текущ секции
        prop_sName_offset = MAX_OPENED_FILES + file_id*MAX_SECTIONS*2, // начальный индекс в массиве property для имен секций
        prop_sText_offset = MAX_OPENED_FILES + file_id*MAX_SECTIONS*2 + MAX_SECTIONS, // начальный индекс в массиве property для текстов секций
        sText_pos, // текущая поз в тексте секции
        sID, // глобал ид текущ секции
        c,
        count, // кол-во просмотренных секций/ключей во время поиска
        found; // флаг - найдена ли секция/ключ
 
 
 
    // поиск секции
    if ( fSections > 0 )
    {
        for ( ; sID < MAX_SECTIONS; sID++ )
        {
            if ( sCur[sUsed] != 1 ) continue;
 
            if ( sCur[sNameLen] == section_len )
            {
                // узнаем имя секции файла
                getproperty( STORE_MACHINE, _, prop_sName_offset + sID, sName );
 
                // сравним две секции
                for ( c = section_len - 1;   c >= 0;   c-- )
                    if ( sName{c} != section[c] ) break;
 
                // если секции идентичны
                if ( c < 0 ) { found = 1; break; }
            }
 
            // если лимит просмотренных секций равен кол-ву секций в файле - остановим поиск
            if ( ++count >= fSections ) break;
        }
    }
 
 
 
    // если секция не найдена
    if ( !found )
    {
        // если лимит секций превышен
        if ( fSections >= MAX_SECTIONS ) return INI_TOO_MANY_SECTIONS;
 
 
        // поиск свободного слота для секции
        for ( sID = 1;   sID < MAX_SECTIONS;   sID++ )
            if ( sCur[sUsed] != 1 ) break;
 
 
        // выставим параметры секции и файла
        sCur[sUsed]    = 1;
        sCur[sKeys]    = 0;
        sCur[sNameLen] = section_len;
        fSections++;
 
        // выставим имя секции
        setproperty( STORE_MACHINE, _, prop_sName_offset + sID, section );
 
 
        // копируем имя секции в текст секции
        sText_pos          = 0;
        sText{sText_pos++} = STR_CAR_RET;
        sText{sText_pos++} = STR_DELIM;
        sText{sText_pos++} = SECTION_START;
 
        for ( c = 0;   c < section_len;   c++, sText_pos++ )
            sText{sText_pos} = section[c];
 
        sText{sText_pos++} = SECTION_END;
        sText{sText_pos}   = 0;
 
        // выставим текст секции
        setproperty( STORE_MACHINE, _, prop_sText_offset + sID, sText );
    }
    // если секция найдена
    else
        // узнаем текст секции
        getproperty( STORE_MACHINE, _, prop_sText_offset + sID, sText );
 
 
 
    // создаем временные данные
    new key_len = strlen(key),
        skID, // ид текущ ключа в секции
        value_len = strlen(value), // размер значения
        sText_len = strlen(sText), // длина текста секции
        sText_offset; // смещение текста секции
 
 
 
    // поиск ключа
    found = 0;
 
    if ( sCur[sKeys] > 0 )
    {
        for ( count = 0;   skID < MAX_SECTION_KEYS;   skID++ )
        {
            if ( skCur[skUsed] != 1 ) continue;
 
            if ( skCur[skNameLen] == key_len )
            {
                // сравним два ключа
                for ( c = 0, sText_pos = skCur[skNamePos];   c < key_len;   c++, sText_pos++ )
                    if ( sText{sText_pos} != key[c] ) break;
 
                // если ключи идентичны
                if ( c >= key_len ) { found = 1; break; }
            }
 
            // если лимит просмотренных ключей равен кол-ву ключей в секции - остановим поиск ключа
            if ( ++count >= sCur[sKeys] ) break;
        }
    }
 
 
 
    // если ключ не найден
    if ( !found )
    {
        // узнаем величину сдвига текста секции в байтах
        sText_offset = key_len + 3 + value_len + ( ( sText_len > 0 ) ? 2 : 0 );
 
        // если лимит ключей превышен или нет места в тексте секции
        if ( sCur[sKeys] >= MAX_SECTION_KEYS || sText_len + sText_offset >= MAX_SECTION_SIZE )
            return INI_TOO_MANY_SECTION_KEYS;
 
        // поиск свободного слота для ключа
        for ( skID = 0; skID < MAX_SECTION_KEYS; skID++ )
            if ( skCur[skUsed] != 1 ) break;
 
        // выставим параметры ключа, секции и файла
        skCur[skUsed]        = 1;
        skCur[skNameLen]     = key_len;
        skCur[skValueOffset] = key_len + 3;
        skCur[skValueLen]    = value_len;
        fKeys++;
        sCur[sKeys]++;
 
        // найдем конец строки с самым последним ключем
        for ( sText_pos = sText_len - 1; sText_pos >= 0; sText_pos-- )
        {
            switch ( sText{sText_pos} )
            {
                case STR_CAR_RET, STR_DELIM : continue;
                default:                      { sText_pos++; break; }
            }
        }
 
        // если позиция для вставки ключа - не самый конец текста секции
        if ( sText_pos < sText_len )
        {
            // переместим символы в конце секции на их новые места
            for ( new pos = sText_pos; pos < sText_len; pos++ )
                sText{pos + sText_offset} = sText{pos};
        }
 
        // добавим \r\n если длина секции не нулевая
        if ( sText_len > 0 )
        {
            sText{sText_pos++} = STR_CAR_RET;
            sText{sText_pos++} = STR_DELIM;
        }
 
        // копируем имя ключа
        skCur[skNamePos] = sText_pos;
        for ( c = 0; c < key_len; c++, sText_pos++ ) sText{sText_pos} = key[c];
 
        // добавим =
        sText{sText_pos++} = ' ';
        sText{sText_pos++} = KEY_VAL_DELIM;
        sText{sText_pos++} = ' ';
 
        // копируем значение
        for ( c = 0; c < value_len; c++, sText_pos++ ) sText{sText_pos} = value[c];
 
        // + символ конца строки
        sText{sText_len + sText_offset} = 0;
    }
    // если ключ найден
    else
    {
        // узнаем величину сдвига текста секции в байтах
        sText_offset = value_len - skCur[skValueLen];
 
        // если нет места в тексте секции
        if ( sText_len + sText_offset >= MAX_SECTION_SIZE )
            return INI_TOO_MANY_SECTION_KEYS;
 
 
        // сдвиг позиций ключей, идущих после текущего ключа
        count = 0;
        for ( new k; k < MAX_SECTION_KEYS; k++ )
        {
            if ( sk[k][skUsed] != 0 )
            {
                // если поз ключа больше поз текущ ключа - изменим поз ключа k
                if ( sk[k][skNamePos] > skCur[skNamePos] ) sk[k][skNamePos] += sText_offset;
 
                // если лимит просмотренных ключей равен кол-ву ключей в секции
                if ( ++count >= sCur[sKeys] ) break;
            }
        }
 
        // сдвиг текста секции
        if ( sText_offset != 0 )
        {
            if ( sText_offset > 0 )
            {
                new valueEndPos = skCur[skNamePos] + skCur[skValueOffset] + skCur[skValueLen];
 
                for ( sText_pos = sText_len - 1;   sText_pos >= valueEndPos;   sText_pos-- )
                    sText{sText_pos + sText_offset} = sText{sText_pos};
            }
            else
            {
                for ( sText_pos = skCur[skNamePos] + skCur[skValueOffset] + skCur[skValueLen];   sText_pos < sText_len;   sText_pos++ )
                    sText{sText_pos + sText_offset} = sText{sText_pos};
            }
 
            sText{sText_len + sText_offset} = 0;
            skCur[skValueLen]               = value_len;
        }
 
 
        // копируем новое значение поверх старого
        for ( c = 0, sText_pos = skCur[skNamePos] + skCur[skValueOffset];   c < value_len;   c++, sText_pos++ )
            sText{sText_pos} = value[c];
    }
 
 
 
    // выставим текст секции
    setproperty( STORE_MACHINE, _, prop_sText_offset + sID, sText );
 
    // файл изменен
    fChanged = 1;
 
    return INI_OK;
}
 
 
 
 
 
stock ini_set_int ( file_id, section[], key[], value )
{
    new strValue [ INT_SIZE ];
    format( strValue, INT_SIZE, "%d", value );
 
    return ini_set( file_id, section, key, strValue );
}
 
 
 
 
 
stock ini_set_float ( file_id, section[], key[], Float: value )
{
    new strValue [ FLOAT_SIZE ];
    format( strValue, FLOAT_SIZE, "%f", value );
 
    return ini_set( file_id, section, key, strValue );
}
 
 
 
 
 
 
 
 
 
 
 
stock ini_remove_key ( file_id, section[], key[] )
{
    // если указан неверный слот
    if ( file_id < 0 || file_id >= MAX_OPENED_FILES || fUsed == 0 )
        return INI_WRONG_FILE_ID;
 
 
 
    // создаем временные данные
    new sName [MAX_SECTION_NAME_SIZE char], // имя текущей секции
        sID, // глобал ид текущ секции
        section_len = strlen(section),
        c, // текущая позиция в указанной секции/ключе
        count, // кол-во просмотренных секций/ключей во время поиска
        found, // флаг - найдена ли секция/ключ
        prop_sName_offset = MAX_OPENED_FILES + file_id*MAX_SECTIONS*2; // начальный индекс в массиве property для имен секций
 
 
 
    // поиск секции
    if ( fSections > 0 )
    {
        for ( ; sID < MAX_SECTIONS; sID++ )
        {
            if ( sCur[sUsed] != 1 ) continue;
 
            if ( sCur[sNameLen] == section_len ) // и длины секций совпадают
            {
                // узнаем имя секции файла
                getproperty( STORE_MACHINE, _, prop_sName_offset + sID, sName );
 
                // сравним две секции
                for ( c = section_len - 1;   c >= 0;   c-- )
                    if ( sName{c} != section[c] ) break;
 
                // если секции идентичны
                if ( c < 0 ) { found = 1; break; }
            }
 
            // если лимит просмотренных секций равен кол-ву секций в файле - остановим поиск
            if ( ++count >= fSections ) break;
        }
    }
 
    if ( found < 1 ) return INI_SECTION_NOT_FOUND;
 
 
 
    // создаем временные данные
    new key_len = strlen(key),
        sText [MAX_SECTION_SIZE char], // текст текущ секции
        skID, // ид текущ ключа в секции
        sText_pos, // текущ поз в тексте секции
        prop_sText_offset = MAX_OPENED_FILES + file_id*MAX_SECTIONS*2 + MAX_SECTIONS; // начальный индекс в массиве property для текстов секций
 
    // узнаем текст секции
    getproperty( STORE_MACHINE, _, prop_sText_offset + sID, sText );
 
 
 
    // поиск ключа
    found = 0;
 
    if ( sCur[sKeys] > 0 )
    {
        for ( count = 0;   skID < MAX_SECTION_KEYS;   skID++ )
        {
            if ( skCur[skUsed] != 1 ) continue;
 
            if ( skCur[skNameLen] == key_len )
            {
                // сравним два ключа
                for ( c = 0, sText_pos = skCur[skNamePos]; c < key_len; c++, sText_pos++ )
                    if ( sText{sText_pos} != key[c] ) break;
 
                // если ключи идентичны
                if ( c >= key_len ) { found++; break; }
            }
 
            // если лимит просмотренных ключей равен кол-ву ключей в секции - остановим поиск ключа
            if ( ++count >= sCur[sKeys] ) break;
        }
    }
 
    if ( found < 1 ) return INI_KEY_NOT_FOUND;
 
 
 
    // создаем временные данные
    new sText_offset = -( skCur[skValueOffset] + skCur[skValueLen] ), // смещение текста секции
        sText_len    = strlen(sText); // длина текста секции
 
 
 
    // если за значением идут пробельные символы, то их удалить надо тоже
    for ( sText_pos = skCur[skNamePos] + skCur[skValueOffset] + skCur[skValueLen];   sText_pos < sText_len;   sText_pos++, sText_offset-- )
        if ( sText{sText_pos} == STR_DELIM ) { sText_offset--; break; }
 
    // сдвиг позиций ключей, идущих после текущего ключа в секции
    count = 0;
    for ( new k; k < MAX_SECTION_KEYS; k++ )
    {
        if ( sk[k][skUsed] != 0 )
        {
            // если поз ключа больше поз текущ ключа - изменим поз ключа k
            if ( sk[k][skNamePos] > skCur[skNamePos] ) sk[k][skNamePos] += sText_offset;
 
            // если лимит просмотренных ключей равен кол-ву ключей в секции
            if ( ++count >= sCur[sKeys] ) break;
        }
    }
 
    // сдвиг текста секции
    for ( sText_pos = skCur[skNamePos] + skCur[skValueOffset] + skCur[skValueLen];   sText_pos < sText_len;   sText_pos++ )
        sText{sText_pos + sText_offset} = sText{sText_pos};
 
    // + символ конца строки
    sText{sText_len + sText_offset} = 0;
 
    // выставим текст секции
    setproperty( STORE_MACHINE, _, prop_sText_offset + sID, sText );
 
    // выставим настройки секции и файла
    fChanged      = 1;
    skCur[skUsed] = 0;
    sCur[sKeys]--;
    fKeys--;
 
    return INI_OK;
}
 
 
 
 
 
stock ini_remove_section ( file_id, section[] )
{
    // если указан неверный слот
    if ( file_id < 0 || file_id >= MAX_OPENED_FILES || fUsed == 0 )
        return INI_WRONG_FILE_ID;
 
 
 
    // создаем временные данные
    new sName [MAX_SECTION_NAME_SIZE char], // имя текущей секции
        sID, // глобал ид текущ секции
        section_len = strlen(section),
        c, // текущая позиция в указанной секции/ключе
        count, // кол-во просмотренных секций/ключей во время поиска
        found, // флаг - найдена ли секция/ключ
        prop_sName_offset = MAX_OPENED_FILES + file_id*MAX_SECTIONS*2; // начальный индекс в массиве property для имен секций
 
 
 
    // поиск секции
    if ( fSections > 0 )
    {
        for ( ; sID < MAX_SECTIONS; sID++ )
        {
            if ( sCur[sUsed] != 1 ) continue;
 
            if ( sCur[sNameLen] == section_len ) // и длины секций совпадают
            {
                // узнаем имя секции файла
                getproperty( STORE_MACHINE, _, prop_sName_offset + sID, sName );
 
                // сравним две секции
                for ( c = section_len - 1;   c >= 0;   c-- )
                    if ( sName{c} != section[c] ) break;
 
                // если секции идентичны
                if ( c < 0 ) { found = 1; break; }
            }
 
            // если лимит просмотренных секций равен кол-ву секций в файле - остановим поиск
            if ( ++count >= fSections ) break;
        }
    }
 
    if ( found < 1 ) return INI_SECTION_NOT_FOUND;
 
 
 
    // удалим текст секции и ее имя из propety массива
    deleteproperty( STORE_MACHINE, _, prop_sName_offset + sID );
    deleteproperty( STORE_MACHINE, _, MAX_OPENED_FILES + file_id*MAX_SECTIONS*2 + MAX_SECTIONS + sID );
 
    // выставим настройки секции и файла
    fChanged    = 1;
    sCur[sUsed] = 0;
    fKeys      -= sCur[sKeys];
    fSections--;
 
    return INI_OK;
}
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
//
// УДАЛЕНИЕ НЕНУЖНЫХ КОНСТАНТ И МАКРОСОВ
//
 
#undef MAX_OPENED_FILES
#undef MAX_SECTION_SIZE
#undef MAX_SECTIONS
#undef MAX_SECTION_KEYS
#undef MAX_SECTION_NAME_SIZE
#undef MAX_FILENAME_SIZE
#undef MAX_STR_SIZE
 
#undef INT_SIZE
#undef FLOAT_SIZE
 
#undef STORE_MACHINE
 
 
 
 
 
#undef ANY_SPACE_CHAR
#undef STR_SPACE_CHAR
#undef STR_CAR_RET
#undef STR_DELIM
#undef KEY_VAL_DELIM
#undef COMMENT_START
#undef SECTION_START
#undef SECTION_END
 
 
 
 
 
#undef skCur
#undef sk
#undef sCur
 
#undef fChanged
#undef fUsed
#undef fKeys
#undef fSections