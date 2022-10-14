//
// Created: 01.04.08
// Aurthor: azarnik
//

#if defined _dm_azarnik2_included
#endinput
#endif

#define _dm_azarnik2_included
#pragma library dm_azarnik2
#include "deathmatch"

static name[MAX_NAME] = "Curio Rocketer"; // unique name of dm
static frequency = 2; // frequency that dm runs
static lineupdelay = 200; // how long we wait for people before starting dm, in seconds
static minplayers = 1; // minimum number of dmrs required to start this dm
static minlevel = 0; // minimum player level required to join this dm
static cashprize = 5000; // cash earned for 1st position
static cashentry = 100; // Cash required to enter (earned by winner)
static xpprize = 8000; // xp earned for 1st position
static xpbonus = 900; // xp earned per player in dm
static xpkill = 1000; // xp gained when killing someone in dm
static xpdeath = 100; // xp lost on death in dm
static maxtime = 240; // time dm runs for (seconds)
static maxdistance = 250; // max distance player can wander from dm before being kicked out
static activedmjoin = 1; // can players join this dm while it is in progress
static weapons[MAX_DMWEAPONS+1] = {36,43,30,34,1,0,...};
static Float:startcp[CoordInfo] = {968.4420,1734.9261,8.6484}; // where startpoint is
static Float:centrecp[CoordInfo] = {-510.8311,2479.1995,60.3414}; // where central
static Float:spawnpoints[][CoordInfo] = {
{-665.6828,2579.4106,151.2240},
{-656.8918,2604.8330,141.1409},
{-687.9781,2620.6206,144.9508},
{-422.1731,2502.4817,123.1191},
{-431.0934,2509.2449,123.3658},
{-639.5268,2379.6892,159.6514},
{-487.7809,2360.7832,122.3941},
{-470.1471,2329.9314,121.4567},
{-674.5870,2359.8086,159.6386}

};

static dmid; // this will hold the id this dm is assigned at init

forward dm_azarnik2_init();

public dm_azarnik2_init() // unique named init function (must be ran on gamemode init)
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
