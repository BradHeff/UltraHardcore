# UltraHardcore for MoP Classic

<div align="center">

![Version](https://img.shields.io/badge/version-1.2.0-blue.svg)
![Interface](https://img.shields.io/badge/interface-5.5.1-green.svg)
![Game Version](https://img.shields.io/badge/MoP%20Classic-Landfall-orange.svg)

*Making World of Warcraft: Mists of Pandaria Classic exponentially more challenging*

</div>

## 🎯 Overview

UltraHardcore is a comprehensive difficulty enhancement addon for MoP Classic that transforms your gameplay experience by removing crucial UI elements, adding visual effects, and implementing hardcore mechanics. This adaptation expands on the original work by [BonniesDad](https://www.curseforge.com/wow/addons/ultra-hardcore) with extensive new features and MoP Classic compatibility.

![UltraHardcore Screenshot](Screenshot.png)

**⚠️ WARNING: This addon significantly increases difficulty and the likelihood of character death. Use at your own risk!**

## ✨ Core Features

### 🖥️ **UI Modifications**
- **Player Frame Hiding**: Removes your health/mana display for true blind gameplay
- **Minimap Removal**: Complete minimap and related elements hiding (including ElvUI compatibility)
- **Target Frame Concealment**: Hide enemy health bars and information
- **Buff Frame Hiding**: Remove beneficial and detrimental effect indicators
- **Action Bar Management**: Smart action bar hiding system (activates at level 10+)
- **Nameplate Control**: Hide enemy nameplates and health indicators
- **Quest Tracker Removal**: Hide quest objectives and progress
- **Tooltip Suppression**: Remove target information tooltips

### 💀 **Death & Combat Indicators**

#### Visual Overlay System
- **Tunnel Vision Effect**: Screen darkening as health decreases
- **Damage Type Overlays**: Specific visual effects for different damage schools:
  - Physical Damage (red overlay)
  - Shadow Damage (purple overlay) 
  - Holy Damage (golden overlay)
  - Arcane Damage (blue overlay)
  - Fire Damage (orange overlay)
  - Frost Damage (cyan overlay)
- **Dazed Effect**: Visual indication when movement impaired
- **Full Health Indicator**: Overlay when at maximum health
- **Critical Hit Effects**: Screen rotation and movement effects on crits

### ⚡ **Resource Management**

#### Advanced Resource Tracking
- **Custom Resource Bars**: Replacement bars for health/mana/energy/rage
- **Combo Point System**: Visual orbs for Rogues and Cat Form Druids using custom textures:
  - `combopoint.blp` - Base combo point texture
  - `combopoint_outline.blp` - Outlined version
  - `flare1_tc_shadowcombo.blp` - Shadow combo effects
- **Power Type Detection**: Automatic resource type identification for all classes
- **Breath Indicator Control**: Underwater breathing management

### 📊 **Statistics & Tracking**

#### Character Progression
- **Lowest Health Tracking**: Records your closest calls with death
- **Elite Kill Counter**: Tracks elite NPCs defeated
- **Enemy Kill Statistics**: General mob elimination count  
- **XP Session Tracking**: Experience gained per session monitoring
- **Level Milestone Announcements**: Automatic UHC channel broadcasts every 5 levels

### 🎮 **Gameplay Mechanics**

#### Hardcore Elements
- **Permanent Pet Death**: Pets die permanently when killed (optional)
- **Group Safety Warnings**: Automatic party/raid notifications about addon usage
- **UI Error Suppression**: Hide game error messages
- **Immunity Detection**: Smart detection and notification for damage immunity
- **Wolf-like NPC Tracking**: Special handling for specific creature types

### ⚙️ **Customization & Settings**

#### Preset Configurations
1. **Lite Preset**: Basic difficulty enhancements
2. **Recommended Preset**: Balanced challenge experience  
3. **Ultra Preset**: Maximum difficulty with all features enabled

#### Fine-Grained Controls
- Individual feature toggles via in-game settings panel
- **Statistics Dashboard**: Real-time tracking display
- **Reset Functions**: Individual stat reset capabilities
- **ElvUI Integration**: Full compatibility with ElvUI addon suite including:
  - ElvUI_mMediaTag DataText panels
  - ElvUI_HoffUI DataText panels  
  - ElvUI_EltreumUI DataText panels

## 🚀 Installation

1. Download the latest release
2. Extract to your `Interface/AddOns/` directory
3. Ensure folder is named `UltraHardcore`
4. Restart World of Warcraft
5. Access settings via Game Menu → "Ultra Hardcore"

## 🎛️ Configuration

### Accessing Settings
- **In-Game**: ESC → "Ultra Hardcore" button
- **Slash Commands**: 
  - `/uhc` - Open settings panel
  - `/bonnie` - Toggle resource indicator
  - Various debug and utility commands

### Key Settings Categories

#### **Essential UI Controls**
- Hide Player Frame
- Hide Target Frame  
- Hide Minimap
- Hide Action Bars (Level 10+)

#### **Visual Effects**
- Death Indicator (Tunnel Vision)
- Damage Type Overlays
- Full Health Indicator
- Critical Hit Effects

#### **Advanced Options**
- Pets Die Permanently
- Group Health Hiding
- Nameplate Health Indicators
- Default UHC Game Options

## 🔧 Technical Implementation

### Resource System
The addon features sophisticated resource detection using `GetCurrentResourceType()` and `CanGainComboPoints()` for MoP Classic compatibility.

### Database Management
Utilizes `UltraHardcoreDB` for persistent storage of:
- Character statistics
- Global settings
- Session tracking data

### Event System  
Comprehensive event handling in `UltraHardcore.lua` managing:
- Combat log events
- Player state changes
- Group dynamics
- UI updates

### ElvUI Compatibility
Advanced integration system supporting multiple ElvUI addons:
- **Core ElvUI**: Standard DataText panels
- **mMediaTag**: Extended DataText and dock panels
- **HoffUI**: Custom UI enhancements
- **EltreumUI**: Additional interface modifications

## 🤝 Community Features

### UHC Channel Integration
- Automatic channel joining: `/join uhc`
- Death notifications to community
- Level milestone sharing
- Group safety announcements

## ⚠️ Important Considerations

### Safety Warnings
- **Significantly increases death probability**
- **Not recommended for hardcore characters** unless you enjoy risk
- **Party/Raid members are warned** about your addon usage
- **Disable for non-UHC groups** to avoid griefing accusations

### Compatibility
- **MoP Classic 5.5.1 (Landfall)** fully supported
- **ElvUI integration** via comprehensive compatibility layer
- **Saved Variables**: `UltraHardcoreDB` for persistent data

## 🎨 Visual Assets

The addon includes custom textures for enhanced visual experience:

### Damage Overlays
- `arcane-damage.png` / `arcane-dot.png` - Arcane damage effects
- `fire-damage.png` / `fire-dot.png` - Fire damage effects  
- `nature-damage.png` / `nature-dot.png` - Nature damage effects
- `shadow-damage.png` / `shadow-dot.png` - Shadow damage effects
- `holy-damage.png` - Holy damage effects
- `physical-damage.png` / `physical-dot.png` - Physical damage effects

### Health Indicators
- `health-icon-red.png` - Critical health warning
- `health-icon-orange.png` - Low health warning
- `health-icon-yellow.png` - Moderate health warning
- `full-health-overlay.png` - Full health indicator

### Special Effects
- `skull1.png` / `skull2.png` / `skull3.png` - Death indicators
- `bonnie0.png` through `bonnie5.png` - Character state indicators
- `tinted_foggy_04.png` through `tinted_foggy_19.png` - Atmospheric effects

## 🏆 Credits

### Original Creator
- **BonniesDad** - Original UltraHardcore concept and implementation
- [Original CurseForge Project](https://www.curseforge.com/wow/addons/ultra-hardcore)

### MoP Classic Adaptation
- **Brad Heffernan** - Extensive adaptation, feature expansion, and MoP Classic compatibility

## 📝 License & Support

This addon builds upon the original UltraHardcore addon with significant enhancements for MoP Classic. 

### File Structure
```
UltraHardcore/
├── UltraHardcore.lua              # Core addon file
├── UltraHardcore.toc              # Addon metadata
├── Constants/                      # Game constants and data
│   └── WolfLikeNPCs.lua           # Special NPC definitions
├── Functions/                      # Core functionality modules
│   ├── DB/                        # Database management
│   │   ├── CharacterStats.lua     # Statistics tracking
│   │   ├── LoadDBData.lua         # Data loading
│   │   └── SaveDBData.lua         # Data persistence
│   ├── Overlays/                  # Visual effect systems
│   │   ├── CustomResourceBar.lua  # Resource bar replacement
│   │   ├── Show*DamageOverlay.lua # Damage type overlays
│   │   └── ShowFullHealthOverlay.lua
│   ├── Statistics/                # Tracking and metrics
│   │   └── TrackLowestHealth.lua  # Health monitoring
│   ├── Utils/                     # Utility functions
│   │   ├── ElvUICompat.lua        # ElvUI integration
│   │   ├── Frame/                 # Frame utilities
│   │   └── Resource/              # Resource management
│   └── [Various gameplay functions]
├── Settings/                      # Configuration interface
│   ├── MainMenuButton.lua         # UI integration
│   └── Settings.lua               # Settings panel
├── Sounds/                        # Audio assets
│   └── heartbeat.ogg              # Heartbeat sound effect
└── Textures/                      # Visual assets (BLP/PNG format)
```

## 🔮 Future Development

This MoP Classic adaptation continues to evolve with:
- Enhanced ElvUI compatibility
- Additional visual effects
- Improved performance optimizations
- Community-requested features

---

<div align="center">

**Ready to face the ultimate challenge in Pandaria?**

*Remember: In UltraHardcore, knowledge is power, but ignorance might just keep you alive.*

</div>