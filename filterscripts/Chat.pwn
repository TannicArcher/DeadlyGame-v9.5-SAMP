#include <a_samp>

#define SPACE_CHARS ' ', '\t', '\r', '\n'

stock trimSideSpaces ( string[] )
{
    new c, len = strlen(string);

    for ( ; c < len; c++ ) // вырежем пробелы в начале
    {
        switch ( string[c] )
        {
            case SPACE_CHARS : continue;
            default:
            {
                if ( c != 0 ) strmid( string, string, c, len, len );
                break;
            }
        }
    }

    for ( c = len - c - 1; c >= 0; c-- ) // вырежем пробелы в конце
    {
        switch ( string[c] )
        {
            case SPACE_CHARS : continue;
            default:
            {
                string[c + 1] = 0;
                break;
            }
        }
    }
}

#define cells *4

stock spaceGroupsToSpaces ( string[] )
{
    new len = strlen(string), c = len - 1, spaces;

    for ( ; c >= 0; c-- )
    {
        switch ( string[c] )
        {
            case SPACE_CHARS : spaces++;
            default :
            {
                if ( spaces > 1 )
                {
                    memcpy( string, string[c + spaces + 1], (c + 2) cells, (len - c - spaces - 1) cells, len );
                    len -= spaces - 1;
                }

                if ( spaces > 0 )
                {
                    string[c + 1] = ' ';
                    spaces        =  0;
                }
            }
        }
    }

    if ( spaces > 1 )
    {
        memcpy( string, string[c + spaces + 1], (c + 2) cells, (len - c - spaces - 1) cells, len );
        len -= spaces - 1;
    }
    if ( spaces > 0 ) string[c + 1] = ' ';

    string[len] = 0;
}

#undef SPACE_CHARS
// список запрещенных доменов 1 уровня
stock forbiddenDomain[][] =
{
    ".net", ".nеt",
    ".com", ".сom", ".соm", ".cоm",
    ".ru", ".ру",
    ".kz", ".кz", ".kз", ".кз",
    ".info", ".infо"
};

stock containsDomainName ( string[] )
{
    new strLen = strlen(string);

    for ( new d = sizeof(forbiddenDomain) - 1, foundPos, domainLen; d >= 0; d-- )
    {
        foundPos  = -1;
        domainLen = strlen(forbiddenDomain[d]);

        for ( ; ( foundPos = strfind( string, forbiddenDomain[d], true, foundPos + 1 ) ) >= 0;  )
        {
            if ( foundPos + domainLen >= strLen ) return 1;

            switch ( string[ foundPos + domainLen ] )
            {
                case 0..64, 91..96, 123..191 : return 1;
            }
        }
    }

    return 0;
}

// список флагов для каждого игрока
stock forbiddenName [ MAX_PLAYERS char ];

#define INCORRECT_CMD_CHARS '.', '?'

stock incorrectCmdAttempt ( string[] )
{
    switch ( string[0] )
    {
        case INCORRECT_CMD_CHARS :
        {
            switch ( string[1] )
            {
                case 65..90, 97..122, 192..255 : return 1;
            }
        }
    }

    return 0;
}

#undef INCORRECT_CMD_CHARS

#define CHAT_STR_SIZE           128 // макс кол-во символов в сообщении чата
#define CHAT_HISTORY_SIZE       20 // кол-во сохраненных сообщений чата
#define DUBLPOSTS_SIMILARITY    1 // допустимый % похожести, идущих подряд, сообщений игрока
#define MAX_MESSAGES_PER_TIME   3 // максимум сообщений за, указанную ниже, единицу времени
#define MAX_MESSAGES_TIME       2000 // мс. За указанное время должно быть не более MAX_FAST_MESSAGES сообщений игрока

enum chatMsInfo // инфо о каждом сообщении чата
{
    chTick,
    chPosterID,
    chText [ CHAT_STR_SIZE ]
}

// массив, где хранятся посл CHAT_HISTORY_SIZE сообщений чата
stock ms [ CHAT_HISTORY_SIZE ] [ chatMsInfo ];

stock sparam
(
    dest[],             maxSize     = sizeof(dest),
    const source[],     delimiter   = ' ',
    substrIndex = 0,    withRest    = 0
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

            goto sparam_end;
        }

        if ( source[cur] == delimiter ) // если текущий символ в source - это символ для разделения строки
        {
            if ( ++i == substrIndex ) // если индекс текущей подстроки и есть sourceIndex
            {
                // скопируем в dest нужную подстроку из source
                strmid( dest, source, pre, ( withRest ? strlen(source) : cur ), maxSize );
                goto sparam_end;
            }

            pre = cur + 1;
        }
    }

    sparam_end:
    return; // завершим работу функции
}

