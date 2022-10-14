#include <a_samp>
#include <a_http>

forward roar_OnGameModeInit();

public OnGameModeInit()
{
	print("\n--------------------------------------");
	print(" ICQ-Roar v0.1 by Trooper[Y] => loaded");
	print("--------------------------------------\n");
	return CallLocalFunction("roar_OnGameModeInit","");
}

forward ICQSend(loginname[],loginpw[],targetuid[],targettext[]);
public ICQSend(loginname[],loginpw[],targetuid[],targettext[])
{
	new icqroar_req[5000];
	format(icqroar_req,5000,"uid=%s&pw=%s&action=send&senduid=%s&sendmsg=%s",loginname,loginpw,targetuid,targettext);
	//printf("query: %s",icqroar_req);
	HTTP(1, HTTP_POST, "trooper.sa-rl.de/savandreas/icq/icq-api.php",icqroar_req,"nirvana");

	return 1;
}

forward nirvana(index, response_code, data[]);
public nirvana(index, response_code, data[])
{
	//printf("response: %s",data);
	return 1;
}

#if defined _def_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _def_OnGameModeInit
#endif
#define OnGameModeInit roar_OnGameModeInit