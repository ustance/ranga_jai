#import "Basic";
Math :: #import "Math";
#import "File";
#import "Hash_Table";
#import "File_Utilities";

#import "kinc";

#load "graphics/camera.jai";
#load "graphics/atlas.jai";
#load "graphics/fonts.jai";
#load "graphics/shaders.jai";

Render_Context :: struct {
	//pipeline:           *Pipeline;
    //text_pipeline:      *Pipeline;
	vertices:            Vertex_Buffer;
	indices:             Index_Buffer;
    
	//projection_location: Constant_Location;
	//camera_location:     Constant_Location;
    
	camera:              Camera;
	projection:          Matrix4x4;
    
    shader_list:         Shader_List;
    current_shader:      *Shader_Program;
    
    atlas_manager:       Atlas_Manager;
    textures:            Table(string, Texture);
	//texture_unit:        Texture_Unit;
	current_texture:    *Texture;
    white_texture:      *Texture;
    
	current_triangle:    int;
	current_ptr:        *float32;
    current_color:       u32 = WHITE;
}

//
// TODO(abstract_panic): Замутить систему загрузки шейдеров!
// 
VS_SRC :: #run read_entire_file("run_tree/assets/shaders/simple.vert.d3d11");
FS_SRC :: #run read_entire_file("run_tree/assets/shaders/simple.frag.d3d11");
FS_TEXT_SRC :: #run read_entire_file("src/shaders/text.frag.d3d11");

ortho :: () -> Matrix4x4 {
	mj := Math.orthographic_projection_matrix(0.0, 1280.0, 800, 0, 0.1, 1000.0);
	Math.transpose(*mj);
    
	mat: Matrix4x4;
	mat.m = mj.floats; 
    
	return mat;
}

//TEST_SRC :: #run read_entire_file("assets/shaders/text_test.txt", true);

init_render_context :: (using render_context: *Render_Context) {
    
	//
	// texture init
	//
	init(*textures, 32); // 32 текстуры потому что сейчас дыа
    
    load_white_texture(render_context, "assets/white.png");
    
	init_atlas_manager(render_context);
    
	// --
	projection = ortho();
    
    camera.zoom = 0.5;
    
    //just a simple shader, but I like the word uber
    create_shader(*shader_list, "uber_shader", "assets/shaders/simple.vert.d3d11", "assets/shaders/simple.frag.d3d11");
    
    text_options: Shader_Program_Options;
    text_options.blend_source = .SOURCE_ALPHA;
    text_options.alpha_blend_source = .SOURCE_ALPHA;
    create_shader(*shader_list, "imgui_shader", "assets/shaders/simple.vert.d3d11", "assets/shaders/simple.frag.d3d11", text_options);
    
    
    create_shader(*shader_list, "text", "assets/shaders/simple.vert.d3d11","assets/shaders/text.frag.d3d11", text_options);
    
    structure := New(Vertex_Structure);
    kinc_g4_vertex_structure_init(structure);
    kinc_g4_vertex_structure_add(structure, "pos",   .FLOAT3);
    kinc_g4_vertex_structure_add(structure, "uv",    .FLOAT2);
    kinc_g4_vertex_structure_add(structure, "color", .FLOAT4);
    
    
    // BUFFERS
    kinc_g4_vertex_buffer_init(*vertices, 1000 * 3, structure, .DYNAMIC, 0);
    current_ptr = kinc_g4_vertex_buffer_lock_all(*vertices);
    
    kinc_g4_index_buffer_init(*indices, 1000 * 3, .FORMAT_32BIT);
    i := kinc_g4_index_buffer_lock(*indices);
    {
        for j: 0..1000-1 {
            << (i + j*3 + 0) = cast(s32) j*3 + 0;
            << (i + j*3 + 1) = cast(s32) j*3 + 1;
            << (i + j*3 + 2) = cast(s32) j*3 + 2;
        }
        kinc_g4_index_buffer_unlock(*indices);
    }
    
    fonts_init();
}

draw_clear :: (color: u32) {
	kinc_g4_clear(CLEAR_COLOR, color, 0.0, 0);
}

draw_begin :: (render_context: *Render_Context) {
	kinc_g4_begin(0);
}

draw_end :: (render_context: *Render_Context) {
	kinc_g4_end(0);
}

swap_buffers :: (render_context: *Render_Context) {
	kinc_g4_swap_buffers();
}

push_triangle :: (render_context: *Render_Context, 
                  x1: float32, y1: float32, x2: float32, y2: float32, x3: float32, y3: float32, 
                  u1: float32, v1: float32, u2: float32, v2: float32, u3: float32, v3: float32) {
	using render_context;
    
	push_vertex(render_context, 0, x1, y1, u1, v1, 1, 1, 1, 1);
	push_vertex(render_context, 9, x2, y2, u2, v2, 1, 1, 1, 1);
	push_vertex(render_context, 18, x3, y3, u3, v3, 1, 1, 1, 1);
    
	current_triangle += 1;
}