stock updateMsHistory ( playerid, msTick, text[] )
{
    // сдвиг всей истории на 1 слот вперед
    for ( new i = 1; i < CHAT_HISTORY_SIZE; i++ )
        memcpy( ms[i], ms[i - 1], 0, sizeof(ms[]) cells );

    // добавим текст и автора в историю сообщений чата
    ms[0][chTick]     = msTick;
    ms[0][chPosterID] = playerid;
    strmid( ms[0][chText], text, 0, strlen(text), CHAT_STR_SIZE );
}

stock tooManyMessagesForShortTime ( playerid, lastMsTick )
{
    // найдем самое первое сообщение игрока в истории чата из его всех быстрых сообщений
    new m, messages;

    for ( ; m < CHAT_HISTORY_SIZE; m++ )
        if ( ms[m][chPosterID] == playerid && ++messages > MAX_MESSAGES_PER_TIME ) break;

    if ( m >= CHAT_HISTORY_SIZE ) m--;
    if ( messages > MAX_MESSAGES_PER_TIME && lastMsTick - ms[m][chTick] < MAX_MESSAGES_TIME ) return 1;

    return 0;
}

#undef cells
#undef CHAT_STR_SIZE
#undef DUBLPOSTS_SIMILARITY
#undef MAX_MESSAGES_PER_TIME
#undef MAX_MESSAGES_TIME

#define MAX_UPPERCASES    50 // допустимый % букв в верхнем регистре

stock tooManyUpperChars ( string[] )
{
    new len = strlen(string), c = len - 1, upperChars;

    for ( ; c >= 0; c-- )
    {
        switch ( string[c] )
        {
            case 'A'..'Z', 'А'..'Я' : upperChars++;
        }
    }

    if ( float(upperChars) / float(len) * 100.0 > MAX_UPPERCASES.0 ) return 1;

    return 0;
}

#undef MAX_UPPERCASES

public OnFilterScriptInit()
{
    for ( new i; i < CHAT_HISTORY_SIZE; i++ ) ms[i][chPosterID] = -1;
}

#undef CHAT_HISTORY_SIZE

public OnPlayerConnect ( playerid )
{
    forbiddenName{playerid} = 0;
    return 1;
}

public OnPlayerDisconnect ( playerid, reason )
{
    forbiddenName{playerid} = 0;
    return 1;
}

#define WARN_MS_COLOR   0xFF5050AA
#define WARN_MS_PREFIX  " * "

public OnPlayerText ( playerid, text[] )
{
    new msgTick = GetTickCount();
    // сообщения чата, похожие на попытку ввода команды чата - отображаться не будут
    if ( incorrectCmdAttempt(text) )
    {
        SendClientMessage( playerid, WARN_MS_COLOR, WARN_MS_PREFIX "{FF0000}[Anti-Oblom]: {FF8888}Попытка ввода команды? Повнимательней." );
        return 0;
    }
    // замена любых групп пробельных символов на единичные пробелы
    spaceGroupsToSpaces(text);
    // обрезка пробельных символов по краям
    trimSideSpaces(text);
    // пустые сообщения отображаться не будут
    if ( text[0] == 0 ) return 0;
    // нельзя писать соообщения, содержащие много букв в верхнем регистре
    if ( tooManyUpperChars(text) )
    {
        SendClientMessage( playerid, WARN_MS_COLOR, WARN_MS_PREFIX "{FF0000}[Anti-Caps Lock]: {FF8888}Отключите CAPS LOCK..." );
        return 0;
    }
    // нельзя писать сообщения, содержащие запрещенные доменные имена
    if ( containsDomainName(text) )
    {
        SendClientMessage( playerid, WARN_MS_COLOR, WARN_MS_PREFIX "{FF0000}[Anti-Adv]: {FF8888}Кое-какие домены и сайты писать нельзя." );
        return 0;
    }
    // нельзя быстро написать неск сообщений подряд
    if ( tooManyMessagesForShortTime( playerid, msgTick ) )
    {
        SendClientMessage( playerid, WARN_MS_COLOR, WARN_MS_PREFIX "{FF0000}[Anti-Flood]: {FF8888}Не флудите, подождите 2-3 секунды..." );
        return 0;
    }
    // обновление истории сообщений чата
    updateMsHistory( playerid, msgTick, text );
    // покажем сообщение в чате
    return 1;
}

#undef WARN_MS_COLOR
#undef WARN_MS_PREFIX

//--защита от DeAMX-------------------------------------------------------------
forward DeAMXI (playerid);
AntiDeAMX()
{
new a[][] =
{
"Unarmed (Fist)",
"Brass K"
};
#pragma unused a
}
public DeAMXI(playerid)
{
AntiDeAMX();
return 1;
}
