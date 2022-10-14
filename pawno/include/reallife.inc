#include <dini> 

#define STREAMER_TYPE_OBJECT (0)
#define STREAMER_TYPE_PICKUP (1)
#define STREAMER_TYPE_CP (2)
#define STREAMER_TYPE_RACE_CP (3)
#define STREAMER_TYPE_MAP_ICON (4)
#define STREAMER_TYPE_3D_TEXT_LABEL (5)
#define STREAMER_TYPE_AREA (6)

// Enumerator

enum
{
	E_STREAMER_ATTACHED_PLAYER,
	E_STREAMER_ATTACHED_VEHICLE,
	E_STREAMER_COLOR,
	E_STREAMER_DISTANCE,
	E_STREAMER_DRAW_DISTANCE,
	E_STREAMER_EXTRA_ID,
	E_STREAMER_INTERIOR_ID,
	E_STREAMER_MAX_X,
	E_STREAMER_MAX_Y,
	E_STREAMER_MAX_Z,
	E_STREAMER_MIN_X,
	E_STREAMER_MIN_Y,
	E_STREAMER_MIN_Z,
	E_STREAMER_MODEL_ID,
	E_STREAMER_MOVE_SPEED,
	E_STREAMER_MOVE_X,
	E_STREAMER_MOVE_Y,
	E_STREAMER_MOVE_Z,
	E_STREAMER_NEXT_X,
	E_STREAMER_NEXT_Y,
	E_STREAMER_NEXT_Z,
	E_STREAMER_PLAYER_ID,
	E_STREAMER_R_X,
	E_STREAMER_R_Y,
	E_STREAMER_R_Z,
	E_STREAMER_SIZE,
	E_STREAMER_STYLE,
	E_STREAMER_TEST_LOS,
	E_STREAMER_TYPE,
	E_STREAMER_WORLD_ID,
	E_STREAMER_X,
	E_STREAMER_Y,
	E_STREAMER_Z
}

// Natives (Settings)

native Streamer_TickRate(rate);
native Streamer_MaxItems(type, items);
native Streamer_VisibleItems(type, items);
native Streamer_CellDistance(Float:distance);
native Streamer_CellSize(Float:size);

// Natives (Updates)

native Streamer_Update(playerid);
native Streamer_UpdateEx(playerid, Float:x, Float:y, Float:z);

// Natives (Data Manipulation)

native Streamer_GetFloatData(type, {Text3D,_}:id, data, &Float:result);
native Streamer_SetFloatData(type, {Text3D,_}:id, data, Float:value);
native Streamer_GetIntData(type, {Text3D,_}:id, data);
native Streamer_SetIntData(type, {Text3D,_}:id, data, value);
native Streamer_IsInArrayData(type, {Text3D,_}:id, data, value);
native Streamer_AppendArrayData(type, {Text3D,_}:id, data, value);
native Streamer_RemoveArrayData(type, {Text3D,_}:id, data, value);
native Streamer_GetUpperBound(type);

// Natives (Miscellaneous)

native Streamer_IsItemVisible(playerid, type, {Text3D,_}:id);
native Streamer_DestroyAllVisibleItems(playerid, type);
native Streamer_CountVisibleItems(playerid, type);

// Natives (Objects)

native CreateDynamicObject(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid = -1, interiorid = -1, playerid = -1, Float:distance = 1000.0);
native DestroyDynamicObject(objectid);
native IsValidDynamicObject(objectid);
native SetDynamicObjectPos(objectid, Float:x, Float:y, Float:z);
native GetDynamicObjectPos(objectid, &Float:x, &Float:y, &Float:z);
native SetDynamicObjectRot(objectid, Float:rx, Float:ry, Float:rz);
native GetDynamicObjectRot(objectid, &Float:rx, &Float:ry, &Float:rz);
native MoveDynamicObject(objectid, Float:x, Float:y, Float:z, Float:speed);
native StopDynamicObject(objectid);
native DestroyAllDynamicObjects();
native CountDynamicObjects();

// Natives (Pickups)

