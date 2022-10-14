/*
 * RLIB v1.0 By Ramjet (c) 2007
 * 5 Useful Functions for PAWN!
 * 6:09 PM 29/06/2007
 *
 */

/*
 * Function: MakeDirectory()
 * Usage: Creates a Directory on the server.
 * Returns: Returns 0 on success, Returns -1 on Failure.
 */

native MakeDirectory(dir[]);

/*
 * Function: DelDirectory()
 * Usage: Deletes a Directory on the server.
 * Returns: Returns 0 on success, Returns -1 on Failure.
 */

native DelDirectory(dir[]);

/*
 * Function: GetDrive()
 * Usage: Returns the Drive in use for the server.
 * Returns: See Above. The return is a single charactor.
 */

native GetDrive();

/*
 * Function: ChmodFile()
 * Usage: Changes the permissions of a file.
 * Returns: Returns 0 on success, Returns -1 on Failure.
 * Extra Info: type is the type of Write Permission. They are defined below.
 */

#define CHMOD_READ 1
#define CHMOD_WRITE 2
#define CHMOD_READ_WRITE 3

native ChmodFile(path[], type);

/*
 * Function: RemoveFile()
 * Usage: Deletes (or removes) a file.
 * Returns: Returns 0 on success, Returns -1 on Failure.
 */

native RemoveFile(path[]);