push_colored_triangle :: (render_context: *Render_Context, 
                          x1: float32, y1: float32, x2: float32, y2: float32, x3: float32, y3: float32, 
                          u1: float32, v1: float32, u2: float32, v2: float32, u3: float32, v3: float32,
                          r: float32, g: float32, b: float32, a: float32) {
	using render_context;
    
	push_vertex(render_context, 0, x1, y1, u1, v1, r, g, b, a);
	push_vertex(render_context, 9, x2, y2, u2, v2, r, g, b, a);
	push_vertex(render_context, 18, x3, y3, u3, v3, r, g, b, a);
    
	current_triangle += 1;
}

DPT :: 27;

push_vertex :: (render_context: *Render_Context, offset: int, x: float32, y: float32, u: float32, v: float32, r: float32, g: float32, b: float32, a: float32) {
	using render_context;
    
	t := DPT * current_triangle + offset;
    
	<< (current_ptr + t + 0) = x;
	<< (current_ptr + t + 1) = y;
	<< (current_ptr + t + 2) = -5;
	<< (current_ptr + t + 3) = u;
	<< (current_ptr + t + 4) = v;
	<< (current_ptr + t + 5) = r;
	<< (current_ptr + t + 6) = g;
	<< (current_ptr + t + 7) = b;
	<< (current_ptr + t + 8) = a;
}

set_default_shader :: (render_context: *Render_Context) {
	//kinc_g4_set_pipeline(render_context.pipeline);
    shader := get_shader(*render_context.shader_list, "uber_shader");
    render_context.current_shader = shader;
    
}

set_shader :: (render_context: *Render_Context, name: string) {
    shader := get_shader(*render_context.shader_list, name);
    render_context.current_shader = shader;
}

set_text_shader :: (render_context: *Render_Context) {
    //kinc_g4_set_pipeline(render_context.text_pipeline);
}

default_texture: Texture;
load_texture :: (render_context: *Render_Context, path: string, new_name: string) {
	path_cstring := cast(*u8) alloc(path.count+1);
    memcpy(path_cstring, path.data, path.count);
    path_cstring[path.count] = 0;
    
	size := kinc_image_size_from_file(path_cstring);
	data := alloc(size);
    
	image: Image;
    
    result := kinc_image_init_from_file(*image, data, path_cstring);
    
	if result > 0 {
        table_set(*render_context.textures, new_name, .{});
        value := table_find_pointer(render_context.textures, new_name);
        kinc_g4_texture_init_from_image(value, *image);
        print("Texture % loaded!\n", new_name);
	} else {
        print("loading image: %\n", result);
    }
}

load_white_texture :: (render_context: *Render_Context, path: string) {
    path_data := *path.data[0];
    size := kinc_image_size_from_file(path_data);
    data := alloc(size);
    
    image: Image;
    if kinc_image_init_from_file(*image, data, path_data) != 0 {
        render_context.white_texture = New(Texture);
        kinc_g4_texture_init_from_image(render_context.white_texture, *image);
        print("White texture loaded!\n");
    }
    
}


draw_string :: (using render_context: *Render_Context, x: float, y: float, text: string) {
    //mark := get_temporary_storage_mark();
    //defer   set_temporary_storage_mark(mark);
    assert(GLOBAL_FONT != null);
    prep_text(GLOBAL_FONT, xx x, xx -y, .{1,1,1,1}, text, 0);
    
    //set_color(render_context, make_color_u32(1.0, 0.0, 0.0, 1.0));
    //set_white_texture(render_context);
    for quad: GLOBAL_FONT.current_quads {
        //map := quad.map;
        
        //im_set_texture(quad.map);
        //set_texture();
        set_texture(render_context, quad.map);
        x := quad.x0;
        y := -quad.y0;
        w := quad.x1 - quad.x0;
        h := -(quad.y1 - quad.y0);
        
        draw_rectangle_uv(render_context, x, y, w, h, quad.u0, quad.v0, quad.u1, quad.v1);
        //im_draw_rect(quad.x0, quad.y0, quad.x1, quad.y1, quad.u0, quad.v0, quad.u1, quad.v1, quad.color);
    }
}

set_color :: (using render_context: *Render_Context, color: u32) {
    render_context.current_color = color;
}

set_white_texture :: (using render_context: *Render_Context) {
    set_texture(render_context, white_texture);
}

draw_rectangle :: (using render_context: *Render_Context, x: float, y: float, width: float, height: float) {
    r, g, b, a := color_u32_to_floats(current_color);
    r *= a;
    g *= a;
    b *= a;
    
    push_colored_triangle(render_context,
                          x, y + height, x, y, x + width, y,
                          0, 1, 0, 0, 1, 0,
                          r, g, b, a);
    push_colored_triangle(render_context,
                          x, y + height, x + width, y, x + width, y + height,
                          0, 1, 1, 0, 1, 1,
                          r, g, b, a);
}


