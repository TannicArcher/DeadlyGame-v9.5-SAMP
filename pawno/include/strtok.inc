#if defined _strtok_included
	#endinput
#endif
#define _strtok_included

strtok(const string[], &index)
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
