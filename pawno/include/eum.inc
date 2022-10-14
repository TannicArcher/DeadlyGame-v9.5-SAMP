// [INC] Easy User Menu 0.4 - by Luka P.
// http://forum.sa-mp.com/index.php?topic=179361.0

#if defined _eum_included
	#endinput
#endif
#define _eum_included

#pragma library EUM

#if !defined _samp_included
	#include "a_samp.inc"
#endif
#if !defined _streamer_included
	#include "streamer.inc"
#endif
#if !defined sscanf && !defined unformat
	#include "sscanf2.inc"
#endif

#define INVALID_EUM_ID  	(-1)
#define EUM_MAX_STRING  	(1024)
#define EUM_CANCELED_TEXT 	"SERVER: Selection Canceled."

new Text:EUM_Textdraw	[MAX_PLAYERS];
new EUM_UsingTextdraw	[MAX_PLAYERS];
new EUM_OptionRange		[MAX_PLAYERS];
new EUM_InformationID	[MAX_PLAYERS];
new EUM_Title           [MAX_PLAYERS];
new EUM_Text            [MAX_PLAYERS];

forward OnPlayerResponse(playerid, option);
forward InitTextdrawForPlayer(playerid);

public OnPlayerConnect(playerid)
{
	EUM_UsingTextdraw[playerid] = 0;
	InitTextdrawForPlayer(playerid);

	if (funcidx("EUM_OnPlayerConnect") != -1)
	{
		return CallLocalFunction("EUM_OnPlayerConnect", "i", playerid);
	}
	return 1;
}

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect EUM_OnPlayerConnect
forward EUM_OnPlayerConnect(playerid);

public OnPlayerDisconnect(playerid, reason)
{
	EUM_DestroyForPlayer(playerid);
	
	if (funcidx("EUM_OnPlayerDisconnect") != -1)
	{
		return CallLocalFunction("EUM_OnPlayerDisconnect", "ii", playerid, reason);
	}
	return 1;
}

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect EUM_OnPlayerDisconnect
forward EUM_OnPlayerDisconnect(playerid, reason);

public OnPlayerText(playerid, text[])
{
	if(EUM_UsingTextdraw[playerid] && EUM_OptionRange[playerid] > 0)
	{
	    new option;
	    if(!sscanf(text, "i", option))
	    {
	        if(option >= 1 && option <= EUM_OptionRange[playerid])
	        {
	            CallRemoteFunction("OnPlayerResponse", "ii", playerid, option);
	            return 0;
	        }
 		}
	}
	
	if (funcidx("EUM_OnPlayerText") != -1)
	{
		return CallLocalFunction("EUM_OnPlayerText", "is", playerid, text);
	}
	return 1;
}

#if defined _ALS_OnPlayerText
	#undef OnPlayerText
#else
	#define _ALS_OnPlayerText
#endif
#define OnPlayerText EUM_OnPlayerText
forward EUM_OnPlayerText(playerid, text[]);

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(EUM_UsingTextdraw[playerid] == 1)
	{
	    if(newkeys & KEY_FIRE)
	    {
			EUM_DestroyForPlayer(playerid);
			SendClientMessage(playerid, 0xE00000AA, EUM_CANCELED_TEXT);
	    }
	}
	
	if (funcidx("EUM_OnPlayerKeyStateChange") != -1)
	{
		return CallLocalFunction("EUM_OnPlayerKeyStateChange", "iii", playerid, newkeys, oldkeys);
	}
	return 1;
}

#if defined _ALS_OnPlayerKeyStateChange
	#undef OnPlayerKeyStateChange
#else
	#define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange EUM_OnPlayerKeyStateChange
forward EUM_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);

public InitTextdrawForPlayer(playerid)
{
    EUM_Textdraw[playerid] = TextDrawCreate(24.000000, 118.000000, "_");
	TextDrawBackgroundColor(EUM_Textdraw[playerid], 255);
	TextDrawFont(EUM_Textdraw[playerid], 1);
	TextDrawLetterSize(EUM_Textdraw[playerid], 0.270000, 1.000000);
	TextDrawColor(EUM_Textdraw[playerid], -1);
	TextDrawSetOutline(EUM_Textdraw[playerid], 0);
	TextDrawSetProportional(EUM_Textdraw[playerid], 1);
	TextDrawSetShadow(EUM_Textdraw[playerid], 1);
	TextDrawUseBox(EUM_Textdraw[playerid], 1);
	TextDrawBoxColor(EUM_Textdraw[playerid], 555819339);
	TextDrawTextSize(EUM_Textdraw[playerid], 209.000000, 0.000000);
	return 1;
}

stock EUM_ShowForPlayer(playerid, id, title[], text[], optionRange = 0)
{
	new string[EUM_MAX_STRING];

	format(string, sizeof(string), "~w~%s~n~~n~%s~n~~n~~w~Press ~g~LMB~w~ to close this message box.", title, text);
	EUM_DestroyForPlayer(playerid);
	
	EUM_Textdraw[playerid] = TextDrawCreate(24.000000, 118.000000, string);
	TextDrawBackgroundColor(EUM_Textdraw[playerid], 255);
	TextDrawFont(EUM_Textdraw[playerid], 1);
	TextDrawLetterSize(EUM_Textdraw[playerid], 0.270000, 1.000000);
	TextDrawColor(EUM_Textdraw[playerid], -1);
	TextDrawSetOutline(EUM_Textdraw[playerid], 0);
	TextDrawSetProportional(EUM_Textdraw[playerid], 1);
	TextDrawSetShadow(EUM_Textdraw[playerid], 1);
	TextDrawUseBox(EUM_Textdraw[playerid], 1);
	TextDrawBoxColor(EUM_Textdraw[playerid], 555819339);
	TextDrawTextSize(EUM_Textdraw[playerid], 209.000000, 0.000000);
	

	EUM_UsingTextdraw[playerid] = 1;
	EUM_OptionRange[playerid] = optionRange;
	EUM_InformationID[playerid] = id;

	strmid(EUM_Title[playerid], title, 0, strlen(title));
	strmid(EUM_Text[playerid], text, 0, strlen(text));
	
	TextDrawShowForPlayer(playerid, EUM_Textdraw[playerid]);
	return 1;
}

stock EUM_ShowForAll(id, title[], text[], optionRange = 0)
{
	for(new i=0; i < MAX_PLAYERS; i++)
	{
	    EUM_ShowForPlayer(i, id, title, text, optionRange);
	}
	return 1;
}

stock EUM_DestroyForPlayer(playerid)
{
	TextDrawHideForPlayer(playerid, EUM_Textdraw[playerid]);
    TextDrawDestroy(EUM_Textdraw[playerid]);
	EUM_UsingTextdraw[playerid] = 0;
	EUM_OptionRange[playerid] = 0;
	EUM_InformationID[playerid] = INVALID_EUM_ID;
	strmid(EUM_Title, "\0", 0, 0);
	strmid(EUM_Text, "\0", 0, 0);
	return 1;
}

stock EUM_DestroyForAll()
{
	for(new i=0; i < MAX_PLAYERS; i++)
	{
	    EUM_DestroyForPlayer(i);
	}
	return 1;
}

stock EUM_Indentify(playerid, id)
{
	if(EUM_InformationID[playerid] == id) return true; else return false;
}

