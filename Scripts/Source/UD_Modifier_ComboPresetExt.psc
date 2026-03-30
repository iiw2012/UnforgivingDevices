;/  File: UD_Modifier_ComboPresetExt
    A modifier with pre-determined Triggers and Outcome. Bind the script to an alias and use it like any other modifier.
    The main difference is that instead of direct references to the trigger and outcome, the binding is done via object names.
    This is necessary so that the script can be used in an external ESP module.

    NameFull:   
    NameAlias:  


    Parameters in DataStr:
        [0 .. 6]            Parameters for the trigger. See description of the selected trigger for details.
        
        [7 .. n]            Parameters for the outcome. See description of the selected outcome for details.

    Form arguments:
        Form1               Argument for the ModTrigger
        Form2               Argument for the ModOutcome
        Form3               Argument for the ModOutcome
        Form4               Not used! (Use ModTriggerName property instead)
        Form5               Not used! (Use ModOutcomeName property instead)
        
    Example:
/;
ScriptName UD_Modifier_ComboPresetExt extends UD_Modifier_Combo

import UnforgivingDevicesMain
import UD_Native

UD_ModTrigger Property ModTrigger Auto Hidden
UD_ModOutcome Property ModOutcome Auto Hidden

String Property ModTriggerName Auto
String Property ModOutcomeName Auto

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function ValidateModifier(UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Bool loc_res = True
    If ModTriggerName != "" && ModTrigger == None
        UD_ModTrigger loc_trigger = UDMain.UDMOM.GetPublicHandler(ModTriggerName) As UD_ModTrigger
        If loc_trigger != None
            If UDMain.TraceAllowed()
                UDMain.Log(Self + "::ValidateModifier() Found and set trigger by its name '" + ModTriggerName + "'", 1)
            EndIf
            ModTrigger = loc_trigger
        Else
            UDMain.Warning(Self + "::ValidateModifier() Can't find public trigger handler with name '" + ModTriggerName + "'!")
            loc_res = False
        EndIf
    EndIf
    If ModOutcomeName != "" && ModOutcome == None
        UD_ModOutcome loc_outcome = UDMain.UDMOM.GetPublicHandler(ModOutcomeName) As UD_ModOutcome
        If loc_outcome != None
            If UDMain.TraceAllowed()
                UDMain.Log(Self + "::ValidateModifier() Found and set outcome by its name '" + ModOutcomeName + "'", 1)
            EndIf
            ModOutcome = loc_outcome
        Else
            UDMain.Warning(Self + "::ValidateModifier() Can't find public outcome handler with name '" + ModOutcomeName + "'!")
            loc_res = False
        EndIf
    EndIf
    Return loc_res && Parent.ValidateModifier(akDevice, asDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
EndFunction

UD_ModTrigger Function GetTrigger(UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Return ModTrigger
EndFunction

UD_ModOutcome Function GetOutcome(UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Return ModOutcome
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetCaption(UD_CustomDevice_RenderScript akDevice, String asDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Return NameFull
EndFunction