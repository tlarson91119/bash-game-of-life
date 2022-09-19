# bash-game-of-life
This is my attempt at creating Conway's Game of Life in a bash shell script

Problem:
  I have set 3 cells, after the matrix declaration and initialization as:
  | X X |
  | X   |
  The next state should look like:
  | X X |
  | X X |
  Instead it looks like this:
  |     |
  |   X |
  
Somewhere in the next_board function, it is having issues detecting bottom neighbors and will not "keep life"
  when the conditions call for it ( neighbors == 2 || neighbors == 3 )

"Give life" seems to be working as the main board (matrix) was updated with the new cell, but the first 3 cells
  had disappeared. I stared at the screen for a couple hours, trying to figure it out, but fell asleep.
  
I'm just starting to figure out how git/github works so let me know if there's any issues with this repository.
  
I am pretty new to bash and have been reading from a bash manual PDF and watching tutorial vids sometimes. I made
  the Game of Life in Python with the 2D PyGame library and it turned out great. But I wanted to see if I could
  make the same game in bash as a way to get a better feel for the syntax. I use Linux on a couple systems regularly, but
  I wanted to get some more experience with writing shell scripts.
