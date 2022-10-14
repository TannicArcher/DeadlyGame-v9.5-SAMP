//
// Created:
// Aurthor: Dmitry Frolov (FP)
//

#if defined _admin_commands_sys_included
#endinput
#endif

#define _admin_commands_sys_included
#pragma library admin_commands_sys
#include "base"
#include "player"

forward AdminCommandHandlerSys(playerid,text[]);

new sysweath = 0;	//WEATHER
new sysswear = 0;	//ANTI SWEAR
new syslotto = 0;	//LOTTERY, WITH Time
new sysmbbomb = 0;	//Military base bombing script

public AdminCommandHandlerSys(playerid,text[]) // process player commands
{
if (!IsPlayerConnected(playerid)) return 0;
if ( !IsPlayerAdmin(playerid) && !IsPlayerAdm(playerid) )
{
return 0;
}
new cmd[20];
new idx;
set(cmd,strcharsplit(text, idx,strchar(" ")));
if(strcomp(cmd, "/sys", true) == 0) return 0;
set(cmd,strcharsplit(text, idx,strchar(" ")));

//SEE COMMAND FOR ALL ADMINS
//if(strcomp(cmd, "/login", true) == 0) 
//{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);
//}

if(strcomp(cmd, "cmdlist", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

  SendClientMessage(playerid, COLOUR_YELLOW, lang_texts[15][57]);
  SendClientMessage(playerid, COLOUR_YELLOW, "S: '/sys cmdlist', '/sys about', '/sys info'");
  SendClientMessage(playerid, COLOUR_YELLOW, "S: '/sys weath <param>', - Weather AutoChange (0/1-20 min)");
  SendClientMessage(playerid, COLOUR_YELLOW, "S: '/sys lotto <param>', - Lottery (0/1-20 min)");
  SendClientMessage(playerid, COLOUR_YELLOW, "S: '/sys antimat <param>', - AntySwear (0/1)");
  SendClientMessage(playerid, COLOUR_YELLOW, "S: '/sys bomb <param>', - Military Base Bombing (0/1)");
}

if(strcomp(cmd, "about", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);
  SendClientMessage(playerid, COLOUR_YELLOW, lang_texts[15][57]);
  SendClientMessage(playerid, COLOUR_YELLOW, lang_texts[15][58]);
  SendClientMessage(playerid, COLOUR_YELLOW, lang_texts[15][59]);
}

if(strcomp(cmd, "info", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

SendClientMessage(playerid, COLOUR_GREEN, "_________________________________________________________________________________");
SendClientMessage(playerid, COLOUR_YELLOW, lang_texts[15][60]);
new string[MAX_STRING];
format(string,sizeof(string),lang_texts[15][61] , ActiveVehiclesCount);
SendClientMessage(playerid, COLOUR_LIGHTGREEN, string);

format(string,sizeof(string),lang_texts[15][65] , never);
SendClientMessage(playerid, COLOUR_LIGHTGREEN, string);

new MAX_ONLINESS = 0;
for (new idst = 0; idst < MAX_PLAYERS; idst++)
	{
	if (IsPlayerConnected(idst))
		{
		MAX_ONLINESS = MAX_ONLINESS + 1;
		}
	}

format(string,sizeof(string),lang_texts[15][62] , MAX_ONLINESS, MAX_PLAYERS);
SendClientMessage(playerid, COLOUR_LIGHTGREEN, string);

new stringas[MAX_STRING];
new hour,minute,second;
gettime(hour,minute,second);
if ( (hour <= 9) && (minute <= 9) ) {format(stringas,sizeof(stringas),"0%d:0%d",hour,minute);}
if ( (hour <= 9) && (minute > 9) )  {format(stringas,sizeof(stringas),"0%d:%d",hour,minute);}
if ( (hour > 9) && (minute <= 9) ) {format(stringas,sizeof(stringas),"%d:0%d",hour,minute);}
if ( (hour > 9) && (minute > 9) )  {format(stringas,sizeof(stringas),"%d:%d",hour,minute);}
format(string,sizeof(string),lang_texts[15][63] , stringas);
SendClientMessage(playerid, COLOUR_LIGHTGREEN, string);

format(string,sizeof(string),lang_texts[15][64] , MAX_BANK, MAX_MONEY);
SendClientMessage(playerid, COLOUR_LIGHTGREEN, string);

SendClientMessage(playerid, COLOUR_YELLOW, lang_texts[15][66]);
format(string,sizeof(string)," '/sys weath' = %d (Weather AutoChange)" , sysweath);
SendClientMessage(playerid, COLOUR_WHITE, string);
format(string,sizeof(string)," '/sys lotto' = %d (Lottery)" , syslotto);
SendClientMessage(playerid, COLOUR_WHITE, string);
format(string,sizeof(string)," '/sys antimat' = %d (AntySwear)" , sysswear);
SendClientMessage(playerid, COLOUR_WHITE, string);
format(string,sizeof(string)," '/sys bomb' = %d (Military Base Bombing)" , sysmbbomb);
SendClientMessage(playerid, COLOUR_WHITE, string);

//format(string,sizeof(string)," '/sys acs' = %d (јнти—павн иллер)" , 1);
//SendClientMessage(playerid, COLOUR_WHITE, string);
}


if(strcomp(cmd, "weath", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new paramid;
paramid = strval(strcharsplit(text, idx,strchar(" ")));
if (paramid == 0)
{
SetTimer("WeatherUpdate", 20*60000,0);
sysweath=0;
SendPlayerFormattedText(playerid,"SYS: Weather AutoChange OFF ", 0,COLOUR_WHITE);
} else if ((paramid >= 1) && (paramid <= 20))
{
SetTimer("WeatherUpdate",paramid*60000, 1);
sysweath=1;
SendPlayerFormattedText(playerid,"SYS: Weather AutoChange ON", 0,COLOUR_WHITE);
} else
{
SendPlayerFormattedText(playerid, lang_texts[15][67] , 0,COLOUR_RED);
return 0;
}

//new string[MAX_STRING];
//format(string,sizeof(string), lang_texts[12][48] ,oGetPlayerName(playerid));			//игроку
//SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);
//format(string,sizeof(string), lang_texts[12][49] ,oGetPlayerName(receiverid));

return 1;
}


if(strcomp(cmd, "lotto", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new paramid;
paramid = strval(strcharsplit(text, idx,strchar(" ")));
if (paramid == 0)
{
SetTimer("Lottery", 20*60000,0);
syslotto=0;
SendPlayerFormattedText(playerid,"SYS: Lottery OFF", 0,COLOUR_WHITE);
} else if ((paramid >= 1) && (paramid <= 20))
{
SetTimer("Lottery",paramid*60000, 1);
syslotto=1;
SendPlayerFormattedText(playerid,"SYS: Lottery ON", 0,COLOUR_WHITE);
} else
{
SendPlayerFormattedText(playerid, lang_texts[15][67] , 0,COLOUR_RED);
return 0;
}

//new string[MAX_STRING];
//format(string,sizeof(string), lang_texts[12][48] ,oGetPlayerName(playerid));			//игроку
//SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);
//format(string,sizeof(string), lang_texts[12][49] ,oGetPlayerName(receiverid));

return 1;
}


if(strcomp(cmd, "antimat", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new paramid;
paramid = strval(strcharsplit(text, idx,strchar(" ")));
if (paramid == 0)
{
sysswear=0;
SendPlayerFormattedText(playerid,"SYS: AntySwear OFF", 0,COLOUR_WHITE);
} else if (paramid == 1)
{
sysswear=1;
SendPlayerFormattedText(playerid,"SYS: AntySwear ON", 0,COLOUR_WHITE);
} else
{
SendPlayerFormattedText(playerid, lang_texts[15][68] , 0,COLOUR_RED);
return 0;
}
return 1;
}


if(strcomp(cmd, "bomb", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new paramid;
paramid = strval(strcharsplit(text, idx,strchar(" ")));
if (paramid == 0)
{
sysmbbomb=0;
SendPlayerFormattedText(playerid,"SYS: Military Base Bombing OFF", 0,COLOUR_WHITE);
} else if (paramid == 1)
{
sysmbbomb=1;
SendPlayerFormattedText(playerid,"SYS: Military Base Bombing ON", 0,COLOUR_WHITE);
} else
{
SendPlayerFormattedText(playerid, lang_texts[15][68] , 0,COLOUR_RED);
return 0;
}
return 1;
}






return 0;
}

// SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, cmd);

