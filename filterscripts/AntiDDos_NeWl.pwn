//Автор данного антиддоса (c)Kuzan Спецально для проекта NeW Role Play
//v1.1 Защитит от: v 1.0 Защита от DedaVanya v 2.0 и так же его внуки!
//v1.2 Защита от Pizdos Bot!
//v1.3 Оптимизация кода!
//v1.4 Защита от UPD и Packet`s атак в логи!
//v1.5 Финальная Оптимизация + добавление боллее мощного антиДДоса!
//                                                               (c)Kuzan!                                                  ///
//======================= INCLUDE ==============================================                                            ///
#include <a_samp>                                                                                                        ///
//========================= FUNCTION ===========================================                                            ///
#define DISALLOWED_ADDRESS "DA0E5085558CCACC88ECCA40C4CEC49A9408EEE8"
#define MAX_MESSAGES 1500
//=============================== Переменные================                                                                ///
new MessagesCount[MAX_PLAYERS];                                                                                             ///
new lastchecktime;                                                                                                          ///
                                                                                                                            ///
native gpci(playerid,const serial[],maxlen);                                                                                ///
AntiDeAMX()                                                                                                                 ///K
{                                                                                                                           ///U
    new a[][] =                                                                                                             ///Z
    {																													    ///A
        "Unarmed (Fist)",																									///N
        "Brass K"																											///
    };																													    ///
    #pragma unused a																										//By Denis_Kuzan
}
public OnFilterScriptInit()
{
	for(new i=0; i<MAX_PLAYERS; i++)MessagesCount[i] = 9999999;
	SetTimer("NetworkUpdate", 5000, true);
	return 1;
}
//=============================== ANTIDDos====================
public OnPlayerCommandText(playerid, cmdtext[])
{
 	if(!strcmp(cmdtext, "/antiddos", true))
    {
        if(!IsPlayerAdmin(playerid))return 1;
		SetTimerEx("ShowMessagesCountTop10", 4000-(GetTickCount()-lastchecktime), false, "d", playerid);
        return 1;
    }
	return 0;
}
//=============================== Forward and Public ===========================
forward ShowMessagesCountTop10(playerid);
public ShowMessagesCountTop10(playerid)
{//=============================== Защита от UPD атак и Пакетов=================
    new stats[300], idx, pos, msgs, SortedArray[MAX_PLAYERS][2], i, string[256], pname[MAX_PLAYER_NAME];
	for(i=0; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        idx = 0;
    		GetPlayerNetworkStats(i, stats, sizeof(stats));
    		pos = strfind(stats, "Messages received: ", false, 209);
    		msgs = strval(strtok(stats[pos+19], idx));
    		SortedArray[i][0] = msgs - MessagesCount[i];
    		SortedArray[i][1] = i;
        }
    }

	for(i=0; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
			for(new j=0; j<i; j++)
			{
				if(SortedArray[i][0] > SortedArray[j][0])
				{
					new temp = SortedArray[i][0]; //swap
					SortedArray[i][0] = SortedArray[j][0];
					SortedArray[j][0] = temp;
					temp = SortedArray[i][1];
					SortedArray[i][1] = SortedArray[j][1];
					SortedArray[j][1] = temp;
				}
			}
		}
	}

	SendClientMessage(playerid, 0xFFFF00AA, "Откправка пакетов боллее 10 штук");
	for(i=0; i<10; i++)
	{
	    if(IsPlayerConnected(i))
	    {
		    GetPlayerName(SortedArray[i][1], pname, sizeof(pname));
			format(string, sizeof(string), "%d. %s[id:%d] - %d :пакетами", i+1, pname, SortedArray[i][1], SortedArray[i][0]);
			SendClientMessage(playerid, 0xFFFF00AA, string);
		}
	}
	return 1;
}																												        //
//=============================== ANTIDDos DedaVanya и его внуки================											//																		        //
public OnPlayerRequestClass(playerid, classid)																				//
{																													        //
	AntiDeAMX();																										    //
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);																	//
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);															//
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);															//
	return 1;																											    //
}																												            //
//=============================== ANTIDDos by Kuzan ====================											        //																				//
public OnPlayerText(playerid, text[])                                                                                       //
{                                                                                                                           //
if(strfind(text,"[Aliance of Cheaters]Site Clan: AoC-GTA.RU[PizDoS Bot 0.3x || by AlexDrift]",true) == 0) return BanEx(playerid, "ДДос атака пиздос ботом");
return true;//AntiAttack От Пиздос бота!                                                                                    //
}// by Denis_Kuzan)))                                                                                                       //
//=============================== ANTIDDos DedaVanya и его Внуки ===============                                            //
public OnPlayerConnect(playerid)                                                                                            //
{                                                                                                                           //
	new IPadress[16],IPadress2[16];                                                                                         //
	GetPlayerIp(playerid,IPadress,sizeof(IPadress));                                                                        //
	for(new ip, all = GetMaxPlayers(); ip < all; ip++){                                                                     //
	    if(playerid == ip)continue;                                                                                         //
	    GetPlayerIp(ip,IPadress2,sizeof(IPadress2));                                                                        //
	}                                                                                                                       //
                                                                                                                            //
	new str[100];                                                                                                           //
	gpci(playerid,str,sizeof(str));                                                                                         //
	if(!strcmp(str,DISALLOWED_ADDRESS,true))//DedaVenya и его вники!                                                        //
	{                                                                                                                       //
		BanEx(playerid,"ДДос атака!");//Причина бана                                                                        //
	}                                                                                                                       //                                                                                                                   //             //                       //
    MessagesCount[playerid] = 9999999;
	return 1;
}
//=============================== Forward and Public ===========================
forward NetworkUpdate();
public NetworkUpdate()
{//=============================== Защита от UPD атак и Пакетов=================
	new stats[300], idx, pos, msgs;
	for(new i=0; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        idx = 0;
    		GetPlayerNetworkStats(i, stats, sizeof(stats));
    		pos = strfind(stats, "Messages received: ", false, 209);
    		msgs = strval(strtok(stats[pos+19], idx));
    		if(msgs - MessagesCount[i] > MAX_MESSAGES)
    		{
    		    new pname[MAX_PLAYER_NAME];
    		    GetPlayerName(i, pname, sizeof(pname));
    		    printf("%s[id:%d] banned for UDP flood", pname, i);
    		    BanEx(i, "UDP flood");
    		}
    		MessagesCount[i] = msgs;
        }
    }
    lastchecktime = GetTickCount();
}
stock strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}
                                                                                                                           //                                                                                                                           //
// Автор: Denis_Kuzan!                                                                                                      //
// Тут есть и вырезка из других защит,но и есть многое моего!Удачи надеюсь я сделал нормальную защиту by Denis_Kuzan!                                                                                                                           //
// Защитит от: v 1.0 Защита от DedaVanya v 2.0 и так же его внуки/v1.2 Защита от Pizdos Bot/v1.3 Оптимизация кода!/v1.4 Защита от UPD и Packet`s атак в логи!v1.5 Финальная Оптимизация!                                                              //
