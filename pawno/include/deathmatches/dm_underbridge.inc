// Created:    04.12.07
// Aurthor:    MadCat
// Based on PEN1 DM

#if defined _dm_underbridge_included
#endinput
#endif

#define _dm_underbridge_included
#pragma library dm_underbridge
#include "deathmatch"

static name[MAX_NAME] = "Under The Bridge";
static frequency = 5;
static lineupdelay = 240;
static minplayers = 3;
static minlevel = 6;
static cashprize = 5000;
static cashentry = 500;
static xpprize = 1500;
static xpbonus = 200;
static xpkill = 400;
static xpdeath = 200;
static maxtime = 400;
static activedmjoin = 1;
static weapons[MAX_DMWEAPONS+1] = {WEAPON_SAWEDOFF,WEAPON_UZI,WEAPON_RIFLE};
static Float:startcp[CoordInfo] = {-2672.2383,1265.9156,56.4844};
static Float:worldbounds[DMWBInfo] = {-2638.666748,-2715.967773,1931.581298,1598.848632};
static Float:spawnpoints[][CoordInfo] = {
{-2695.7998,1793.0549,59.5925},
{-2695.3850,1769.3763,59.9591},
{-2696.1301,1752.8712,59.9475},
{-2696.4785,1742.5632,59.9072},
{-2696.8298,1732.1811,59.8224},
{-2696.9377,1721.9010,59.7155},
{-2685.4753,1722.4534,59.7231},
{-2684.5673,1731.1551,59.8136},
{-2684.4467,1741.6062,59.9035},
{-2684.1022,1755.8035,59.9589},
{-2683.5288,1765.7734,59.9609},
{-2683.6538,1775.6083,59.9028},
{-2676.3449,1778.3319,59.8556},
{-2669.9296,1770.3603,59.9586},
{-2669.4919,1765.0820,59.9612},
{-2669.4692,1754.2019,59.9527},
{-2669.1542,1748.3226,59.9297},
{-2668.2275,1737.8400,59.8707},
{-2667.4650,1727.1214,59.7791},
{-2677.5864,1714.1016,59.6088}
};

static dmid; // this will hold the id this dm is assigned at init

forward dm_underbridge_init();

public dm_underbridge_init() // unique named init function (must be ran on gamemode init)
{
	dmid = RegisterDM(name);
	if (dmid == INVALID_RACE_ID) return;

	Deathmatch[dmid][dm_frequency] = frequency;
 	Deathmatch[dmid][dm_lineupdelay] = lineupdelay;
 	Deathmatch[dmid][dm_minplayers] = minplayers;
 	Deathmatch[dmid][dm_minlevel] = minlevel;
 	Deathmatch[dmid][dm_cashprize] = cashprize;
	Deathmatch[dmid][dm_cashentry] = cashentry;
	Deathmatch[dmid][dm_xpprize] = xpprize;
	Deathmatch[dmid][dm_xpbonus] = xpbonus;
	Deathmatch[dmid][dm_xpkill] = xpkill;
	Deathmatch[dmid][dm_xpdeath] = xpdeath;
	Deathmatch[dmid][dm_maxtime] = maxtime;
	Deathmatch[dmid][dm_activedmjoin] = activedmjoin;
	set(Deathmatch[dmid][dm_weapons],weapons);
	DeathmatchStats[dmid][dm_timer] = MakeDMSleepTime(dmid);
	DeathmatchStats[dmid][dm_state] = DM_STATE_SLEEPING;
	
	DMStartCP[dmid][Coord_X] = startcp[Coord_X];
	DMStartCP[dmid][Coord_Y] = startcp[Coord_Y];
	DMStartCP[dmid][Coord_Z] = startcp[Coord_Z];
	
	DMWorldBounds[dmid][x_max] = worldbounds[x_max];
	DMWorldBounds[dmid][x_min] = worldbounds[x_min];
	DMWorldBounds[dmid][y_max] = worldbounds[y_max];
	DMWorldBounds[dmid][y_min] = worldbounds[y_min];
	
	DMSpawnsSize[dmid] = sizeof(spawnpoints);
	for (new spid=0;spid<sizeof(spawnpoints);spid++)
	{
		DMSpawnPoints[dmid][spid][Coord_X] = spawnpoints[spid][Coord_X];
		DMSpawnPoints[dmid][spid][Coord_Y] = spawnpoints[spid][Coord_Y];
		DMSpawnPoints[dmid][spid][Coord_Z] = spawnpoints[spid][Coord_Z];
	}

 }
 	