native CreateDynamicPickup(modelid, type, Float:x, Float:y, Float:z, worldid = -1, interiorid = -1, playerid = -1, Float:distance = 100.0);
native DestroyDynamicPickup(pickupid);
native IsValidDynamicPickup(pickupid);
native DestroyAllDynamicPickups();
native CountDynamicPickups();

// Natives (Checkpoints)

native CreateDynamicCP(Float:x, Float:y, Float:z, Float:size, worldid = -1, interiorid = -1, playerid = -1, Float:distance = 100.0);
native DestroyDynamicCP(checkpointid);
native IsValidDynamicCP(checkpointid);
native TogglePlayerDynamicCP(playerid, checkpointid, toggle);
native TogglePlayerAllDynamicCPs(playerid, toggle);
native IsPlayerInDynamicCP(playerid, checkpointid);
native DestroyAllDynamicCPs();
native CountDynamicCPs();

// Natives (Race Checkpoints)

native CreateDynamicRaceCP(type, Float:x, Float:y, Float:z, Float:nextx, Float:nexty, Float:nextz, Float:size, worldid = -1, interiorid = -1, playerid = -1, Float:distance = 100.0);
native DestroyDynamicRaceCP(checkpointid);
native IsValidDynamicRaceCP(checkpointid);
native TogglePlayerDynamicRaceCP(playerid, checkpointid, toggle);
native TogglePlayerAllDynamicRaceCPs(playerid, toggle);
native IsPlayerInDynamicRaceCP(playerid, checkpointid);
native DestroyAllDynamicRaceCPs();
native CountDynamicRaceCPs();

// Natives (Map Icons)

native CreateDynamicMapIcon(Float:x, Float:y, Float:z, type, color, worldid = -1, interiorid = -1, playerid = -1, Float:distance = 400.0);
native DestroyDynamicMapIcon(iconid);
native IsValidDynamicMapIcon(iconid);
native DestroyAllDynamicMapIcons();
native CountDynamicMapIcons();

// Natives (3D Text Labels)

native Text3D:CreateDynamic3DTextLabel(const text[], color, Float:x, Float:y, Float:z, Float:drawdistance, attachedplayer = INVALID_PLAYER_ID, attachedvehicle = INVALID_VEHICLE_ID, testlos = 0, worldid = -1, interiorid = -1, playerid = -1, Float:distance = 100.0);
native DestroyDynamic3DTextLabel(Text3D:id);
native IsValidDynamic3DTextLabel(Text3D:id);
native UpdateDynamic3DTextLabelText(Text3D:id, color, const text[]);
native DestroyAllDynamic3DTextLabels();
native CountDynamic3DTextLabels();

// Natives (Areas)

native CreateDynamicCircle(Float:x, Float:y, Float:size, worldid = -1, interiorid = -1, playerid = -1);
native CreateDynamicRectangle(Float:minx, Float:miny, Float:maxx, Float:maxy, worldid = -1, interiorid = -1, playerid = -1);
native CreateDynamicSphere(Float:x, Float:y, Float:z, Float:size, worldid = -1, interiorid = -1, playerid = -1);
native CreateDynamicCube(Float:minx, Float:miny, Float:minz, Float:maxx, Float:maxy, Float:maxz, worldid = -1, interiorid = -1, playerid = -1);
native DestroyDynamicArea(areaid);
native IsValidDynamicArea(areaid);
native TogglePlayerDynamicArea(playerid, areaid, toggle);
native TogglePlayerAllDynamicAreas(playerid, toggle);
native IsPlayerInDynamicArea(playerid, areaid);
native AttachDynamicAreaToPlayer(areaid, playerid);
native AttachDynamicAreaToVehicle(areaid, vehicleid);
native DestroyAllDynamicAreas();
native CountDynamicAreas();

// Natives (Internals)

native Streamer_AddPlayer(playerid);
native Streamer_RemovePlayer(playerid);
native Streamer_VerifyPickup(playerid, pickupid);
native Streamer_VerifyCheckpoint(playerid, type, status);
native Streamer_RegisterInterface();

