//
// Created: 18.12.2007
// Aurthor: Dmitry Frolov (FP)
//

#if defined _mod_commands_included
#endinput
#endif

#define _mod_commands_included
#pragma library mod_commands
#include "base"
#include "player"

forward ModCommandHandler(playerid,text[]);
forward ModSpecialCommandHandler(playerid,text[]);

public ModCommandHandler(playerid,text[]) // process player commands
{
if (!IsPlayerConnected(playerid)) return 0;
if ( !IsPlayerMod(playerid) && !IsPlayerAdmin(playerid) && !IsPlayerAdm(playerid) )
{
return 0;
}
new cmd[20];
new idx;
//set(cmd,strcharsplit(text, idx,strchar(" ")));
//if(strcomp(cmd, "/mod", true) == 0) return 0;
set(cmd,strcharsplit(text, idx,strchar(" ")));

if(strcomp(cmd, "/cmdlist", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

  SendClientMessage(playerid, COLOUR_LIGHTGREEN, "M: '/cmdlist', '/about', '/mute <ID>', '/unmute <ID>', '/jmpl'");
}

if(strcomp(cmd, "/about", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);
  SendClientMessage(playerid, COLOUR_LIGHTGREEN, lang_texts[15][41]);
  SendClientMessage(playerid, COLOUR_LIGHTGREEN, lang_texts[15][42]);
  SendClientMessage(playerid, COLOUR_LIGHTRED, lang_texts[15][43]);
  SendClientMessage(playerid, COLOUR_LIGHTRED, lang_texts[15][44]);
}

if(strcomp(cmd, "/jmpl", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

  SendClientMessage(playerid, COLOUR_YELLOW, lang_texts[15][46]);
  SendClientMessage(playerid, COLOUR_WHITE, "RESERVED");
}



if(strcomp(cmd, "/mute", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new muteid;
muteid = strval(strcharsplit(text, idx,strchar(" ")));

if ((muteid < 0) || (muteid >= MAX_PLAYERS) || (IsPlayerAdmin(muteid) && !IsPlayerAdmin(playerid)) )
{
SendPlayerFormattedText(playerid, lang_texts[12][22] , 0,COLOUR_RED);
return 1;
}

if (IsPlayerConnected(muteid) == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][23] , 0,COLOUR_RED);
return 1;
}

Player[muteid][Muted] = 1;

new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][24] ,oGetPlayerName(playerid));
SendPlayerFormattedText(muteid,string, 0,COLOUR_RED);

//GIVE MUTE INFO
SetPlayerWantedLevel(muteid, 3);
format(string,sizeof(string), lang_texts[12][50], oGetPlayerName(muteid));
//GameTextForAll(string,5000,4);
SendClientMessageToAll(COLOUR_WHITE, string);
printf("SERVER : %s Has Been Muted by %s",oGetPlayerName(muteid),oGetPlayerName(playerid));

return 1;
}

if(strcomp(cmd, "/unmute", true) == 1)
{
SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new unmuteid;
unmuteid = strval(strcharsplit(text, idx,strchar(" ")));

if ((unmuteid < 0) || (unmuteid >= MAX_PLAYERS) || (IsPlayerAdmin(unmuteid) && !IsPlayerAdmin(playerid)) )
{
SendPlayerFormattedText(playerid, lang_texts[12][25] , 0,COLOUR_RED);
return 1;
}

if (IsPlayerConnected(unmuteid) == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][26] , 0,COLOUR_RED);
return 1;
}

Player[unmuteid][Muted] = 0;

new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][27] ,oGetPlayerName(playerid));
SendPlayerFormattedText(unmuteid,string, 0,COLOUR_GREEN);

//GIVE UNMUTE INFO
SetPlayerWantedLevel(unmuteid, 0);
format(string,sizeof(string), lang_texts[12][51], oGetPlayerName(unmuteid));
//GameTextForAll(string,5000,4);
SendClientMessageToAll(COLOUR_WHITE, string);
printf("SERVER : %s Has Been UNMuted by %s",oGetPlayerName(unmuteid),oGetPlayerName(playerid));

return 1;
}




return 0;
}



public ModSpecialCommandHandler(playerid,text[])
{
if (!IsPlayerConnected(playerid)) return 0;

if(text[0] == '#')
{
new string[MAX_STRING];
strmid(string,text,1,strlen(text));
new count = 0;
for (new adminid=0; adminid<MAX_PLAYERS;adminid++)
{
if ( IsPlayerMod(adminid) )
	{
	new message[MAX_STRING];
	format(message,sizeof(message), lang_texts[12][79] ,oGetPlayerName(playerid),string);
	SendPlayerFormattedText(adminid,message, 0,COLOUR_RED);
	count++;
	}
}
if (count == 0)
	{
	SendPlayerFormattedText(playerid, lang_texts[12][80] , 0,COLOUR_RED);
	return 0;
	} else {
	new message[MAX_STRING];
	format(message,sizeof(message), lang_texts[12][81] ,string);
	SendPlayerFormattedText(playerid,message, 0,COLOUR_GREEN);
	return 0;
	}
}
return 0;
}