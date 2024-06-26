Scriptname UD_CompatibilityManager_Script extends Quest Hidden

import UnforgivingDevicesMain

;============================================================
;========================PROPERTIES==========================
;============================================================

UnforgivingDevicesMain  Property UDmain                 auto

UDCustomDeviceMain      Property UDCDmain                       hidden
    UDCustomDeviceMain Function get()
        return UDmain.UDCDmain
    EndFunction
EndProperty

bool                    Property Ready      = false     auto    hidden

;============================================================
;======================LOCAL VARIABLES=======================
;============================================================

bool    _OrdinatorCompatibilityApplied      = false

;============================================================
;========================FUNCTIONS===========================
;============================================================

Event OnInit()
    if IsRunning()
        RegisterForSingleUpdate(45.0)
        Ready = true
    endif
EndEvent

Event OnUpdate()
    if UDmain.IsEnabled()
        Process()
    else
        ; mod is still not installed, wait another minute
        RegisterForSingleUpdate(60.0)
    endif
EndEvent
Function Update()
    Process()
EndFunction

Function Process()
    ;check if perks are added
    Ordinator_GetAgilityPerks()
    Ordinator_GetStrengthPerks()
    Ordinator_GetMagickPerks()
    
    ;add perks on every update, as they will be lost between reloads
    if !_OrdinatorCompatibilityApplied && UDmain.OrdinatorInstalled
        _OrdinatorCompatibilityApplied = true
        GInfo("Ordinator detected. Installing compatibility patch...")
        Ordinator_AddPerks()
        GInfo("Ordinator compatibility patch installed")
    endif
    
    if _OrdinatorCompatibilityApplied && !UDmain.OrdinatorInstalled
        _OrdinatorCompatibilityApplied = false
        GInfo("Ordinator installed but not detected. Uninstalling compatibility patch...")
        Ordinator_RemovePerks()
        GInfo("Ordinator compatibility patch uninstalled")
    endif
EndFunction

;============================================================
;========================ORDINATOR===========================
;============================================================
Function Ordinator_AddPerks()
    Ordinator_AddPerksToList(UDCDmain.UD_AgilityPerks   , _OrdinatorPerks_Agility)
    Ordinator_AddPerksToList(UDCDmain.UD_StrengthPerks  , _OrdinatorPerks_Strength)
    Ordinator_AddPerksToList(UDCDmain.UD_MagickPerks    , _OrdinatorPerks_Magick)
EndFunction
Function Ordinator_RemovePerks()
    Ordinator_RemovePerksFromList(UDCDmain.UD_AgilityPerks   , _OrdinatorPerks_Agility)
    Ordinator_RemovePerksFromList(UDCDmain.UD_StrengthPerks  , _OrdinatorPerks_Strength)
    Ordinator_RemovePerksFromList(UDCDmain.UD_MagickPerks    , _OrdinatorPerks_Magick)
EndFunction

Function Ordinator_AddPerksToList(FormList akPerkList, Form[] apPerksToAdd)
    int loc_i = 0
    while loc_i < apPerksToAdd.length
        akPerkList.AddForm(apPerksToAdd[loc_i])
        loc_i += 1
    endwhile
EndFunction
Function Ordinator_RemovePerksFromList(FormList akPerkList, Form[] apPerksToRemove)
    int loc_i = 0
    while loc_i < apPerksToRemove.length
        akPerkList.RemoveAddedForm(apPerksToRemove[loc_i])
        loc_i += 1
    endwhile
EndFunction

Form[] _OrdinatorPerks_Agility
Form[] _OrdinatorPerks_Strength
Form[] _OrdinatorPerks_Magick

