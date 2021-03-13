KINC :: #foreign_library "../../lib/Kinc";

#load "types.jai";

kinc_init :: (name: *u8, width: s32, height: s32, window_options: *Window_Options, framebuffer_options: *Framebuffer_Options) -> s32 #foreign KINC;

kinc_application_name :: () -> *u8 #foreign KINC;
kinc_set_application_name :: (str: *u8) #foreign KINC;
kinc_width :: () -> s32 #foreign KINC;
kinc_height :: () -> s32 #foreign KINC;

kinc_internal_handle_messages :: () -> bool #foreign KINC;
kinc_load_url :: (url: *u8) #foreign KINC;
kinc_system_id :: () -> *u8 #foreign KINC;
kinc_internal_save_path :: () -> *u8 #foreign KINC;
kinc_video_formats :: () -> **u8 #foreign KINC;
kinc_language :: () -> *u8 #foreign KINC;
kinc_vibrate :: (ms: s32) #foreign KINC;


kinc_safe_zone :: () -> float32 #foreign KINC;
kinc_automatic_safe_zone :: () -> bool #foreign KINC;
kinc_set_safe_zone :: (value: float32) #foreign KINC;

kinc_frequency :: () -> float64 #foreign KINC;
// kinc_ticks_t kinc_timestamp()
kinc_time :: () -> float64 #foreign KINC;

kinc_start :: () #foreign KINC;
kinc_stop :: () #foreign KINC;

kinc_login :: () #foreign KINC;
kinc_waiting_for_login :: () -> bool #foreign KINC;
kinc_unlock_achievement :: (id: s32) #foreign KINC;
kinc_disallow_user_change :: () #foreign KINC;
kinc_allow_user_change :: () #foreign KINC;

kinc_set_keep_screen_on :: (on: bool) #foreign KINC;

kinc_set_update_callback :: (value: *void) #foreign KINC;
kinc_set_foreground_callback :: (value: *void) #foreign KINC;
kinc_set_resume_callback :: (value: *void) #foreign KINC;
kinc_set_pause_callback :: (value: *void) #foreign KINC;
kinc_set_background_callback :: (value: *void) #foreign KINC;
kinc_set_shutdown_callback :: (value: *void) #foreign KINC;
kinc_set_drop_files_callback :: (value: *void) #foreign KINC;
kinc_set_cut_callback :: (value: *void) #foreign KINC;
kinc_set_copy_callback :: (value: *void) #foreign KINC;
kinc_set_paste_callback :: (value: *void) #foreign KINC;
kinc_set_login_callback :: (value: *void) #foreign KINC;
kinc_set_logout_callback :: (value: *void) #foreign KINC;
// -----------------------------------------------------------------------------
//
// window.h
//
// -----------------------------------------------------------------------------
kinc_window_create :: (win: *Window_Options, frame: *Framebuffer_Options) -> s32 #foreign KINC;
kinc_window_destroy :: (window_index: s32) #foreign KINC;
kinc_count_windows :: () -> s32 #foreign KINC;
kinc_window_resize :: (window_index: s32, width: s32, height: s32) #foreign KINC;
kinc_window_move :: (window_index: s32, x: s32, y: s32) #foreign KINC;
kinc_window_change_mode :: (window_index: s32, mode: Window_Mode) #foreign KINC;
kinc_window_change_features :: (window_index: s32, features: s32) #foreign KINC;
kinc_window_change_framebuffer :: (window_index: s32, frame: *Framebuffer_Options) #foreign KINC;

kinc_window_x :: (window_index: s32) -> s32 #foreign KINC;
kinc_window_y :: (window_index: s32) -> s32 #foreign KINC;
kinc_window_width :: (window_index: s32) -> s32 #foreign KINC;
kinc_window_height :: (window_index: s32) -> s32 #foreign KINC;
kinc_window_display :: (window_index: s32) -> s32 #foreign KINC;
kinc_window_get_mode :: (window_index: s32) -> Window_Mode #foreign KINC;
kinc_window_show :: (window_index: s32) #foreign KINC;
kinc_window_hide :: (window_index: s32) #foreign KINC;
kinc_window_set_title :: (window_index: s32, title: *u8) #foreign KINC;
/* window_set_resize_callback :: (window_index: s32, callback : "c" (x: s32, y: s32, data: *void), data: *void) #foreign KINC; */
/* window_set_ppi_changed_callback :: (window_index: s32, callback : "c" (ppi: s32, data: *void), data: *void) #foreign KINC; */
kinc_window_vsynced :: (window_index: s32) -> bool #foreign KINC;
// -----------------------------------------------------------------------------
//
// image.h
//
// -----------------------------------------------------------------------------
kinc_image_init :: (image: *Image, memory: *void, width: s32, height: s32, format: Image_Format) -> s64 #foreign KINC;
kinc_image_init3d :: (image: *Image, memory: *void, width: s32, height: s32, depth: s32, format: Image_Format) -> s64 #foreign KINC;
kinc_image_size_from_file :: (filename: *u8) -> s64 #foreign KINC;
kinc_image_size_from_callbacks :: (callbacks: Image_Read_Callbacks, user_data: *void, filename: *u8) -> s64 #foreign KINC;
kinc_image_init_from_file :: (image: *Image, memory: *void, filename: *u8) -> s64 #foreign KINC;
kinc_image_init_from_callbacks :: (image: *Image, memory: *void, callbacks: Image_Read_Callbacks, user_data: *void, filename: *u8) -> s64 #foreign KINC;

