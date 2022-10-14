/* Feel free to do waht you want with it as
 * long you give credit.
 *
 * (c) Copyright 2007, Sagi Levy (`LucifeR`)
 * This file is provided as is (no warranties).
 */

#if defined _vehicle_included
  #endinput
#endif

#define _vehicle_included
#pragma library vehicle

#include <a_samp>
#include <dudb>


/*
 # To be Used:
 #              AddStaticVehicles(modelid, Float:x, Float:y, Float:z, Float:angle, amount ,plusx, plusy, colors[]);
 #                  modelid - the Model-ID of the Vehicle (type).
 #                  Float:x, Float:y, Float:z - the coords for the first car.
 #                  Float:angle - the angle that the car should look at.print
 #                  amount - the amount of  vehicles that the function will make.
 #                  plusx - the differents of the x's coord between the first and the second vehicle.
 #                  plusx - the differents of the y's coord between the first and the second vehicle.
 #                  colors[] - a string of the colors for the car. can use only two colors ("1 0")
 #                             and all the cars will have this color. can be used with ("1 0 3 4 5 9")
 #                             and each of the 3 cars will have a different color. if there will be any
 #                             more vehicles which a color is not beeing set to it will use the last given
 #                             colors. instead of a color number you can use the word "rand" and the color
 #                             will bw a random one. you can use "rand rand" and all the vehicles will have a
 #                             random color (a different for each car).
 #   exemple: AddStaticVehicles(401, -5.6264, 1076.3631, 10.3412, 246.453, 3, 6, 3, 1 56 75 26 42 55);
*/
public AddStaticVehicles(modelid, Float:x, Float:y, Float:z, Float:angle, amount ,plusx, plusy, colors[])
{
	new px = 0-plusx;
	new py = 0-plusy;

	new color1;
	new color2;
	new temp[256];
	new index = 0;
	
	new cl1[256];
	new cl2[256];
	
	for(new i=0; i <= amount; i++)
	{
	    temp = strtok(colors, index);
        if(!strlen(temp)) {
			if(strcmp(cl1, "rand", true) == 0) { color1 = random(127); }
		    else { color1 = strval(cl1); }
		}
		else {
			if(strcmp(temp, "rand", true) == 0) { color1 = random(127); }
		    else { color1 = strval(temp); }
		    cl1[255] = temp[255];
	 	}
	    
        temp = strtok(colors, index);
        if(!strlen(temp)) {
			if(strcmp(cl2, "rand", true) == 0) { color2 = random(127); }
		    else { color2 = strval(cl2); }
		}
		else {
			if(strcmp(temp, "rand", true) == 0) { color2 = random(127); }
		    else { color2 = strval(temp); }
		    cl2[255] = temp[255];
	 	}
		
	    px+=plusx;
	    py+=plusy;
		AddStaticVehicle(modelid, x+px, y+py, z, angle, color1, color2);
	}
}



/*
 # To be Used:
 #              AnyPlayerInVehicle(vehicleid)
 #                  vehicleid - the id of the vehicle you want to check.
 #   exemple: if(AnyPlayerInVehicle(GetPlayerVehicleID(playerid))) { print("the player is really in a vehicle"); }
*/

public AnyPlayerInVehicle(vehicleid)
{
	new bool:in = false;
	for(new i=0; i <= GetMaxPlayers(); i++)
	{
	    if(IsPlayerConnected(i))
	    {
        	if((IsPlayerConnected(i)) && (IsPlayerInVehicle(i, vehicleid)))
			{
			    in = true;
			}
        }
	}
	return in;
}



/*
 # To be Used:
 #              IsVehicleInArea(vehicleid, Float:data[4])
 #                  vehicleid - the id of the vehicle you want to check.
 #                  Float:data[4] - a Float with 4 parameters.
 #   exemple: if(IsVehicleInArea(0)) { print(" vehicle id 0 is in the area."); }
*/
public IsVehicleInArea(VehicleID, Float:data[4])
{
	new Float:X, Float:Y, Float:Z;

	GetVehiclePos(VehicleID, X, Y, Z);
	if(X >= data[0] && X <= data[2] && Y >= data[1] && Y <= data[3]) {
		return 1;
	}
	return 0;
}



/*
 # To be Used:
 #              GetVehiclePlayersAmount(vehicleid)
 #                  vehicleid - the id of the vehicle you want to check.
 #   exemple: new playersincar = GetVehiclePlayersAmount(28);
*/

public GetVehiclePlayersAmount(vehicleid)
{
 	new amount=0;
	for(new i=0; i <= GetMaxPlayers(); i++)
	{
	    if((IsPlayerConnected(i)) && (IsPlayerInVehicle(i, vehicleid)))
     	{
  		    amount++;
        }
	}
	return amount;
}

/*
 # To be Used:
 #              GetVehiclePassengers(vehicleid)
 #                  vehicleid - the id of the vehicle you want to check.
 #   exemple: new passengers = Passengers(28);
*/

public GetVehiclePassengers(vehicleid)
{
 	new amount=0;
	for(new i=0; i <= GetMaxPlayers(); i++)
	{
	    if((IsPlayerConnected(i)) && (IsPlayerInVehicle(i, vehicleid)) && (GetPlayerState(i) != PLAYER_STATE_DRIVER))
     	{
  		    amount++;
        }
	}
	return amount;
}




/*
 # To be Used:
 #              GetVehicleDriver(vehicleid)
 #                  vehicleid - the id of the vehicle you want to check.
 #   exemple: new driver = GetVehicleDriver(0);
*/

public GetVehicleDriver(vehicleid)
{
 	new id;
	for(new i=0; i <= GetMaxPlayers(); i++)
	{
	    if((IsPlayerConnected(i)) && (IsPlayerInVehicle(i, vehicleid)) && (GetPlayerState(i) == PLAYER_STATE_DRIVER))
     	{
			id=i;
        }
	}
	
	return id;
}




/*
 # To be Used:
 #              IsPlayerDriver(playerid)
 #                  playerid - the id of the player to check.
 #   exemple: if(IsPlayerDriver(playerid)) { prin("player is driving a car"); }
*/

public IsPlayerDriver(playerid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) { return true; }
 	return false;
}



/*
 # To be Used:
 #              RemovePassengersFromVehicle(vehicleid)
 #                  vehicleid - the id of the vehicle wich the players will be removed from.
 #   exemple: RemovePassengersFromVehicle(0) print("all players exept the driver was removed from the vehicle.");
*/

public RemovePassengersFromVehicle(vehicleid)
{
    for(new i=0; i <= GetMaxPlayers(); i++)
	{
	    if((IsPlayerConnected(i)) && (IsPlayerInVehicle(i, vehicleid)) && (GetPlayerState(i) != PLAYER_STATE_DRIVER))
     	{
  		    RemovePlayerFromVehicle(i);
        }
	}
}







