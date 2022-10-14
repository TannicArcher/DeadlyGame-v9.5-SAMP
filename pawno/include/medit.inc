/* -----------------------------------------------------------------------------
               ___  ___              _____    _ _ _
               |  \/  |             |  ___|  | (_) |
               | .  . | __ _ _ __   | |__  __| |_| |_ ___  _ __
               | |\/| |/ _` | '_ \  |  __|/ _` | | __/ _ \| '__|
               | |  | | (_| | |_) | | |__| (_| | | || (_) | |
               \_|  |_/\__,_| .__/  \____/\__,_|_|\__\___/|_|
                      LIGHT | | by mabako
                            |_|
Description:
	provides various useful functions for your own gamemodes that're handy so
	you can use functions from Map Editor.
	
----------------------------------------------------------------------------- */
#include <a_samp>





/* -----------------------------------------------------------------------------
define:
	MEDIT_VERSION
Notes:
    0504 as 0.5rc4 is the actual first Release which supports Map Editor Light.
    if it's actually HIGHER than the release returned by the map editor, we just
    end the gamemode.
----------------------------------------------------------------------------- */
#define MEDIT_VERSION_INTERNAL		0504





/* -----------------------------------------------------------------------------
Enum:
	MEdit_AccessLevels
----------------------------------------------------------------------------- */
enum MEdit_AccessLevels( <<= 1 )
{
	MEdit_AccessLevel_None = 1,
	MEdit_AccessLevel_User,
	MEdit_AccessLevel_Admin, // has no rights to SAVE a file, still
	MEdit_AccessLevel_Full,
	MEdit_AccessLevel_Default // default behaviour
}





/* -----------------------------------------------------------------------------
Callback:
	MEdit_OnInit / MEdit_OnInternalInit
Returns:
	-
Notes:
	MEdit_OnInternalInit will exit the script if the used version of map editor
	is too old
	
	MEdit_OnInit Gets called when the Map Editor is about to initalize, this is
	useful for setting permissions and enabling/disabling autoload
----------------------------------------------------------------------------- */
forward MEdit_OnInternalInit( );
forward MEdit_OnInit( );

public MEdit_OnInternalInit( )
{
	if( MEDIT_VERSION_INTERNAL > CallRemoteFunction( "_medit_GetVersion", "" ) )
	{
	    print( "[error] Map Editor Remote Version is too old.\n        Please Update Map Editor to a newer one" );
	    SendRconCommand( "gmx" );
	}
	else
	{
		CallLocalFunction( "MEdit_OnInit", "" );
	}
}




/* -----------------------------------------------------------------------------
Callback:
	MEdit_OnPickup
Returns:
	playerid - the player who picked up the pickup
	pickupid - the ID of the picked up pickup - the ID can actually work with
	modelid  - the model ID of the pickup
Notes:
	-
----------------------------------------------------------------------------- */
// forward MEdit_OnPickup( playerid, pickupid, modelid );





/* -----------------------------------------------------------------------------
Function:
	MEdit_EnableAutoLoad
Params:
	enabled - if set to 0, autoload.meditc will be NOT executed, means you won't
	          have your configured maps loaded
Returns:
	-
Notes:
	-
----------------------------------------------------------------------------- */
stock MEdit_EnableAutoLoad( enabled )
{
	CallRemoteFunction( "_medit_EnableAutoLoad", "i", enabled );
}





/* -----------------------------------------------------------------------------
Function:
	MEdit_SetDefaultAccessLevel
Params:
	level - Sets one of the levels from (enum) MEdit_AccessLevels that'll be
	        applied to all users (if not otherwise set)
Returns:
	-
Notes:
	-
----------------------------------------------------------------------------- */
stock MEdit_SetDefaultAccessLevel( MEdit_AccessLevels: level )
{
	CallRemoteFunction( "_medit_SetDefaultAccessLevel", "i", _: level );
}





/* -----------------------------------------------------------------------------
Function:
	MEdit_SetPlayerAccessLevel
Params:
	playerid - the playerid for which the level should be changed
	level    - Sets one of the levels from (enum) MEdit_AccessLevels that'll be
	           applied
Returns:
	succeed - 1 if it was successful (player is connected), 0 otherwise
Notes:
	-
----------------------------------------------------------------------------- */
stock MEdit_SetPlayerAccessLevel( playerid, MEdit_AccessLevels: level )
{
	return CallRemoteFunction( "_medit_SetPlayerAccessLevel", "ii", playerid, _: level );
}





/* -----------------------------------------------------------------------------
Function:
	MEdit_LoadMapFile
Params:
	mapfile	 - the name of the mapfile to load, same name as in scriptfiles/
	ReadOnly - if set to 1, players can't edit this Map with Map Editor
	diffX    - the difference at x-axis from the mapfile's positions
	diffY    - the difference at y-axis from the mapfile's positions
	diffZ    - the difference at z-axis from the mapfile's positions
Returns:
	object_count - number of object that're in the map file
Notes:
	-
----------------------------------------------------------------------------- */
stock MEdit_LoadMapFile( mapfile[], ReadOnly = 1, Float:diffX = 0.0, Float:diffY = 0.0, Float:diffZ = 0.0 )
{
	if( strlen( mapfile ) == 0 )
	{
		return -1;
	}
	
	return CallRemoteFunction( "_medit_LoadMapFile", "sifff", mapfile, ReadOnly, diffX, diffY, diffZ );
}





/* -----------------------------------------------------------------------------
Function:
	MEdit_ClearMap
Params:
	-
Returns:
	-
Notes:
	Cleans the map from all objects and  pickups that have been created with
	Map Editor
----------------------------------------------------------------------------- */
stock MEdit_ClearMap( )
{
	CallRemoteFunction( "_medit_ClearMap", "" );
}
