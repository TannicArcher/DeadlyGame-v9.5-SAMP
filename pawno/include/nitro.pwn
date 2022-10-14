/*
 ==================================================
|[FS]Nitro on motorcycles[0,3c] by [omegakai]Games |
 ==================================================
*/

#include <a_samp>

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

new countpos[MAX_PLAYERS];
new Flame[MAX_PLAYERS][2];

forward Counter();

public OnFilterScriptInit()
{
    SetTimer("Counter",1000,1);
	return 1;
}

public OnPlayerConnect(playerid)
{
    countpos[playerid] = 0;
    return 1;
}

public Counter()
{
	for(new i; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i) && countpos[i] != 0)
		{
			countpos[i]++;
			if(countpos[i] == 4)
			{
				countpos[i] = 0;
				DestroyObject(Flame[i][0]);
				DestroyObject(Flame[i][1]);
			}
		}
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (PRESSED(KEY_FIRE))
	{
		new vehid = GetPlayerVehicleID(playerid);
		new model = GetVehicleModel(vehid);
		if(model == 522 || model == 461 || model == 463 || model == 468 || model == 523)
		{
			new Float:Velocity[3];
			GetVehicleVelocity(vehid, Velocity[0], Velocity[1], Velocity[2]);
			if(Velocity[0] <1.3  && Velocity[1] < 1.3 && Velocity[0] > -1.3 && Velocity[1] > -1.3)
			{
				SetVehicleVelocity(vehid, Velocity[0]*2, Velocity[1]*2, 0.0);
				if(countpos[playerid] == 0)
				{
					countpos[playerid] = 1;
					if(model != 468)
					{
						Flame[playerid][0] = CreateObject(18693, 0.0, 0.0, 0.0, 0.0, 0, 0, 0);
						Flame[playerid][1] = CreateObject(18693, 0.0, 0.0, 0.0, 0.0, 0, 0, 0);
						if(model == 522)
						{
							AttachObjectToVehicle(Flame[playerid][0], vehid, 0.194999, 0.439999, 0.044999, 86.429962, 0.000000, 0.000000);
							AttachObjectToVehicle(Flame[playerid][1], vehid, -0.204999, 0.439999, 0.044999, 86.429962, 0.000000, 0.000000);
						}
						else if(model == 461)
						{
							AttachObjectToVehicle(Flame[playerid][0], vehid, -0.354999, 0.374999, -0.164999, 84.419967, 3.645001, 0.000000);
							AttachObjectToVehicle(Flame[playerid][1], vehid, 0.135000, 0.374999, -0.164999, 84.419967, 3.645001, 0.000000);
						}
						else if(model == 463)
						{
							AttachObjectToVehicle(Flame[playerid][0], vehid, 0.164999, 0.909999, -0.379999, 86.429962, 3.645001, 0.000000);
							AttachObjectToVehicle(Flame[playerid][1], vehid, -0.419999, 0.909999, -0.379999, 86.429962, 3.645001, 0.000000);
						}
						else if(model == 523)
						{
							AttachObjectToVehicle(Flame[playerid][0], vehid, -0.345999, 0.459999, -0.141999, 89.444953, 3.645001, 0.000000);
							AttachObjectToVehicle(Flame[playerid][1], vehid, 0.119000, 0.459999, -0.141999, 89.444953, 3.645001, 0.000000);
						}
					}
					else
					{
						Flame[playerid][0] = CreateObject(18693, 0.0, 0.0, 0.0, 0.0, 0, 0, 0);
						AttachObjectToVehicle(Flame[playerid][0], vehid, -0.095999, 0.734999, 0.159999, 90.449951, 3.645001, 0.000000);
					}
				}
			}
		}
	}
}

public OnPlayerDisconnect(playerid, reason)
{
	if(countpos[playerid] != 0)
	{
		countpos[playerid] = 0;
		DestroyObject(Flame[playerid][0]);
		DestroyObject(Flame[playerid][1]);
	}
	return 1;
}
