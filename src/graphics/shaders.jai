#import "Basic";
#import "Hash_Table";
#import "File";

Shader_Program :: struct {
    pipeline: Pipeline;
    
    texture_units: Table(string, Texture_Unit);
    locations:     Table(string, Constant_Location);
}

Shader_List :: struct {
    inited := false;
    table: Table(string, *Shader_Program);
}

Shader_Program_Options :: struct {
    blend_source            := Blending_Operation.ONE;
    blend_destination       := Blending_Operation.INV_SOURCE_ALPHA;
    alpha_blend_source      := Blending_Operation.ONE;
    alpha_blend_destination := Blending_Operation.INV_SOURCE_ALPHA;
}

shader_set_float :: (using shader: *Shader_Program, $name: string, v: float) {
    loc, found := table_find(locations, name);
    if !found {
        table_set(*locations, name, kinc_g4_pipeline_get_constant_location(*pipeline, name));
        loc, found = table_find(locations, name);
    }
    
    kinc_g4_set_float(loc, v);
}

shader_set_filter :: (using shader: *Shader_Program, $name: string, filter: bool) {
    loc, found := table_find(texture_units, name);
    if !found {
        table_set(*texture_units, name, kinc_g4_pipeline_get_texture_unit(*pipeline, name));
        loc, found = table_find(texture_units, name);
    }
    if filter {
        kinc_g4_set_texture_magnification_filter(loc, .LINEAR);
        kinc_g4_set_texture_minification_filter(loc, .LINEAR);
    } else {
        kinc_g4_set_texture_magnification_filter(loc, .POINT);
        kinc_g4_set_texture_minification_filter(loc, .POINT);
    }
    
}

shader_set_matrix :: (using shader: *Shader_Program, $name: string, v: *Matrix4x4) {
    loc, found := table_find(locations, name);
    if !found {
        table_set(*locations, name, kinc_g4_pipeline_get_constant_location(*pipeline, name));
        loc, found = table_find(locations, name);
    }
    
    kinc_g4_set_matrix4(loc, v);
}

shader_set_texture :: (using shader: *Shader_Program, $name: string, v: *Texture) {
    loc, found := table_find(texture_units, name);
    if !found {
        table_set(*texture_units, name, kinc_g4_pipeline_get_texture_unit(*pipeline, name));
        loc, found = table_find(texture_units, name);
    }
    
    kinc_g4_set_texture(loc, v);
}

ensure_shader_list_inited :: (using shader_List: *Shader_List) {
    if !inited {
        init(*table, 32);
        inited = true;
    }
}

make_shader_program :: () -> *Shader_Program {
    result := New(Shader_Program);
    init(*result.texture_units, 16);
    init(*result.locations, 16);
    return result;
}

get_shader :: (shader_list: *Shader_List, name: string) -> *Shader_Program{
    value, ok := table_find(shader_list.table, name);
    if ok return value; else return null;
}

create_shader :: (shader_list: *Shader_List, name: string, vertex_path: string, fragment_path: string, options := Shader_Program_Options.{}) {
    ensure_shader_list_inited(shader_list);
    
    new_shader := make_shader_program();
    table_set(*shader_list.table, name, new_shader);
    
	vertex_shader := New(Shader); 
    vs_src, vs_ok := read_entire_file(vertex_path, true);
    
    assert(vs_ok);
    
	kinc_g4_shader_init(vertex_shader, *vs_src.data[0], vs_src.count, .VERTEX);
    
	fragment_shader:= New(Shader); 
    fs_src, fs_ok := read_entire_file(fragment_path, true);
    //fs_src := copy_string(tfs_src);
    assert(fs_ok);
    
	kinc_g4_shader_init(fragment_shader, *fs_src.data[0], fs_src.count, .FRAGMENT);
    
	structure := New(Vertex_Structure);
	kinc_g4_vertex_structure_init(structure);
	kinc_g4_vertex_structure_add(structure, "pos",   .FLOAT3);
	kinc_g4_vertex_structure_add(structure, "uv",    .FLOAT2);
	kinc_g4_vertex_structure_add(structure, "color", .FLOAT4);
    
    pipeline := *new_shader.pipeline;
	kinc_g4_pipeline_init(pipeline);
    
	pipeline.blend_source            = options.blend_source;
	pipeline.blend_destination       = options.blend_destination;
	pipeline.alpha_blend_source      = options.alpha_blend_source;
	pipeline.alpha_blend_destination = options.alpha_blend_destination;
    
	pipeline.vertex_shader   = vertex_shader;
	pipeline.fragment_shader = fragment_shader;
	pipeline.input_layout[0] = structure;
	pipeline.input_layout[1] = null;
    
	kinc_g4_pipeline_compile(pipeline);
    
    table_set(*new_shader.texture_units, "tex", kinc_g4_pipeline_get_texture_unit(pipeline, "tex"));
    table_set(*new_shader.locations, "projection", kinc_g4_pipeline_get_constant_location(pipeline, "projection"));
    table_set(*new_shader.locations, "camera", kinc_g4_pipeline_get_constant_location(pipeline, "camera"));
    //projection_location = kinc_g4_pipeline_get_constant_location(pipeline, "projection");
    //camera_location = kinc_g4_pipeline_get_constant_location(pipeline, "camera");
    
    print("Created shader %\n", name);
}