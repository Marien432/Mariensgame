# Mariensgame

#### Video Demo: https://youtu.be/Fvc53Nl6cWo

#### Description: This is a platform game made with lua in Love2d. I used Atom as my IDE. 
The map is created with 'Tiled' and implemented with the Simple Tile Implementation (STI). 
With the little time i had (2 weeks) there is only one map at the moment. 
But I'd like to expand this game later on with multiple maps, sound, enemies etc.

To start the game:
Make sure you have downloaded LÖVE and put the shortcut on your desktop.
Click and draw this entire folder onto the Love shortcut and the game will start.

Objective:
Reach the end of the map without dying and collect as many coins as you can find.
Avoid the spikes on the ground because they will deal alot of damage!

How to play:
To walk, press:  ←  →  / A  D
To jump, press:  ↑  / W
To duck, press:  ↓  / S
To double jump, press jump while in the air
To run, hold: (Right or Left) shift while walking

What each of the files for the project contains and does:
Main.lua is the first file that love2d looks for. This contains the main functionality of 
loading, updating and drawing the game.

Conf.lua is the file to configurate the things about the gameclient.
Here you can set the title of the game, the height and width of the client and if you want a 
console window enabled which i have used alot for checking and debugging. 

Player.lua contains all the variables and functions for the player. 
The player is made with the player spritesheet. I have downloaded this from the internet and
created all the smaller images myself and turned them all into a png file with transparant background.
these pictures are in a for loop showing up very fast after eachother which makes it look animated.

Coin.lua contains all the variables and functions for the coins.
The coins is made with a coin picture that rotates by constantly updating a new X axis scale.
this scale is made with a sinus so that it goes from 1 to 0 to -1 which makes it look like it spins.

Spike.lua contains all the variables and functions for the spiked balls.
This file is very similar to the coin file but adjusted so that when contact is made the spike
will damage the player. The player has 3 health points and with each hit it will take 1 point away. 

Gui.lua contains the graphical user interface. This displays the amount of coins the player
has and shows the health bar. this will be displayed above everything else.

Camera.lua contains the functions to set the camera position so that the player will
be in the middle unless it reaches the sides of the map.

The assets folder contains all the assets in the game such as the background, the tilesets, 
the player spritesheet and coins pictures. These are all found on the internet.

The map folder contains the 'Tiled' map file inside the tmx folder and the exported lua map file.

The sti folder contains the simple tiled implementation which implements the map file into löve
