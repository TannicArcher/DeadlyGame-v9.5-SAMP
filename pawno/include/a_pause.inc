/*
 *          Pause System Include
 *            (c) xJester 2009
 *
 */

#if defined _pause_included
	#endinput
#endif
#define _pause_included
#pragma library pause

#include <a_samp>
#define delay(%1); pause(%1);

/*  ---------------------------------------------
 *	Function name: 	pause(seconds)
 *  Parameters:     seconds - delay in seconds
 *  ---------------------------------------------
 */

pause(seconds)
{
	static newDelay[4], oldDelay[4];
	gettime(oldDelay[0], oldDelay[1], oldDelay[2]);
	oldDelay[3] = oldDelay[2] + (oldDelay[1] * 60) + (oldDelay[0] * 600);
	while(newDelay[3] != (oldDelay[3] + seconds))
	{
		gettime(newDelay[0], newDelay[1], newDelay[2]);
		newDelay[3] = newDelay[2] + (newDelay[1] * 60) + (newDelay[0] * 600);
	}
}
