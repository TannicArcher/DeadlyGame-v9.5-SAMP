/********************************************
*************** Include *********************
****** Simple Check Vehicle Fuel ***********
*************** by DiSE ********************
*****************************Original Schwan****************/
#include <a_samp>
#if defined SCVF_loaded
#endinput
#endif

#define SCVF_loaded

/*
 IsPlayerAI95(playerid);
 IsPlayerAI92(playerid);
 IsPlayerAI80(playerid);
 IsPlayerSolyarka(playerid);

 */


stock IsPlayerAI95(playerid)                    // 95 бензин
{
    #define MAX_AI95 22
    new AI95[MAX_AI95] =
    {
        602,429,496,541,415,587,494,502,411,559,603,506,451,558,477,489,490,495,505,525,528
    };
    new vehicleid = GetPlayerVehicleID(playerid);
    if(IsPlayerInVehicle(playerid,vehicleid))
    {
                for(new i = 0; i < MAX_AI95; i++)
                {
                    if(GetVehicleModel(vehicleid) == AI95[i])
                    {
                        return true;
                    }
                }
    }
    return false;
}

stock IsPlayerAI92(playerid)                // 92 бензин
{
    #define MAX_AI92 53
    new AI92[MAX_AI92] =
    {
        400,401,402,405,410,413,420,421,422,424,426,434,436,439,442,445,458,459,461,463,
	468,471,475,479,480,485,500,507,516,518,521,522,523,526,527,533,546,547,550,551,
	561,562,565,574,581,583,585,586,596,597,598,555,560
    };
    new vehicleid = GetPlayerVehicleID(playerid);
    if(IsPlayerInVehicle(playerid,vehicleid))
    {
                for(new i = 0; i < MAX_AI92; i++)
                {
                    if(GetVehicleModel(vehicleid) == AI80[i])
                    {
                        return true;
                    }
                }
    }
    return false;
}

stock IsPlayerAI80(playerid)                // 80 бензин
{
    #define MAX_AI80 30
    new AI80[MAX_AI80] =
    {
        404,412,419,438,439,448,457,462,466,467,474,478,491,492,504,
	517,534,535,536,542,543,545,549,575,576,580,589,600,604,605
    };
    new vehicleid = GetPlayerVehicleID(playerid);
    if(IsPlayerInVehicle(playerid,vehicleid))
    {
                for(new i = 0; i < MAX_AI80; i++)
                {
                    if(GetVehicleModel(vehicleid) == AI80[i])
                    {
                        return true;
                    }
                }
    }
    return false;
}



stock IsPlayerSolyarka(playerid)   // Солярка
{
    #define MAX_Solyarka 45
    new Solyarka[MAX_Solyarka] =
    {
	609,601,588,582,578,573,573,564,556,557,554,552,544,532,531,524,515,514,482,470,456,455,
	444,443,440,437,433,432,431,428,427,423,418,416,414,409,408,407,406,403,508,499,498,486,483
    };
    new vehicleid = GetPlayerVehicleID(playerid);
    if(IsPlayerInVehicle(playerid,vehicleid))
    {
                for(new i = 0; i < MAX_Solyarka; i++)
                {
                    if(GetVehicleModel(vehicleid) == Solyarka[i])
                    {
                        return true;
                    }
                }
    }
    return false;
}