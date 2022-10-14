/*
*	Created:			09.03.10
*	Author:				009
*	Last Modifed:		-
*	Description:		нативы управления NPC
*/

#if defined _cnpc_included
	#endinput
#endif

#define _cnpc_included
#pragma library cnpc

native CreateNPC(npcid,npcname[]);
native DestroyNPC(npcid);
native SetNPCPos(npcid,Float:X,Float:Y,Float:Z);
native NPC_AimAt(npcid,Float:X,Float:Y,Float:Z);
native NPC_ShotAt(npcid,Float:X,Float:Y,Float:Z);
native NPC_WalkTo(npcid,Float:X,Float:Y,Float:Z);
native NPC_RunTo(npcid,Float:X,Float:Y,Float:Z);
native NPC_SprintTo(npcid,Float:X,Float:Y,Float:Z);
native SetNPCWeapon(npcid,weaponid);
native KillNPC(npcid);
native SpawnNPC(npcid);
native StopNPC(npcid);

#define SetNPCSkin(%1) SetPlayerSkin(%1)
#define GetNPCPos(%1) GetPlayerPos(%1)

forward OnNPCGetDamage(npcid,playerid);