kinc_image_init_from_bytes :: (image: *Image, data: *void, width: s32, height: s32, format: Image_Format) #foreign KINC;
kinc_image_init_from_bytes3d :: (image: *Image, data: *void, width: s32, height: s32, depth: s32, format: Image_Format) #foreign KINC;
kinc_image_destroy :: (image: *Image) #foreign KINC;
kinc_image_at :: (image: *Image, x: s32, y: s32) #foreign KINC;
kinc_image_get_pixels :: (image: *Image) -> *u8 #foreign KINC;

kinc_image_format_sizeof :: (format: Image_Format) -> s32 #foreign KINC;
// -----------------------------------------------------------------------------
//
// display.h
//
// -----------------------------------------------------------------------------
kinc_display_init :: () #foreign KINC;
kinc_primary_display :: () -> s32 #foreign KINC;
kinc_count_displays :: () -> s32 #foreign KINC;
kinc_display_available :: (display_index: s32) -> bool #foreign KINC;
kinc_display_name :: (display_index: s32) -> *u8 #foreign KINC;
kinc_display_current_mode :: (display_index: s32) -> Display_Mode #foreign KINC;
kinc_display_count_available_modes :: (display_index: s32) -> s32 #foreign KINC;
kinc_display_available_mode :: (display_index: s32, mode_index: s32) -> Display_Mode #foreign KINC;
// -----------------------------------------------------------------------------
//
// color.h
//
// -----------------------------------------------------------------------------
kinc_color_components :: (color: u32, red: *float32, green: *float32, blue: *float32, alpha: *float32) #foreign KINC;
// -----------------------------------------------------------------------------
//
// socket.h
//
// -----------------------------------------------------------------------------
kinc_socket_init :: (socket: *Socket) #foreign KINC;
kinc_socket_destroy :: (socket: *Socket) #foreign KINC;
kinc_socket_open :: (socket: *Socket, port: s32) -> bool #foreign KINC;
kinc_socket_set_broadcast_enabled :: (socket: *Socket, enabled: bool) #foreign KINC;
kinc_socket_send :: (socket: *Socket, address: u32, port: s32, data: *void, size: s32) #foreign KINC;
kinc_socket_send_url :: (socket: *Socket, address: u32, url: *u8, data: *void, size: s32) #foreign KINC;
kinc_socket_receive :: (socket: *Socket, data: *u8, max_size: s32, from_address: *u32, from_port: *u32) -> s32 #foreign KINC;
kinc_url_to_int :: (url: *u8, port: s32) -> u32 #foreign KINC;
// -----------------------------------------------------------------------------
//
// http.h
//
// -----------------------------------------------------------------------------
kinc_http_request :: (url: *u8, path: *u8, data: *u8, port: s32, secure: bool, method: s32, header: *u8, callback: (error: s32, response: s32, body: *u8, callbackdata: *void) #c_call, callbackdata: *void) #foreign KINC;
// -----------------------------------------------------------------------------
//
// audio2.h
//
// -----------------------------------------------------------------------------
kinc_a2_init :: () #foreign KINC;
kinc_a2_set_callback :: (callback: (buffer: *Audio2_Buffer, samples: s32) #c_call) #foreign KINC;
//kinc_a2_set_sample_rate_callback :: (callback: *void) #foreign KINC;
kinc_a2_samples_per_second: s32;
kinc_a2_update :: () #foreign KINC;
kinc_a2_shutdown :: () #foreign KINC;
// -----------------------------------------------------------------------------
//
// vrinterface.h
//
// -----------------------------------------------------------------------------
/* kinc_vr_interface_init :: (hinst: *void, title: *u8, window_class_name: *u8) -> *void #foreign KINC; */
/* kinc_vr_interface_begin :: () #foreign KINC; */
/* kinc_vr_interface_begin_render :: (eye: s32) #foreign KINC; */
/* kinc_vr_interface_end_render :: (eye: s32) #foreign KINC; */
/* kinc_vr_interface_get_sensor_state :: (eye: s32) -> Vr_Sensor_State #foreign KINC; */
/* kinc_vr_interface_get_controller :: (index: s32) -> Vr_Pos_State #foreign KINC; */
/* kinc_vr_interface_warp_swap :: () #foreign KINC; */
/* kinc_vr_interface_update_tracking_origin :: (origin: Tracking_Origin) #foreign KINC; */
/* kinc_vr_interface_reset_hmd_pose :: () #foreign KINC; */
/* kinc_vr_interface_ovr_shutdown :: () #foreign KINC; */
// -----------------------------------------------------------------------------
//
// vector.h
//
// -----------------------------------------------------------------------------
//nothing
// -----------------------------------------------------------------------------
//
// matrix.h
//
// -----------------------------------------------------------------------------
kinc_matrix3x3_get :: (matrix: *Matrix3x3, x: s32, y: s32) -> float32 #foreign KINC;
kinc_matrix3x3_set :: (matrix: *Matrix3x3, x: s32, y: s32, value: float32) #foreign KINC;
kinc_matrix3x3_transpose :: (matrix: *Matrix3x3) #foreign KINC;
kinc_matrix3x3_identity :: () -> Matrix3x3 #foreign KINC;

kinc_matrix3x_rotation_x :: (alpha: float32) -> Matrix3x3 #foreign KINC;
kinc_matrix3x_rotation_y :: (alpha: float32) -> Matrix3x3 #foreign KINC;
kinc_matrix3x_rotation_z :: (alpha: float32) -> Matrix3x3 #foreign KINC;

kinc_matrix4x4_get :: (matrix: *Matrix4x4, x: s32, y: s32) -> float32 #foreign KINC;
kinc_matrix4x4_set :: (matrix: *Matrix4x4, x: s32, y: s32, value: float32) #foreign KINC;
kinc_matrix4x4_transpose :: (matrix: *Matrix4x4) #foreign KINC;
kinc_matrix4x4_multiply :: (a: *Matrix4x4, b: *Matrix4x4) #foreign KINC;
// -----------------------------------------------------------------------------
//
// quaternion.h
//
// -----------------------------------------------------------------------------
//nothing
// -----------------------------------------------------------------------------
//
// random.h
//
// -----------------------------------------------------------------------------
kinc_random_init :: (seed: s32) #foreign KINC;
kinc_random_get :: () -> s32 #foreign KINC;
kinc_random_get_max :: (max: s32) -> s32 #foreign KINC;
kinc_random_get_in :: (min: s32, max: s32) -> s32 #foreign KINC;
// -----------------------------------------------------------------------------
//
// math/core.h
//
// -----------------------------------------------------------------------------
kinc_sin :: (value: float32) -> float32 #foreign KINC;
kinc_cos :: (value: float32) -> float32 #foreign KINC;
kinc_tan :: (value: float32) -> float32 #foreign KINC;
kinc_cot :: (value: float32) -> float32 #foreign KINC;
kinc_round :: (value: float32) -> float32 #foreign KINC;
kinc_ceil :: (value: float32) -> float32 #foreign KINC;
kinc_pow :: (value: float32) -> float32 #foreign KINC;
kinc_max_float :: () -> float32 #foreign KINC;
kinc_sqrt :: (value: float32) -> float32 #foreign KINC;
kinc_abs :: (value: float32) -> float32 #foreign KINC;
kinc_asin :: (value: float32) -> float32 #foreign KINC;
kinc_acos :: (value: float32) -> float32 #foreign KINC;
kinc_atan :: (value: float32) -> float32 #foreign KINC;
kinc_atan2 :: (y: float32, x: float32) -> float32 #foreign KINC;
kinc_floor :: (value: float32) -> float32 #foreign KINC;
kinc_mod :: (numer: float32, denom: float32) -> float32 #foreign KINC;
kinc_exp :: (exponent: float32) -> float32 #foreign KINC;
kinc_min :: (a: float32, b: float32) -> float32 #foreign KINC;
kinc_max :: (a: float32, b: float32) -> float32 #foreign KINC;
kinc_maxi :: (a: s32, b: s32) -> s32 #foreign KINC;
kinc_mini :: (a: s32, b: s32) -> s32 #foreign KINC;
kinc_clamp :: (value: float32, min_value: float32, max_value: float32) -> s32 #foreign KINC;
// -----------------------------------------------------------------------------
//
// filewriter.h
//
// -----------------------------------------------------------------------------
kinc_file_writer_open :: (writer: *File_Writer, filepath: *u8) -> bool #foreign KINC;
kinc_file_writer_write :: (writer: *File_Writer, data: *void, size: s32) #foreign KINC;
kinc_file_writer_close :: (writer: *File_Writer) #foreign KINC;
// -----------------------------------------------------------------------------
//
// filereader.h
//
// -----------------------------------------------------------------------------
kinc_file_reader_open :: (reader: *File_Reader, filename: *u8, type: s32) -> bool #foreign KINC;
kinc_file_reader_close :: (reader: *File_Reader) #foreign KINC;
kinc_file_reader_read :: (reader: *File_Reader, data: *void, size: s64) -> s32 #foreign KINC;
kinc_file_reader_size :: (reader: *File_Reader) -> s64 #foreign KINC;
kinc_file_reader_pos :: (reader: *File_Reader) -> s32 #foreign KINC;
kinc_file_reader_seek :: (reader: *File_Reader, pos: s32) #foreign KINC;

//uint8_t = u8
kinc_read_f32le :: (data: *u8) -> float32 #foreign KINC;
kinc_read_f32be :: (data: *u8) -> float32 #foreign KINC;

// u64 = uint64_t
kinc_read_u64le :: (data: *u8) -> u64 #foreign KINC;
kinc_read_u64be :: (data: *u8) -> u64 #foreign KINC;

kinc_read_s64le :: (data: *u8) -> s64 #foreign KINC;
kinc_read_s64be :: (data: *u8) -> s64 #foreign KINC;

kinc_read_u32le :: (data: *u8) -> u32 #foreign KINC;
kinc_read_u32be :: (data: *u8) -> u32 #foreign KINC;

kinc_read_s32le :: (data: *u8) -> s32 #foreign KINC;
kinc_read_s32be :: (data: *u8) -> s32 #foreign KINC;

kinc_read_u16le :: (data: *u8) -> u16 #foreign KINC;
kinc_read_u16be :: (data: *u8) -> u16 #foreign KINC;

kinc_read_s16le :: (data: *u8) -> s16 #foreign KINC;
kinc_read_s16be :: (data: *u8) -> s16 #foreign KINC;

kinc_read_u8 :: (data: *u8) -> u8 #foreign KINC;
kinc_read_s8 :: (data: *u8) -> s8 #foreign KINC;
// -----------------------------------------------------------------------------
//
// keyboard.h
//
// -----------------------------------------------------------------------------
kinc_keyboard_show :: () #foreign KINC;
kinc_keyboard_hide :: () #foreign KINC;
kinc_keyboard_active :: () -> bool #foreign KINC;


abstract_kinc_set_key_down_callback :: (key_down: (key: s32) #c_call) #foreign KINC;
abstract_kinc_set_key_up_callback :: (key_up: (key: s32) #c_call) #foreign KINC;
abstract_kinc_set_key_press_callback :: (key_press: (key:u32) #c_call) #foreign KINC;
//  "";
//"__imp_kinc_keyboard_key_up_callback";
//"__imp_kinc_keyboard_key_press_callback";
/* kinc_keyboard_key_down_callback: (key: s32) #foreign KINC; */
/* kinc_keyboard_key_up_callback: (key: s32) #foreign KINC; */
/* kinc_keyboard_key_press_callback: (character: u32) #foreign KINC; */

// -----------------------------------------------------------------------------
//
// mouse.h
//
// -----------------------------------------------------------------------------
kinc_mouse_can_lock :: (window: s32) -> bool #foreign KINC;
kinc_mouse_is_locked :: (window: s32) -> bool #foreign KINC;
kinc_mouse_lock :: (window: s32) #foreign KINC;
kinc_mouse_unlock :: (window: s32) #foreign KINC;

kinc_mouse_set_cursor :: (cursor: s32) #foreign KINC;


kinc_mouse_show :: () #foreign KINC;
kinc_mouse_hide :: () #foreign KINC;
kinc_mouse_set_position :: (window: s32, x: s32, y: s32) #foreign KINC;
kinc_mouse_get_position :: (window: s32, x: *s32, y: *s32) #foreign KINC;


kinc_abstract_set_mouse_press   :: (kinc_mouse_press_callback       : (window: s32, button: s32, x: s32, y: s32) #c_call) #foreign KINC;
kinc_abstract_set_mouse_release :: (kinc_mouse_release_callback     : (window: s32, button: s32, x: s32, y: s32) #c_call) #foreign KINC;
kinc_abstract_set_mouse_move    :: (kinc_mouse_move_callback        : (window: s32, x: s32, y: s32, movement_x: s32, movement_y: s32) #c_call) #foreign KINC;
kinc_abstract_set_mouse_scroll  :: (kinc_mouse_scroll_callback      : (window: s32, delta: s32) #c_call) #foreign KINC;
kinc_abstract_set_mouse_enter   :: (kinc_mouse_enter_window_callback: (window: s32) #c_call) #foreign KINC;
kinc_abstract_set_mouse_leave   :: (kinc_mouse_leave_window_callback: (window: s32) #c_call) #foreign KINC;

/* @(link_name="__imp_kinc_mouse_press_callback") */
/* kinc_mouse_press_callback: (window: s32, button: s32, x: s32, y: s32) #foreign KINC; */

/* /1* @(link_name="__imp_kinc_mouse_release_callback") *1/ */
/* kinc_mouse_release_callback: (window: s32, button: s32, x: s32, y: s32) #foreign KINC; */

/* /1* @(link_name="__imp_kinc_mouse_move_callback") *1/ */
/* kinc_mouse_move_callback: (window: s32, x: s32, y: s32, movement_x: s32, movement_y: s32) #foreign KINC; */

/* /1* @(link_name="__imp_kinc_mouse_scroll_callback") *1/ */
/* kinc_mouse_scroll_callback: (window: s32, delta: s32) #foreign KINC; */

/* /1* @(link_name="__imp_kinc_mouse_enter_window_callback") *1/ */
/* kinc_mouse_enter_window_callback: (window: s32) #foreign KINC; */

/* /1* @(link_name="__imp_kinc_mouse_leave_window_callback") *1/ */
/* kinc_mouse_leave_window_callback: (window: s32) #foreign KINC; */

// -----------------------------------------------------------------------------
//
// gamepad.h
//
// -----------------------------------------------------------------------------
kinc_gamepad_vendor :: (gamepad: s32) -> *u8 #foreign KINC;
kinc_gamepad_product_name :: (gamepad: s32) -> *u8 #foreign KINC;
kinc_gamepad_connected :: (gamepad: s32) -> bool #foreign KINC;

/* @(link_name="__imp_kinc_gamepad_axis_callback") */
kinc_gamepad_axis_callback: (gamepad: s32, axis: s32, value: float32) #foreign KINC;
/* @(link_name="__imp_kinc_gamepad_button_callback") */
kinc_gamepad_button_callback: (gamepad: s32, button: s32, value: float32) #foreign KINC;


// -----------------------------------------------------------------------------
//
// graphics4.h
//
// -----------------------------------------------------------------------------
kinc_g4_init :: (window: s32, depth_buffer_bits: s32, stencil_buffer_bits: s32, vsync: bool) #foreign KINC;
kinc_g4_destroy :: (window: s32) #foreign KINC;

kinc_g4_flush :: () #foreign KINC;

kinc_g4_begin :: (window: s32) #foreign KINC;
kinc_g4_end :: (window: s32) #foreign KINC;

kinc_g4_swap_buffers :: () -> bool #foreign KINC;

kinc_g4_clear :: (flags: u32, color: u32, depth: float32, stencil: s32) #foreign KINC;
kinc_g4_viewport :: (x: s32, y: s32, width: s32, height: s32) #foreign KINC;
kinc_g4_scissor :: (x: s32, y: s32, width: s32, height: s32) #foreign KINC;
kinc_g4_disable_scissor :: () #foreign KINC;
kinc_g4_draw_indexed_vertices :: () #foreign KINC;
kinc_g4_draw_indexed_vertices_from_to :: (start: s32, count: s32) #foreign KINC;
kinc_g4_draw_indexed_vertices_from_to_from :: (start: s32, count: s32, vertex_offset: s32) #foreign KINC;
kinc_g4_draw_indexed_vertices_instanced :: (instance_count: s32) #foreign KINC;
kinc_g4_draw_indexed_vertices_instanced_from_to :: (instance_count: s32, start: s32, count: s32) #foreign KINC;
kinc_g4_set_texture_addressing :: (unit: Texture_Unit, dir: Texture_Direction, addressing: Texture_Addressing) #foreign KINC;
kinc_g4_set_texture3d_addressing :: (unit: Texture_Unit, dir: Texture_Direction, addressing: Texture_Addressing) #foreign KINC;
kinc_g4_set_pipeline :: (pipeline: *Pipeline) #foreign KINC;
kinc_g4_set_stencil_reference_value :: (value: s32) #foreign KINC;
kinc_g4_set_texture_operation :: (operation: Texture_Operation, arg1: Texture_Argument, arg2: Texture_Argument) #foreign KINC;

kinc_g4_set_int :: (location: Constant_Location, value: s32) #foreign KINC;
kinc_g4_set_int2 :: (location: Constant_Location, value1: s32, value2: s32) #foreign KINC;
kinc_g4_set_int3 :: (location: Constant_Location, value1: s32, value2: s32, value3: s32) #foreign KINC;
kinc_g4_set_int4 :: (location: Constant_Location, value1: s32, value2: s32, value3: s32, value4: s32) #foreign KINC;
kinc_g4_set_ints :: (location: Constant_Location, values: *float32, count: s32) #foreign KINC;

kinc_g4_set_float :: (location: Constant_Location, value: float32) #foreign KINC;
kinc_g4_set_float2 :: (location: Constant_Location, value1: float32, value2: float32) #foreign KINC;
kinc_g4_set_float3 :: (location: Constant_Location, value1: float32, value2: float32, value3: float32) #foreign KINC;
kinc_g4_set_float4 :: (location: Constant_Location, value1: float32, value2: float32, value3: float32, value4: float32) #foreign KINC;
kinc_g4_set_floats :: (location: Constant_Location, values: *float32, count: s32) #foreign KINC;

kinc_g4_set_bool :: (location: Constant_Location, value: bool) #foreign KINC;

kinc_g4_set_matrix3 :: (location: Constant_Location, value: *Matrix3x3) #foreign KINC;
kinc_g4_set_matrix4 :: (location: Constant_Location, value: *Matrix4x4) #foreign KINC;

kinc_g4_set_texture_magnification_filter :: (unit: Texture_Unit, filter: Texture_Filter) #foreign KINC;
kinc_g4_set_texture3d_magnification_filter :: (unit: Texture_Unit, filter: Texture_Filter) #foreign KINC;

kinc_g4_set_texture_minification_filter :: (unit: Texture_Unit, filter: Texture_Filter) #foreign KINC;
kinc_g4_set_texture3d_minification_filter :: (unit: Texture_Unit, filter: Texture_Filter) #foreign KINC;

kinc_g4_set_texture_mipmap_filter :: (unit: Texture_Unit, filter: Mipmap_Filter) #foreign KINC;
kinc_g4_set_texture3d_mipmap_filter :: (unit: Texture_Unit, filter: Mipmap_Filter) #foreign KINC;

kinc_g4_set_texture_compare_mode :: (unit: Texture_Unit, enabled: bool) #foreign KINC;
kinc_g4_set_cubemap_compare_mode :: (unit: Texture_Unit, enabled: bool) #foreign KINC;

kinc_g4_max_bound_textures :: () -> s32 #foreign KINC;
kinc_g4_render_targets_inverted_y :: () -> bool #foreign KINC;
kinc_g4_non_pow2_textures_supported :: () -> bool #foreign KINC;

kinc_g4_restore_render_target :: () #foreign KINC;
kinc_g4_set_render_targets :: (targets: *Render_Target, count: s32) #foreign KINC;
kinc_g4_set_render_target_face :: (texture: *Render_Target, face: s32) #foreign KINC;

kinc_g4_set_texture :: (unit: Texture_Unit, texture: *Texture) #foreign KINC;
kinc_g4_set_image_texture :: (unit: Texture_Unit, texture: *Texture) #foreign KINC;

kinc_g4_init_occlusion_query :: (occlusion_query: *u32) -> bool #foreign KINC;
kinc_g4_delete_occlusion_query :: (occlusion_query: *u32) #foreign KINC;
kinc_g4_start_occlusion_query :: (occlusion_query: *u32) #foreign KINC;
kinc_g4_end_occlusion_query :: (occlusion_query: *u32) #foreign KINC;

kinc_g4_are_query_results_available :: (occlusion_query: *u32) -> bool #foreign KINC;
kinc_g4_get_query_results :: (occlusion_query: *u32, pixel_count: *u32) -> bool #foreign KINC;
kinc_g4_set_texture_array :: (unit: Texture_Unit, array: *Texture_Array) #foreign KINC;
kinc_g4_antialiasing_samples :: () -> s32 #foreign KINC;
kinc_g4_set_antialiasing_samples :: (samples: s32) #foreign KINC;
// -----------------------------------------------------------------------------
//
// indexbuffer.h
//
// -----------------------------------------------------------------------------
kinc_g4_index_buffer_init :: (buffer: *Index_Buffer, count: s32, format: Index_Buffer_Format) #foreign KINC;
kinc_g4_index_buffer_destroy :: (buffer: *Index_Buffer) #foreign KINC;
kinc_g4_index_buffer_lock :: (buffer: *Index_Buffer) -> *s32 #foreign KINC;
kinc_g4_index_buffer_unlock :: (buffer: *Index_Buffer) #foreign KINC;
kinc_g4_index_buffer_count :: (buffer: *Index_Buffer) -> *s32 #foreign KINC;

kinc_g4_set_index_buffer :: (buffer: *Index_Buffer) #foreign KINC;
// -----------------------------------------------------------------------------
//
// vertexbuffer.h
//
// -----------------------------------------------------------------------------
kinc_g4_vertex_buffer_init :: (buffer: *Vertex_Buffer, count: s32, structure: *Vertex_Structure, usage: Usage, instance_data_step_rate: s32) #foreign KINC;
kinc_g4_vertex_buffer_destroy :: (buffer: *Vertex_Buffer) #foreign KINC;
kinc_g4_vertex_buffer_lock_all :: (buffer: *Vertex_Buffer) -> *float32 #foreign KINC;
kinc_g4_vertex_buffer_lock :: (buffer: *Vertex_Buffer, start: s32, count: s32) -> *float32 #foreign KINC;
kinc_g4_vertex_buffer_unlock_all :: (buffer: *Vertex_Buffer) #foreign KINC;
kinc_g4_vertex_buffer_unlock :: (buffer: *Vertex_Buffer, count: s32) #foreign KINC;
kinc_g4_vertex_buffer_count :: (buffer: *Vertex_Buffer) -> s32 #foreign KINC;
kinc_g4_vertex_buffer_stride :: (buffer: *Vertex_Buffer) -> s32 #foreign KINC;

kinc_internal_g4_vertex_buffer_set :: (buffer: *Vertex_Buffer, offset: s32) -> s32 #foreign KINC;

kinc_g4_set_vertex_buffers :: (buffer: *Vertex_Buffer, count: s32) #foreign KINC;
kinc_g4_set_vertex_buffer :: (buffer: *Vertex_Buffer) #foreign KINC;
// -----------------------------------------------------------------------------
//
// vertexstructure.h
//
// -----------------------------------------------------------------------------
kinc_g4_vertex_element_init :: (element: *Vertex_Element, name: *u8, data: Vertex_Data) #foreign KINC;
kinc_g4_vertex_structure_init :: (structure: *Vertex_Structure) #foreign KINC;
kinc_g4_vertex_structure_add :: (structure: *Vertex_Structure, name: *u8, data: Vertex_Data) #foreign KINC;
// -----------------------------------------------------------------------------
//
// pipeline.h
//
// -----------------------------------------------------------------------------
kinc_g4_pipeline_init :: (state: *Pipeline) #foreign KINC;
kinc_g4_pipeline_destroy :: (state: *Pipeline) #foreign KINC;
kinc_g4_pipeline_compile :: (state: *Pipeline) #foreign KINC;
kinc_g4_pipeline_get_constant_location :: (state: *Pipeline, name: *u8) -> Constant_Location #foreign KINC;
kinc_g4_pipeline_get_texture_unit :: (state: *Pipeline, name:*u8) -> Texture_Unit #foreign KINC;
// -----------------------------------------------------------------------------
//
// texture.h
//
// -----------------------------------------------------------------------------
kinc_g4_texture_init :: (texture: *Texture, width: s32, height: s32, format: Image_Format) #foreign KINC;
kinc_g4_texture_init3d :: (texture: *Texture, width: s32, height: s32, depth: s32, format: Image_Format) #foreign KINC;
kinc_g4_texture_init_from_image :: (texture: *Texture, image: *Image) #foreign KINC;
kinc_g4_texture_init_from_image3d :: (texture: *Texture, image: *Image) #foreign KINC;
kinc_g4_texture_destroy :: (texture: *Texture) #foreign KINC;
//ANDROID >>> g4_texture_init_from_id
kinc_g4_texture_lock :: (texture: *Texture) -> u8 #foreign KINC;
kinc_g4_texture_clear :: (texture: *Texture, x: s32, y: s32, z: s32, width: s32, height: s32, depth: s32, color: u32) #foreign KINC;
//IOS||MACOS >>>> texture_upload
kinc_g4_texture_generate_mipmaps :: (texture: *Texture, levels: s32) #foreign KINC;
kinc_g4_texture_set_mipmap :: (texture: *Texture, mipmap: *Image, level: s32) #foreign KINC;
kinc_g4_texture_stride :: (texture: *Texture) -> s32 #foreign KINC;
// -----------------------------------------------------------------------------
//
// shader.h
//
// -----------------------------------------------------------------------------
kinc_g4_shader_init :: (shader: *Shader, data: *void, length: s64, type: Shader_Type) #foreign KINC;
kinc_g4_shader_init_from_source :: (shader: *Shader, source: *u8, type: Shader_Type) #foreign KINC;
kinc_g4_shader_destroy :: (shader: *Shader) #foreign KINC;
// -----------------------------------------------------------------------------
//
// rendertarget.h
//
// -----------------------------------------------------------------------------
kinc_g4_render_target_init :: (render_target: *Render_Target, width: s32, height: s32, depth_buffer_bits: s32, antialiasing: bool, format: Render_Target_Format, stencill_buffer_bits: s32, context_id: s32) #foreign KINC;
kinc_g4_render_target_init_cube :: (render_target: *Render_Target, cube_map_size: s32, depth_buffer_bits: s32, antialiasing: bool, format: Render_Target_Format, stencill_buffer_bits: s32, context_id: s32) #foreign KINC;
kinc_g4_render_target_destroy :: (render_target: *Render_Target) #foreign KINC;
kinc_g4_render_target_use_color_as_texture :: (render_target: *Render_Target, unit: Texture_Unit) #foreign KINC;
kinc_g4_render_target_use_depth_as_texture :: (render_target: *Render_Target, unit: Texture_Unit) #foreign KINC;
kinc_g4_render_target_set_depth_stencil_from :: (render_target: *Render_Target, source: *Render_Target) #foreign KINC;
kinc_g4_render_target_get_pixels :: (render_target: *Render_Target, data: *u8) #foreign KINC;
kinc_g4_render_target_generate_mipmaps :: (render_target: *Render_Target, levels: s32) #foreign KINC;
// -----------------------------------------------------------------------------
//
// texturearray.h
//
// -----------------------------------------------------------------------------
kinc_g4_texture_array_init :: (array: *Texture_Array, textures: *Image, count: s32) #foreign KINC;
kinc_g4_texture_array_destroy :: (array: *Texture_Array) #foreign KINC;

// -----------------------------------------------------------------------------
//
// sound.h
//
// -----------------------------------------------------------------------------
kinc_a1_sound_create :: (filename: *u8) -> *Audio1_Sound #foreign KINC;
kinc_a1_sound_destroy :: (sound: *Audio1_Sound) #foreign KINC;
kinc_a1_sound_volume :: (sound: *Audio1_Sound) -> float32 #foreign KINC;
kinc_a1_sound_set_volume :: (sound: *Audio1_Sound, value: float32) #foreign KINC;
// -----------------------------------------------------------------------------
//
// audio1/audio.h
//
// -----------------------------------------------------------------------------
kinc_a1_init :: () #foreign KINC;
kinc_a1_play_sound :: (sound: *Audio1_Sound, loop: bool, pitch: float32, unique: bool) -> Audio1_Channel #foreign KINC;

kinc_a1_stop_sound :: (sound: *Audio1_Sound) #foreign KINC;
kinc_a1_play_sound_stream :: (stream: *Audio1_Sound_Stream) #foreign KINC;
kinc_a1_stop_sound_stream :: (stream: *Audio1_Sound_Stream) #foreign KINC;
/* audio1_play_video_sound_stream :: (stream: *Audio1_Video_Sound_Stream) #foreign KINC; */
/* audio1_stop_video_sound_stream :: (stream: *Audio1_Video_Sound_Stream) #foreign KINC; */
// -----------------------------------------------------------------------------
//
// soundstream.h
//
// -----------------------------------------------------------------------------
kinc_a1_sound_stream_create :: (filename: *u8, looping: bool) -> *Audio1_Sound_Stream #foreign KINC;
kinc_a1_sound_stream_next_sample :: (stream: *Audio1_Sound_Stream) -> float32 #foreign KINC;
kinc_a1_sound_stream_channels :: (stream: *Audio1_Sound_Stream) -> float32 #foreign KINC;
kinc_a1_sound_stream_sample_rate :: (stream: *Audio1_Sound_Stream) -> float32 #foreign KINC;
kinc_a1_sound_stream_looping :: (stream: *Audio1_Sound_Stream) -> bool #foreign KINC;
kinc_a1_sound_stream_set_looping :: (stream: *Audio1_Sound_Stream, loop: bool) #foreign KINC;
kinc_a1_sound_stream_ended :: (stream: *Audio1_Sound_Stream) -> bool #foreign KINC;
kinc_a1_sound_stream_length :: (stream: *Audio1_Sound_Stream) -> float32 #foreign KINC;
kinc_a1_sound_stream_position :: (stream: *Audio1_Sound_Stream) -> float32 #foreign KINC;
kinc_a1_sound_stream_reset :: (stream: *Audio1_Sound_Stream) #foreign KINC;
kinc_a1_sound_stream_volume :: (stream: *Audio1_Sound_Stream) -> float32 #foreign KINC;
kinc_a1_sound_stream_set_volume :: (stream: *Audio1_Sound_Stream, value: float32) #foreign KINC;
