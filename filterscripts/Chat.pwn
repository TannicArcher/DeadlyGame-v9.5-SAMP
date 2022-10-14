#include <a_samp>

#define SPACE_CHARS ' ', '\t', '\r', '\n'

stock trimSideSpaces ( string[] )
{
    new c, len = strlen(string);

    for ( ; c < len; c++ ) // ������� ������� � ������
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

    for ( c = len - c - 1; c >= 0; c-- ) // ������� ������� � �����
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
// ������ ����������� ������� 1 ������
stock forbiddenDomain[][] =
{
    ".net", ".n�t",
    ".com", ".�om", ".��m", ".c�m",
    ".ru", ".��",
    ".kz", ".�z", ".k�", ".��",
    ".info", ".inf�"
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

// ������ ������ ��� ������� ������
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

#define CHAT_STR_SIZE           128 // ���� ���-�� �������� � ��������� ����
#define CHAT_HISTORY_SIZE       20 // ���-�� ����������� ��������� ����
#define DUBLPOSTS_SIMILARITY    1 // ���������� % ���������, ������ ������, ��������� ������
#define MAX_MESSAGES_PER_TIME   3 // �������� ��������� ��, ��������� ����, ������� �������
#define MAX_MESSAGES_TIME       2000 // ��. �� ��������� ����� ������ ���� �� ����� MAX_FAST_MESSAGES ��������� ������

enum chatMsInfo // ���� � ������ ��������� ����
{
    chTick,
    chPosterID,
    chText [ CHAT_STR_SIZE ]
}

// ������, ��� �������� ���� CHAT_HISTORY_SIZE ��������� ����
stock ms [ CHAT_HISTORY_SIZE ] [ chatMsInfo ];

stock sparam
(
    dest[],             maxSize     = sizeof(dest),
    const source[],     delimiter   = ' ',
    substrIndex = 0,    withRest    = 0
)
{
    dest[0] = 0; // ������� ������ ����������

    for ( new cur, pre, i = -1; ; cur++ ) // ���������� �� ������� ������� � ������ source
    {
        if ( source[cur] == 0 ) // ���� ������� ������ � source - ��� ������ ����� ������
        {
            if ( ++i == substrIndex ) // ���� ������ ������� ��������� � ���� sourceIndex
                // ��������� � dest ������ ��������� �� source
                strmid( dest, source, pre, ( withRest ? strlen(source) : cur ), maxSize );

            goto sparam_end;
        }

        if ( source[cur] == delimiter ) // ���� ������� ������ � source - ��� ������ ��� ���������� ������
        {
            if ( ++i == substrIndex ) // ���� ������ ������� ��������� � ���� sourceIndex
            {
                // ��������� � dest ������ ��������� �� source
                strmid( dest, source, pre, ( withRest ? strlen(source) : cur ), maxSize );
                goto sparam_end;
            }

            pre = cur + 1;
        }
    }

    sparam_end:
    return; // �������� ������ �������
}

stock updateMsHistory ( playerid, msTick, text[] )
{
    // ����� ���� ������� �� 1 ���� ������
    for ( new i = 1; i < CHAT_HISTORY_SIZE; i++ )
        memcpy( ms[i], ms[i - 1], 0, sizeof(ms[]) cells );

    // ������� ����� � ������ � ������� ��������� ����
    ms[0][chTick]     = msTick;
    ms[0][chPosterID] = playerid;
    strmid( ms[0][chText], text, 0, strlen(text), CHAT_STR_SIZE );
}

stock tooManyMessagesForShortTime ( playerid, lastMsTick )
{
    // ������ ����� ������ ��������� ������ � ������� ���� �� ��� ���� ������� ���������
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

#define MAX_UPPERCASES    50 // ���������� % ���� � ������� ��������

stock tooManyUpperChars ( string[] )
{
    new len = strlen(string), c = len - 1, upperChars;

    for ( ; c >= 0; c-- )
    {
        switch ( string[c] )
        {
            case 'A'..'Z', '�'..'�' : upperChars++;
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
    // ��������� ����, ������� �� ������� ����� ������� ���� - ������������ �� �����
    if ( incorrectCmdAttempt(text) )
    {
        SendClientMessage( playerid, WARN_MS_COLOR, WARN_MS_PREFIX "{FF0000}[Anti-Oblom]: {FF8888}������� ����� �������? ��������������." );
        return 0;
    }
    // ������ ����� ����� ���������� �������� �� ��������� �������
    spaceGroupsToSpaces(text);
    // ������� ���������� �������� �� �����
    trimSideSpaces(text);
    // ������ ��������� ������������ �� �����
    if ( text[0] == 0 ) return 0;
    // ������ ������ ����������, ���������� ����� ���� � ������� ��������
    if ( tooManyUpperChars(text) )
    {
        SendClientMessage( playerid, WARN_MS_COLOR, WARN_MS_PREFIX "{FF0000}[Anti-Caps Lock]: {FF8888}��������� CAPS LOCK..." );
        return 0;
    }
    // ������ ������ ���������, ���������� ����������� �������� �����
    if ( containsDomainName(text) )
    {
        SendClientMessage( playerid, WARN_MS_COLOR, WARN_MS_PREFIX "{FF0000}[Anti-Adv]: {FF8888}���-����� ������ � ����� ������ ������." );
        return 0;
    }
    // ������ ������ �������� ���� ��������� ������
    if ( tooManyMessagesForShortTime( playerid, msgTick ) )
    {
        SendClientMessage( playerid, WARN_MS_COLOR, WARN_MS_PREFIX "{FF0000}[Anti-Flood]: {FF8888}�� �������, ��������� 2-3 �������..." );
        return 0;
    }
    // ���������� ������� ��������� ����
    updateMsHistory( playerid, msgTick, text );
    // ������� ��������� � ����
    return 1;
}

#undef WARN_MS_COLOR
#undef WARN_MS_PREFIX

//--������ �� DeAMX-------------------------------------------------------------
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
