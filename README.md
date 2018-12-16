# RubiksCubeAI
## Initial Setup
### Download and Install Processing 3: https://processing.org/download/

### Clone This Repository

If you have git installed, type the following into your terminal:

```
git clone https://github.com/Code-Bullet/RubiksCubeAI.git
```

Else, download the zip file and unpack by clicking the green "Clone and download" button on the top right of the screen.

### Open The Project Files
1. Open the Processing application
2. Click `File > Open`
3. Go to where you downloaded the files for this repository, the folder should be called `RubiksCubeAI`
4. Inside the `RubiksCubeAI` folder there should be another called `RubiksCube`
5. Inside the `RubiksCube` folder click on the file called `RubiksCube.pde`
6. You should now see `RubiksCube.pde` as well as the rest of the files opened up in the Processing application
7. Click the play button to start the program

## Using The Program
1. Open `RubiksCube.pde` in the Processing application. It is located at. `RubiksCubeAI/RubiksCube/RubiksCube.pde`. (See [Open The Project Files](#open-the-project-files) for additional information)
2. Press the ***Run*** button or click `Sketch > Run`
3. Press `L` to Lock/Unlock the cube
4. Press `Space` to initially scramble the cube
5. Press `Space` again to watch the program unscramble the cube

## Modifying The Program

### Changing Cube Size
Open `RubiksCube.pde` in the Processing application. It is located at. `RubiksCubeAI/RubiksCube/RubiksCube.pde`. (See [Open The Project Files](#open-the-project-files) for additional information)

On line 8, modify the variable called `numberOfSides`

``` java
//dont do even sized cubes (it wont work)
//Have fun

int numberOfSides = 25;//<<< change this to change the size of the cube
```

It is initially set to `25`, if you want the standard 3x3 Rubik Cube set `numberOfSides` to `3`.

#### Example:

``` java
//dont do even sized cubes (it wont work)
//Have fun

int numberOfSides = 3;//<<< change this to change the size of the cube
```

### Changing Window Size
Open `RubiksCube.pde` in the Processing application. It is located at. `RubiksCubeAI/RubiksCube/RubiksCube.pde`. (See [Open The Project Files](#open-the-project-files) for additional information)

On line 96, modify the function called `size(1000, 1000, P3D);`

``` java
  size(1000, 1000, P3D);
  //size(2000, 2000, P3D); //if you've got a 4K monitor then you can uncomment this out to have a bigger window, also make sure to comment out the line before
```

The first number is width and second number is height in pixels.

Modify these to match your screen resolution.

If you are unsure of your screen resolution go to: http://whatismyscreenresolution.net/

If your screen resolution is 1980x1080 modify line 96 like so:

``` java
  size(1920, 1080, P3D);
  //size(2000, 2000, P3D); //if you've got a 4K monitor then you can uncomment this out to have a bigger window, also make sure to comment out the line before
```
