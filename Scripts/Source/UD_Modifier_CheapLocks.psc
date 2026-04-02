;/  File: UD_Modifier_CheapLocks
    Devices locks can get randomely jammed over time or when wearer is attacked

    NameFull:   Cheap Locks
    NameAlias:  CLO

    Parameters in DataStr:
        [0]     Float       (optional) Chance to get jammed lock every hour
                            Default value: 0.0%

        [1]     Float       (optional) Chance to get jammed lock when hit with a weapon
                            Default value: 0.0%
                        
        [2]     Float       (optional) Chance that the lock will jam, proportional to the damage taken
                            Default value: 0.0% per damage point
/;
ScriptName UD_Modifier_CheapLocks extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afGameHoursSinceLastCall, String asDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    if !akDevice.HaveUnlockableLocks()
        return
    endif
    Float loc_chance_h = GetParamFlt(akDevice, asDataStr, 0, 0.0, "Probability")
    If loc_chance_h <= 0.0
        Return
    EndIf
    Int loc_jlocks = akDevice.GetJammedLocks()
    Int loc_i = 0
    While loc_i < Math.Floor(afGameHoursSinceLastCall)
        akDevice.AddJammedLock(Round(loc_chance_h))
        loc_i += 1
    EndWhile
    If afGameHoursSinceLastCall - Math.Floor(afGameHoursSinceLastCall) > 0.01
        Int loc_prob = Round((1.0 - Math.Pow(0.01 * loc_chance_h, afGameHoursSinceLastCall - Math.Floor(afGameHoursSinceLastCall))) * 100)
        akDevice.AddJammedLock(loc_prob)
    EndIf
    If loc_jlocks != akDevice.GetJammedLocks() && akDevice.WearerIsPlayer()
        UDMain.Print("You hear an unpleasant sound coming from the locks on your " + akDevice.UD_DeviceType)
    EndIf
EndFunction

Function WeaponHit(UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, Float afDamage, String asDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If akWeapon == None || afDamage < 0.0
        Return
    EndIf
    Int loc_jlocks = akDevice.GetJammedLocks()
    Float loc_chance1 = GetParamFlt(akDevice, asDataStr, 1, 0.0, "Probability")
    Float loc_chance2 = GetParamFlt(akDevice, asDataStr, 2, 0.0, "Probability")
    If loc_chance1 + loc_chance2 * afDamage <= 0.0
        Return
    EndIf
    akDevice.AddJammedLock(UD_Native.Round((loc_chance1 + loc_chance2 * afDamage) * MultOutputQuantities))
    If loc_jlocks != akDevice.GetJammedLocks() && akDevice.WearerIsPlayer()
        UDMain.Print("The impact hit one of the locks on your " + akDevice.UD_DeviceType + ". You wouldn't be surprised if it got jammed.")
    EndIf
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Chance per hour:",     FormatFloat(GetParamFlt(akDevice, asDataStr, 0, 0.0, "Probability"), 2) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Chance per hit:",      FormatFloat(GetParamFlt(akDevice, asDataStr, 1, 0.0, "Probability"), 2) + "%")
    loc_res += UDmain.UDMTF.TableRowDetails("Chance per dmg:",      FormatFloat(GetParamFlt(akDevice, asDataStr, 2, 0.0, "Probability"), 2) + "%")
    Return loc_res
EndFunction