/////////////////////////////////////////////////
/// АНТИЧИТ НА ДЕНЬГИ by Green                
////////////////////////////////////////////////
///  У С Т А Н О В К А
//1.в начале мода после #include <a_samp> вписать #include <weaponhack>
//2. Вставить:
//
//   * Hacktool_OnInit(); // Это вставить ниже OnGameModeInit()/OnFilterScriptInit()
//  * Hacktool_OnPlayerConnect(playerid); // Это вставить ниже OnPlayerConnect(playerid)
//  * Hacktool_OnPlayerSpawn(playerid); // Это вставить ниже OnPlayerSpawn(playerid)
//   * Hacktool_OnPlayerDisconnect(playerid, reason); // Это вставить ниже OnPlayerDisconnect(playerid, reason)
//////////////////////////////
// ФУНКЦИИ
/////////////////////////////
 //   * Hacktool_GivePlayerWeapon(playerid, weaponid, ammo); // Дает пользователю оружие
 //  то есть щаменить GivePlayerWeapon на Hacktool_GivePlayerWeapon там где вам необходимо
 /////////////////////////////////
 ///http://gmc-games.org.ru Портал GTA
 ///////////////////////////////
#include <a_samp>
#define GREEN 0x21DD00FF
#define RED 0xE60000FF
#define ADMIN_RED 0xFB0000FF
#define YELLOW 0xFFFF00FF
#define PURPLE 0xB360FDFF
#define PLAYER_COLOR 0xFFFFFFFF
#define BLUE 0x1229FAFF
#define PINK 0xD52DFFFF
#define DARKGREY    0x626262FF
#define AQUAGREEN   0x03D687FF
#define NICESKY 0x99FFFFAA
#define WHITE 			0xFFFFFFFF
#define ON      					1
#define OFF     					0
#define MAX_WEAPONS                 47
#define ORANGE 0xF97804FF
#define LIGHTRED 0xFF8080FF
#define LIGHTBLUE 0x00C2ECFF
#define MONEY_HACK                  999999999
#define MAX_AMMO_HACK               69
#define KICK                        1
#define LIGHTGREEN 0x38FF06FF
#define DARKPINK 0xE100E1FF
#define DARKGREEN 0x008040FF
#define ANNOUNCEMENT 0x6AF7E1FF
#define COLOR_SYSTEM 0xEFEFF7AA
#define GREY 0xCECECEFF
#define BAN                         2
enum acInfo
{
	acWeapon[13],
	acCash,
	acWAmmo[MAX_WEAPONS],
}
new Hacktool[MAX_PLAYERS][acInfo];
new hhtime[MAX_PLAYERS];
new HACKER = BAN;

new TOGGLE_WEAPON_DETECTION = ON;
new TOGGLE_JETPACK_DETECTION = ON;
// **FORWARDS** //
forward HackingDetected(playerid, reason[]);
forward WeaponDetection();
forward MoneyDetection();
forward HealthDetection(playerid);
forward HealthHackSuspection(suspectid);
forward Hacktool_OnInit();
forward Hacktool_OnPlayerSpawn(playerid);
forward Hacktool_OnPlayerConnect(playerid);
forward Hacktool_OnPlayerDisconnect(playerid, reason);
/*x---------------------------------CallBacks-------------------------------------x*/
public WeaponDetection()
{
	new w[MAX_PLAYERS],a[MAX_PLAYERS];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if (IsPlayerConnected(i))
	    {
	        if (TOGGLE_JETPACK_DETECTION == ON)
			{
				if (GetPlayerSpecialAction(i) == SPECIAL_ACTION_USEJETPACK)
				{
					HackingDetected(i, "Джетпак");
					break;
				}
			}
			w[i] = 0;
			a[i] = 0;
	        for(new s = 0; s < 13; s++)
	        {
         		GetPlayerWeaponData(i, s, w[i], a[i]);
           		if (Hacktool[i][acWeapon][s] != w[i])
             	{
              		if (a[i] > Hacktool[i][acWAmmo][w[i]])
           			{
              			if ((a[i] - Hacktool[i][acWAmmo][w[i]]) >= MAX_AMMO_HACK)
              			{
                 			HackingDetected(i, "Хак на оружие");
	                        break;
                    	}
                   	}
             	}
	        }
	    }
	}
}

public MoneyDetection()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if (IsPlayerConnected(i))
	    {
	        new cash = GetPlayerMoney(i);
	        if (cash > Hacktool[i][acCash])
	        {
	            if ((cash - Hacktool[i][acCash]) > MONEY_HACK)
	            {
	                HackingDetected(i, "Хак на деньги");
	                break;
	            }
	        }
	    }
	}
}