// Callbacks

forward OnDynamicObjectMoved(objectid);
forward OnPlayerPickUpDynamicPickup(playerid, pickupid);
forward OnPlayerEnterDynamicCP(playerid, checkpointid);
forward OnPlayerLeaveDynamicCP(playerid, checkpointid);
forward OnPlayerEnterDynamicRaceCP(playerid, checkpointid);
forward OnPlayerLeaveDynamicRaceCP(playerid, checkpointid);
forward OnPlayerEnterDynamicArea(playerid, areaid);
forward OnPlayerLeaveDynamicArea(playerid, areaid);

// Callback Hook Section

static bool:Streamer_g_OPC = false;
static bool:Streamer_g_OPDC = false;
static bool:Streamer_g_OPPP = false;
static bool:Streamer_g_OPEC = false;
static bool:Streamer_g_OPLC = false;
static bool:Streamer_g_OPERC = false;
static bool:Streamer_g_OPLRC = false;
static bool:Streamer_g_RI = false;

public OnFilterScriptInit()
{
	if (!Streamer_g_RI)
	{
		Streamer_g_OPC = funcidx("Streamer_OnPlayerConnect") != -1;
		Streamer_g_OPDC = funcidx("Streamer_OnPlayerDisconnect") != -1;
		Streamer_g_OPPP = funcidx("Streamer_OnPlayerPickUpPickup") != -1;
		Streamer_g_OPEC = funcidx("Streamer_OnPlayerEnterCP") != -1;
		Streamer_g_OPLC = funcidx("Streamer_OnPlayerLeaveCP") != -1;
		Streamer_g_OPERC = funcidx("Streamer_OnPlayerEnterRaceCP") != -1;
		Streamer_g_OPLRC = funcidx("Streamer_OnPlayerLeaveRaceCP") != -1;
		Streamer_g_RI = true;
		Streamer_RegisterInterface();
	}
	if (funcidx("Streamer_OnFilterScriptInit") != -1)
	{
		return CallLocalFunction("Streamer_OnFilterScriptInit", "");
	}
	return 1;
}

#if defined _ALS_OnFilterScriptInit
	#undef OnFilterScriptInit
#else
	#define _ALS_OnFilterScriptInit
#endif
#define OnFilterScriptInit Streamer_OnFilterScriptInit

forward Streamer_OnFilterScriptInit();

public OnGameModeInit()
{
	if (!Streamer_g_RI)
	{
		Streamer_g_OPC = funcidx("Streamer_OnPlayerConnect") != -1;
		Streamer_g_OPDC = funcidx("Streamer_OnPlayerDisconnect") != -1;
		Streamer_g_OPPP = funcidx("Streamer_OnPlayerPickUpPickup") != -1;
		Streamer_g_OPEC = funcidx("Streamer_OnPlayerEnterCP") != -1;
		Streamer_g_OPLC = funcidx("Streamer_OnPlayerLeaveCP") != -1;
		Streamer_g_OPERC = funcidx("Streamer_OnPlayerEnterRaceCP") != -1;
		Streamer_g_OPLRC = funcidx("Streamer_OnPlayerLeaveRaceCP") != -1;
		Streamer_g_RI = true;
		Streamer_RegisterInterface();
	}
	if (funcidx("Streamer_OnGameModeInit") != -1)
	{
		return CallLocalFunction("Streamer_OnGameModeInit", "");
	}
	return 1;
}

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Streamer_OnGameModeInit

forward Streamer_OnGameModeInit();

public OnPlayerConnect(playerid)
{
	if (!IsPlayerNPC(playerid))
	{
		Streamer_AddPlayer(playerid);
	}
	if (Streamer_g_OPC)
	{
		return CallLocalFunction("Streamer_OnPlayerConnect", "d", playerid);
	}
	return 1;
}

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Streamer_OnPlayerConnect

forward Streamer_OnPlayerConnect(playerid);

