/*  SA:MP Bot Functions
 *
 *  (c) Copyright 2008, Sacky
 *
 */

#if !defined BOTS_INC
#define BOTS_INC
#pragma library bots

#define MAX_NODES 500
#define MAX_AREAS 64
#define MAX_LINKS 15
#define INVALID_NODE_ID 0xFFFF
#define INVALID_LINK_ID 0xFFFF

// Distances based on meters per 1000 ticks with standard SA:MP keys
#define DIS_RUNNING	5.64440
#define DIS_WALKING	1.552086
#define DIS_SPRINT	9.26784
#define DIS_CROUCH	3.71058
 
// Natives for bots only

native ConnectBot(name[]);
native DisconnectBot(botid);
native SetBotKeys(botid,key1,key2,key3);
native KillBot(botid,killerid,reason);
native IsPlayerBot(playerid);
native SetBotCamVector(botid,Float:x,Float:y,Float:z,Float:pitch);
native SetBotSpeed(botid,Float:x,Float:y,Float:z);
native SetBotSurfOffsets(botid,Float:x,Float:y,Float:z);
native SetBotSurfVehicle(botid,vehicleid);
native SetBotVehicleRoll(botid,Float:rX,Float:rY,Float:rZ);
native SetBotVehicleDirection(botid,Float:rX,Float:rY,Float:rZ);
native SetBotVehicleSirenOn(botid,bool:siren);
native SetBotLandingGearState(botid,landinggear);
native SetBotTireState(botid,tireid,tirestate);
native SetBotHydraJetAngle(botid,angle);
native GetBotLastUpdate(botid);

// Some Extensions to SA:MP Player natives

native GetPlayerCamVector(playerid,&Float:x,&Float:y,&Float:z,&Float:pitch);
native GetPlayerSpeed(playerid,&Float:x,&Float:y,&Float:z);
native GetPlayerSurfOffsets(playerid,&Float:x,&Float:y,&Float:z);
native GetPlayerSurfVehicle(playerid);
native IsPlayerVehicleSirenOn(playerid);
native GetPlayerLandingGearState(playerid);
native GetPlayerTireState(playerid,tireid);
native GetPlayerHydraJetAngle(playerid);
native GetPlayerSpawnInfo(playerid,&Float:x,&Float:y,&Float:z,&Float:angle);
native GetPlayerVehicleRoll(playerid,&Float:rX,&Float:rY,&Float:rZ);
native GetPlayerVehicleDirection(playerid,&Float:rX,&Float:rY,&Float:rZ);

// Functions to parse GTA Node files

native OpenNode(filename[]);
native CloseNode(nodeid);
native GetNumNodes(nodeid);
native GetNumPedNodes(nodeid);
native GetNumVehicleNodes(nodeid);
native GetNumNaviNodes(nodeid);
native GetNumLinks(nodeid);
native GetNodePos(nodeid,gnodeid,&Float:x,&Float:y,&Float:z);
native GetNodeLinkID(nodeid,gnodeid);
native GetNodeAreaID(nodeid,gnodeid);
native Float:GetNodePathWidth(nodeid,gnodeid);
native GetNodeType(nodeid,gnodeid);
native GetNodeLinkCount(nodeid,gnodeid);
native IsNodeRoadBlock(nodeid,gnodeid);
native IsNodeMaritime(nodeid,gnodeid);
native IsNodeEmergency(nodeid,gnodeid);
native IsNodeHighway(nodeid,gnodeid);
native GetNaviNodePos(nodeid,nnodeid,&Float:x,&Float:y);
native GetNaviAreaID(nodeid,nnodeid);
native GetNaviGNodeID(nodeid,nnodeid);
native GetNaviNodeDir(nodeid,nnodeid,&Float:x,&Float:y);
native GetLinkNodeID(nodeid,linkid);
native GetLinkAreaID(nodeid,linkid);
native Float:GetLinkLength(nodeid,linkid);

/*

Player functions that work with bots (all Get/Is functions work):

SetSpawnInfo
SpawnPlayer
SetPlayerTeam
SetPlayerName
SetPlayerSkin
SetPlayerPos
SetPlayerHealth
SetPlayerColor
SetPlayerInterior
SetPlayerScore
SetPlayerFacingAngle
GivePlayerMoney
ResetPlayerMoney
ResetPlayerWeapons
GivePlayerWeapon
SetPlayerArmour
SetPlayerAmmo
SetPlayerWantedLevel
SetPlayerVirtualWorld
ApplyAnimation
ClearAnimation
SetPlayerSpecialAction
PutPlayerInVehicle
RemovePlayerFromVehicle

*/

#endif