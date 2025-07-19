# QuickGuiLib

A minimal Roblox GUI library for easily creating tabs and buttons with simple API calls.

---

## Features

- Create multiple tabs with `AddTab(name)`
- Add buttons to each tab with `AddButton(tab, name, callback)`
- Auto handles tab switching and button layout
- Lightweight and easy to extend

---

## Installation

1. Save `QuickGuiLib.lua` as a ModuleScript in your Roblox project.
2. Require it from your LocalScript.

```lua
local QuickGuiLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/AzxerMan000/QuickGuiLibary/refs/heads/main/Source.lua"))()