public OnPlayerDisconnect(playerid, reason)
{
	if (!IsPlayerNPC(playerid))
	{
		Streamer_RemovePlayer(playerid);
	}
	if (Streamer_g_OPDC)
	{
		return CallLocalFunction("Streamer_OnPlayerDisconnect", "dd", playerid, reason);
	}
	return 1;
}

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Streamer_OnPlayerDisconnect

forward Streamer_OnPlayerDisconnect(playerid, reason);

public OnPlayerPickUpPickup(playerid, pickupid)
{
	if (!IsPlayerNPC(playerid))
	{
		Streamer_VerifyPickup(playerid, pickupid);
	}
	if (Streamer_g_OPPP)
	{
		return CallLocalFunction("Streamer_OnPlayerPickUpPickup", "dd", playerid, pickupid);
	}
	return 1;
}

#if defined _ALS_OnPlayerPickUpPickup
	#undef OnPlayerPickUpPickup
#else
	#define _ALS_OnPlayerPickUpPickup
#endif
#define OnPlayerPickUpPickup Streamer_OnPlayerPickUpPickup

forward Streamer_OnPlayerPickUpPickup(playerid, pickupid);

public OnPlayerEnterCheckpoint(playerid)
{
	if (!IsPlayerNPC(playerid))
	{
		Streamer_VerifyCheckpoint(playerid, STREAMER_TYPE_CP, 0);
	}
	if (Streamer_g_OPEC)
	{
		return CallLocalFunction("Streamer_OnPlayerEnterCP", "d", playerid);
	}
	return 1;
}

#if defined _ALS_OnPlayerEnterCheckpoint
	#undef OnPlayerEnterCheckpoint
#else
	#define _ALS_OnPlayerEnterCheckpoint
#endif
#define OnPlayerEnterCheckpoint Streamer_OnPlayerEnterCP

forward Streamer_OnPlayerEnterCP(playerid);

public OnPlayerLeaveCheckpoint(playerid)
{
	if (!IsPlayerNPC(playerid))
	{
		Streamer_VerifyCheckpoint(playerid, STREAMER_TYPE_CP, 1);
	}
	if (Streamer_g_OPLC)
	{
		return CallLocalFunction("Streamer_OnPlayerLeaveCP", "d", playerid);
	}
	return 1;
}

#if defined _ALS_OnPlayerLeaveCheckpoint
	#undef OnPlayerLeaveCheckpoint
#else
	#define _ALS_OnPlayerLeaveCheckpoint
#endif
#define OnPlayerLeaveCheckpoint Streamer_OnPlayerLeaveCP

forward Streamer_OnPlayerLeaveCP(playerid);

public OnPlayerEnterRaceCheckpoint(playerid)
{
	if (!IsPlayerNPC(playerid))
	{
		Streamer_VerifyCheckpoint(playerid, STREAMER_TYPE_RACE_CP, 0);
	}
	if (Streamer_g_OPERC)
	{
		return CallLocalFunction("Streamer_OnPlayerEnterRaceCP", "d", playerid);
	}
	return 1;
}

#if defined _ALS_OnPlayerEnterRaceCP
	#undef OnPlayerEnterRaceCheckpoint
#else
	#define _ALS_OnPlayerEnterRaceCP
#endif
#define OnPlayerEnterRaceCheckpoint Streamer_OnPlayerEnterRaceCP

forward Streamer_OnPlayerEnterRaceCP(playerid);

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	if (!IsPlayerNPC(playerid))
	{
		Streamer_VerifyCheckpoint(playerid, STREAMER_TYPE_RACE_CP, 1);
	}
	if (Streamer_g_OPLRC)
	{
		return CallLocalFunction("Streamer_OnPlayerLeaveRaceCP", "d", playerid);
	}
	return 1;
}

#if defined _ALS_OnPlayerLeaveRaceCP
	#undef OnPlayerLeaveRaceCheckpoint
#else
	#define _ALS_OnPlayerLeaveRaceCP
#endif
#define OnPlayerLeaveRaceCheckpoint Streamer_OnPlayerLeaveRaceCP

