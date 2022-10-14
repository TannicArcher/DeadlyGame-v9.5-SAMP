//
// Created:     August 2009
// Aurthor:    Roman Ivanenko
//

#if defined _dm_ravine_included
  #endinput
#endif

#define _dm_ravine_included
#pragma library dm_ravine
#include "deathmatch"

static name[MAX_NAME] = "Big Ravine"; // unique name of dm
static frequency = 1; // frequency that dm runs
static lineupdelay = 140; // how long we wait for people before starting dm, in seconds
static minplayers = 2; // minimum number of dmrs required to start this dm
static minlevel = 4; // minimum player level required to join this dm
static cashprize = 60000; // cash earned for 1st position
static cashentry = 500; // Cash required to enter (earned by winner)
static xpprize = 8000; // xp earned for 1st position
static xpbonus = 5000; // xp earned per player in dm
static xpkill = 2400; // xp gained when killing someone in dm
static xpdeath = 444; // xp lost on death in dm
static maxtime = 240; // time dm runs for (seconds)
static maxdistance = 500; // max distance player can wander from dm before being kicked
static activedmjoin = 1; // can players join this dm while it is in progress
static weapons[MAX_DMWEAPONS+1] = {34,0}; // pistol, shotgun, chainsaw
static Float:startcp[CoordInfo] = {1964.748413,1343.146850,16.591800}; // where startpoint is located
static Float:centrecp[CoordInfo] = {685.918273,976.880615,-13.073643,}; // central point
static Float:spawnpoints[][CoordInfo] = {
{685.918273,976.880615,-13.073643}, // cssp2
{589.803649,976.647949,-7.360126}, // cssp3
{629.808044,999.962402,5.510210}, // cssp4
{737.686157,969.059509,5.510610,}, // cssp5
{719.840942,886.974853,-26.891782}, // cssp6
{644.704528,936.960449,-37.244281}, //  cssp7
{661.462341,853.824890,-43.304901} //  cssp8
};

static dmid; // this will hold the id this dm is assigned at init

forward dm_ravine_init();

public dm_ravine_init() // unique named init function (must be ran on gamemode init)
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


