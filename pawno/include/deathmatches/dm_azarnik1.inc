//
// Created: 01.04.08
// Aurthor: azarnik
//

#if defined _dm_azarnik1_included
#endinput
#endif

#define _dm_azarnik1_included
#pragma library dm_azarnik1
#include "deathmatch"

static name[MAX_NAME] = "Hunt in Forest"; // unique name of dm
static frequency = 2; // frequency that dm runs
static lineupdelay = 120; // how long we wait for people before starting dm, in seconds
static minplayers = 2; // minimum number of dmrs required to start this dm
static minlevel = 2; // minimum player level required to join this dm
static cashprize = 10000; // cash earned for 1st position
static cashentry = 1500; // Cash required to enter (earned by winner)
static xpprize = 14000; // xp earned for 1st position
static xpbonus = 1500; // xp earned per player in dm
static xpkill = 2000; // xp gained when killing someone in dm
static xpdeath = 350; // xp lost on death in dm
static maxtime = 240; // time dm runs for (seconds)
static maxdistance = 250; // max distance player can wander from dm before being kicked out
static activedmjoin = 1; // can players join this dm while it is in progress
static weapons[MAX_DMWEAPONS+1] = {33,25,24,0,...};
static Float:startcp[CoordInfo] = {1349.0535,-1280.1948,13.3828}; // where startpoint is
static Float:centrecp[CoordInfo] = {-1632.2523,-2242.9861,31.4766}; // where central
static Float:spawnpoints[][CoordInfo] = {
{-1593.4479,-2219.1147,21.2373},
{-1617.5140,-2267.9849,33.5588},
{-1732.6942,-2254.2615,53.1493},
{-1727.8425,-2180.8352,54.1435},
{-1715.3776,-2131.9180,49.6589},
{-1741.4481,-2093.3137,40.5852},
{-1749.1290,-2048.1348,59.3041},
{-1689.0588,-2059.4063,45.1868},
{-1654.9213,-2084.0464,43.9463}

};

static dmid; // this will hold the id this dm is assigned at init

forward dm_azarnik1_init();

public dm_azarnik1_init() // unique named init function (must be ran on gamemode init)
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
