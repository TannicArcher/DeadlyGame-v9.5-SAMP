#if defined _TIS_included
	#endinput
#endif
#define _TIS_included

native xsleep(ms);
native CreateThread(you_param[]);
forward OnThreadWork(tid_param[]);