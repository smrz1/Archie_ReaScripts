--[[
   * Category:    Take
   * Description: Delete name in selected items in active take
   * Author:      Archie
   * Version:     1.03
   * AboutScript: Delete name in selected items in active take
   * О скрипте:   Удалить имя в выбранных элементах в активном take
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---(---)
   * Gave idea:   YuriOl(RMM)
   * Changelog:   +  Fixed paths for Mac/ v.1.03 [29.01.19] 
   *              +  Исправлены пути для Mac/ v.1.03 [29.01.19]  

   *              +  initialе / v.1.0 [17.01.2019]
   
   ===========================================================================================\
   -------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   ===========================================================================================|
   + Reaper v.5.965 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.2.2 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]

                


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    --============================ FUNCTION MODULE FUNCTION ================================ FUNCTION MODULE FUNCTION ========================================
    local Fun,scr,dir,MB,Arc,Load = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions',select(2,reaper.get_action_context()):match("(.+)[\\/]"),
    reaper.GetResourcePath();package.path=Fun.."/?.lua"..";"..scr.."/?.lua"..";"..dir.."/?.lua"..";"..package.path;Load,Arc=pcall(require,"Arc_Function_lua");
    if not Load then reaper.MB('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in\n'..Fun..'\n\n'..'Отсутствует '..--====
    'файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..Fun,"Error.",0)return end;--=======================================
    if not Arc.VersionArc_Function_lua("2.2.2",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================




    local Count_sel_item = reaper.CountSelectedMediaItems(0);
    if Count_sel_item == 0 then Arc.no_undo() return end;
    
    
    reaper.Undo_BeginBlock();

    for i = 1, Count_sel_item do;
        local SelItem = reaper.GetSelectedMediaItem(0,i-1);
        local ActiveTake = reaper.GetActiveTake(SelItem);
        reaper.GetSetMediaItemTakeInfo_String(ActiveTake,"P_NAME","",1);
    end;

    reaper.Undo_EndBlock('Delete name in selected items in active take',-1);
    reaper.UpdateArrange();