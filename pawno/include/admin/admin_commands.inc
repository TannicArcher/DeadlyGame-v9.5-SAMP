//
// Created: 04.11.06
// Aurthor: Iain Gilbert, represent by Dmitry Frolov (FP)
//

#if defined _admin_commands_included
#endinput
#endif

#define _admin_commands_included
#pragma library admin_commands
#include "base"
#include "utils\gtoutils"
#include "player"
#include "account"
#include "race"
#include "payday"

forward AdminCommandHandler(playerid,text[]);
forward AdminSpecialCommandHandler(playerid,text[]);
forward SendMessageToAdmins(playerid, color, text[]);

stock IsSkinValid(SkinID) return ((SkinID == 0)||(SkinID == 7)||(SkinID >= 9 && SkinID <= 41)||(SkinID >= 43 && SkinID <= 64)||(SkinID >= 66 && SkinID <= 73)||(SkinID >= 75 && SkinID <= 85)||(SkinID >= 87 && SkinID <= 118)||(SkinID >= 120 && SkinID <= 148)||(SkinID >= 150 && SkinID <= 207)||(SkinID >= 209 && SkinID <= 264)||(SkinID >= 274 && SkinID <= 288)||(SkinID >= 290 && SkinID <= 299)) ? true:false;

// Tick count of the last time the thing was saved.
new Float:LocX[MAX_PLAYERS] = 0.0;
new Float:LocY[MAX_PLAYERS] = 0.0;
new Float:LocZ[MAX_PLAYERS] = 0.0;
new Float:Ang[MAX_PLAYERS];

#define POINTSHOMES 10
new Float:PointsH[POINTSHOMES][CoordInfo] = {
{-2824.375488,2176.859375,180.767562},
{-2233.071289,-1736.994506,480.829284},
{-2541.038574,-627.034057,147.906311},
{-1346.315307,492.034332,11.202690},
{2838.117431,-2542.724853,18.346969},
{1562.584350,-1358.699218,329.453460},
{1976.502441,1916.305297,130.934509},
{1481.328125,-1790.289794,156.753326},
{1067.241821,2919.043945,47.823116},
{2836.330566,2595.337890,22.441707}
};

