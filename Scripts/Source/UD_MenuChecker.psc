;/   File: UD_MenuChecker
    This script checks if any menu is open using events.
    
    Because of that, checking if menu is open is much faster by using this script
    
    On other hand there is issue with event lag.
    
    There is allways small delay before the scripts variables gets updated after menu is opened/closed
    
    See: <IsMenuOpen>, <IsMenuOpenID>, <IsContainerMenuOpen>, <IsLockpickingMenuOpen>, <IsInventoryMenuOpen>, <IsMessageboxOpen>
/;
Scriptname UD_MenuChecker extends Quest hidden

;/ About: Menus ID
    --- Code
    |======================================|
    |           Menu ID table              |
    |======================================|
    |   aiID    |           MENU           |
    |======================================|
    |    00     =     ContainerMenu        |
    |    01     =     Lockpicking Menu     |
    |    02     =     InventoryMenu        |
    |    03     =     Journal Menu         |
    |    04     =     Crafting Menu        |
    |    05     =     Dialogue Menu        |
    |    06     =     FavoritesMenu        |
    |    07     =     GiftMenu             |
    |    08     =     Main Menu            |
    |    09     =     Loading Menu         |
    |    10     =     Book Menu            |
    |    11     =     MagicMenu            |
    |    12     =     MapMenu              |
    |    13     =     MessageBoxMenu       |
    |    14     =     RaceSex Menu         |
    |    15     =     Sleep/Wait Menu      |
    |    16     =     StatsMenu            |
    |    17     =     Tutorial Menu        |
    |    18     =     TweenMenu            |
    |    19     =     Console              |
    |    20     =     BarterMenu           |
    |    21     =     CustomMenu (UIE)     |
    |======================================|
    ---
/;

import UnforgivingDevicesMain

UnforgivingDevicesMain Property UDmain auto

String[]        Property UD_MenuList                                    auto hidden
bool[]          Property UD_MenuListID                                  auto hidden
int             Property UD_MenuListIDBit               = 0x00000000    auto hidden
string          Property UD_LastMenuOpened              = "none"        auto hidden
Bool            Property UD_MenuOpened                  = False         auto hidden
Bool            Property Ready                          = False         auto hidden

Bool Function IsMenuOpen(Int aiID)
    return UD_MenuListID[aiID]
EndFunction

Event OnInit()
    RegisterForSingleUpdate(20.0)
EndEvent

Function OnUpdate()
    if UDmain.WaitForReady()
        Update()
    endif
EndFunction

Function Update()
    UD_MenuListIDBit = 0x00000000 ;reset menu bit map
    InitMenuArr()
    UnregisterMenuEvents()
    RegisterMenuEvents()
    Ready = True
EndFunction

Function InitMenuArr()
    UD_MenuList         = new String[22]
    UD_MenuListID       = new bool[22]
    
    UD_MenuList[00] = "ContainerMenu"
    UD_MenuList[01] = "Lockpicking Menu"
    UD_MenuList[02] = "InventoryMenu"
    UD_MenuList[03] = "Journal Menu"
    UD_MenuList[04] = "Crafting Menu"
    UD_MenuList[05] = "Dialogue Menu"
    UD_MenuList[06] = "FavoritesMenu"
    UD_MenuList[07] = "GiftMenu"
    UD_MenuList[08] = "Main Menu"
    UD_MenuList[09] = "Loading Menu"
    UD_MenuList[10] = "Book Menu"
    UD_MenuList[11] = "MagicMenu"
    UD_MenuList[12] = "MapMenu"
    UD_MenuList[13] = "MessageBoxMenu"
    UD_MenuList[14] = "RaceSex Menu"
    UD_MenuList[15] = "Sleep/Wait Menu"
    UD_MenuList[16] = "StatsMenu"
    UD_MenuList[17] = "Tutorial Menu"
    UD_MenuList[18] = "TweenMenu"
    UD_MenuList[19] = "Console"
    UD_MenuList[20] = "BarterMenu"
    UD_MenuList[21] = "CustomMenu"
EndFunction

Function RegisterMenuEvents()
    int loc_i = UD_MenuList.length
    while loc_i
        loc_i -= 1
        RegisterForMenu(UD_MenuList[loc_i])
    endwhile
EndFunction

Function UnregisterMenuEvents()
    UnregisterForAllMenus()
EndFunction

Event OnMenuOpen(String MenuName)
    if UDmain.UDReady()
        if UDmain.TraceAllowed()
            UDmain.Log("OnMenuOpenPre - " + MenuName + ", bit="+ UD_MenuListIDBit,3)
        endif
        
        if MenuName != "Console" && MenuName != "MessageBoxMenu" ;these can be opened over other menus, check them out
            UD_LastMenuOpened = MenuName
            UD_MenuOpened = true
        elseif UD_LastMenuOpened == "none"
            UD_LastMenuOpened = MenuName
            UD_MenuOpened = true
        endif
        
        Int loc_i = 0
        while loc_i < UD_MenuList.length
            if UD_MenuList[loc_i] == MenuName
                UD_MenuListID[loc_i] = true
                _StartBitMutex()
                UD_MenuListIDBit = Math.LogicalOr(UD_MenuListIDBit,Math.LeftShift(0x1,loc_i))
                _EndBitMutex()
                if UDmain.TraceAllowed()
                    UDmain.Log("OnMenuOpenPost - " + MenuName + ", bit="+ UD_MenuListIDBit,3)
                endif
                return
            endif
            loc_i += 1
        endwhile
    endif
EndEvent

Event OnMenuClose(String MenuName)
    if UDmain.UDReady()
        if UDmain.TraceAllowed()
            UDmain.Log("OnMenuClosePre - " + MenuName + ", bit="+ UD_MenuListIDBit,3)
        endif
        
        Utility.waitMenuMode(0.1) ;wait small time so it cant happen that the close event will be sent before open event is processed
        
        if MenuName != "Console" && MenuName != "MessageBoxMenu" ;these can be opened over other menus, check them out
            UD_MenuOpened = false
            if UD_LastMenuOpened == MenuName
                UD_LastMenuOpened = "none"
            endif
        elseif UD_LastMenuOpened == "Console" || UD_LastMenuOpened == "MessageBoxMenu" ;only reset state if no other menu was used before
            UD_MenuOpened = false
            UD_LastMenuOpened = "none"
        endif
        
        Int loc_i = 0
        while loc_i < UD_MenuList.length
            if UD_MenuList[loc_i] == MenuName
                UD_MenuListID[loc_i] = false
                _StartBitMutex()
                UD_MenuListIDBit = Math.LogicalAnd(UD_MenuListIDBit,Math.LogicalNot(Math.LeftShift(0x1,loc_i)))
                _EndBitMutex()
                if UDmain.TraceAllowed()
                    UDmain.Log("OnMenuClosePost - " + MenuName + ", bit="+ UD_MenuListIDBit,3)
                endif
                return
            endif
            loc_i += 1
        endwhile
    endif
EndEvent

bool _BitMutex = False
Function _StartBitMutex()
    while _BitMutex
        Utility.waitMenuMode(0.05)
    endwhile
    _BitMutex = True
EndFunction
Function _EndBitMutex()
    _BitMutex = False
EndFunction