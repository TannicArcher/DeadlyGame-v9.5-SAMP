#include <a_samp>

#define MAP_ICON_ID 25

new bmx1, bmx2, bmx3, bmx4, bmx5, bmx6;
new ParkourCP[MAX_PLAYERS];
new ParkourPickups[25];
new ParkourObjects[30];
new Float:ParkourCheckpoints[25][3] = {
	{2373.8765,-1541.5344,23.9957}, // ParkourCP1
	{2373.0486,-1552.8400,24.0017}, // ParkourCP2
	{2384.4683,-1551.3596,27.9935}, // ParkourCP3
	{2399.1670,-1555.5956,31.5000}, // ParkourCP4
	{2453.5364,-1537.7587,32.5703}, // ParkourCP5
	{2449.3672,-1519.6571,39.5156}, // ParkourCP6
	{2438.5513,-1505.6760,35.7168}, // ParkourCP7
	{2413.3809,-1461.7438,28.4979}, // ParkourCP8
	{2378.7883,-1461.2406,30.4979}, // ParkourCP9
	{2369.2756,-1427.0782,31.4979}, // ParkourCP10
	{2390.0483,-1424.7968,34.8078}, // ParkourCP11
	{2428.7058,-1425.8597,34.0322}, // ParkourCP12
	{2525.3743,-1426.2411,52.6406}, // ParkourCP13
	{2610.0210,-1426.4327,62.2486}, // ParkourCP14
	{2636.8721,-1426.3130,64.2202}, // ParkourCP15
	{2666.7104,-1426.4470,52.5178}, // ParkourCP16
	{2705.0305,-1426.1185,54.8802}, // ParkourCP17
	{2704.8784,-1385.9751,70.9922}, // ParkourCP18
	{2704.8552,-1314.7786,72.9453}, // ParkourCP19
	{2629.3811,-1274.8241,81.1481}, // ParkourCP20
	{2530.4265,-1274.1678,52.2697}, // ParkourCP21
	{2552.0576,-1344.4407,54.9633}, // ParkourCP22
	{2548.2012,-1388.1635,44.3632}, // ParkourCP23
	{2543.7932,-1418.7817,34.1670}, // ParkourCP24
	{2540.7419,-1457.0958,31.4730}  // ParkourCP25
};
//==============================================================================
public OnFilterScriptInit()
{
	ParkourObjects[0] = CreateObject(973, 2422.804932, -1552.438110, 30.359535, 92.8192, 0.0000, 0.0000);
	ParkourObjects[1] = CreateObject(973, 2435.304932, -1552.438110, 30.359535, 92.8192, 0.0000, 0.0000);
	ParkourObjects[2] = CreateObject(973, 2449.005127, -1552.438110, 30.359535, 92.8192, 0.0000, 0.0000);
	ParkourObjects[3] = CreateObject(973, 2453.329834, -1545.011475, 30.359535, 92.8192, 0.0000, 90.0000);
	ParkourObjects[4] = CreateObject(1685, 2456.470215, -1525.627319, 32.320313, 0.0000, 0.0000, 326.2500);
	ParkourObjects[5] = CreateObject(1685, 2453.294922, -1523.502197, 36.020294, 0.0000, 0.0000, 326.2500);
	ParkourObjects[6] = CreateObject(2653, 2440.325261, -1508.193433, 33.972530, 0.0000, 0.0000, 37.1877);
	ParkourObjects[7] = CreateObject(2653, 2435.546387, -1501.893433, 33.972530, 0.0000, 0.0000, 37.1877);
	ParkourObjects[8] = CreateObject(2653, 2430.794434, -1495.617920, 33.972530, 0.0000, 0.0000, 37.1877);
	ParkourObjects[9] = CreateObject(2653, 2426.070313, -1489.368408, 33.972530, 0.0000, 0.0000, 37.1877);
	ParkourObjects[10] = CreateObject(2653, 2421.318359, -1483.093872, 33.972530, 0.0000, 0.0000, 37.1877);
	ParkourObjects[11] = CreateObject(18257, 2384.402588, -1424.625610, 29.807814, 0.0000, 0.0000, 180.0000);
	ParkourObjects[12] = CreateObject(17055, 2394.301758, -1425.311279, 32.082123, 0.0000, 0.0000, 270.0000);
	ParkourObjects[13] = CreateObject(17055, 2398.228027, -1425.411377, 32.082123, 0.0000, 0.0000, 270.0000);
	ParkourObjects[14] = CreateObject(17055, 2402.204102, -1425.536499, 32.082123, 0.0000, 0.0000, 270.0000);
	ParkourObjects[15] = CreateObject(17055, 2406.200195, -1425.636353, 32.082123, 0.0000, 0.0000, 270.0000);
	ParkourObjects[16] = CreateObject(16766, 2526.078125, -1426.324951, 50.654560, 0.0000, 347.9679, 0.0000);
	ParkourObjects[17] = CreateObject(16481, 2611.000000, -1426.421509, 60.358688, 0.0000, 0.0000, 180.0000);
	ParkourObjects[18] = CreateObject(16314, 2636.341309, -1426.361938, 42.368404, 0.0000, 0.0000, 0.0000);
	ParkourObjects[19] = CreateObject(16481, 2662.387939, -1426.514648, 49.670704, 0.0000, 0.0000, 360.0000);
	ParkourObjects[20] = CreateObject(2653, 2694.157471, -1427.553223, 50.361935, 0.0000, 0.0000, 270.0000);
	ParkourObjects[21] = CreateObject(2653, 2694.129639, -1426.377075, 50.361935, 0.0000, 0.0000, 270.0000);
	ParkourObjects[22] = CreateObject(2653, 2694.129639, -1425.051514, 50.361935, 0.0000, 0.0000, 270.0000);
	ParkourObjects[23] = CreateObject(2653, 2709.724121, -1394.352539, 54.612118, 23.2048, 0.0000, 0.0000);
	ParkourObjects[24] = CreateObject(2653, 2709.098633, -1394.352539, 57.362072, 23.2048, 0.0000, 180.0000);
	ParkourObjects[25] = CreateObject(2653, 2709.724121, -1394.352539, 60.262112, 23.2048, 0.0000, 0.0000);
	ParkourObjects[26] = CreateObject(2653, 2709.098633, -1394.352539, 63.037052, 23.2048, 0.0000, 180.0000);
	ParkourObjects[27] = CreateObject(2653, 2709.724121, -1394.352539, 65.962128, 23.2048, 0.0000, 0.0000);
	ParkourObjects[28] = CreateObject(2653, 2709.098633, -1394.352539, 68.787033, 23.2048, 0.0000, 180.0000);
	ParkourObjects[29] = CreateObject(1634, 2650.559326, -1274.538818, 72.967613, 0.0000, 0.0000, 90.0000);
	
	bmx1 = CreateVehicle(481,2707.9404,-1311.6324,72.4639,91.8986,46,46,30); // ParkourBMX
	bmx2 = CreateVehicle(481,2707.7512,-1310.9205,72.4602,92.2435,65,9,30); // ParkourBMX
	bmx3 = CreateVehicle(481,2707.7454,-1309.2709,72.4604,90.5178,12,9,30); // ParkourBMX
	bmx4 = CreateVehicle(481,2707.6079,-1310.1509,72.4610,91.8119,14,1,30); // ParkourBMX
	bmx5 = CreateVehicle(481,2707.6165,-1307.3964,72.4600,91.3951,1,1,30); // ParkourBMX
	bmx6 = CreateVehicle(481,2707.6287,-1308.3234,72.4602,91.3950,26,1,30); // ParkourBMX
	
	for(new i = 0; i < sizeof(ParkourCheckpoints); i++)
	{
	    ParkourPickups[i] = CreatePickup(2914, 2, ParkourCheckpoints[i][0], ParkourCheckpoints[i][1], ParkourCheckpoints[i][2]);
	}
	return 1;
}
//==============================================================================
public OnFilterScriptExit()
{
	for(new i = 0; i < sizeof(ParkourCheckpoints); i++)
	{
	    DestroyPickup(ParkourPickups[i]);
	}
	for(new i = 0; i < 30; i++)
	{
	    DestroyObject(ParkourObjects[i]);
	}
	DestroyVehicle(bmx1);
	DestroyVehicle(bmx2);
	DestroyVehicle(bmx3);
	DestroyVehicle(bmx4);
	DestroyVehicle(bmx5);
	DestroyVehicle(bmx6);
	return 1;
}
//==============================================================================
public OnPlayerConnect(playerid)
{
	ParkourCP[playerid] = -1;
	return 1;
}
//==============================================================================
forward Parkour(playerid);
public Parkour(playerid)
{
	    ParkourCP[playerid] = 0;
	    SetPlayerMapIcon(playerid, MAP_ICON_ID, ParkourCheckpoints[0][0], ParkourCheckpoints[0][1], ParkourCheckpoints[0][2], 53, 0);
	    SetPlayerPos(playerid, 2374.4949,-1521.4510,23.8281);
	    SetPlayerFacingAngle(playerid, 175.9439);
	    SetCameraBehindPlayer(playerid);
	    SetPlayerHealth(playerid, 100.0);
	    SendClientMessage(playerid, 0xFACBADFF, "Вы на старте Паркур Зоны, подбирайте флажки и продвигайтесь вперёд!");
	    return 1;
}
//==============================================================================
public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(ParkourCP[playerid] == -1)
	    return 1;
	    
	if(ParkourPickups[ParkourCP[playerid]] == pickupid)
	{
		ParkourCP[playerid]++;
		if(ParkourCP[playerid] == sizeof(ParkourCheckpoints))
		{
			ParkourCP[playerid] = -1;
			SendClientMessage(playerid, 0xFACBADFF, "Вы прошли всю Паркур Зону");
			RemovePlayerMapIcon(playerid, MAP_ICON_ID);
		}
		else
		{
		    new string[50];
		    format(string, 50, "~g~~h~~h~do vnhnwa: ~g~~h~~h~~h~%i/25", ParkourCP[playerid]);
		    GameTextForPlayer(playerid, string, 3000, 5);
			SetPlayerMapIcon(playerid, MAP_ICON_ID, ParkourCheckpoints[ParkourCP[playerid]][0], ParkourCheckpoints[ParkourCP[playerid]][1], ParkourCheckpoints[ParkourCP[playerid]][2], 53, 0);
		}
	}
	return 1;
}
//==============================================================================
forward GivePlayerMoneyByKRYPTODENS(playerid,money);
public GivePlayerMoneyByKRYPTODENS(playerid,money)
{
  GivePlayerMoney(playerid, money);
  return 1;
}
