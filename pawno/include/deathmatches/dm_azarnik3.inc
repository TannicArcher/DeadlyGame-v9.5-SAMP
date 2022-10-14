//
// Created: 01.04.08
// Aurthor: azarnik
//

#if defined _dm_azarnik3_included
#endinput
#endif

#define _dm_azarnik3_included
#pragma library dm_azarnik3
#include "deathmatch"

static name[MAX_NAME] = "Rendezvous"; // unique name of dm
static frequency = 2; // frequency that dm runs
static lineupdelay = 140; // how long we wait for people before starting dm, in seconds
static minplayers = 2; // minimum number of dmrs required to start this dm
static minlevel = 5; // minimum player level required to join this dm
static cashprize = 15000; // cash earned for 1st position
static cashentry = 2000; // Cash required to enter (earned by winner)
static xpprize = 10000; // xp earned for 1st position
static xpbonus = 3500; // xp earned per player in dm
static xpkill = 2000; // xp gained when killing someone in dm
static xpdeath = 350; // xp lost on death in dm
static maxtime = 240; // time dm runs for (seconds)
static maxdistance = 350; // max distance player can wander from dm before being kicked out
static activedmjoin = 1; // can players join this dm while it is in progress
static weapons[MAX_DMWEAPONS+1] = {14,23,26,30,1,0,...};
static Float:startcp[CoordInfo] = {2095.976806,1285.144653,10.820312}; // where startpoint is
static Float:centrecp[CoordInfo] = {369.895355,-2044.091796,7.671875}; // where central
static Float:spawnpoints[][CoordInfo] = {
{356.732482,-2031.612426,10.742187},
{376.171661,-2063.526611,10.695312},
{364.572601,-2061.221435,15.396829},
{393.690856,-2056.040771,13.834616},
{377.074707,-2016.949951,7.830090},
{396.714447,-2058.694335,7.835937},
{386.686462,-2076.436279,7.835937}
};

static dmid; // this will hold the id this dm is assigned at init

forward dm_azarnik3_init();

public dm_azarnik3_init() // unique named init function (must be ran on gamemode init)
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

