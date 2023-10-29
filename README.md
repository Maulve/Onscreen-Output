# Onscreen Output
Onscreen Output is a logging tool made for Godot 4 that allows you to print messages to the screen for debugging and development purposes.
It is a fork of [Screen Console by joaoh82](https://github.com/joaoh82/screen_console).

This fork aims to improve the original. A lot of features already got reworked, and will
continue to improve.

# Installation
Direct Download from Github:

Step 1: Copy the `onscreen-output` folder from this repository

Step 2: Put the folder into your Godot Project into your `addons` folder

Step 3: Follow `Setup`

**OR**

Download from the Asset Library! **Note that this version is out of date with the GitHub version**
[On the website](https://godotengine.org/asset-library/asset/2244) or in the Godot Editor.

Then follow `Setup`

# Setup

Step 1: Enable the Addon in Project > Project Settings > Plugins

Step 2: Add autoload for "onscreen_output/output.tscn"

Step 3: Reload your Project

You can then use the scene from anywhere in your Project!

## Usage

Note: If your autoload name is different, you need to use your respective autoload name instead.

`screenOutput.print(message : String)`

Example:
`screenOutput.print("Hello World!")`

# Improvements
All the improvements from this fork over Screen Console.

- Output scrolling
- Improved formatting with Timestamp
- Anchor support
- Hide/Show the Output with Ctrl+Shift+A
- Export to file
- Change the size of the Output

# Roadmap
Planned features and improvements

- more UI improvements