public HealthDetection(playerid)
{
	if (IsPlayerConnected(playerid))
	{
	    KillTimer(hhtime[playerid]);
	    new Float:hp;
	    GetPlayerHealth(playerid, hp);
	    if (hp >= 100)
	    {
	        if (GetPlayerPing(playerid) < 700)
	        {
	            SetPlayerHealth(playerid, 99);
	            hhtime[playerid] = SetTimerEx("Хак на жизни",1000,0,"d",playerid);
	            return;
	        }
	    }
	    hhtime[playerid] = SetTimerEx("HealthDetection",1000,0,"d",playerid);
	}
}

public HealthHackSuspection(suspectid)
{
	if (IsPlayerConnected(suspectid))
	{
	    new Float:hp;
	    GetPlayerHealth(suspectid, hp);
	    if (hp >= 100)
	    {
	        if (GetPlayerPing(suspectid) < 700) HackingDetected(suspectid, "Health hacking");
	    }
	}
}

public HackingDetected(playerid, reason[])
{
	new string[128];
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	if (HACKER == BAN)
	{
	    format(string, sizeof(string), "Сервер: %s Был кикнут. Причина : %s -", name, reason);
	    SendClientMessageToAll(0xF97804FF, string);
	    Kick(playerid);
	}
	else if (HACKER == KICK)
	{
	    format(string, sizeof(string), "Сервер: %s Был кикнут. Причина : %s -", name, reason);
	    SendClientMessageToAll(0xF97804FF, string);
	    Kick(playerid);
	}
}

public Hacktool_OnInit()
{
    SetTimer("MoneyDetection",2000,1);
	if (TOGGLE_WEAPON_DETECTION == ON) SetTimer("WeaponDetection",5000,1);
}

public Hacktool_OnPlayerSpawn(playerid)
{
    hhtime[playerid] = SetTimerEx("HealthDetection",1000,0,"d",playerid);
}

public Hacktool_OnPlayerConnect(playerid)
{
    for(new i = 0; i <= 12; i++) Hacktool[playerid][acWeapon][i] = 0;
    for(new w = 0; w <= MAX_WEAPONS; w++) Hacktool[playerid][acWAmmo][w] = 0;
    Hacktool[playerid][acCash] = 0;
}

public Hacktool_OnPlayerDisconnect(playerid, reason)
{
    for(new i = 0; i <= 12; i++) Hacktool[playerid][acWeapon][i] = 0;
    for(new w = 0; w <= MAX_WEAPONS; w++) Hacktool[playerid][acWAmmo][w] = 0;
    Hacktool[playerid][acCash] = 0;
    KillTimer(hhtime[playerid]);
}

stock GetWeapSlotID(weaponid)
{
	switch (weaponid)
	{
	    case 0,1: return 0;
	    case 2..9: return 1;
	    case 10..15: return 10;
	    case 16..18,39: return 8;
	    case 22..24: return 2;
	    case 25..27: return 3;
	    case 28,29,32: return 4;
	    case 33,34: return 6;
	    case 35..38: return 7;
	    case 41..43: return 9;
	    case 44..46: return 11;
	    default: return 12;
	}
	return 0;
}

stock IsValidWeapon(weaponid)
{
	if (weaponid > 0) return 1;
	return 0;
}

Hacktool_GivePlayerMoney(playerid, amount)
{
	Hacktool[playerid][acCash] += amount;
	GivePlayerMoney(playerid, amount);
}

Hacktool_TakePlayerMoney(playerid, amount)
{
	Hacktool[playerid][acCash] -= amount;
	GivePlayerMoney(playerid, -amount);
}

Hacktool_GivePlayerWeapon(playerid, weaponid, ammos)
{
	Hacktool[playerid][acWeapon][GetWeapSlotID(weaponid)] = weaponid;
	Hacktool[playerid][acWAmmo][weaponid] = ammos;
	GivePlayerWeapon(playerid, weaponid, ammos);
}

Hacktool_ResetPlayerMoney(playerid)
{
	Hacktool[playerid][acCash] -= Hacktool[playerid][acCash];
	GivePlayerMoney(playerid, Hacktool[playerid][acCash]-Hacktool[playerid][acCash]);
}

Hacktool_GetPlayerMoney(playerid)
{
	return Hacktool[playerid][acCash];
}
