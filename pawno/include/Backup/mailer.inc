/*
Native function(s) for mailer plugin 0.2

© Nubworx 2009
*/

#if defined mailer_included
	#endinput
#endif
#define mailer_included


native email(from[], to[], subject[], body[], bool:html = false);

#define Email(%0) email(%0)
