;/  File: UD_Modifier_Disabler
    Disables some of the player controls. Probably not the best idea

    NameFull:   Disabler
    NameAlias:  DIS

    Parameters in DataStr:
        [0]     Int         (optional) Disable fast travel
                            Default value: 0
        
        [1]     Int         (optional) Disable waiting
                            Default value: 0
/;
Scriptname UD_Modifier_Disabler extends UD_Modifier

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
Function DeviceLocked(UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    ; TODO PR195
EndFunction

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    ; TODO PR195
EndFunction

String Function GetDetails(UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_msg = ""
    
    loc_msg += "==== " + NameFull + " ====\n"
    loc_msg += "\n"
    
    if Description
        loc_msg += "=== Description ===" + "\n"
        loc_msg += Description
    endif
    Return loc_msg
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Disable fast travel:", UDmain.UDMTF.InlineIfString(GetParamBln(asDataStr, 0, False), "True", "False"))
    loc_res += UDmain.UDMTF.TableRowDetails("Disable waiting:", UDmain.UDMTF.InlineIfString(GetParamBln(asDataStr, 1, False), "True", "False"))
    Return loc_res
EndFunction