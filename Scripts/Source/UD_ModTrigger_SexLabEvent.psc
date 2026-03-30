;/  File: UD_ModTrigger_SexLabEvent
    It triggers on sex event

    NameFull: On Sex Event

    Parameters in DataStr:
        [0]     String      SexLab event name
                                

        [1]     Float       (optional) Base probability to trigger on event (in %)
                            Default value: 100.0%

    Example:
        
/;
Scriptname UD_ModTrigger_SexLabEvent extends UD_ModTrigger

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
Bool Function SexLabEvent(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Bool[] aabTypes, Actor[] aakActors, String asDataStr, Form akForm1)
    Float loc_prob_base = GetParamFlt(akModifier, asDataStr, 1, 100.0, "Probability")
    ; TODO PR195
    Return False
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1)
    Float loc_prob_base = GetParamFlt(akModifier, asDataStr, 1, 100.0, "Probability")
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:", FormatFloat(loc_prob_base, 1) + "%")
    Return loc_res
EndFunction
