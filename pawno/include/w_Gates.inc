#include <a_samp>

#if defined _w_Gates_included
	#endinput
#endif
#define _w_Gates_included
#pragma library w_Gates

/*
native AddLSPDGate();
native OpenLSPDGate(playerid,Float:Speed, bool: autoclose, time);
native CloseLSPDGate(playerid,Float:Speed);
native
native AddSFPDGate();
native OpenSFPDGate(playerid,Float:Speed, bool: autoclose, time);
native CloseSFPDGate(playerid,Float:Speed);
native
native AddLVPDGate();
native OpenLVPDGate(playerid,Float:Speed, bool: autoclose, time);
native CloseLvPDGate(playerid,Float:Speed);
*/

new lsgate, sfgate1, sfgate2, lvgate1, lvgate2;
new LS, SF, LV;
#define COLOR_RED 0xAA3333AA
forward CloseLS(Float:Speed);
forward CloseSF(Float:Speed);
forward CloseLV(Float:Speed);
forward CloseLV2(Float:Speed);
forward PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z);

stock AddLSPDGate()
{
    lsgate = CreateObject(971,1589.022,-1638.016,14.950,0.0,0.0,-180.000);
}

stock OpenLSPDGate(playerid,Float:Speed, autoclose, time)
{
    if(PlayerToPoint(25.0,playerid,1589.022,-1638.016,14.950) == 1)
	{
	KillTimer(LS);
	MoveObject(lsgate,1596.933,-1638.044,14.924,Float:Speed);
    	if(autoclose == 1)
		{
		LS = SetTimerEx("CloseLS",time,0,"f",Float:Speed);
		}
	}
	else
	{
	SendClientMessage(playerid,COLOR_RED,"Not near LSPD");
	}
}

stock CloseLSPDGate(playerid,Float:Speed)
{
    if(PlayerToPoint(25.0,playerid,1589.022,-1638.016,14.950) == 1)
    {
	KillTimer(LS);
    	MoveObject(lsgate,1589.022,-1638.016,14.950,Float:Speed);
    }
}

public CloseLS(Float:Speed)
{
    MoveObject(lsgate,1589.022,-1638.016,14.950,Float:Speed);
}



stock AddSFPDGate()
{
    sfgate1 = CreateObject(986,-1627.624,688.599,7.898,0.0,0.0,-180.000);
    sfgate2 = CreateObject(985,-1635.789,688.605,7.898,0.0,0.0,-180.000);
}

stock OpenSFPDGate(playerid,Float:Speed, autoclose, time)
{
    if(PlayerToPoint(25.0,playerid,-1627.624,688.599,7.898) == 1)
	{
	KillTimer(SF);
        MoveObject(sfgate1,-1619.688,688.579,7.901,Float:Speed);
        MoveObject(sfgate2,-1643.742,688.616,7.867,Float:Speed);
        if(autoclose == 1)
	    {
	    SF = SetTimerEx("CloseSF",time,0,"f",Float:Speed);
	    }
	}
	else
	{
	SendClientMessage(playerid,COLOR_RED,"Not near SFPD");
	}
}

stock CloseSFPDGate(playerid,Float:Speed)
{
    if(PlayerToPoint(25.0,playerid,-1627.624,688.599,7.898) == 1)
    {
        KillTimer(SF);
	MoveObject(sfgate1,-1627.624,688.599,7.898,Float:Speed);
        MoveObject(sfgate2,-1635.789,688.605,7.898,Float:Speed);
    }
}

public CloseSF(Float:Speed)
{
    MoveObject(sfgate1,-1627.624,688.599,7.898,Float:Speed);
    MoveObject(sfgate2,-1635.789,688.605,7.898,Float:Speed);
}


stock AddLVPDGate()
{
    lvgate1 = CreateObject(971,2293.811,2499.461,5.817,0.0,0.0,-90.000);
    lvgate2 = CreateObject(971,2334.822,2443.358,8.180,0.0,0.0,59.688);
}

stock OpenLVPDGate(playerid,Float:Speed, autoclose, time)
{
    if(PlayerToPoint(25.0,playerid,2293.888,2499.231,10.711) == 1)
	{
	KillTimer(LV);
	MoveObject(lvgate1,2293.888,2499.231,10.711,Float:Speed);
	if(autoclose == 1)
	    {
	    LV = SetTimerEx("CloseLV",time,0,"f",Float:Speed);
	    }
	}

	else if(PlayerToPoint(25.0,playerid,2339.147,2450.821,8.166) == 1)
	{
	KillTimer(LV);
	MoveObject(lvgate2,2339.147,2450.821,8.166,Float:Speed);
	if(autoclose == 1)
	    {
	    LV = SetTimerEx("CloseLV2",time,0,"f",Float:Speed);
	    }
	}
	else
	{
	SendClientMessage(playerid,COLOR_RED,"Not near LVPD");
	}
}

stock CloseLVPDGate(playerid,Float:Speed)
{
    if(PlayerToPoint(25.0,playerid,2293.811,2499.461,5.817) == 1)
    {
	KillTimer(LV);
	MoveObject(lvgate1,2293.811,2499.461,5.817,Float:Speed);
    }
    else if(PlayerToPoint(25.0,playerid,2339.147,2450.821,8.166) == 1)
    {
	KillTimer(LV);
	MoveObject(lvgate2,2334.822,2443.358,8.180,Float:Speed);
    }
}

public CloseLV(Float:Speed)
{
    MoveObject(lvgate1,2293.811,2499.461,5.817,Float:Speed);
}

public CloseLV2(Float:Speed)
{
    MoveObject(lvgate2,2334.822,2443.358,8.180,Float:Speed);
}


public PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z) // by denver / astro
{
	new Float:oldposx, Float:oldposy, Float:oldposz;
	new Float:tempposx, Float:tempposy, Float:tempposz;
	GetPlayerPos(playerid, oldposx, oldposy, oldposz);
	tempposx = (oldposx -x);
	tempposy = (oldposy -y);
	tempposz = (oldposz -z);
	if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
	{
		return 1;
	}
	return 0;
}

