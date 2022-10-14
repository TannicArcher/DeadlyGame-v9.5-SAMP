//
// Created:     August 2009
// Aurthor:    Roman Ivanenko
//

#if defined _dm_atsmall_included
  #endinput
#endif

#define _dm_atsmall_included
#pragma library dm_atsmall
#include "deathmatch"

static name[MAX_NAME] = "At Small Town"; // unique name of dm
static frequency = 1; // frequency that dm runs
static lineupdelay = 120; // how long we wait for people before starting dm, in seconds
static minplayers = 2; // minimum number of dmrs required to start this dm
static minlevel = 10; // minimum player level required to join this dm
static cashprize = 10000; // cash earned for 1st position
static cashentry = 1500; // Cash required to enter (earned by winner)
static xpprize = 10000; // xp earned for 1st position
static xpbonus = 2000; // xp earned per player in dm
static xpkill = 2000; // xp gained when killing someone in dm
static xpdeath = 350; // xp lost on death in dm
static maxtime = 240; // time dm runs for (seconds)
static maxdistance = 250; // max distance player can wander from dm before being kicked
static activedmjoin = 1; // can players join this dm while it is in progress
static weapons[MAX_DMWEAPONS+1] = {22,31,32,26,0}; // pistol, shotgun, chainsaw
static Float:startcp[CoordInfo] = {2496.995361,1275.863891,10.812500}; // where startpoint is located
static Float:centrecp[CoordInfo] = {-2485.912841,2512.232421,18.062500}; // central point
static Float:spawnpoints[][CoordInfo] = {
{-2485.912841,2512.232421,18.062500}, // cssp2
{-2463.150634,2512.932861,18.255390}, // cssp3
{-2429.231933,2478.14089,13.736648}, // cssp4
{-2404.199462,2513.457031,12.165237}, // cssp5
{-2485.912841,2512.232421,18.062500}, // cssp6
{-2463.150634,2512.932861,18.255390}, //  cssp7
{-2429.231933,2478.14089,13.736648} //  cssp8
};

static dmid; // this will hold the id this dm is assigned at init

forward dm_atsmall_init();

public dm_atsmall_init() // unique named init function (must be ran on gamemode init)
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