draw_rectangle_uv :: (using render_context: *Render_Context, x: float, y: float, width: float, height: float, u0: float, v0: float, u1: float, v1: float) {
    
    r, g, b, a := color_u32_to_floats(current_color);
    r *= a;
    g *= a;
    b *= a;
    
    push_colored_triangle(render_context,
                          x, y + height, x, y, x + width, y,
                          u0, v1, u0, v0, u1, v0,
                          r, g, b, a);
    push_colored_triangle(render_context,
                          x, y + height, x + width, y, x + width, y + height,
                          u0, v1, u1, v0, u1, v1,
                          r, g, b, a);
}

draw_image :: (using render_context: *Render_Context, texture_name: string, x: float, y: float, xscale := 1.0, yscale := 1.0) {
	set_texture(render_context, texture_name);
    
	w := current_texture.tex_width;
	h := current_texture.tex_height;
    
	input_xscale := xscale;
	input_yscale := yscale;
    
	output_w := w * input_xscale;
	output_h := h * input_yscale;
    
    r, g, b, a := color_u32_to_floats(current_color);
    r *= a;
    g *= a;
    b *= a;
    
	push_colored_triangle(render_context,
                          x, y + output_h, x, y, x + output_w, y, //pos
                          0, 1, 0, 0, 1, 0, /*uv*/
                          r, g, b, a);
    
	push_colored_triangle(render_context,
                          x, y + output_h, x + output_w, y, x + output_w, y + output_h, //pos
                          0, 1, 1, 0, 1, 1, /*uv*/
                          r, g, b, a);
}

draw_atlas_image :: (using render_context: *Render_Context, atlas_name: string, sprite_name: string, x: float, y: float, xscale := 1.0, yscale := 1.0) {
	atlas := get_atlas(*atlas_manager, atlas_name);
	assert(atlas != null);
    
	texture := atlas.texture;
	assert(texture != null);
	set_texture(render_context, texture);
    
	sprite, ok := get_sprite_data(atlas, sprite_name);
	assert(ok);
    
	tw: float = xx texture.tex_width;
	th: float = xx texture.tex_height;
    
    sx: float = xx sprite.x;
    sy: float = xx sprite.y;
    sw: float = xx sprite.w;
    sh: float = xx sprite.h;
    
	tl_x := sx / tw;
	tl_y := sy / th;
    
	tr_x := (sx + sw) / tw;
	tr_y := sy / th;
    
    bl_x := sx/tw;
	bl_y := (sy+sh)/th;
    
	br_x := (sx+sw)/tw;
	br_y := (sy+sh)/th;
    
    r, g, b, a := color_u32_to_floats(current_color);
    r *= a;
    g *= a;
    b *= a;
    
    
	push_colored_triangle(render_context,
                          x, y + cast(float)sprite.h*yscale, x, y, x + cast(float)sprite.w*xscale, y,
                          bl_x, bl_y, tl_x, tl_y, tr_x, tr_y,
                          r, g, b, a);
	push_colored_triangle(render_context,
                          x, y + cast(float)sprite.h*yscale, x + cast(float)sprite.w*xscale, y, x + cast(float)sprite.w*xscale, y + cast(float)sprite.h*yscale,
                          bl_x, bl_y, tr_x, tr_y, br_x, br_y,
                          r, g, b, a);
    
    
}

set_texture :: (render_context: *Render_Context, name: string) {
	texture := table_find_pointer(render_context.textures, name);
	render_context.current_texture = texture;
}

set_texture :: (render_context: *Render_Context, texture: *Texture) {
	render_context.current_texture = texture;
}

flush :: (render_context: *Render_Context) {
	using render_context;
    
	if current_triangle != 0 {
        
        kinc_g4_set_pipeline(*current_shader.pipeline);
		kinc_g4_vertex_buffer_unlock(*vertices, cast(s32) current_triangle*3);
        
		kinc_g4_set_vertex_buffer(*vertices);
		kinc_g4_set_index_buffer(*indices);
        
		//kinc_g4_set_texture(texture_unit, current_texture);
        shader_set_texture(current_shader, "tex", current_texture);
        shader_set_filter(current_shader, "tex", true);
        shader_set_matrix(current_shader, "projection", *projection);
		//kinc_g4_set_matrix4(render_context.projection_location, *projection);
        
		update_camera_matrix(*camera);
		//kinc_g4_set_matrix4(render_context.camera_location, *camera.matrix);
        shader_set_matrix(current_shader, "camera", *camera.matrix);
        
		kinc_g4_draw_indexed_vertices_from_to(0, cast(s32) current_triangle*3);
        
		current_triangle = 0;
		current_texture = null;
        
		current_ptr = kinc_g4_vertex_buffer_lock_all(*vertices);
	}
}

#scope_file

private_onlyfans_function :: () {
	print("(  O_)O BOOBA");
}


