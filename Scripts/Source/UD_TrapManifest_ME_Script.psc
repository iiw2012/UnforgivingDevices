Scriptname UD_TrapManifest_ME_Script extends activemagiceffect  

import UnforgivingDevicesMain

UD_AbadonQuest_script Property AbadonQuest auto
UD_libs Property UDlibs auto
UDCustomDeviceMain Property UDCDmain auto
zadlibs Property libs auto

Event OnEffectStart(Actor akTarget, Actor akCaster)

    if !akTarget.wornhaskeyword(libs.zad_deviousheavybondage)
        UDCDmain.DisableActor(akTarget)

        bool loc_haveSuit = akTarget.wornhaskeyword(libs.zad_deviousSuit)
        Formlist loc_formlist = none
        Armor device = none

        Int loc_arousal = UDCDmain.UDOM.getArousal(akTarget)
        int random = Round(Utility.randomInt(1,100) + (loc_arousal/5))
        
        if random > 90
            loc_formlist = UDCDmain.UDmain.UDRRM.UD_AbadonDeviceList_HeavyBondageHard
        elseif random > 60 
            loc_formlist = UDCDmain.UDmain.UDRRM.UD_AbadonDeviceList_HeavyBondage
        else
            loc_formlist = UDCDmain.UDmain.UDRRM.UD_AbadonDeviceList_HeavyBondageWeak
        endif

        if loc_haveSuit
            Keyword[] loc_filter = new keyword[1]
            loc_filter[0] = libs.zad_deviousStraitjacket
            device = UDCDmain.UDmain.UDRRM.getRandomFormFromFormlistFilter(loc_formlist,loc_filter,2) as Armor
        else
            device = UDCDmain.UDmain.UDRRM.getRandomFormFromFormlist(loc_formlist) as Armor
        endif
            
        UDCDMain.LockDeviceParalel(akTarget,device)

            if GActorIsPlayer(akTarget)
                UDCDmain.Print("Black goo smacks you and transforms into " + device.getName())
            else
                UDCDmain.Print("Black goo smacks " + GetActorName(akTarget) + " and transforms into " + device.getName())
            endif

        UDCDmain.EnableActor(akTarget)

    else
        int loc_devicenum = Utility.randomInt(0,iRange(Round(GetMagnitude()),1,20))
        if UDCDmain.UDmain.UDRRM.LockAnyRandomRestrain(akTarget,loc_devicenum) ;did we managed to add some restraints?
            if GActorIsPlayer(akTarget)
                UDCDmain.Print("Black goo smacks you and transforms into restraint!")
            else
                UDCDmain.Print("Black goo smacks " + GetActorName(akTarget) + " and transforms into restraint!")
            endif
        else
            ;placeholder for something fun to be done in case our victim is already all wrapped up... add some black goo to inventory maybe?
        endif
    endif

EndEvent

