
/* V-Admin Include  1.0 - Created by Yaheli
=============================================================================================
	Functions:
		IsPlayerVAdmin(playerid); - Checks if the player is an admin (Returns 'true' if the player is an admin and 'false' if he isn't)
		GetPlayerVAdminLevel(playerid); - Returns the players Admin Level
=============================================================================================
*/

#if defined _VAdmin_included
  #endinput
#endif
#define _VAdmin_included
#pragma library VAdmin

#include <a_samp>


stock IsPlayerVAdmin(playerid)
{

	new playrname[MAX_PLAYER_NAME], string[128], Admin, val[128], key[128], Data[128];  
	GetPlayerName(playerid, playrname, sizeof(playrname));
	format(string, sizeof(string),"V-Admin/Users/%s.ini",playrname);
	new File: UserFile = fopen(string, io_read);
	if ( UserFile )
	{
		key = ini_GetKey( Data );
		if( strcmp( key , "AdminLevel" , true ) == 0 ) { val = ini_GetValue( Data ); Admin = strval( val ); }
      		fclose(UserFile);//close the file after everything has been read in the while
	}
	if(Admin != 0) return true;
	else return false;
}

stock GetPlayerVAdminLevel(playerid)
{

	new playrname[MAX_PLAYER_NAME], string[128], Admin, val[126], key[128], Data[128];  
	GetPlayerName(playerid, playrname, sizeof(playrname));
	format(string, sizeof(string), "V-Admin/Users/%s.ini", playrname);
	new File: UserFile = fopen(string, io_read);
	if ( UserFile )
	{
		key = ini_GetKey( Data );
		if( strcmp( key , "AdminLevel" , true ) == 0 ) { val = ini_GetValue( Data ); Admin = strval( val ); }
      		fclose(UserFile);//close the file after everything has been read in the while
	}
	return Admin;
}

stock ini_GetValue ( line[] )
{
	new valRes[256];
	valRes[0]=0;
	if ( strfind( line , "=" , true ) == -1 ) return valRes;
	strmid( valRes , line , strfind( line , "=" , true )+1 , strlen( line ) , sizeof( valRes ) );
	return valRes;
}
