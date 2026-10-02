;/  File: UD_Modifier_AddSpell
    Adds magical enhancement (or penalty) to the wearer

    NameFull:   Enchantment
    NameAlias:  ENCH

    Parameters in DataStr:

    Form arguments:
        Form1   Spell       A spell to be added to the wearer
        
        Form2   Spell       (optional) A spell to be added to the wearer
        
        Form3   Spell       (optional) A spell to be added to the wearer

    Example:

/;
Scriptname UD_Modifier_AddSpell extends UD_Modifier

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
Function GameLoaded(UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)

EndFunction

Function DeviceLocked(UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Actor loc_wearer = akDevice.GetWearer()
    If akForm1
        If loc_wearer.AddSpell(akForm1 as Spell) == False
            UDmain.Info("UD_Modifier_AddSpell::DeviceLocked() Failed to add spell to the wearer. (Wearer = " + loc_wearer + ", Device = " + akDevice + ", Spell = " + akForm1 + ")")
        EndIf
    EndIf
    If akForm2
        If loc_wearer.AddSpell(akForm2 as Spell) == False
            UDmain.Info("UD_Modifier_AddSpell::DeviceLocked() Failed to add spell to the wearer. (Wearer = " + loc_wearer + ", Device = " + akDevice + ", Spell = " + akForm2 + ")")
        EndIf
    EndIf
    If akForm3
        If loc_wearer.AddSpell(akForm3 as Spell) == False
            UDmain.Info("UD_Modifier_AddSpell::DeviceLocked() Failed to add spell to the wearer. (Wearer = " + loc_wearer + ", Device = " + akDevice + ", Spell = " + akForm3 + ")")
        EndIf
    EndIf
EndFunction

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Actor loc_wearer = akDevice.GetWearer()
    If akForm1
        If loc_wearer.RemoveSpell(akForm1 as Spell) == False
            UDmain.Info("UD_Modifier_AddSpell::DeviceUnlocked() Failed to remove spell from the wearer. (Wearer = " + loc_wearer + ", Device = " + akDevice + ", Spell = " + akForm1 + ")")
        EndIf
    EndIf
    If akForm2
        If loc_wearer.RemoveSpell(akForm2 as Spell) == False
            UDmain.Info("UD_Modifier_AddSpell::DeviceUnlocked() Failed to remove spell from the wearer. (Wearer = " + loc_wearer + ", Device = " + akDevice + ", Spell = " + akForm2 + ")")
        EndIf
    EndIf
    If akForm3
        If loc_wearer.RemoveSpell(akForm3 as Spell) == False
            UDmain.Info("UD_Modifier_AddSpell::DeviceUnlocked() Failed to remove spell from the wearer. (Wearer = " + loc_wearer + ", Device = " + akDevice + ", Spell = " + akForm3 + ")")
        EndIf
    EndIf
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_res = ""
    String loc_name = ""
    If akForm1
        loc_name = akForm1.GetName()
        If loc_name == ""
            loc_name = "<Unnamed spell>"
        EndIf
        If StringUtil.GetLength(loc_name) > 20
            loc_name = StringUtil.Substring(loc_name, 0, 18) + "..."
        EndIf
        loc_res += UDmain.UDMTF.TableRowDetails("Enchantment #1:", loc_name)
    EndIf
    If akForm2
        loc_name = akForm2.GetName()
        If loc_name == ""
            loc_name = "<Unnamed spell>"
        EndIf
        If StringUtil.GetLength(loc_name) > 20
            loc_name = StringUtil.Substring(loc_name, 0, 18) + "..."
        EndIf
        loc_res += UDmain.UDMTF.TableRowDetails("Enchantment #2:", loc_name)
    EndIf
    If akForm3
        loc_name = akForm3.GetName()
        If loc_name == ""
            loc_name = "<Unnamed spell>"
        EndIf
        If StringUtil.GetLength(loc_name) > 20
            loc_name = StringUtil.Substring(loc_name, 0, 18) + "..."
        EndIf
        loc_res += UDmain.UDMTF.TableRowDetails("Enchantment #3:", loc_name)
    EndIf
    Return loc_res
EndFunction