public AdminCommandHandler(playerid,text[]) // process player commands
{
if (!IsPlayerConnected(playerid)) return 0;
if ( !IsPlayerAdmin(playerid) )
{
return 0;
}

new cmd[20];
new idx;
//set(cmd,strcharsplit(text, idx,strchar(" ")));
//if(strcomp(cmd, "/admin", true) == 0) return 0;

set(cmd,strcharsplit(text, idx,strchar(" ")));

if(strcomp(cmd, "/cmdlist", true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

  SendClientMessage(playerid, COLOUR_GREEN, "Administrator RCON:______________________________________________________________");
  SendClientMessage(playerid, COLOUR_WHITE, "R: '/ssay <text>', '/boom <IDboom>', '/setlvl <ID> <lvl>', '/setstatus <ID> <status> (0,1-10,11-256)'");
  SendClientMessage(playerid, COLOUR_WHITE, "R: '/disarm <ID>', '/disarmall', '/skydiveall', '/paralyzeall', '/deparalyzeall', '/remcash <ID>', '/remcashall'");
  SendClientMessage(playerid, COLOUR_WHITE, "R: '/payday'");
}


if(strcomp(cmd, "/go", true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);
new pointt;
pointt = strval(strcharsplit(text, idx,strchar(" ")));
if ((pointt < 0) || (pointt > 9)) {return 1;}
SetPlayerPos (playerid, PointsH[pointt][Coord_X], PointsH[pointt][Coord_Y], PointsH[pointt][Coord_Z]+0.1);
}


if(strcomp(cmd, "/payday", true) == 1)
{
admpayday=256;
PayDay();
  SendClientMessage(playerid, COLOUR_WHITE, lang_texts[12][90]);
}

if(strcomp(cmd, "/about", true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

  SendClientMessage(playerid, COLOUR_GREEN, "Administrator RCON:______________________________________________________________");
  SendClientMessage(playerid, COLOUR_LIGHTRED, lang_texts[15][51]);
  SendClientMessage(playerid, COLOUR_WHITE, lang_texts[15][52]);
  SendClientMessage(playerid, COLOUR_WHITE, lang_texts[15][53]);
  SendClientMessage(playerid, COLOUR_WHITE, lang_texts[15][54]);
  SendClientMessage(playerid, COLOUR_YELLOW, lang_texts[15][55]);
}

if(strcomp(cmd, "/boom", true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new bomamount;
bomamount = strval(strcharsplit(text, idx,strchar(" ")));
new Float:X;
new Float:Y;
new Float:Z;
GetPlayerPos(playerid,X,Y,Z);
CreateExplosion((X+20), Y, (Z+2), bomamount, 30);
return 1;
}


if(strcomp(cmd, "/ssay", true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new string[MAX_STRING];
set(string,text);
strdel(string, 0, idx);
format(string,sizeof(string), lang_texts[12][1] ,string);
SendClientMessageToAll(COLOUR_YELLOW, string);
return 1;
}

if(strcomp(cmd, "/skydiveall", true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new string[MAX_STRING];
new Float:playerx,Float:playery,Float:playerz;

for (new id = 0; id < MAX_PLAYERS; id++)
{
if (IsPlayerConnected(id) && (Player[id][Jailed] == 0))
	{
	GivePlayerWeapon(id,46,1);
	GetPlayerPos(id,playerx,playery,playerz);
	PlayerPlaySound(id,1058,0,0,0);
	SetPlayerPos(id,playerx,playery,playerz+1200);
	}
if (Player[id][Jailed] == 1)
	{
	SendPlayerFormattedText(id, lang_texts[1][22], 0,COLOUR_LIGHTRED);
	}
}
SendClientMessageToAll(COLOUR_WHITE,lang_texts[1][19]);
format(string,sizeof(string), lang_texts[1][20]);
GameTextForAll(string,5000,6);

//	format(string,sizeof(string), lang_texts[1][21] ,oGetPlayerName(playerid),playerid);
//	SendClientMessageToRegistered(COLOUR_GREY, string);
return 1;
}


if(strcomp(cmd, "/disarm", true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new receiverid;
receiverid = strval(strcharsplit(text, idx,strchar(" ")));
if ((receiverid < 0) || (receiverid >= MAX_PLAYERS))
{
SendPlayerFormattedText(playerid, lang_texts[12][9] , 0,COLOUR_RED);
return 1;
}
if (IsPlayerConnected(receiverid) == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][10] , 0,COLOUR_RED);
return 1;
}
ResetPlayerWeapons(receiverid);
for (new i=1;i<MAX_WEAPONS;i++)
{
	PlayerWeapons[receiverid][i] = 0;
}

new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][48] ,oGetPlayerName(playerid));			//игроку
SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);
format(string,sizeof(string), lang_texts[12][49] ,oGetPlayerName(receiverid));
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}



if(strcomp(cmd, "/disarmall", true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new string[MAX_STRING];
for (new id = 0; id < MAX_PLAYERS; id++)
{
if ( (id < playerid) || (id > playerid) )
	{
	if (IsPlayerConnected(id) && (Player[id][Jailed] == 0))
		{
		if (IsPlayerConnected(id) == 0) { return 0; }
		if (IsPlayerAdmin(id) == 1) { return 0; }
		ResetPlayerWeapons(id);
		for (new i=1;i<MAX_WEAPONS;i++)
		{
		PlayerWeapons[id][i] = 0;
		}
		format(string,sizeof(string), lang_texts[12][48] ,oGetPlayerName(playerid));	//игроку
		SendPlayerFormattedText(id,string, 0,COLOUR_XP_GOOD);
		}
	}
}
format(string,sizeof(string), lang_texts[12][75]);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}


if(strcomp(cmd, "/paralyzeall", true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new string[MAX_STRING];
for (new id = 0; id < MAX_PLAYERS; id++)
{
if ( (id < playerid) || (id > playerid) )
	{
	if (IsPlayerConnected(id) && (Player[id][Jailed] == 0))
		{
		if (IsPlayerConnected(id) == 0) { return 0; }
		if (IsPlayerAdmin(id) == 1) { return 0; }
		TogglePlayerControllable(id,0);
		format(string,sizeof(string), lang_texts[12][54] ,oGetPlayerName(playerid));//игроку
		SendPlayerFormattedText(id,string, 0,COLOUR_XP_GOOD);
		}
	}
}
format(string,sizeof(string), lang_texts[12][76]);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}


if(strcomp(cmd, "/deparalyzeall", true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new string[MAX_STRING];
for (new id = 0; id < MAX_PLAYERS; id++)
{
if ( (id < playerid) || (id > playerid) )
	{
	if (IsPlayerConnected(id) && (Player[id][Jailed] == 0))
		{
		if (IsPlayerConnected(id) == 0) { return 0; }
		if (IsPlayerAdmin(id) == 1) { return 0; }
		TogglePlayerControllable(id,1);
		format(string,sizeof(string), lang_texts[12][56] ,oGetPlayerName(playerid));//игроку
		SendPlayerFormattedText(id,string, 0,COLOUR_XP_GOOD);
		}
	}
}
format(string,sizeof(string), lang_texts[12][77]);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}

if(strcomp(cmd, "/remcash", true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new receiverid;
receiverid = strval(strcharsplit(text, idx,strchar(" ")));
if ((receiverid < 0) || (receiverid >= MAX_PLAYERS) || (IsPlayerAdmin(receiverid) && !IsPlayerAdmin(playerid)) )
{
SendPlayerFormattedText(playerid, lang_texts[12][9] , 0,COLOUR_RED);
return 1;
}
if (IsPlayerConnected(receiverid) == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][10] , 0,COLOUR_RED);
return 1;
}
ResetPlayerMoney(receiverid);

new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][58] ,oGetPlayerName(playerid));			//игроку
SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);
format(string,sizeof(string), lang_texts[12][59] ,oGetPlayerName(receiverid));
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}


if(strcomp(cmd, "/remcashall", true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new string[MAX_STRING];
for (new id = 0; id < MAX_PLAYERS; id++)
{
if ( (id < playerid) || (id > playerid) )
	{
	if (IsPlayerConnected(id) && (Player[id][Jailed] == 0))
		{
		if (IsPlayerConnected(id) == 0) { return 0; }
		if (IsPlayerAdmin(id) == 1) { return 0; }
		ResetPlayerMoney(id);
		format(string,sizeof(string), lang_texts[12][58] ,oGetPlayerName(playerid));//игроку
		SendPlayerFormattedText(id,string, 0,COLOUR_XP_GOOD);
		}
	}
}
format(string,sizeof(string), lang_texts[12][78]);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}

if(strcomp(cmd, "/setlvl", true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new receiverid;
receiverid = strval(strcharsplit(text, idx,strchar(" ")));
if ((receiverid < 0) || (receiverid >= MAX_PLAYERS) || (IsPlayerAdmin(receiverid) && !IsPlayerAdmin(playerid)) )
{
SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
return 1;
}
if (IsPlayerConnected(receiverid) == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][3] , 0,COLOUR_RED);
return 1;
}

new lvlamount;
lvlamount = strval(strcharsplit(text, idx,strchar(" ")));
if ((lvlamount < 0) || (lvlamount > MAX_LEVEL))
{
SendPlayerFormattedText(playerid, lang_texts[12][33] , 0,COLOUR_RED);
return 1;
}

if (!IsPlayerAdmin(receiverid) && (lvlamount >MAX_LEVEL-1))
{
SendPlayerFormattedText(playerid, lang_texts[12][39] , 0,COLOUR_RED);
return 1;
}
new lvlthisday;
lvlthisday = CalculatePlayerLevel(receiverid);
//SetPlayerXP(receiverid,0);
SetPlayerXP(receiverid, LevelList[lvlamount][level_xp]);
CheckPlayerLevel(receiverid);

new string[MAX_STRING];
format(string,sizeof(string), lang_texts[12][31] ,oGetPlayerName(playerid),lvlamount);
SendPlayerFormattedText(receiverid,string, 0,COLOUR_XP_GOOD);

format(string,sizeof(string), lang_texts[12][32] ,oGetPlayerName(receiverid),lvlamount,lvlthisday);
SendPlayerFormattedText(playerid,string, 0,COLOUR_XP_GOOD);
return 1;
}


// SET STATUS FOR PLAYER 0-JUST GAMER, 1-10-MOD, 11>ADMIN

if(strcomp(cmd, "/setstatus", true) == 1)
{
//SendMessageToAdmins(playerid,COLOUR_LIGHTGREEN, text);

new receiverid;
receiverid = strval(strcharsplit(text, idx,strchar(" ")));
if ((receiverid < 0) || (receiverid >= MAX_PLAYERS))
{
SendPlayerFormattedText(playerid, lang_texts[12][2] , 0,COLOUR_RED);
return 1;
}
if (IsPlayerConnected(receiverid) == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][3] , 0,COLOUR_RED);
return 1;
}
new sid;
sid = strval(strcharsplit(text, idx,strchar(" ")));
if ((sid < 0) || (sid > 255))
{
SendPlayerFormattedText(playerid, lang_texts[12][44] , 0,COLOUR_RED);
return 1;
}
if (sid<255 && IsPlayerAdmin(receiverid))
	{
	SendPlayerFormattedText(playerid, lang_texts[12][89] , 0,COLOUR_RED);
	return 1;
	}
