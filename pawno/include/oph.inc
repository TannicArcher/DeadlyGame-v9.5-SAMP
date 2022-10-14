/*  SA-MP OnPlayerHit System Functions
 *
 *  (c) Copyright 2010, AirKite
 *
 */

stock TogglePlayerOnHitted(playerid, toggle)return CallRemoteFunction("OnPlayerHitParam","ddd",1,playerid,toggle);
stock ToggleWeaponBlockHit(weaponid, toggle)return CallRemoteFunction("OnPlayerHitParam","ddd",2,weaponid,toggle);
stock ToggleWeaponBlockHitForPlayer(playerid, weaponid, toggle)return CallRemoteFunction("OnPlayerHitParam","dddd",3,playerid,weaponid,toggle);
stock SetWeaponRangeHit(weaponid, Float:range)return CallRemoteFunction("OnPlayerHitParam","ddd",4,weaponid,0,0,range);
stock SetPlayerDemagedHealth(playerid, Float:health, hiterid=-1, reason=-1)return CallRemoteFunction("OnPlayerHitParam","ddddf",5,playerid,killerid,reason,health);
stock SetOnPlayerDeath(playerid, killerid, reason)return CallRemoteFunction("OnPlayerHitParam","dddd",6,playerid,killerid,reason);

// --------------------------------------------------
// Forwards (Callback declarations)
// --------------------------------------------------
forward OnPlayerHit(playerid, hiterid, bodypart, weaponid, Float:distance);

// --------------------------------------------------
// Defines Body Part
// --------------------------------------------------
#define OPH_HEAD 1
#define OPH_BODY 2
#define OPH_FOOT 3

/*
native TogglePlayerOnHitted(playerid, toggle);
native ToggleWeaponBlockHit(weaponid, toggle);
native ToggleWeaponBlockHitForPlayer(playerid, weaponid, toggle);
native SetWeaponRangeHit(weaponid, Float:range);
native SetPlayerDemagedHealth(playerid, Float:health, hiterid=-1, reason=-1);
native SetOnPlayerDeath(playerid, killerid, reason);
*/