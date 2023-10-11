# Onscreen Output
Onscreen Output is a logging tool made for Godot 4 that allows you to print messages to the screen for debugging and development purposes.
It is a fork of [Screen Console by joaoh82](https://github.com/joaoh82/screen_console).

This fork aims to improve the original. A lot of features already got reworked, and will
continue to improve.

Furthermore, this Onscreen Output will receive more features going forward.

# Installation
Direct Download from Github:

Step 1: Copy the `addons/onscreen-output` folder from this repository

Step 2: Put the folder into your Godot Project

Step 3: Enable the Addon in Project>Project Settings>Plugins

Step 4: Reload your Project

**OR**

Download from the Asset Library!
[On the website](https://godotengine.org/asset-library/asset/2244) or in the Godot Editor

## Usage

`scrnOutput.print(message : String)`

Example:
`scrnOutput.print("Hello World!")`

# Improvements
Improvements the fork already has

- Performance improvements (by using a singular RichTextLabel instead of multiple Labels)
- by using RichTextLabels, it also has a scroll system instead of a disappearing system
  (Output Messages don't get deleted)
- Improved formatting with Timestamp
- Anchor support
- Hide/Show Button to toggle visibility of the Onscreen Output in-game (to be improved)
- Export to file

# Roadmap
Planned features and improvements

- Improved config menu
- Config for Output size
- small UI improvements