new string[MAX_STRING];
new sidstring[MAX_STRING];
if (sid>10) {format(sidstring,sizeof(sidstring),lang_texts[12][86],sid);}
else if ( (sid>=1) && (sid<=10) ) {format(sidstring,sizeof(sidstring),lang_texts[12][87],sid);}
else {format(sidstring,sizeof(sidstring),lang_texts[12][88]);}

if (sid>1)
{
format(string,sizeof(string), lang_texts[12][82] ,oGetPlayerName(playerid), playerid, sidstring);
SendPlayerFormattedText(receiverid,string, 0,COLOUR_WHITE);
format(string,sizeof(string), lang_texts[12][83] ,oGetPlayerName(receiverid), receiverid, sidstring);
SendPlayerFormattedText(playerid,string, 0,COLOUR_WHITE);
} else {
	format(string,sizeof(string), lang_texts[12][84] ,oGetPlayerName(playerid), playerid);
	SendPlayerFormattedText(receiverid,string, 0,COLOUR_WHITE);
	format(string,sizeof(string), lang_texts[12][85] ,oGetPlayerName(receiverid), receiverid);
	SendPlayerFormattedText(playerid,string, 0,COLOUR_WHITE);
	}
Player[receiverid][Status]=sid;
player_save_db_dini(receiverid);
return 1;
}




