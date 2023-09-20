# Onscreen Output
Onscreen Output is a logging tool made for Godot 4 that allows you to print messages to the screen for debugging and development purposes.
It is a fork of [Screen Console by joaoh82](https://github.com/joaoh82/screen_console).

This fork aims to improve the original. A lot of features already got reworked, and will
continue to improve.

Furthermore, this Onscreen Output will receive more features going forward.

# Installation
Currently, the addon is only available here on GitHub. (AssetLib release planned)

Step 1: Copy the `assets` folder from this repository
Step 2: Put the `assets` folder into your Godot Project
Step 3: Enable the Addon in Project->Project Settings->Plugins
Step 4: Reload your Project

# Improvements
Improvements the fork already has

- Performance improvements (by using a singular RichTextLabel instead of multiple Labels)
- by using RichTextLabels, it also has a scroll system instead of a disappearing system
  (Output Messages don't get deleted)
- Improved formatting with Timestamp
- Removal of unecessary features

# Roadmap
Planned features and improvements

- hide/show button to toggle visibility of the Onscreen Output in-game
- Anchor support
- Improved config menu
- Config for Output size
- small UI improvements
