--[[
   * Category:    View
   * Description: Enable spectral peaks on selected tracks
   * Author:      Archie
   * Version:     1.08
   * AboutScript: Enable spectral peaks only on selected tracks
   *                RUN THE SCRIPT WITH CTRL + SHIFT + CLICK 
   *                  TO RESET ALL PEAK CACHE FILES
   * О скрипте:   Включить спектральные пики только на выбранных дорожках
   *                ЗАПУСТИТЕ СКРИПТ СОЧЕТАНИЕМ КЛАВИШ CTRL + SHIFT + CLICK 
   *                 ЧТОБЫ СБРОСИТЬ ВСЕ ПИКОВЫЕ ФАЙЛЫ КЭША
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    smrz1(RMM Forum)
   * Gave idea:   smrz1(RMM Forum)
   * Changelog:   
   *              !+ Fixed disabling of actions: Scale peaks by square root / Rectify peaks / v.1.08 [03.02.2019]
   *              !+ Исправлено отключение действий: масштабирование пиков по квадратному корню / исправление пиков/ v.1.08 [03.02.2019]

   *              !+ Fixed reset of the peaks at the switching off action of the Toggle spectral peaks / v.1.06 [01.02.2019]
   *              !+ Fixed not scanning spectral peaks in new projects / v.1.06 [01.02.2019]
   *              !+ Исправлен сброс пиков при отключении экшена переключение спектральных пиков / v.1.06 [01.02.2019]
   *              !+ Исправлено не сканирование спектральных пиков в новых проектах / v.1.06 [01.02.2019]
   *              !+ Cleaned re-scan of the files when you reopen the project / v.1.05 [30.01.2019]
   *              !+ Убрано повторное сканирование файлов при повторном открытии проекта  / v.1.05 [30.01.2019]
   *              !+ Fixed paths for Mac / v.1.04 [29.01.2019]
   *              !+ Исправлены пути для Mac / v.1.04 [29.01.2019]
   *              !+ Fixed working with child tracks / v.1.03 [28.01.2019]
   *              !+ Fixed bug when scanning peak cache files / v.1.03 [28.01.2019]
   *              !+ Исправлена работа с дочерними треками / v.1.03 [28.01.2019]
   *              !+ Исправлена ошибка при сканировании пиковых файлов кэша / v.1.03 [28.01.2019]
   *              ++ initialе / v.1.0

   ===========================================================================================\
   -------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   ===========================================================================================|
   + Reaper v.5.963 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.2.3 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   + reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   ? Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]




    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    --============================ FUNCTION MODULE FUNCTION ================================ FUNCTION MODULE FUNCTION ========================================
    local Fun,scr,dir,MB,Arc,Load = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions',select(2,reaper.get_action_context()):match("(.+)[\\/]"),
    reaper.GetResourcePath();package.path=Fun.."/?.lua"..";"..scr.."/?.lua"..";"..dir.."/?.lua"..";"..package.path;Load,Arc=pcall(require,"Arc_Function_lua");
    if not Load then reaper.MB('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in\n'..Fun..'\n\n'..'Отсутствует '..--====
    'файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..Fun,"Error.",0)return end;--=======================================
    if not Arc.VersionArc_Function_lua("2.2.3",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================



    if not reaper.JS_Mouse_GetState then reaper.MB(
    'There is no file "reaper_js_ReaScriptAPI.dll" \nInstall repository "ReaTeam Extensions"\n\n'..
    'Отсутствует файл "reaper_js_ReaScriptAPI.dll" \nУстановите репозиторий "ReaTeam Extensions"'
    ,"Error",0) Arc.no_undo() return end;
    -------------------------------------


    local RemovePeak = 40097;
    local SpectrPeak = 42073;
    local RebuilPeak = 40048;
    local ScalePeaks = 42306;
    local RectifPeak = 42307;


    -- #108 -----------------------------------------------
    ActionScale = reaper.GetToggleCommandState(ScalePeaks);
    ActionRecti = reaper.GetToggleCommandState(RectifPeak);
    -------------------------------------------------------


     -----------------------------------------------------------------------------------------------------
     -- Option / Preferences / Media
           -- ON | Always generate spectral peak information (default is only when spectral peaks enabled)
           -- ON | Automatically rebuild peaks if necessary when enabling spectral peaks
     local showpeaks = reaper.SNM_GetIntConfigVar("showpeaks",0);
     if showpeaks ~= 67 and showpeaks ~= 1123 then;
         if reaper.GetToggleCommandState(42073)== 1 then;
             reaper.SNM_SetIntConfigVar("showpeaks",1123);
         else;
             reaper.SNM_SetIntConfigVar("showpeaks",67);
         end;
     end;  -- Default ini "showpeaks = 3"
    ----------------------------------------------------------------------------------------------------- 


    -- #108 -----------------
    if ActionScale == 1 then;
        Arc.Action(ScalePeaks);
    end;

    if ActionRecti == 1 then;
        Arc.Action(RectifPeak);
    end;
    ---------------------------


    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then Arc.no_undo() return end;


    local Proj = reaper.GetProjectPath("").."/"..reaper.GetProjectName(0,""); 


    if reaper.JS_Mouse_GetState(12) == 12 then; -- Ctrl + Shift
        ---Reset-----------------------------------------------
        if reaper.GetToggleCommandState(SpectrPeak) == 1 then Arc.Action(SpectrPeak)end;
        reaper.DeleteExtState(Proj.."SelTrSpectPeak39674867",Proj.."key_SpectPeak39674867",true);---
        Arc.Action(RebuilPeak);
        reaper.JS_Window_Enable(reaper.JS_Window_Find("Building Peaks",false),false);
        for i = 1, reaper.CountTracks(0) do;
            local Track = reaper.GetTrack(0,i-1);
            Arc.SetPreventSpectralPeaksInTrack(Track,false);
        end;
        Arc.no_undo() return;
        ---------------------
    else;
        ---Help-----------------------------
        local Clock = math.ceil(os.clock());
        local ClockES = reaper.HasExtState("OsCclockHelpSpect","HelpSpect");
        if ClockES then;
            ClockES = reaper.GetExtState("OsCclockHelpSpect","HelpSpect");
            if Clock > ClockES+15 then;
                reaper.DeleteExtState("OsCclockHelpSpect","HelpSpect",false);
            end;
        end;
        if not ClockES then;
            local HelpWindow = Arc.HelpWindow_WithOptionNotToShow(
                               "Rus:\n"..
                               "    Запустите скрипт сочетанием клавиш Ctrl + Shift + Click чтобы\n"..
                               "    Сбросить все пиковые файлы кэша\n"..
                               "    Сбросить Предотвращение всех спектральных пиков\n"..
                               "    Выключить спектральные пики\n"..
                               "-----------------------------------------------"..
                               "---------------------------------------------\n"..
                               "Eng:\n"..
                               "    Run the script with Ctrl + Shift + Click to\n"..
                               "    Reset all peak cache files\n"..
                               "    Reset Prevention of all spectral peaks\n"..
                               "    Turn off spectral peaks\n","Help.",295746,false);--reset
            if HelpWindow > -1 then;
                reaper.SetExtState("OsCclockHelpSpect","HelpSpect",Clock,false);
            end;
        end;
        -----------------------------------------------------------------------
    end;

    --[[
    local Spectral = reaper.GetToggleCommandState(SpectrPeak);
    if Spectral == 0 then;
        reaper.DeleteExtState(Proj.."SelTrSpectPeak39674867",Proj.."key_SpectPeak39674867",true);---
    end;
    --]]
    
    ----------------------------------------------------------------------------------
    local Peak = reaper.HasExtState(Proj.."SelTrSpectPeak39674867",Proj.."key_SpectPeak39674867");
    if not Peak then;
        reaper.PreventUIRefresh(1);
        local Spectral = reaper.GetToggleCommandState(SpectrPeak);
        if Spectral == 0 then Arc.Action(SpectrPeak) end;
        for i = 1, reaper.CountTracks(0) do;
            local Track = reaper.GetTrack(0,i-1);
            Arc.SetPreventSpectralPeaksInTrack(Track,false);
        end;
        Arc.Action(RemovePeak,RebuilPeak);
        reaper.SetExtState(Proj.."SelTrSpectPeak39674867",Proj.."key_SpectPeak39674867",1,true);---
    end;
    --------------------------------------------------------------------


    ----------------------------------------------------------
    local Spectral = reaper.GetToggleCommandState(SpectrPeak);
    if Spectral == 0 then Arc.Action(SpectrPeak) end;
    -------------------------------------------------


    ---------------------------------------------------------------
    local WindHWND = reaper.JS_Window_Find("Building Peaks",false);
    if WindHWND then;
        local _,_, scr_x, scr_y = reaper.my_getViewport(0,0,0,0,0,0,0,0,0);
        local scr_x = scr_x/2-183;
        local scr_y = scr_y/2+70;
        reaper.JS_Window_SetPosition(WindHWND,scr_x,scr_y,372,95);
        reaper.JS_Window_SetTitle(WindHWND,"Archie: Building Peaks");
        reaper.JS_Window_Enable(WindHWND,false);
    end;
    --------------------------------------------
    

    local WindHWND = reaper.JS_Window_Find("Building Peaks",false);
    if WindHWND then;
        local Mb = reaper.MB("Rus.\n    Дождитесь окончание перестройки всех пиков,\n    Затем  нажмите ОК \n"..
                       "Eng.\n    Wait for the completion of the restructuring of all the peaks,\n"..
                             "    and then click OK","Archie_: Building Peaks",0);
        if Mb then dofile(select(2,reaper.get_action_context()))Arc.no_undo()return end;
    end;
    ----
    

    ----------------------------------------------
    local Undo;
    
    reaper.PreventUIRefresh(1);

    local Depth,Child;
    for i = CountTrack-1,0,-1 do;
        local Track = reaper.GetTrack(0,i);
        local sel = reaper.IsTrackSelected(Track);
        if Child then;
            local fold = reaper.GetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH");
            if fold == 1 then;
                Depth = reaper.GetTrackDepth(Track);
                if Depth == 0 then;
                    sel = true;
                    Child = nil;
                end;
            end;
        end;
        if sel == true then;
            Depth = reaper.GetTrackDepth(Track);
            if Depth > 0 then;
                Child = true;
            end;
            Arc.SetPreventSpectralPeaksInTrack(Track,false);
            if not Undo then reaper.Undo_BeginBlock(); Undo = 1 end;
        else;
            Arc.SetPreventSpectralPeaksInTrack(Track,true);
        end;
    end;

    reaper.PreventUIRefresh(-1);
    ------------------------------------------------------
    


    --#3----------Stop > Auto enable spectral peaks on selected tracks.lua ---------------------------------------------
    if reaper.HasExtState("StopScriptAutoSpectralPeaks_EnableSpectralPeaks","key_StopScriptAutoSpectralPeaks")then;
    reaper.DeleteExtState("StopScriptAutoSpectralPeaks_EnableSpectralPeaks","key_StopScriptAutoSpectralPeaks",false)end;
    --------------------------------------------------------------------------------------------------------------------
    
    reaper.DeleteExtState("OsCclockHelpSpect","HelpSpect",false);
 
    if Undo then
        reaper.Undo_EndBlock("Enable spectral peaks on selected tracks",-1);
    else;
        Arc.no_undo();
    end;