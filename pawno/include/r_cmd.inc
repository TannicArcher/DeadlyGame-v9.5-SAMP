

#if defined _rcmd_included
	#endinput
#endif	
#define _rcmd_included
// =============================================

// ================== Natives ==================
/*
	native CallPlayerCommand(cmd_text[], playerid, params[0] = 0);
	native CallRCONCommand(cmd_text[], params[0] = 0);
*/
// =============================================

// ================= Константы =================
const MAX_CMD_NAME = 14; // Максимальное имя команды
// =============================================

// =========== Дополнительные функции ==========
static stock FixConsoleInput(source[]) /// by Romanius
{
	for(new i; source[i] != 0x0; i++)
	{
		switch(source[i])
		{
			case 0x80..0xAF: source[i] += 0x40;
			case 0xE0..0xEF: source[i] += 0x10;
			case 0xF0: 		 source[i] -= 0x48;
			case 0xF1: 		 source[i] -= 0x39;
			case 0xFC: 		 source[i] -= 0x43;
			default: 		 source[i] -= 0x0;
		}
	}
}
// =============================================

// ================ Сам движок =================
public OnPlayerCommandText(playerid, cmdtext[])
{
    new i = 1, command[MAX_CMD_NAME char], cparams = 1; // Обьявим переменные (тут i = 1 потому что команда начинается с / (слеш))
	
	command{0} = 'p'; command{1} = '_'; // Подставим префикс
	
	for( ; cmdtext[i] > 0x20; i++) command{i + 1} = tolower(cmdtext[i]); // Получим имя команды в нижнем регистре
	
	if(funcidx(command) > 0) // Проверим есть ли такая команда в моде
	{
		while(cmdtext[i] == 0x20) i++; // Проберемся до первого пробела
		
		if(!cmdtext[i]) return CallLocalFunction(command, "isi", playerid, "\1", 0); // Если параметров нет то вызовим функцию с нулевым параметром
		else // Если параметр(ы) существует(ют)
		{
			for(new j = i; cmdtext[j] != 0x0; j++) if(cmdtext[j] == 0x20) cparams++; // Посчитаем количество параметров
			
			return CallLocalFunction(command, "isi", playerid, cmdtext[i], cparams); // Вызовим нашу команду
		}
	}
	else if(funcidx("rcmd_OnPlayerCommandText") > 0) return CallLocalFunction("rcmd_OnPlayerCommandText", "is", playerid, cmdtext); else return 0; // Если имеется CallBack OnPlayerCommandText то вызовим его в противном случае возвратим 0 (сервер выдаст "SERVER: Unkown command")
}

public OnRconCommand(cmd[])
{
	new i = 0, command[MAX_CMD_NAME char], cparams = 1; // Обьявим переменные
	
	command{0} = 'r'; command{1} = '_'; // Подставим префикс
	
	for( ; cmd[i] > 0x20; i++) command{i + 2} = tolower(cmd[i]); // Получим имя команды в нижнем регистре
	
	if(funcidx(command) > 0) // Проверим есть ли такая команда в моде
	{
		while(cmd[i] == 0x20) i++; // Проберемся до первого пробела
		
		if(!cmd[i]) return CallLocalFunction(command, "si", "\1", 0); // Если параметров нет то вызовим функцию с нулевым параметром
		else // Если параметр(ы) существует(ют)
		{
			for(new j = i; cmd[j] != 0x0; j++) if(cmd[j] == 0x20) cparams++; // Посчитаем количество параметров
			
			#if defined FIX_CONSOLE_INPUT
			  FixConsoleInput(cmd[i]); // Профиксим русские буквы
			#endif
			
			return CallLocalFunction(command, "si", cmd[i], cparams); // Вызовим нашу команду
		}
	}
	else if(funcidx("rcmd_OnRconCommand") > 0) return CallLocalFunction("rcmd_OnRconCommand", "s", cmd); else return 0; // Если имеется CallBack OnRconCommand то вызовим его в противном случае возвратим 0 (сервер выдаст "Unkown command or varable")
}
// =============================================

// ===== Функции для вызова команд из кода =====
stock CallPlayerCommand(cmd_text[], playerid, params[0] = 0)
{
	new command[MAX_CMD_NAME char], cparams = 1;  // Заведем переменные
	
	command{0} = 'p'; command{1} = '_'; // Подставим префикс
	
	for(new i = 0; cmd_text[i] != 0x0; i++) command{i + 2} = tolower(cmd_text[i]); // Получим имя команды в нижнем регистре
	
	if(funcidx(command) > 0) // Проверим есть ли такая команда в моде
	{
		if(!params[0]) return CallLocalFunction(command, "isi", playerid, "\1", 0); // Если параметров нет то вызовим функцию с нулевым параметром
		else // Если параметр(ы) существует(ют)
		{
			for(new j = 0; params[j] != 0x0; j++) if(params[j] == 0x20) cparams++; // Посчитаем количество параметров
			
			return CallLocalFunction(command, "isi", playerid, params, cparams); // Вызовим нашу команду
		}
	}
	else return 0; // Если функции не найдено вернем 0
}

stock CallRCONCommand(cmd_text[], params[0] = 0)
{
	new command[MAX_CMD_NAME char], cparams = 1;  // Заведем переменные
	
	command{0} = 'r'; command{1} = '_'; // Подставим префикс
	
	for(new i = 0; cmd_text[i] != 0x0; i++) command{i + 2} = tolower(cmd_text[i]); // Получим имя команды в нижнем регистре
	
	if(funcidx(command) > 0) // Проверим есть ли такая команда в моде
	{
		if(!params[0]) return CallLocalFunction(command, "si", "\1", 0); // Если параметров нет то вызовим функцию с нулевым параметром
		else // Если параметр(ы) существует(ют)
		{
			for(new j = 0; params[j] != 0x0; j++) if(params[j] == 0x20) cparams++; // Посчитаем количество параметров
			
			return CallLocalFunction(command, "si", params, cparams); // Вызовим нашу команду
		}
	}
	else return 0; // Если функции не найдено вернем 0
}
// =============================================

// ============= Удаление Констант =============
#undef MAX_CMD_NAME
// =============================================

// ===== Forward'ы для изменненых пабликов =====
forward rcmd_OnPlayerCommandText(playerid, cmdtext[]);
forward rcmd_OnRconCommand(cmd[]);
// =============================================

// == Макросы для создания команд для игроков ==
#define PLAYERCMD:%1(%2,%3,%4) forward p_%1(%2, %3, %4); \
							   public p_%1(%2, %3, %4)
							   
#define PCMD:%1(%2,%3,%4)      PLAYERCMD:%1(%2, %3, %4)
#define playercmd(%1,%2,%3,%4) PLAYERCMD:%1(%2, %3, %4)
#define pcmd(%1,%2,%3,%4)      PLAYERCMD:%1(%2, %3, %4)
// =============================================

// ===== Макросы для создания RCON команд ======
#define RCONCMD:%1(%2,%3) forward r_%1(%2, %3); \
						  public r_%1(%2, %3)
					   
#define RCMD:%1(%2,%3)    RCONCMD:%1(%2, %3)
#define rconcmd(%1,%2,%3) RCONCMD:%1(%2, %3)
#define rcmd(%1,%2,%3)    RCONCMD:%1(%2, %3)
// =============================================

// ==== Макросы для управлениями пабликами =====
#define OnPlayerCommandText rcmd_OnPlayerCommandText
#define OnRconCommand rcmd_OnRconCommand
// =============================================