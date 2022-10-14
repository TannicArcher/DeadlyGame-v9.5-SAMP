/*
Native function(s) for mailer plugin

By Nubotron
© Nubworx 2009
*/

#if defined mailer_included
	#endinput
#endif
#define mailer_included


native Email(from[], to[], subject[], message[]);
native EmailFile(from[], to[], subject[], file[]);
