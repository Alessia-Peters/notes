#ifndef CWrapper_h
#define CWrapper_h

#include <ncurses.h>

// Exists because importing C variadic functions into swift doesn't seem to work
void movePrint(int y, int x, const char * text, bool highlighted) {
	if(highlighted) {
		attron(A_REVERSE);
		mvprintw(y, x, text);
		attroff(A_REVERSE);
	} else {
		mvprintw(y, x, text);
	}
	
}

#endif /* CWrapper_h */
