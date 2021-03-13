
Player :: struct {
    using entity: Entity;
    entity.type = .PLAYER;
    
    movement_speed := 600.0;
    looking_left := false;
}



create_player :: (entity_manager: *Entity_Manager) {
    
    player, locator := create_entity(entity_manager, .PLAYER, Player);
    
    // this is for default variables
    constr: Player;
    << player = constr;
}


update_player :: (game_context: *Game_Context, entity: *Entity, dt: float64) {
    input_manager := *game_context.input_manager;
    
    player: *Player = xx entity;
    
    spd := player.movement_speed * cast(float32)dt;
	if check_key(input_manager, KEY_D) {
        if is_island_on_position(game_context, player.x + spd, player.y) 
            player.x += spd;
        
		player.looking_left = false;
	}
    
	if check_key(input_manager, KEY_A) {
        if is_island_on_position(game_context, player.x - spd, player.y)
            player.x -= spd;
		player.looking_left = true;
	}
    
	if check_key(input_manager, KEY_W) {
        if is_island_on_position(game_context, player.x, player.y - spd)
            player.y -= spd;
	}
    
	if check_key(input_manager, KEY_S) {
        if is_island_on_position(game_context, player.x, player.y + spd)
            player.y += spd;
	}
}

draw_player :: (render_context: *Render_Context, entity: *Entity) {
    player: *Player = xx entity;
    spr_w := get_sprite_width(*render_context.atlas_manager, "main_atlas", "player");
    spr_h := get_sprite_height(*render_context.atlas_manager, "main_atlas", "player");
    
    if player.looking_left {
        draw_atlas_image(render_context, "main_atlas", "player", player.x - spr_w/2, player.y - spr_h*0.9);
    } else {
        draw_atlas_image(render_context, "main_atlas", "player", player.x + spr_w/2, player.y - spr_h*0.9, -1);
    }
    
}