forward Streamer_OnPlayerLeaveRaceCP(playerid);

// PAWN Invoke Section

forward Streamer_PublicFunction();

public Streamer_PublicFunction()
{
	new Float:value;
	CreatePickup(0, 0, 0.0, 0.0, 0.0, 0);
	CreatePlayer3DTextLabel(0, "", 0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0);
	CreatePlayerObject(0, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	DeletePlayer3DTextLabel(0, PlayerText3D:0);
	DestroyPickup(0);
	DestroyPlayerObject(0, 0);
	DisablePlayerCheckpoint(0);
	DisablePlayerRaceCheckpoint(0);
	GetPlayerInterior(0);
	GetPlayerPos(0, value, value, value);
	GetPlayerState(0);
	GetPlayerVirtualWorld(0);
	GetVehiclePos(0, value, value, value);
	MovePlayerObject(0, 0, 0.0, 0.0, 0.0, 0.0);
	RemovePlayerMapIcon(0, 0);
	SetPlayerCheckpoint(0, 0.0, 0.0, 0.0, 0.0);
	SetPlayerMapIcon(0, 0, 0.0, 0.0, 0.0, 0, 0, 0);
	SetPlayerObjectPos(0, 0, 0.0, 0.0, 0.0);
	SetPlayerObjectRot(0, 0, 0.0, 0.0, 0.0);
	SetPlayerRaceCheckpoint(0, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	StopPlayerObject(0, 0);
	UpdatePlayer3DTextLabelText(0, PlayerText3D:0, 0, "");
	return 1;
}

IsNumeric(const string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return 0;
	}
	return 1;
}

ReturnUser(text[], playerid = INVALID_PLAYER_ID)
{
	new pos = 0;
	while (text[pos] < 0x21) // Strip out leading spaces
	{
		if (text[pos] == 0) return INVALID_PLAYER_ID; // No passed text
		pos++;
	}
	new userid = INVALID_PLAYER_ID;
	if (IsNumeric(text[pos])) // Check whole passed string
	{
		// If they have a numeric name you have a problem (although names are checked on id failure)
		userid = strval(text[pos]);
		if (userid >=0 && userid < MAX_PLAYERS)
		{
			if(!IsPlayerConnected(userid))
			{
				/*if (playerid != INVALID_PLAYER_ID)
				{
					SendClientMessage(playerid, 0xFF0000AA, "User not connected");
				}*/
				userid = INVALID_PLAYER_ID;
			}
			else
			{
				return userid; // A player was found
			}
		}
		/*else
		{
			if (playerid != INVALID_PLAYER_ID)
			{
				SendClientMessage(playerid, 0xFF0000AA, "Invalid user ID");
			}
			userid = INVALID_PLAYER_ID;
		}
		return userid;*/
		// Removed for fallthrough code
	}
	// They entered [part of] a name or the id search failed (check names just incase)
	new len = strlen(text[pos]);
	new count = 0;
	new name[MAX_PLAYER_NAME];
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			GetPlayerName(i, name, sizeof (name));
			if (strcmp(name, text[pos], true, len) == 0) // Check segment of name
			{
				if (len == strlen(name)) // Exact match
				{
					return i; // Return the exact player on an exact match
					// Otherwise if there are two players:
					// Me and MeYou any time you entered Me it would find both
					// And never be able to return just Me's id
				}
				else // Partial match
				{
					count++;
					userid = i;
				}
			}
		}
	}
	if (count != 1)
	{
		if (playerid != INVALID_PLAYER_ID)
		{
			if (count)
			{
				SendClientMessage(playerid, 0xFF0000AA, "Multiple users found, please narrow earch");
			}
			else
			{
				SendClientMessage(playerid, 0xFF0000AA, "No matching user found");
			}
		}
		userid = INVALID_PLAYER_ID;
	}
	return userid; // INVALID_USER_ID for bad return
}

// Список цветов

// Список градиентных цветов
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GRAD3 0xCBCCCEFF
#define COLOR_GRAD4 0xD8D8D8FF
#define COLOR_GRAD5 0xE3E3E3FF
#define COLOR_GRAD6 0xF0F0F0FF

