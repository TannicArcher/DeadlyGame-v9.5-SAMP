//
// Created: 27.03.08
// Aurthor: azarnik
//

#if defined _dm_azarnik_included
#endinput
#endif

#define _dm_azarnik_included
#pragma library dm_azarnik
#include "deathmatch"

static name[MAX_NAME] = "Fight on a Hill"; // unique name of dm
static frequency = 2; // frequency that dm runs
static lineupdelay = 160; // how long we wait for people before starting dm, in seconds
static minplayers = 2; // minimum number of dmrs required to start this dm
static minlevel = 10; // minimum player level required to join this dm
static cashprize = 20000; // cash earned for 1st position
static cashentry = 4500; // Cash required to enter (earned by winner)
static xpprize = 20000; // xp earned for 1st position
static xpbonus = 4000; // xp earned per player in dm
static xpkill = 4000; // xp gained when killing someone in dm
static xpdeath = 999; // xp lost on death in dm
static maxtime = 240; // time dm runs for (seconds)
static maxdistance = 250; // max distance player can wander from dm before being kicked out
static activedmjoin = 1; // can players join this dm while it is in progress
static weapons[MAX_DMWEAPONS+1] = {25,42,8,31,34,0,...};
static Float:startcp[CoordInfo] = {2015.5129,2147.6936,10.8203}; // where startpoint is
static Float:centrecp[CoordInfo] = {-258.4693,2237.3823,109.8077}; // where central
static Float:spawnpoints[][CoordInfo] = {
{-207.9015,2300.8821,104.0114},
{-224.6035,2372.3550,110.9417},
{-294.2666,2382.8262,111.0062},
{-306.4213,2356.5229,112.6234},
{-267.3782,2339.3760,108.7885},
{-260.1350,2302.3782,110.9554},
{-294.4211,2148.0647,113.0393},
{-265.4460,2149.3704,109.4173},
{-300.3588,2172.4226,112.3011}

};

static dmid; // this will hold the id this dm is assigned at init

forward dm_azarnik_init();

public dm_azarnik_init() // unique named init function (must be ran on gamemode init)
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
