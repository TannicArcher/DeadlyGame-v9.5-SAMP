#if defined _YSF_included
	#endinput
#endif
#define _YSF_included

// Generic functions
native SetPlayerGravity(playerid, Float:gravity);
native AddServerRule(name[], value[]);
native SetServerRule(name[], value[]);
native SetPlayerSkinForPlayer(skinplayer, forplayer, skin);
native GetPlayerSkinForPlayer(skinplayer, forplayer);

// File functions
native ffind(const pattern[], filename[], len, &idx);
//native frename(const oldname[], const newname[]);

// Directory functions
native dfind(const pattern[], filename[], len, &idx);
native dcreate(const name[]);
native drename(const oldname[], const newname[]);
