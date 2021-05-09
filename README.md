# AudioAssignment

##Student Info

Student Name: Maciej Kostka

Student Number: C19496786

Student Course: DT228

Module: Object-Oriented Programming

Lecturer: Brian Duggan

Date: 07 / 05 / 2021

##What My Assignment Does

My assignment has two options, number 1 and number 2, controlled by the **keyPressed** function.

**Option 1** contains a terrain created using "TRIANGLE_STRIP". The terrain has two layers, one for the parallel connections of vertices, one for the diagonal connection of vertices.

> **y** is forthe parallel connection of vertices.
> 
> **y+1** is for the diagonal connection of vertices.

I map the **lerpedTerrain[y] & lerpedTerrain[x]** values using the noise() function, to return more harmonic noise values from numbers 0 through 30. I apply this value to the z position of the vertices, which allows them to move up and down in sync with the music being played.

In this option theres also a button in the top left corner to **Turn Cubes On**. This displays 10 cubes of the same size and different colour. Each cube represents a band. When the band size increases, the size of the relative cube will also incease.Initially the cubes are in group rotation, which means they all undergo the same rotation. This option also maps some colour onto the terrain.

When the cubes are turned on, two buttons are present in the top left corner. The first one is **Turn Cubes Off** which turns the cubes off, as the name suggests. The second button is **Individual Rotation**. When this button is clicked, the individual rotation is turned on, and the button now says **Group Rotation**. When the button is pressed again the grouped rotation is turned on again.

**Option 2** contains a collection of 3D spheres which represent orbiting planets. I used a recursive algorithm to create the main planet at the center, and then create consecutive planets which are of the a smaller size than the previous, which is based on the level of recursion they are being created in. The spheres get a random rotation and a random orbit speed. They orbit their respectful parent spheres. The level variable controls the level of recursion, and therefore how many layers of children will be displayed. Each planet has a random number of children planets, between values 1 and 3.
The random orbit speed is added to the rotation which is a random value in the range *TWO_PI*. The size of the spheres reacts to the frequency of the music. In the top left corner we there's a button **Turn Stars On** which allows the user to turn stars on and off. When the stars are off, the peasyCam library is enabled, giving the user the ability to move around in 3D space and see the spheres from different angles. When the stars are turned on, peasyCam is disabled.

When the stars are on, I draw 512 ellipses randomly on the screen. The stars are drawn in 2D, but I simulate a 3D environment by making the ellipses z position a random value between 0 and width. I then loop through the ellipses, increasing their z position by adding the frequency of the music to it. This makes the ellipse go outwards, and eventually off screen, giving the illusion it went behind us. When a stars z position is less than 1, we reset it to it's starting position and loop throgugh it again. This allows us to reuse the stars and avoid drawing an infinite or very large amount unnecessarily. In order to further simulate 3D, I map the z position of the star relative to the width of the screen between the values of 0 and 2. If the z value is small, the value will be closer to 2. If the z value is large, value will be closer to 0. We use this value as the radius of the ellipse, which makes them larger when they're clsoer and smaller when they're far away. 


##What the Controls Are

Controls are as follows

_***KeyPad***_
> **Press 1** for scene 1 with terrain.
> 
> **Press 2** for scene 2 with planets.
> 
> **Press spaceBar** to stop pause music.
> 
> **Press spaceBar again** to rewind music to the beginnig and play.

***_Buttons: Scene 1_***
> **Press 'Turn Cubes On'** in scene 1 to reveal band cubes and colorful terrain.
> 
> **Press 'Individual Rotation'** in scene 1 to display a cool rotation.
> 
> **Press 'Group Rotation'** in scene 1 to display cubes rotating simultaneously.
> 
> **Press 'Turn Cubes Off'** to return to display only white terrain which moves relative to music.

***_Buttons: Scene 2_***
> **Press 'Turn Stars On'** to display stars which move relative to the music and disable peasyCam.
> 
> **Press 'Turn Stars Off'** to turn stars on and enable peasyCam.

***_Scene 2: Mouse/TouchPad_***
> Click and move mouse or touchpad to see planets from different angles when stars are turned off.
> Double-click to reset camera to original position

##How to Make it Run

To run, open sketch in processing 4 and press **Run** in the top left hand corner. 

##Stuff I'm Most Proud of

* Making the Terrain react to the music change smoothly.
* Understanding and applying recusrion to create the planets.
* Applying the smoothedBands to create a cool animation for the cubes.
* Switching between different modes of colors, rotations, etc. using buttons.


##References

TheCodingTrain youtube channel
