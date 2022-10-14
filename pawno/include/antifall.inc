/*
					///////////////////////////////////////////////////
					////                                           ////
					////          tAxI's Bike Anti-Fall            ////
					////                 System                    ////
					////                                           ////
					////     COPYRIGHT: RELEASED UNDER the GNU     ////
					////                 LICENCE                   ////
					////                                           ////
					///////////////////////////////////////////////////


    tAxI's Bike Anti-Fall System - INC Package for SA-MP Multiplayer Modification
    of Grand Theft Auto - San Andreas.

    Copyright (C) 2008  Chris Johnstone (tAxI/Necrioss)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <http://www.gnu.org/licenses/>.

=============================================================================================
THIS CODE IS DESIGNED TO ALLOW USERS TO SPECIFY WHETHER OR NOT A PERSON CAN FALL OFF A BIKE 
AFTER A COLLISION - THERE IS STILL THE POSSIBILLITY OF FALLING OFF IF THE PLAYER SPINS OUT OF
CONTROL
=============================================================================================

native tAxI_OnPlayerEnterVehicle(playerid,vehicleid)
native tAxI_OnPlayerKeyStateChange(playerid,newkeys)
NATIVE tAxI_OnPlayerStateChange(playerid,newstate,oldstate)
native SetBikeAntiFallForPlayer(playerid,bool:toggle)

=============================================================================================
*/


#define RED 0xFF0000AA
#define BLUE 0x0000BBAA
#define KEY_EXIT_VEHICLE	16

new antifall[MAX_PLAYERS];
new cmdoff[MAX_PLAYERS];
new lastv[MAX_PLAYERS];


stock tAxI_OnPlayerEnterVehicle(playerid,vehicleid)
{
	lastv[playerid] = vehicleid;
	if(Abandoned[vehicleid] == 1) {
	    Abandoned[vehicleid] = 0;
	 	KillTimer(atimer[vehicleid]);
	}
    SetVehicleUsed(vehicleid,true);
	return 1;
}

stock tAxI_OnPlayerStateChange(playerid,newstate,oldstate)
{
	if (oldstate == PLAYER_STATE_DRIVER) {
 		if(antifall[playerid] == 1 && newstate == PLAYER_STATE_ONFOOT) {
    		if(cmdoff[playerid] == 1) {
     			cmdoff[playerid] = 0;
     		}
      		else {
       			PutPlayerInVehicle(playerid,lastv[playerid],0);
			}
       	}
    }
    if (oldstate == PLAYER_STATE_PASSENGER) {
 		if(antifall[playerid] == 1 && newstate == PLAYER_STATE_ONFOOT) {
    		if(cmdoff[playerid] == 1) {
     			cmdoff[playerid] = 0;
     		}
      		else {
       			PutPlayerInVehicle(playerid,lastv[playerid],1);
			}
       	}
    }
}

stock SetBikeAntiFallForPlayer(playerid,bool:toggle)
{
    if(toggle == true) {
        antifall[playerid] = 1;
        cmdoff[playerid] = 0;
        return SendClientMessage(playerid,BLUE,"Your bike Anti-Fall is now active!");
    }
    if(toggle == false) {
        antifall[playerid] = 0;
        cmdoff[playerid] = 0;
        return SendClientMessage(playerid,RED,"Your bike Anti-Fall is now inactive!");
    }
    return 1;
}

stock tAxI_OnPlayerKeyStateChange(playerid,newkeys)
{
	if(newkeys == KEY_EXIT_VEHICLE) {
		cmdoff[playerid] = 1;
	}
	return 1;
}
