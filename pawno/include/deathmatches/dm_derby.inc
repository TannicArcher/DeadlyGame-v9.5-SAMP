//
// Created:     August 2009
// Aurthor:    Roman Ivanenko
//

#if defined _dm_derby_included
  #endinput
#endif

#define _dm_derby_included
#pragma library dm_derby
#include "deathmatch"

static name[MAX_NAME] = "Derby on a Hill"; // unique name of dm
static frequency = 1; // frequency that dm runs
static lineupdelay = 240; // how long we wait for people before starting dm, in seconds
static minplayers = 1; // minimum number of dmrs required to start this dm
static minlevel = 10; // minimum player level required to join this dm
static cashprize = 30000; // cash earned for 1st position
static cashentry = 4000; // Cash required to enter (earned by winner)
static xpprize = 14000; // xp earned for 1st position
static xpbonus = 3000; // xp earned per player in dm
static xpkill = 4400; // xp gained when killing someone in dm
static xpdeath = 400; // xp lost on death in dm
static maxtime = 240; // time dm runs for (seconds)
static maxdistance = 50; // max distance player can wander from dm before being kicked
static activedmjoin = 1; // can players join this dm while it is in progress
static weapons[MAX_DMWEAPONS+1] = {0}; // pistol, shotgun, chainsaw
static Float:startcp[CoordInfo] = {-1974.069580,137.145782,27.687500}; // where startpoint is located
static Float:centrecp[CoordInfo] = {-661.432006,2369.051025,160.018173}; // central point
static Float:spawnpoints[][CoordInfo] = {
{-661.432006,2369.051025,160.018173}, // cssp2
{-654.744018,2376.763916,160.419738}, // cssp3
{-648.081420,2373.454589,159.957824}, // cssp4
{-655.029663,2371.651611,160.027557}, // cssp5
{-654.425292,2365.811279,159.551239}, // cssp6
{-648.441467,2363.621337,159.197723}, //  cssp7
{-652.790954,2356.976806,158.815216} //  cssp8
};

static dmid; // this will hold the id this dm is assigned at init

forward dm_derby_init();

public dm_derby_init() // unique named init function (must be ran on gamemode init)
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


