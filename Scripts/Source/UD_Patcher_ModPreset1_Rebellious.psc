;   File: UD_Patcher_ModPreset1_Rebellious
;   Preset for the Rebellious modifier. 
;   
Scriptname UD_Patcher_ModPreset1_Rebellious extends UD_Patcher_ModPreset1

Int Function CheckDeviceCompatibility(UD_CustomDevice_RenderScript akDevice, Bool abCheckWearer = True)
    If !akDevice.GetManipulatedState()
        Return -1
    Endif
    Return Parent.CheckDeviceCompatibility(akDevice, abCheckWearer)
EndFunction