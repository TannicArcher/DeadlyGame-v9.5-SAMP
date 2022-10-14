//
// Created: 01.04.08
// Aurthor: azarnik
//

#if defined _dm_azarnik4_included
#endinput
#endif

#define _dm_azarnik4_included
#pragma library dm_azarnik4
#include "deathmatch"

static name[MAX_NAME] = "Wall on Wall"; // unique name of dm
static frequency = 2; // frequency that dm runs
static lineupdelay = 160; // how long we wait for people before starting dm, in seconds
static minplayers = 3; // minimum number of dmrs required to start this dm
static minlevel = 2; // minimum player level required to join this dm
static cashprize = 9000; // cash earned for 1st position
static cashentry = 100; // Cash required to enter (earned by winner)
static xpprize = 8000; // xp earned for 1st position
static xpbonus = 900; // xp earned per player in dm
static xpkill = 2000; // xp gained when killing someone in dm
static xpdeath = 666; // xp lost on death in dm
static maxtime = 240; // time dm runs for (seconds)
static maxdistance = 250; // max distance player can wander from dm before being kicked out
static activedmjoin = 1; // can players join this dm while it is in progress
static weapons[MAX_DMWEAPONS+1] = {35,43,3,0,...};
static Float:startcp[CoordInfo] = {2217.5837,-1162.9459,25.7266}; // where startpoint is
static Float:centrecp[CoordInfo] = {-2051.8098,-185.1215,35.3274}; // where central
static Float:spawnpoints[][CoordInfo] = {
{-2086.8269,-114.4988,35.3203},
{-2068.0854,-113.5207,35.3326},
{-2043.3750,-106.2115,35.2061},
{-2015.5953,-111.3927,35.0969},
{-2013.6875,-161.2175,35.3203},
{-2088.5496,-194.8448,35.3203},
{-2078.9705,-253.1744,35.3203},
{-2044.7653,-259.8583,35.3203},
{-2014.1833,-254.0218,35.3203}

};

static dmid; // this will hold the id this dm is assigned at init

forward dm_azarnik4_init();

public dm_azarnik4_init() // unique named init function (must be ran on gamemode init)
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
