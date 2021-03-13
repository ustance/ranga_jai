#import "Basic";
#import "Hash_Table";

Input_Manager :: struct {
	mouse_x: float;
	mouse_y: float;
    
	mouse_scroll: s32;
    
	keys_hold: Table(s32, bool);
	keys_pressed: Table(s32, bool);
	keys_released: Table(s32, bool);
    
    keys_pressed_frame: Table(s32, bool);
    
    blocking_keyboard: bool;
    blocking_mouse: bool;
    
    pressed_char: u32;
}



// GLOBAL API

check_key :: (manager: *Input_Manager, key: s32) -> bool {
    if manager.blocking_keyboard return false;
	result, ok := table_find(manager.keys_hold, key);
    
	if !ok return false;
    
	return result;
}

check_key_pressed :: (manager: *Input_Manager, key: s32) -> bool {
    if manager.blocking_keyboard return false;
	result, ok := table_find(manager.keys_pressed, key);
    
	if !ok return false;
    
	return result;
}

check_key_released :: (manager: *Input_Manager, key: s32) -> bool {
    if manager.blocking_keyboard return false;
	result, ok := table_find(manager.keys_released, key);
    
	if !ok return false;
    
	return result;
}



input_post_update :: (manager: *Input_Manager) {
	manager.mouse_scroll = 0;
	for manager.keys_pressed {
		table_set(*manager.keys_pressed, it_index, false);
	}
	for manager.keys_pressed {
		table_set(*manager.keys_released, it_index, false);
	}
    
    manager.pressed_char = 0;
}




_current_input_manager: *Input_Manager;

input_init :: (manager: *Input_Manager) {
	_current_input_manager = manager;
    
	// init keys hash_table
	init(*manager.keys_hold, 190); //187 to be exact, but you know, anything can happen
	init(*manager.keys_pressed, 190); 
	init(*manager.keys_released, 190);
    init(*manager.keys_pressed_frame, 190);
    
	kinc_abstract_set_mouse_press(input_mouse_press);
	kinc_abstract_set_mouse_release(input_mouse_release);
    
	abstract_kinc_set_key_down_callback(input_key_down);
	abstract_kinc_set_key_up_callback(input_key_up);
    abstract_kinc_set_key_press_callback(input_key_press);
    
	kinc_abstract_set_mouse_move(input_mouse_move);
	kinc_abstract_set_mouse_scroll(input_mouse_scroll);
}

check_mouse_scroll_up :: (manager: *Input_Manager) -> bool {
    if manager.blocking_mouse return false;
	return manager.mouse_scroll == -1;
}

check_mouse_scroll_down :: (manager: *Input_Manager) -> bool {
    if manager.blocking_mouse return false;
	return manager.mouse_scroll == 1;
}

input_mouse_move :: (window: s32, x: s32, y: s32, mx: s32, my: s32) #c_call {
	_current_input_manager.mouse_x = cast(float) x;
	_current_input_manager.mouse_y = cast(float) y;
    mouse_x = x;
    mouse_y = y;
}

input_mouse_scroll :: (window: s32, dt: s32) #c_call {
	_current_input_manager.mouse_scroll = dt;
}

input_key_down :: (key: s32) #c_call {
	manager := _current_input_manager;
    
	new_context: Context;
	push_context new_context {
		table_set(*manager.keys_hold, key, true);
		table_set(*manager.keys_pressed, key, true);
        table_set(*manager.keys_pressed_frame, key, true);
	}
}

input_key_press :: (char: u32) #c_call {
    manager := _current_input_manager;
    
    // @CleanUp:
    io := ImGui.GetIO();
    io.AddInputCharacter(io, char);
    
    manager.pressed_char = char;
}

input_key_up :: (key: s32) #c_call {
	manager := _current_input_manager;
    
	new_context: Context;
	push_context new_context {
		table_set(*manager.keys_released, key, true);
		table_set(*manager.keys_hold, key, false);
        table_set(*manager.keys_pressed_frame, key, false);
	}
}

input_mouse_release :: (window: s32, button: s32, x: s32, y: s32) #c_call {
    if button == {
        case 0;
        hold_lmb = false;
        case 1;
        hold_rmb = false;
    }
    mouse_x = x;
    mouse_y = y;
}

hold_lmb := false;
hold_rmb := false;
mouse_x := 0;
mouse_y := 0;

input_mouse_press :: (window: s32, button: s32, x: s32, y: s32) #c_call {
    if button == {
        case 0;
        hold_lmb = true;
        case 1;
        hold_rmb = true;
    }
    mouse_x = x;
    mouse_y = y;
}
