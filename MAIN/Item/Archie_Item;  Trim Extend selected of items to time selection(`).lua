--[[
   * Category:    Item
   * Description: Trim Extend selected of items to time selection
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Trim Extend selected of items to time selection
   *              NOTE THE SETTINGS BELOW
   * О скрипте:   Обрезать, Удленить выбранные элементы по времени
   *              ОБРАТИТЕ ВНИМАНИЕ НА НАСТРОЙКИ НИЖЕ
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---
   * Gave idea:   Iskander M(Rmm/forum) 
   * Changelog:   +  Fixed paths for Mac/ v.1.02 [29.01.19] 
   *              +  Исправлены пути для Mac/ v.1.02 [29.01.19]  

   *              + initialе / v.1.0[14122018]

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
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================  
  
  
  
  
    local Only_Items_In_Time_Selection = 0
                                    -- = 0 | ОБРЕЗКА РАСПРОСТРАНЯЕТСЯ ТОЛЬКО НА ТЕ
                                    --     | ЭЛЕМЕНТЫ, КОТОРЫЕ НАХОДЯТСЯ В ВЫБОРЕ ВРЕМЕНИ 
                                    -- = 1 | ОБРЕЗКА РАСПРОСТРАНЯЕТСЯ  НА ВСЕ ЭЛЕМЕНТЫ 
                                             ----------------------------------------- 
                                    -- = 0 | TRIM EXTENDS ONLY THOSE ITEMS WHICH 
                                    --     | ARE IN TIME SELECTION          
                                    -- = 1 | TRIM APPLIES TO ALL ITEMS
                                    --================================



    --=========================================================================================
    --/////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\\\
    --=========================================================================================




    --============================ FUNCTION MODULE FUNCTION ================================ FUNCTION MODULE FUNCTION ========================================
    local Fun,scr,dir,MB,Arc,Load = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions',select(2,reaper.get_action_context()):match("(.+)[\\/]"),
    reaper.GetResourcePath();package.path=Fun.."/?.lua"..";"..scr.."/?.lua"..";"..dir.."/?.lua"..";"..package.path;Load,Arc=pcall(require,"Arc_Function_lua");
    if not Load then reaper.MB('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in\n'..Fun..'\n\n'..'Отсутствует '..--====
    'файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..Fun,"Error.",0)return end;--=======================================
    if not Arc.VersionArc_Function_lua("2.2.2",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================




    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then Arc.no_undo() return end;


    local startTime,endTime = reaper.GetSet_LoopTimeRange(0,0,0,0,0);

    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();

    for i = 1,CountSelItem do;
        local sel_item = reaper.GetSelectedMediaItem(0,i-1);
        local item_pos = Arc.GetMediaItemInfo_Value(sel_item,"D_POSITION");
        -- local item_len = Arc.GetMediaItemInfo_Value(sel_item,"D_LENGTH");
        local item_end = Arc.GetMediaItemInfo_Value(sel_item,"D_END");

        if Only_Items_In_Time_Selection == 0 then;

            if item_end > startTime and item_pos < endTime then;
                if item_end <= endTime then;
                    reaper.SetMediaItemLength(sel_item,endTime-item_pos,true);
                    Arc.SetMediaItemLeftTrim2(startTime ,sel_item);
                else;   
                    Arc.SetMediaItemLeftTrim2(startTime ,sel_item);
                    reaper.SetMediaItemLength(sel_item,endTime-startTime,true);
                end;
            end;

        elseif Only_Items_In_Time_Selection == 1 then;

            if item_end <= endTime then;
                reaper.SetMediaItemLength(sel_item,endTime-item_pos,true);
                Arc.SetMediaItemLeftTrim2(startTime ,sel_item);
            else;
                Arc.SetMediaItemLeftTrim2(startTime ,sel_item);
                reaper.SetMediaItemLength(sel_item,endTime-startTime,true);
            end;
        end; 
    end;

    reaper.Undo_EndBlock("Trim Extend selected of items to time selection",-1)
    reaper.PreventUIRefresh(-1)
    reaper.UpdateArrange()