#define OBJECTIVE_COLOR 0x64000064
#define TEAM_GREEN_COLOR 0xFFFFFFAA
#define TEAM_JOB_COLOR 0xFFB6C1AA
#define TEAM_HIT_COLOR 0xFFFFFF00
#define TEAM_BLUE_COLOR 0x8D8DFF00
#define COLOR_ADD 0x63FF60AA
#define TEAM_GROVE_COLOR 0x00D900C8
#define TEAM_VAGOS_COLOR 0xFFC801C8
#define TEAM_BALLAS_COLOR 0xD900D3C8
#define TEAM_AZTECAS_COLOR 0x01FCFFC8
#define TEAM_CYAN_COLOR 0xFF8282AA
#define TEAM_ORANGE_COLOR 0xFF830000
#define TEAM_COR_COLOR 0x39393900
#define TEAM_BAR_COLOR 0x00D90000
#define TEAM_TAT_COLOR 0xBDCB9200
#define TEAM_CUN_COLOR 0xD900D300
#define TEAM_STR_COLOR 0x01FCFF00
#define TEAM_ADMIN_COLOR 0x00808000
#define COLOR_INVIS 0xAFAFAF00
#define COLOR_SPEC 0xBFC0C200
#define COLOR_XD 0xA9C4E4AA
#define COLOR_GREEN2 0x0D74FFF
#define COLOR_RED2 0xFF5F3CFF
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_LIME 0x10F441AA
#define COLOR_MAGENTA 0xFF00FFFF
#define COLOR_NAVY 0x000080AA
#define COLOUR_MONEY_BAD 0xDAA520AA
#define COLOR_AQUA 0xF0F8FFAA
#define COLOR_CRIMSON 0xDC143CAA
#define COLOR_FLBLUE 0x6495EDAA
#define COLOR_BISQUE 0xFFE4C4AA
#define COLOR_BLACK 0x000000AA
#define COLOR_CHARTREUSE 0x7FFF00AA
#define COLOR_BROWN 0xA52A2AAA
#define COLOR_CORAL 0xFF7F50AA
#define COLOR_GOLD 0xB8860BAA
#define COLOR_GREENYELLOW 0xADFF2FAA
#define COLOR_INDIGO 0x4B00B0AA
#define COLOR_IVORY 0xFFFF82AA
#define COLOR_LAWNGREEN 0x7CFC00AA
#define COLOR_LIMEGREEN 0x32CD32AA
#define COLOR_MIDNIGHTBLUE 0x191970AA
#define COLOR_MAROON 0x800000AA
#define COLOR_OLIVE 0x808000AA
#define COLOR_ORANGERED 0xFF4500AA
#define COLOR_PINK 0xFFC0CBAA
#define COLOR_SPRINGGREEN 0x00FF7FAA
#define COLOR_TOMATO 0xFF6347AA
#define COLOR_YELLOWGREEN 0x9ACD32AA
#define COLOR_MEDIUMAQUA 0x83BFBFAA
#define COLOR_MEDIUMMAGENTA 0x8B008BAA
#define COLOR_BRIGHTRED 0xDC143CAA
#define COLOR_SYSTEM 0xEFEFF7AA

#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_LIGHTRED 0xFF6347AA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_LIGHTGREEN 0x9ACD32AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_YELLOW2 0xF5DEB3AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_FADE1 0xE6E6E6E6
#define COLOR_FADE2 0xC8C8C8C8
#define COLOR_FADE3 0xAAAAAAAA
#define COLOR_FADE4 0x8C8C8C8C
#define COLOR_FADE5 0x6E6E6E6E
#define COLOR_PURPLE 0xC2A2DAAA
#define COLOR_DBLUE 0x2641FEAA
#define COLOR_ALLDEPT 0xFF8282AA
#define COLOR_NEWS 0xFFA500AA
#define COLOR_OOC 0xE0FFFFAA
#define COLOR_YELLOW3d 0xFFFF00FF
