//
// Created: 30.03.08
// Aurthor: konsul
//

#if defined _dm_kons_included
#endinput
#endif

#define _dm_kons_included
#pragma library dm_kons
#include "deathmatch"

static name[MAX_NAME] = "Punk's House"; // unique name of dm
static frequency = 2; // frequency that dm runs
static lineupdelay = 140; // how long we wait for people before starting dm, in seconds
static minplayers = 2; // minimum number of dmrs required to start this dm
static minlevel = 3; // minimum player level required to join this dm
static cashprize = 45000; // cash earned for 1st position
static cashentry = 3500; // Cash required to enter (earned by winner)
static xpprize = 10000; // xp earned for 1st position
static xpbonus = 3500; // xp earned per player in dm
static xpkill = 2500; // xp gained when killing someone in dm
static xpdeath = 450; // xp lost on death in dm
static maxtime = 150; // time dm runs for (seconds)
static maxdistance = 300; // max distance player can wander from dm before being kicked out
static activedmjoin = 1; // can players join this dm while it is in progress
static weapons[MAX_DMWEAPONS+1] = {9,2,22,26,37,30,0,...};
static Float:startcp[CoordInfo] = {1489.034912,722.709411,10.820312}; // where startpoint is
static Float:centrecp[CoordInfo] = {1291.253540,-787.970214,96.455444}; // where central
static Float:spawnpoints[][CoordInfo] = {
{1282.152954,-785.159729,92.031250},
{1260.957031,-806.924377,88.312500},
{1300.356323,-789.897949,88.312500},
{1285.751220,-830.039916,83.140625},
{1248.251098,-807.777954,84.140625},
{1278.804687,-774.249145,95.962036}

};

static dmid; // this will hold the id this dm is assigned at init

forward dm_kons_init();

public dm_kons_init() // unique named init function (must be ran on gamemode init)
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
