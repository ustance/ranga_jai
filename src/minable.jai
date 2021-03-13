
Minable :: struct {
    using entity: Entity;
    entity.type = .MINABLE;
    
    hp:     u16 = 10;
    max_hp: u16 = 10;
}

create_minable :: (entity_manager: *Entity_Manager, x: float, y: float) {
    
    minable, locator := create_entity(entity_manager, .MINABLE, Minable);
    
    // this is for default variables
    constr: Minable;
    << minable = constr;
    
    minable.x = x;
    minable.y = y;
}

draw_minable :: (render_context: *Render_Context, entity: *Entity) {
    
    spr_w := get_sprite_width(*render_context.atlas_manager, "main_atlas", "tree");
    spr_h := get_sprite_height(*render_context.atlas_manager, "main_atlas", "tree");
    
    draw_atlas_image(render_context, "main_atlas", "tree", 
                     entity.x - spr_w/2, entity.y - spr_h*0.9);
}