Function Ordinator_GetAgilityPerks()
    ;add perks to array
    if !_OrdinatorPerks_Agility
        UDmain.Info("Adding ordinator agility perks...")
        _OrdinatorPerks_Agility = PapyrusUtil.PushForm(_OrdinatorPerks_Agility,GetMeMyForm(0x033295, "Ordinator - Perks of Skyrim.esp")) ;"Blood Money"
        _OrdinatorPerks_Agility = PapyrusUtil.PushForm(_OrdinatorPerks_Agility,GetMeMyForm(0x032D1F, "Ordinator - Perks of Skyrim.esp")) ;"Trained Rabbit"
        _OrdinatorPerks_Agility = PapyrusUtil.PushForm(_OrdinatorPerks_Agility,GetMeMyForm(0x0327A4, "Ordinator - Perks of Skyrim.esp")) ;"Thief's Eye"
        _OrdinatorPerks_Agility = PapyrusUtil.PushForm(_OrdinatorPerks_Agility,GetMeMyForm(0x03222D, "Ordinator - Perks of Skyrim.esp")) ;"Death's Emperor"
        _OrdinatorPerks_Agility = PapyrusUtil.PushForm(_OrdinatorPerks_Agility,GetMeMyForm(0x032231, "Ordinator - Perks of Skyrim.esp")) ;"Death's Emperor"
        _OrdinatorPerks_Agility = PapyrusUtil.PushForm(_OrdinatorPerks_Agility,GetMeMyForm(0x03328D, "Ordinator - Perks of Skyrim.esp")) ;"On the Run"
        _OrdinatorPerks_Agility = PapyrusUtil.PushForm(_OrdinatorPerks_Agility,GetMeMyForm(0x0515BF, "Ordinator - Perks of Skyrim.esp")) ;"On the Run Proc"
        _OrdinatorPerks_Agility = PapyrusUtil.PushForm(_OrdinatorPerks_Agility,GetMeMyForm(0x034873, "Ordinator - Perks of Skyrim.esp")) ;"Lawless World"
        _OrdinatorPerks_Agility = PapyrusUtil.PushForm(_OrdinatorPerks_Agility,GetMeMyForm(0x03380E, "Ordinator - Perks of Skyrim.esp")) ;"Thief's Luck"
        _OrdinatorPerks_Agility = PapyrusUtil.PushForm(_OrdinatorPerks_Agility,GetMeMyForm(0x03328F, "Ordinator - Perks of Skyrim.esp")) ;"Desperado"
        _OrdinatorPerks_Agility = PapyrusUtil.PushForm(_OrdinatorPerks_Agility,GetMeMyForm(0x034863, "Ordinator - Perks of Skyrim.esp")) ;"Stalk the Prey"
        _OrdinatorPerks_Agility = PapyrusUtil.PushForm(_OrdinatorPerks_Agility,GetMeMyForm(0x0515BF, "Ordinator - Perks of Skyrim.esp")) ;"On the Run Proc"
        _OrdinatorPerks_Agility = PapyrusUtil.PushForm(_OrdinatorPerks_Agility,GetMeMyForm(0x03485F, "Ordinator - Perks of Skyrim.esp")) ;"Stalk the Prey"
        _OrdinatorPerks_Agility = PapyrusUtil.PushForm(_OrdinatorPerks_Agility,GetMeMyForm(0x032237, "Ordinator - Perks of Skyrim.esp")) ;"Doomed to Plunder"
        _OrdinatorPerks_Agility = PapyrusUtil.PushForm(_OrdinatorPerks_Agility,GetMeMyForm(0x03381E, "Ordinator - Perks of Skyrim.esp")) ;"Crime Wave"
        _OrdinatorPerks_Agility = PapyrusUtil.PushForm(_OrdinatorPerks_Agility,GetMeMyForm(0x03486F, "Ordinator - Perks of Skyrim.esp")) ;"You Saw Nothing"
        _OrdinatorPerks_Agility = PapyrusUtil.PushForm(_OrdinatorPerks_Agility,GetMeMyForm(0x0342EF, "Ordinator - Perks of Skyrim.esp")) ;"Mutiny"
        _OrdinatorPerks_Agility = PapyrusUtil.PushForm(_OrdinatorPerks_Agility,GetMeMyForm(0x034875, "Ordinator - Perks of Skyrim.esp")) ;"Robbed Blind"
        _OrdinatorPerks_Agility = PapyrusUtil.PushForm(_OrdinatorPerks_Agility,GetMeMyForm(0x032236, "Ordinator - Perks of Skyrim.esp")) ;"Dragon Hoard"
        UDmain.Info("Ordinator agility perks added!")
    endif
