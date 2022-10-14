//
// Created:     August 2009
// Aurthor:    Roman Ivanenko
//

#if defined _dm_airport_included
  #endinput
#endif

#define _dm_airport_included
#pragma library dm_airport
#include "deathmatch"

static name[MAX_NAME] = "Airoport Madness"; // unique name of dm
static frequency = 1; // frequency that dm runs
static lineupdelay = 130; // how long we wait for people before starting dm, in seconds
static minplayers = 2; // minimum number of dmrs required to start this dm
static minlevel = 18; // minimum player level required to join this dm
static cashprize = 32000; // cash earned for 1st position
static cashentry = 3500; // Cash required to enter (earned by winner)
static xpprize = 8000; // xp earned for 1st position
static xpbonus = 5000; // xp earned per player in dm
static xpkill = 2500; // xp gained when killing someone in dm
static xpdeath = 500; // xp lost on death in dm
static maxtime = 240; // time dm runs for (seconds)
static maxdistance = 200; // max distance player can wander from dm before being kicked
static activedmjoin = 1; // can players join this dm while it is in progress
static weapons[MAX_DMWEAPONS+1] = {16,31,30,26,0}; // pistol, shotgun, chainsaw
static Float:startcp[CoordInfo] = {1677.125488,1310.680297,10.385018}; // where startpoint is located
static Float:centrecp[CoordInfo] = {1656.416503,1401.332763,20.977142}; // central point
static Float:spawnpoints[][CoordInfo] = {
{1656.416503,1401.332763,20.977142}, // cssp2
{1595.498291,1383.043823,21.135868}, // cssp3
{1687.663208,1336.738647,20.917982}, // cssp4
{1649.279541,1437.131225,23.828125}, // cssp5
{1630.593017,1434.648559,27.289062}, // cssp6
{1617.123046,1436.107543,25.710937}, //  cssp7
{1623.844970,1412.576171,23.710990} //  cssp8
};

static dmid; // this will hold the id this dm is assigned at init

forward dm_airport_init();

public dm_airport_init() // unique named init function (must be ran on gamemode init)
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


