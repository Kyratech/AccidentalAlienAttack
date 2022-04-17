# Accidental Alien Attack!

A clone of Space Invaders made in the [TIC-80](https://github.com/nesbox/TIC-80) fantasy console as a holiday project.

## Features

- 10 exciting (citation needed) levels!
- 3 different special weapons!
- 4 different powerups!
- Basic visual novel style cutscenes!
- Difficulty and accessibility settings!
- Persistent high score recording!
- Ingame manual!

## Roadmap

Unordered TODO list before the game hits 1.0.0.

- Additional ways to earn bonus points.
- Better level transitions.
- 3 new alien types.
- 3 new special weapons.
- 30 new levels (for a total of 40).

## Requirements

The free version of TIC-80 does not have support for exporting or importing cartridges (games) as script files, so to build this project, you will need to have TIC-80 Pro.

## Installation

I am using the node package [tic-bundle](https://github.com/chronoDave/tic-bundle) to compile my various disparate source files into a single script file that TIC-80 can load. So, on first download, you will need to run:

```
npm install
```
To install the single `tic-bundle` dependency.

## Workflow

### Build the cartridge file

As per the instructions for `tic-bundle`, I have included the command to compile the cartridge file in the `watch` script. So, before starting development, run the following in a console:

```
npm run watch
```
After this, the updated source file will be generated whenever a file in `src/` is saved. The catridge file is called `build.lua` by default.

### Load the cartridge file

In TIC-80 itself, navigate to the project directory to load the catridge file:
```
load build.lua
```
Run the cartridge file using `CTRL + R`.

### Changes to non-script assets

Update: As of version 3.3.0 of ticBundle, changes made to non-script assets are easier to work with. Following is the new workflow:

1. When the compiled `build.lua` file is loaded, make my changes to the sprites in TIC-80.
2. Save the cartridge as a different file `src/metadata.lua`.
3. Make some small change to another file so that the watch script notices the change and triggers a rebuild.

## Contributions

This is a project just for my own enjoyment and I will not be accepting contributions at this time. You are however welcome to fork this project, build upon it, tear it apart etc to your hearts extent!

It's not exactly an original game, haha!

## Licence

Licenced under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html).
