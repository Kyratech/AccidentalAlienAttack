# Accidental Alien Attack!

A clone of Space Invaders made in the [TIC-80](https://github.com/nesbox/TIC-80) fantasy console as a holiday project.

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

Getting changes to sprites etc is a little fiddly with my external editor workflow. I do the following:

1. Make my changes to the sprites in TIC-80.
2. Save the cartridge in TIC-80 (`CTRL + S`).
3. Open the modified `build.lua` in my IDE.
4. Copy the asset metadata from the bottom of the file to `assetMetadata.lua`.
5. This triggers a project rebuild containing the updated assets.

This may not be the best workflow, but it's worked for me in this little toy project. It may be a wise idea to change step 2 so that you save to a different catridge file so that the automatic rebuild doesn't immediately overwrite your sprite changes. Either way, the sprite changes will exist in memory until you run `load build.lua` again.

## Contributions

This is a project just for my own enjoyment and I will not be accepting contributions at this time. You are however welcome to fork this project, build upon it, tear it apart etc to your hearts extent!

It's not exactly an original game, haha!

## Licence

Licenced under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html).