//
// Created: 01.04.08
// Aurthor: azarnik
//

#if defined _dm_azarnik5_included
#endinput
#endif

#define _dm_azarnik5_included
#pragma library dm_azarnik5
#include "deathmatch"

static name[MAX_NAME] = "Peril Highness"; // unique name of dm
static frequency = 3; // frequency that dm runs
static lineupdelay = 140; // how long we wait for people before starting dm, in seconds
static minplayers = 2; // minimum number of dmrs required to start this dm
static minlevel = 2; // minimum player level required to join this dm
static cashprize = 9000; // cash earned for 1st position
static cashentry = 1400; // Cash required to enter (earned by winner)
static xpprize = 8000; // xp earned for 1st position
static xpbonus = 1000; // xp earned per player in dm
static xpkill = 1999; // xp gained when killing someone in dm
static xpdeath = 350; // xp lost on death in dm
static maxtime = 240; // time dm runs for (seconds)
static maxdistance = 150; // max distance player can wander from dm before being kicked out
static activedmjoin = 1; // can players join this dm while it is in progress
static weapons[MAX_DMWEAPONS+1] = {32,26,22,1,46,0,...};
static Float:startcp[CoordInfo] = {1887.2286,-1424.6245,10.3594}; // where startpoint is
static Float:centrecp[CoordInfo] = {1545.9141,-1353.4669,329.4808}; // where central
static Float:spawnpoints[][CoordInfo] = {
{1527.4285,-1358.1443,329.4609},
{1529.8925,-1348.2144,329.4609},
{1537.8075,-1341.3566,329.4641},
{1550.2080,-1340.4637,329.4605},
{1559.9308,-1347.4486,329.4609},
{1562.4791,-1358.0250,329.4535},
{1556.4194,-1367.5005,329.4535},
{1545.4984,-1371.1309,329.4535},
{1533.4363,-1368.5642,329.4609}

};

static dmid; // this will hold the id this dm is assigned at init

forward dm_azarnik5_init();

public dm_azarnik5_init() // unique named init function (must be ran on gamemode init)
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
