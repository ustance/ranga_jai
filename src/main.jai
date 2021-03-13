#import "Basic";
#import "kinc";


#load "graphics.jai";
#load "input.jai";

#load "island.jai";

#load "editor.jai";

#load "entity_manager.jai";
#load "minable.jai";
#load "player.jai";

#load "my_imgui.jai";


#load "my_math.jai";
#load "json_string.jai";
#load "json.jai";
#load "utils/color.jai";

Game_Context :: struct {
	entity_manager: Entity_Manager;
    
	input_manager: Input_Manager;
	render_context: Render_Context;
    
	islands: [..] Island;
    
    editor: Editor;
}

GAME_MODE :: enum {
    GAME;
    EDITOR;
}



// думаю можно просто бахнуть не поинтер, потому что да, оно будет одно.
game_context: *Game_Context;
screen_camera: Camera;
init :: () {
	game_context = New(Game_Context);
    
    current_time := get_system_time();
    
    kinc_random_init(current_time.millisecond);
    
    //test_thread = thread_create(test_thread_func);
    //thread_start(test_thread);
	
    input_init(*game_context.input_manager);
	init_render_context(*game_context.render_context);
    
    editor_init(*game_context.editor);
    init_entity_manager(*game_context.entity_manager);
    
    update_camera_matrix(*screen_camera);
    
    init_imgui();
	//test_math_functions();
	create_island(game_context, 0, 0, 8, 8);
    
    
    
    kinc_set_update_callback(cast(*void)c_update);
    //create_island(game_context, 0, - TILE_SIZE*4, 4, 4);
    
    
}

test_thread: *Thread;

test_thread_func :: (thread: *Thread) -> s64 {
    i := 0;
    
    while i < 1024 {
        i += 1;
    }
    
    print("Test thread is done!\n");
    
    return 0;
}

#import "Thread";

//time := 0.0;
fps_show_count := 0;
exit_game := false;
update :: (dt: float64) {
	//time += cast(float32)dt;
    
    
	if check_mouse_scroll_up(*game_context.input_manager) {
		game_context.render_context.camera.zoom *= 1.1;
	}
	if check_mouse_scroll_down(*game_context.input_manager) {
		game_context.render_context.camera.zoom *= 0.9;
	}
    
    
    update_entities(game_context, dt);
    update_islands(game_context);
    
    editor_update(game_context);
    
    /*
    if test_thread {
        if thread_is_done(test_thread) {
            thread_destroy(test_thread);
            test_thread = null;
        }
    }
*/
    
	//TODO: make a real shutdown function in a c_update
	if check_key_pressed(*game_context.input_manager, KEY_ESCAPE) {
		exit_game = true;
	}
    imgui_process_events();
}


render :: () {
	render_context := *game_context.render_context;
	draw_begin(render_context);
    
	draw_clear(0xff88aaff);
    
    
    
    draw_islands(game_context);
    
    
    //drawing entities
    set_default_shader(render_context);
    
    draw_entities(game_context);
    
    flush(render_context);
    
    editor_draw(game_context);
    
    
	
    
    
    
    imgui_new_frame();
    
    editor_imgui_draw(game_context);
    
    ImGui.EndFrame();
    
    ImGui.Render();
    
    imgui_render_kinc();
    //ImGui.ShowDemoWindow();
    
    //ImGui.EndFrame();
    
    //ImGui.Render();
    
    //draw_data := ImGui.GetDrawData();
    //print("%\n", draw_data);
    
    //set_default_shader(render_context);
    //set_shader(render_context, "text");
    //draw_string(render_context, 0, 0, tprint("FPS:% (fake btw)", 60));
    //draw_string(render_context, 0, 72, "Вау, поггерс!");
    //flush(render_context);
    
    //set_shader(render_context, "text");
    //draw_string(render_context, 0, 72*3, "WHOA!123456");
    //flush(render_context);
    //testing draw_rectangle
    
	draw_end(render_context);
	swap_buffers(render_context);
}

//TODO: мне лень вспоминать как там высчитывать фпс.
fps := 0.0;

dt := 1.0 / 60.0;
current_time: float64 = 0.0;
c_update :: () #c_call {
	new_context: Context;
	push_context new_context {
		//update();
		new_time := kinc_time();
		frame_time := new_time - current_time;
        
		current_time = new_time;
        
		while frame_time > 0.0 {
			delta_time := min(frame_time, dt);
			update(delta_time);
			frame_time -= delta_time;
		}
        
		input_post_update(*game_context.input_manager);
		render();
        
		reset_temporary_storage();
        
        if exit_game 
            kinc_stop();
	}
}

main :: () {
	options: Window_Options;
	options.visible = true;
	options.x = -1;
	options.y = -1;
	options.window_features = WINDOW_FEATURE_MINIMIZABLE;
    
	kinc_init("Ranga", 1280, 800, *options, null);
    
	init();
    
	kinc_start();
}