return 0;
}

public AdminSpecialCommandHandler(playerid,text[])
{
if (!IsPlayerConnected(playerid)) return 0;

if(text[0] == '@')
{
new string[MAX_STRING];
strmid(string,text,1,strlen(text));
new count = 0;
for (new adminid=0; adminid<MAX_PLAYERS;adminid++)
{
if ( IsPlayerAdmin(adminid) && IsPlayerAdm(adminid) )
{
new message[MAX_STRING];
format(message,sizeof(message), lang_texts[12][28] ,oGetPlayerName(playerid),string);
SendPlayerFormattedText(adminid,message, 0,COLOUR_RED);
count++;
}
}
if (count == 0)
{
SendPlayerFormattedText(playerid, lang_texts[12][29] , 0,COLOUR_RED);
return 0;
} else {
new message[MAX_STRING];
format(message,sizeof(message), lang_texts[12][30] ,string);
SendPlayerFormattedText(playerid,message, 0,COLOUR_GREEN);
return 0;
}
}
return 0;
}


SendMessageToAdmins(playerid, color, text[])
{
new string[MAX_STRING];
new message[MAX_STRING];
strmid(string,text,0,strlen(text));

format(message,sizeof(message), lang_texts[1][24] ,oGetPlayerName(playerid), playerid, string);
printf("%s",message);

for (new aid=0; aid<MAX_PLAYERS;aid++)
{
	if ( IsPlayerAdmin(aid) && IsPlayerAdm(aid) )
	{
		if (aid == playerid)
		{
		
		} else {
			format(message,sizeof(message), lang_texts[1][23] ,oGetPlayerName(playerid), playerid, Player[playerid][Status], string);
			SendPlayerFormattedText(aid,message, 0,color);
			}
	}
}
return 0;
}