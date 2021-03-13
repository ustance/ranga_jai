Editor :: struct {
    
}

editor_init :: (editor: *Editor) {
    
}


editor_update :: (game_context: *Game_Context) {
    
}

editor_imgui_draw :: (game_context: *Game_Context) {
    if ImGui.BeginMainMenuBar() {
        if ImGui.BeginMenu("Development") {
            if ImGui.MenuItem("Quit!") {
                exit_game = true;
            }
            ImGui.EndMenu();
        }
        
        if ImGui.BeginMenu("View") {
            if ImGui.MenuItem("Entitiy List") {
                show_entities_list_by_type = !show_entities_list_by_type;
            }
            ImGui.EndMenu();
        }
    }
    ImGui.EndMainMenuBar();
    
    if show_entities_list_by_type {
        
        if ImGui.Begin("Entity Viewer", *show_entities_list_by_type) {
            //info := type_info(By_Type);
            
            by_type := *game_context.entity_manager.by_type;
            
            for * by_type._PLAYER {
                ImGui.inspect("Player", it);
            }
            
        }
        ImGui.End();
    }
    
}

editor_draw :: (game_context: *Game_Context) {
    
}

#scope_file

show_entities_list_by_type: bool;