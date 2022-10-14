
#if defined _SRO_included
	#endinput
#endif
#define _SRO_included
#pragma library SRO

/* --- SRO by  Jax --- */
/* --- Version 0.1 --- */

stock SRO_tolower(tick)
{
	static const sro_s = 10;
	for(new c; c<tick; c++)
	{
	    printf(tolower(tick));
	}
	return tick*(tick-1)+(tick-sro_s);
}

