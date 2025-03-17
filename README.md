# Hack 'n' Slash Game Mods
 My documentation of modifications to the game that I have found to bennefit
| Mod | Location | Class | Description | Modification |
|-----|----------|--------|-------------|--------------|
| Walk on Air and Water | Data/Content/Game/Global/Entities/Alice.lua | onEnterWater | Allows walking on water | Line 5: Change `if not collidingWater, go to 63` to `if collidingWater, go to 63` |
| Demon Hand Healing | Data/Content/Game/DweebKeep/Entities/DungeonLobby/DemonHand.lua | kill | Makes Demon Hand heal you | Line 7: Change `health:setHealth(0)` to `health:setHealth(%Whatever you want%)` |
| Friendly Ravens | Data/Content//Game/DorkForest/Entities/Raven.lua | onEntityLeavePerception | Prevents Ravens from attacking you or rock | Line 4: Change `if _ , then goto 9` to `if not _ , then goto 9` |
| No Damage Spike Turtles | Data/Content//Game/DorkForest/Entities/SpikeTurtle.lua | onHitRegionEntitieEnter | Prevents damage from Spike Turtles | Line 6: Change `if _ , goto 6` to `if not _ , goto 6` |
| Friendly Swamp King | Data/Content/Game/DorkForest/Entities/SwampKing.lua | init | Makes Swamp King friendly | Line 17: Change `_ ( self , " BAD ")` to `_ ( self , " GOOD ")` |
| Hackable Swamp King | Data/Content/Game/DorkForest/Entities/SwampKing.lua | isHackable | Makes Swamp King hackable | Line 6: Change `false -> _` to `true -> _` |
| Hackable Breakable Blocks | Data/Content/Game/Global/Entities/Block.lua | isHackable | Makes breakable blocks hackable | Line 0: Change `false -> _` to `true -> _` |
| Infinite Hack Block Charges | Data/Content/Game/Global/Entities/HackBlock.lua | onPushed | Prevents charge consumption | Line 1: Change `_ - 1 -> _` to `_ - 0 -> _` |
| Push Hack Block Without Charges | Data/Content/Game/Global/Entities/HackBlock.lua | canPush | Allows pushing without charges | Line 9: Change `false -> _` to `true -> _` |
| Friendly Guards | Data/Content/Game/Global/Entities/Guard.lua | init | Makes guards friendly | Line 67: Change `_ ( self , " BAD ")` to `_ ( self , " GOOD ")` |

---
