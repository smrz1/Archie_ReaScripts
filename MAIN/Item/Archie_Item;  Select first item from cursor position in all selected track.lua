--[[
   * Category:    Item
   * Description: Select first item from cursor position in all selected track
   * Oписание:    Выбрать первый элемент от позиции курсора во всех выбранных треках   
   * GIF:         http://goo.gl/t2rLxh 
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.0
   * customer:    ---
   * gave idea:   HDVulcan(RMM Forum)   
--==========================================]]



    --===========================================================================
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------
   
   
      
    local Count_Sel_Track = reaper.CountSelectedTracks( 0 )
    if Count_Sel_Track == 0 then no_undo() return end
    
    
    local UnselectAllItems = nil 
    for i = 1,Count_Sel_Track do 
        local SelTrack = reaper.GetSelectedTrack( 0, i-1 )
    
        local CountTrItem = reaper.CountTrackMediaItems( SelTrack )
        if CountTrItem > 0 then
            local Cur = reaper.GetCursorPosition()
            for i = 1,CountTrItem do 
                local Tr_item =  reaper.GetTrackMediaItem( SelTrack, i-1 )
                local pos = reaper.GetMediaItemInfo_Value( Tr_item, 'D_POSITION' )  
                if pos >= Cur then 
                    if not UnselectAllItems then 
                        reaper.SelectAllMediaItems( 0, 0 )
                        UnselectAllItems = 0
                    end
                    reaper.SetMediaItemSelected( Tr_item, 1 )
                    undo = 1
                    break
                end       
            end
        end 
    end

    if undo == 1 then
        reaper.Undo_BeginBlock()   
        reaper.Undo_EndBlock( [[Select first item from cursor
                              position in first selected track]],-1)                      
    else
        no_undo()
    end                     
    reaper.UpdateArrange()
