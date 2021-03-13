#import "Basic";
#import "Bucket_Array";
#import "String";
#import "Sort";

Entity_Type :: enum {
	PLAYER  :: 0;
    MINABLE :: 1;
}

Entity :: struct {
	x: float;
	y: float;
    
    locator: Bucket_Locator; @noui;
    
	type: Entity_Type; @noui;
}

create_entity :: (entity_manager: *Entity_Manager, entity_type: Entity_Type, $T: Type) -> *T, Bucket_Locator{
    array := get_bucket_array_by_type(*entity_manager.by_type, entity_type, T);
    
    entity, locator := find_and_occupy_empty_slot(array);
    entity.locator = locator;
    entity.type = entity_type;
    
    array_add(*entity_manager.entities, entity);
    
    return xx entity, locator;
}


find_entity_typed :: (entity_manager: *Entity_Manager, entity_type: Entity_Type, $T: Type, locator: Bucket_Locator) -> *T {
    
    array := get_bucket_array_by_type(*entity_manager.by_type, entity_type, T);
    
    return 
        *array
        .all_buckets[locator.bucket_index]
        .data[locator.slot_index];
    
}
//
// Entity Manager
//

Entity_Manager :: struct {
	entities: [..] *Entity;
    
    by_type: By_Type;
    
	//by_type: By_Type;
}


init_entity_manager :: (entity_manager: *Entity_Manager) {
    by_type_init(*entity_manager.by_type);
	create_player(entity_manager);
}

update_entities :: (using game_context: *Game_Context, dt: float64) {
	for entity_manager.entities {
		if it.type == {
			case .PLAYER;
            
            update_player(game_context, it, dt);
            camera_set_centered_position_from_world(*render_context.camera, it.x + 96/2, it.y + 128/2);
            case .MINABLE;
		}
	}
    
    //quick_sort(entity_manager.entities, sort_by_depth);
    merge_sort(entity_manager.entities, sort_by_depth);
}

sort_by_depth :: (entity1: *Entity, entity2: *Entity) -> int {
    if entity1.y < entity2.y return -1;
    if entity1.y > entity2.y return 1;
    return 0;
}

draw_entities :: (using game_context: *Game_Context) {
	for entity_manager.entities {
		if it.type == {
			case .PLAYER;
            draw_player(*game_context.render_context, it);
            
            case .MINABLE;
            draw_minable(*game_context.render_context, it);
		}
	}
}

generate_by_type_struct :: () -> string {
	info := type_info(Entity_Type);
	builder: String_Builder;
	init_string_builder(*builder);
    
    type_names: [..] string;
    
	for info.names {
        
		append(*builder, "_");
		append(*builder, it[0]);
        
		lower_cased_after_first := copy_string(slice(it, 1, it.count-1));
        
		//TODO: эээ сделай после подчеркивания большую букавку
		append(*builder, lower_cased_after_first);
		//append(*builder, to_lower(slice(it, 1, it.count-1)));
        
		append(*builder, ": Bucket_Array(");
        
        to_lower(lower_cased_after_first);
        
		append(*builder, it[0]);
		append(*builder, lower_cased_after_first);
		append(*builder, ", 50, true);\n");
        
		//print("%\n", builder_to_string(*builder));
	}
    
    // Map of from type to array
    append(*builder, "map: Table(Entity_Type, *void);\n");
    
    
    print("%\n", builder_to_string(*builder));
    
	return builder_to_string(*builder);
}

by_type_init :: (by_type: *By_Type) {
    init(*by_type.map);
    
    table_set(*by_type.map, .PLAYER, *by_type._PLAYER);
    table_set(*by_type.map, .MINABLE, *by_type._MINABLE);
}

get_bucket_array_by_type :: (by_type: *By_Type, entity_type: Entity_Type, $T: Type) -> *Bucket_Array(T, 50, true){
    
    pointer, found := table_find(by_type.map, entity_type);
    assert(found);
    return xx pointer;
}

By_Type :: struct {
#insert #run generate_by_type_struct();
}

