#import "Basic";
#import "Hash_Table";
kinc :: #import "kinc";

Atlas_Data :: struct {
	frames: [..]Atlas_Data_Sprite;
}

Atlas_Data_Sprite :: struct {
	filename: string;
	frame: Atlas_Rect;
	rotated: bool;
	trimmed: bool;
	spriteSourceSize: Atlas_Rect;
	sourceSize: Sprite_WH;
}

Sprite_WH :: struct {
	w: int;
	h: int;
}

Atlas_Manager :: struct {
	table: Table(string, Atlas);
}

Atlas :: struct {
	name: string;
    table: Table(string, Atlas_Rect);
	texture: *kinc.Texture;
}

Atlas_Rect :: struct {
    x: int;
    y: int;
    w: int;
    h: int;
}

init_atlas_manager :: (using render_context: *Render_Context) {
	init(*render_context.atlas_manager.table, 32);
    
	using *atlas_manager;
    
	load_atlas(render_context, "assets/main_atlas.json", "main_atlas");
    load_atlas(render_context, "assets/ui_atlas.json", "ui_atlas");
    load_atlas(render_context, "assets/tiles_atlas.json", "tiles_atlas");
    
    //overrun_engine_with_a_lot_of_atlases(render_context);
    
}

overrun_engine_with_a_lot_of_atlases :: (render_context: *Render_Context) {
    for i: 0..25-1 {
        load_atlas(render_context, "assets/main_atlas.json", tprint("atlas%", i));
    }
}

load_atlas :: (render_context: *Render_Context, path_to_json: string, atlas_name: string) {
	source := read_entire_file(path_to_json);
    
	parsed_data, ok2 := json_parse_string(source);
    
	json_data := parsed_data.value.object;
    
	meta_result, found_1 := table_find(<<json_data, "meta");
	image_name_data, found_2 := table_find(<<meta_result.value.object, "image");
	image_name := image_name_data.value.str;
    
	{
		builder: String_Builder;
		append(*builder, "assets/");
		append(*builder, image_name);
        
		path_to_image := builder_to_string(*builder);
        
		load_texture(render_context, path_to_image, image_name);
        
		create_atlas(render_context, atlas_name, image_name);
	}
    
	result, found:= table_find(<<json_data, "frames");
    
	frames := result.value.object;
	for sprite_table, key: frames {
		sprite_name := key;
        
		frame_data, _1 := table_find(<<sprite_table.value.object, "frame");
		x, _2 := table_find(<<frame_data.value.object, "x");
		y, _3 := table_find(<<frame_data.value.object, "y");
		w, _4 := table_find(<<frame_data.value.object, "w");
		h, _5 := table_find(<<frame_data.value.object, "h");
        
		rect: Atlas_Rect;
		rect.x = xx x.value.number;
		rect.y = xx y.value.number;
		rect.w = xx w.value.number;
		rect.h = xx h.value.number;
        
		put_sprite_into_atlas(*render_context.atlas_manager, atlas_name, sprite_name, rect);
	}
}

create_atlas :: (render_context: *Render_Context, name: string, texture_name: string) {
    atlas: Atlas;
    atlas.name = name;
    
	ptr_to_texture := table_find_pointer(render_context.textures, texture_name);
    assert(ptr_to_texture != null);
	atlas.texture = ptr_to_texture;
    
    
	table_set(*render_context.atlas_manager.table, name, atlas);
}

get_atlas :: (manager: *Atlas_Manager, name: string) -> *Atlas {
	ptr := table_find_pointer(manager.table, name);
	assert(ptr != null);
    
    return ptr;
}

get_sprite_data :: (atlas: *Atlas, name: string) -> Atlas_Rect, bool #must {
	rect, ok := table_find(atlas.table, name);
	return rect, ok;
}

get_sprite_width :: (manager: *Atlas_Manager, atlas_name: string, sprite_name: string) -> int {
    atlas := get_atlas(manager, atlas_name);
    data, ok := get_sprite_data(atlas, sprite_name);
    if ok return data.w;
    return 0;
}

get_sprite_height :: (manager: *Atlas_Manager, atlas_name: string, sprite_name: string) -> int {
    atlas := get_atlas(manager, atlas_name);
    data, ok := get_sprite_data(atlas, sprite_name);
    if ok return data.h;
    return 0;
}

put_sprite_into_atlas :: (manager: *Atlas_Manager, atlas_name: string, sprite_name: string, data: Atlas_Rect) {
    using manager;
    
    table_of_sprites := table_find_pointer(manager.table, atlas_name);
    
    table_set(*table_of_sprites.table, sprite_name, data);
}
