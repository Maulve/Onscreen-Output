# Onscreen Output

**!! Onscreen Output will no longer receive major updates. !!**

Onscreen Output is a logging tool made for Godot 4 that allows you to print messages to the screen for debugging and development purposes.
It is a fork of [Screen Console by joaoh82](https://github.com/joaoh82/screen_console).

This fork aims to improve the original. A lot of features already got reworked, and will
continue to improve.

# Installation

Download from the Asset Library!

Step 1: Download from [the website](https://godotengine.org/asset-library/asset/2266) or the Godot Editor

Step 2: Enable addon in *Project>Project Settings>Plugins*

Step 3: Reload your project

**OR**

Direct Download from Github:

Step 1: Copy the `onscreen-output` folder from this repository

Step 2: Put the folder into your Godot project

Step 3: Enable the addon in *Project>Project Settings>Plugins*

Step 4: Reload your project

## Usage
**Note: The singleton name can be changed.**

`Output.print(message : String)`

Example:
`Output.print("Hello, World!")`

### Configuration

You can configure Onscreen Output by editing the `config.tres` file.

# Changes
- Removal of the config menu in favor of a resource file
- Output scrolling
- Improved formatting with timestamp
- Anchor support
- Hide/Show the output with Ctrl+Alt+A
- Configurable keybind
- Export to file
- Change the size of the output