EndFunction

Function Ordinator_GetStrengthPerks()
    if !_OrdinatorPerks_Strength
        UDmain.Info("Adding ordinator strength perks...")
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x00B14B, "Ordinator - Perks of Skyrim.esp")) ;"Two-Handed Mastery"
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x00B14C, "Ordinator - Perks of Skyrim.esp")) ;"Two-Handed Mastery"
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x00390C, "Ordinator - Perks of Skyrim.esp")) ;"Bleed Like a Dog" 1
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x00390D, "Ordinator - Perks of Skyrim.esp")) ;"Bleed Like a Dog" 2
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x00390E, "Ordinator - Perks of Skyrim.esp")) ;"Bleed Like a Dog" 3
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x003909, "Ordinator - Perks of Skyrim.esp")) ;"Clash of Heroes" 1
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x00390A, "Ordinator - Perks of Skyrim.esp")) ;"Clash of Heroes" 2
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x00390B, "Ordinator - Perks of Skyrim.esp")) ;"Clash of Heroes" 3
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x00390F, "Ordinator - Perks of Skyrim.esp")) ;"Crushing Blows" 1
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x003910, "Ordinator - Perks of Skyrim.esp")) ;"Crushing Blows" 2
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x003911, "Ordinator - Perks of Skyrim.esp")) ;"Crushing Blows" 3
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x003E7F, "Ordinator - Perks of Skyrim.esp")) ;"Batter"
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x003E80, "Ordinator - Perks of Skyrim.esp")) ;"Batter"
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x003E7B, "Ordinator - Perks of Skyrim.esp")) ;"Maul" 1
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x003E7C, "Ordinator - Perks of Skyrim.esp")) ;"Maul" 2
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x003E7D, "Ordinator - Perks of Skyrim.esp")) ;"Rive"
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x003E7E, "Ordinator - Perks of Skyrim.esp")) 
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x004414, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x0043F8, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x005474, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x0043F3, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x004400, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x004418, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x01284E, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x012855, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x012846, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x061988, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x003E82, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x003E89, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x003E85, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x065A58, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x065A52, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x00ECC6, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x00F229, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x061989, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x063F53, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x063F52, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x005473, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x060EA6, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x071296, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x070D1E, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Strength = PapyrusUtil.PushForm(_OrdinatorPerks_Strength,GetMeMyForm(0x005472, "Ordinator - Perks of Skyrim.esp"))
        UDmain.Info("Ordinator strength perks added!")
    endif
EndFunction

Function Ordinator_GetMagickPerks()
    if !_OrdinatorPerks_Magick
        UDmain.Info("Adding ordinator magick perks...")
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x0148FD, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x014903, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x024E40, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x024E41, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x024E3D, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x024E3E, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x0263ED, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x0263EE, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x0148FC, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x2114A5, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x2114A6, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x2114A7, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x025E80, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x027F04, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x029A1B, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x0148FA, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x024E3F, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x01BB2E, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x0263F0, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x0148F0, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x029A33, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x02799C, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x02799A, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x029F97, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x025915, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x0263F6, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x025E86, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x02AFF6, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x02A515, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x02A506, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x02A507, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x02A508, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x0263FC, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x029F96, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x027F02, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x028472, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x025E82, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x024E3C, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x02AA92, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x02846E, "Ordinator - Perks of Skyrim.esp"))
        _OrdinatorPerks_Magick = PapyrusUtil.PushForm(_OrdinatorPerks_Magick,GetMeMyForm(0x02A503, "Ordinator - Perks of Skyrim.esp"))
        UDmain.Info("Ordinator magick perks added!")
    endif
EndFunction