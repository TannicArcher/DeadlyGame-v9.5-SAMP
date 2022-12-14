//
// Created:     August 2009
// Aurthor:    Roman Ivanenko
//

#if defined _dm_avto_included
  #endinput
#endif

#define _dm_avto_included
#pragma library dm_avto
#include "deathmatch"

static name[MAX_NAME] = "Deathmatch at the Stop"; // unique name of dm
static frequency = 1; // frequency that dm runs
static lineupdelay = 160; // how long we wait for people before starting dm, in seconds
static minplayers = 2; // minimum number of dmrs required to start this dm
static minlevel = 16; // minimum player level required to join this dm
static cashprize = 10000; // cash earned for 1st position
static cashentry = 2000; // Cash required to enter (earned by winner)
static xpprize = 16000; // xp earned for 1st position
static xpbonus = 2000; // xp earned per player in dm
static xpkill =  2000; // xp gained when killing someone in dm
static xpdeath = 400; // xp lost on death in dm
static maxtime = 170; // time dm runs for (seconds)
static maxdistance = 290; // max distance player can wander from dm before being kicked
static activedmjoin = 1; // can players join this dm while it is in progress
static weapons[MAX_DMWEAPONS+1] = {25,31,30,27,0}; // pistol, shotgun, chainsaw
static Float:startcp[CoordInfo] = {2525.836669,922.050048,10.397602}; // where startpoint is located
static Float:centrecp[CoordInfo] = {2508.492919,2510.817138,21.442317}; // central point
static Float:spawnpoints[][CoordInfo] = {
{2508.492919,2510.817138,21.442317}, // cssp2
{2462.621337,2495.360595,21.426382}, // cssp3
{2530.098876,2467.480224,21.422557}, // cssp4
{2528.165527,2537.726806,21.437459}, // cssp5
{2466.286376,2530.191406,21.427751}, // cssp6
{2426.389404,2557.727783,21.442003}, //  cssp7
{2508.492919,2510.817138,21.442317} //  cssp8
};

static dmid; // this will hold the id this dm is assigned at init

forward dm_avto_init();

public dm_avto_init() // unique named init function (must be ran on gamemode init)
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
	Deathmatch[dmid][dm_distance] = maxdistance;
	Deathmatch[dmid][dm_activedmjoin] = activedmjoin;
	set(Deathmatch[dmid][dm_weapons],weapons);
	DeathmatchStats[dmid][dm_timer] = MakeDMSleepTime(dmid);
	DeathmatchStats[dmid][dm_state] = DM_STATE_SLEEPING;

	DMStartCP[dmid][Coord_X] = startcp[Coord_X];
	DMStartCP[dmid][Coord_Y] = startcp[Coord_Y];
	DMStartCP[dmid][Coord_Z] = startcp[Coord_Z];

	DMCentreCP[dmid][Coord_X] = centrecp[Coord_X];
	DMCentreCP[dmid][Coord_Y] = centrecp[Coord_Y];
	DMCentreCP[dmid][Coord_Z] = centrecp[Coord_Z];

	DMSpawnsSize[dmid] = sizeof(spawnpoints);
	for (new spid=0;spid<sizeof(spawnpoints);spid++)
	{
		DMSpawnPoints[dmid][spid][Coord_X] = spawnpoints[spid][Coord_X];
		DMSpawnPoints[dmid][spid][Coord_Y] = spawnpoints[spid][Coord_Y];
		DMSpawnPoints[dmid][spid][Coord_Z] = spawnpoints[spid][Coord_Z];
	}

 	printf("Deathmatch: '%s' Loaded.",name);
 }


