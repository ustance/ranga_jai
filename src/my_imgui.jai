ImGui :: #import "jai-imgui"(LINK_STATIC=true);


imgui_alloc_context: Context;

maxBufferSize :s32= 10000;
vtx: *Vertex_Buffer;
idx: *Index_Buffer;
imgui_structure: *Vertex_Structure;

imgui_font_image: *Image;

imgui_ctx: *ImGui.Context;
c_alloc :: (sz: u64, userdata: *void) -> *void #c_call {
    push_context << cast(*Context)userdata {return alloc(cast(s64)sz);}
}
c_free :: (ptr: *void, userdata: *void) #c_call {
    push_context << cast(*Context)userdata { free(ptr); }
}

init_imgui :: () {
    
    imgui_alloc_context = context;
    ImGui.SetAllocatorFunctions(c_alloc, c_free, *imgui_alloc_context);
    
    imgui_ctx = ImGui.CreateContext();
    
    io := ImGui.GetIO();
    w, h: s32;
    pixels: *u8;
    io.Fonts.GetTexDataAsRGBA32(io.Fonts, *pixels, *w, *h);
    
    
    io.KeyMap[ImGui.Key.Tab] = KEY_TAB;                     // Keyboard mapping. ImGui will use those indices to peek into the io.KeyDown[] array.
    io.KeyMap[ImGui.Key.LeftArrow] = KEY_LEFT;
    io.KeyMap[ImGui.Key.RightArrow] = KEY_RIGHT;
    io.KeyMap[ImGui.Key.UpArrow] = KEY_UP;
    io.KeyMap[ImGui.Key.DownArrow] = KEY_DOWN;
    io.KeyMap[ImGui.Key.PageUp] = KEY_PAGE_UP;
    io.KeyMap[ImGui.Key.PageDown] = KEY_PAGE_DOWN;
    io.KeyMap[ImGui.Key.Home] = KEY_HOME;
    io.KeyMap[ImGui.Key.End] = KEY_END;
    io.KeyMap[ImGui.Key.Delete] = KEY_DELETE;
    io.KeyMap[ImGui.Key.Backspace] = KEY_BACKSPACE;
    io.KeyMap[ImGui.Key.Enter] = KEY_RETURN;
    io.KeyMap[ImGui.Key.Escape] = KEY_ESCAPE;
    io.KeyMap[ImGui.Key.A] = KEY_A;
    io.KeyMap[ImGui.Key.C] = KEY_C;
    io.KeyMap[ImGui.Key.V] = KEY_V;
    io.KeyMap[ImGui.Key.X] = KEY_X;
    io.KeyMap[ImGui.Key.Y] = KEY_Y;
    io.KeyMap[ImGui.Key.Z] = KEY_Z;
    
    //io.RenderDrawListsFn = ImGui_ImplSdl_RenderDrawLists;   // Alternatively you can set this to NULL and call ImGui::GetDrawData() after ImGui::Render() to get the same ImDrawData pointer.
    //io.SetClipboardTextFn = ImGui_ImplSdl_SetClipboardText;
    //io.GetClipboardTextFn = ImGui_ImplSdl_GetClipboardText;
    io.ClipboardUserData = null;
    
    imgui_structure = New(Vertex_Structure);
    kinc_g4_vertex_structure_init(imgui_structure);
    kinc_g4_vertex_structure_add(imgui_structure, "pos",   .FLOAT3);
    kinc_g4_vertex_structure_add(imgui_structure, "uv",    .FLOAT2);
    kinc_g4_vertex_structure_add(imgui_structure, "color", .FLOAT4);
    
    
    vtx = New(Vertex_Buffer);
    kinc_g4_vertex_buffer_init(vtx, maxBufferSize, imgui_structure, .STATIC, 0);
    idx = New(Index_Buffer);
    kinc_g4_index_buffer_init(idx, maxBufferSize, .FORMAT_32BIT);
    
    imgui_create_fonts_texture();
    
    //cursor_arrow = SDL_CreateSystemCursor(.ARROW);
    //cursor_text_input = SDL_CreateSystemCursor(.IBEAM);
    //cursor_move = SDL_CreateSystemCursor(.HAND);
    //cursor_resize_ns = SDL_CreateSystemCursor(.SIZENS);
    //cursor_resize_ew = SDL_CreateSystemCursor(.SIZEWE);
    //cursor_resize_nesw = SDL_CreateSystemCursor(.SIZENESW);
    //cursor_resize_nwse = SDL_CreateSystemCursor(.SIZENWSE);
}

imgui_create_fonts_texture :: () {
    io := ImGui.GetIO();
    
    if io.Fonts.TexID != null
        return;
    
    pixels: *u8;
    width, height: s32;
    io.Fonts.GetTexDataAsRGBA32(io.Fonts, *pixels, *width, *height);
    
    imgui_font_image = New(Image);
    kinc_image_init_from_bytes(imgui_font_image, pixels, width, height, .RGBA32);
    texture := New(Texture);
    kinc_g4_texture_init_from_image(texture, imgui_font_image);
    
    io.Fonts.TexID = xx texture;
    
}

imgui_vec2 :: (x: float, y: float) -> ImGui.ImVec2 {
    vec: ImGui.ImVec2;
    vec.x = xx x;
    vec.y = xx y;
    return vec;
}

imgui_new_frame :: () {
    ImGui.NewFrame();
}

imgui_want_capture_mouse: bool;
imgui_want_capture_keyboard: bool;
imgui_process_events :: () {
    io := ImGui.GetIO();
    
    w, h: s32;
    
    w = kinc_window_width(0);
    h = kinc_window_height(0);
    
    io.DisplaySize = imgui_vec2(xx w, xx h);
    io.DeltaTime = 1.0/60.0;
    
    io.MousePos = imgui_vec2(xx mouse_x, xx mouse_y);
    
    input := *game_context.input_manager;
    
    io.MouseDown[0] = hold_lmb;
    io.MouseDown[1] = hold_rmb;
    io.MouseWheel -= input.mouse_scroll;
    
    io.KeyCtrl = check_key(input, KEY_CONTROL);
    io.KeyShift = check_key(input, KEY_SHIFT);
    io.KeyAlt = check_key(input, KEY_ALT);
    io.KeySuper = check_key(input, KEY_WIN);
    
    input.blocking_keyboard = io.WantCaptureKeyboard;
    input.blocking_mouse = io.WantCaptureMouse;
    
    imgui_key :: (key: s32) {
        io := ImGui.GetIO();
        input := *game_context.input_manager;
        val, ok := table_find(input.keys_pressed_frame, key);
        if ok
            io.KeysDown[key] = val;
    } 
    
    imgui_key(KEY_TAB);
    imgui_key(KEY_LEFT);
    imgui_key(KEY_RIGHT);
    imgui_key(KEY_UP);
    imgui_key(KEY_DOWN);
    imgui_key(KEY_PAGE_UP);
    imgui_key(KEY_PAGE_DOWN);
    imgui_key(KEY_HOME);
    imgui_key(KEY_END);
    imgui_key(KEY_RETURN);
    imgui_key(KEY_BACKSPACE);
    imgui_key(KEY_ESCAPE);
    imgui_key(KEY_DELETE);
    imgui_key(KEY_A);
    imgui_key(KEY_C);
    imgui_key(KEY_V);
    imgui_key(KEY_X);
    imgui_key(KEY_Y);
    imgui_key(KEY_Z);
}

imgui_shutdown :: () {
    //ImGui.Shutdown();
}

imgui_render_kinc :: () {
    
    draw_data := ImGui.GetDrawData();
    
    for i: 0..draw_data.CmdListsCount-1 {
        idx_offset := 0;
        cmd_list := draw_data.CmdLists[i];
        cmd_buffer := cmd_list.CmdBuffer;
        vtx_buffer := cmd_list.VtxBuffer;
        idx_buffer := cmd_list.IdxBuffer;
        
        for j: 0..cmd_list.CmdBuffer.Size-1 {
            cmd := cmd_buffer.Data[j];
            _it := cmd.ElemCount / 3;
            if cmd.ElemCount > xx maxBufferSize {
                kinc_g4_vertex_buffer_destroy(vtx);
                kinc_g4_index_buffer_destroy(idx);
                //vtx = New(Vertex_Buffer);
                //idx = New(Index_Buffer);
                kinc_g4_vertex_buffer_init(vtx, xx cmd.ElemCount,imgui_structure, .STATIC, 0);
                kinc_g4_index_buffer_init(idx, xx cmd.ElemCount, .FORMAT_32BIT);
                maxBufferSize = xx cmd.ElemCount;
            }
            
            v := kinc_g4_vertex_buffer_lock_all(vtx);
            ii := kinc_g4_index_buffer_lock(idx);
            
            for tri: 0.._it-1 {
                base_idx := idx_offset + (tri * 3);
                idx1 := idx_buffer.Data[base_idx + 0];
                idx2 := idx_buffer.Data[base_idx + 1];
                idx3 := idx_buffer.Data[base_idx + 2];
                vtx1 := vtx_buffer.Data[idx1];
                vtx2 := vtx_buffer.Data[idx2];
                vtx3 := vtx_buffer.Data[idx3];
                tmul := tri * 27;
                
                v[tmul+0] = vtx1.pos.x; v[tmul+1] = vtx1.pos.y; v[tmul+2] = -5;
                v[tmul+3] = vtx1.uv.x; v[tmul+4] = vtx1.uv.y;
                
                v[tmul+7] = ((vtx1.col >> 0) & 0xFF) / 255.0; //r
                v[tmul+6] = ((vtx1.col >> 8) & 0xFF) / 255.0; //g
                v[tmul+5] = ((vtx1.col >> 16) & 0xFF) / 255.0; // b
                
                
                v[tmul+8] = ((vtx1.col >> 24) & 0xFF) / 255.0;// a
                
                
                v[tmul+9] = vtx2.pos.x; v[tmul+10] = vtx2.pos.y; v[tmul+11] = -5;
                v[tmul+12] = vtx2.uv.x; v[tmul+13] = vtx2.uv.y;
                v[tmul+16] = ((vtx2.col >> 0) & 0xFF) / 255.0;
                v[tmul+15] = ((vtx2.col >> 8) & 0xFF) / 255.0;
                v[tmul+14] = ((vtx2.col >> 16) & 0xFF) / 255.0;
                v[tmul+17] = ((vtx2.col >> 24) & 0xFF) / 255.0;
                
                
                
                v[tmul+18] = vtx3.pos.x; v[tmul+19] = vtx3.pos.y; v[tmul+20] = -5;
                v[tmul+21] = vtx3.uv.x; v[tmul+22] = vtx3.uv.y;
                
                v[tmul+25] = ((vtx3.col >> 0) & 0xFF) / 255.0;
                v[tmul+24] = ((vtx3.col >> 8) & 0xFF) / 255.0;
                v[tmul+23] = ((vtx3.col >> 16) & 0xFF) / 255.0;
                v[tmul+26] = ((vtx3.col >> 24) & 0xFF) / 255.0;
                
                
                ii[xx tri*3 + 0] = xx (tri*3 + 0);
                ii[xx tri*3 + 1] = xx (tri*3 + 1);
                ii[xx tri*3 + 2] = xx (tri*3 + 2);
            }
            
            kinc_g4_vertex_buffer_unlock_all(vtx);
            kinc_g4_index_buffer_unlock(idx);
            
            tex := cast(*Texture )cmd.TextureId;
            
            simple_shader := get_shader(*game_context.render_context.shader_list, "imgui_shader");
            kinc_g4_set_pipeline(*simple_shader.pipeline);
            tu, ok := table_find(simple_shader.texture_units, "tex");
            assert(ok);;
            
            shader_set_matrix(simple_shader, "camera", *screen_camera.matrix);
            
            kinc_g4_set_texture(tu, tex);
            kinc_g4_set_texture_magnification_filter(tu, .POINT);
            kinc_g4_set_texture_minification_filter(tu, .POINT);
            
            kinc_g4_set_vertex_buffer(vtx);
            kinc_g4_set_index_buffer(idx);
            kinc_g4_scissor(xx cmd.ClipRect.x, xx cmd.ClipRect.y, xx (cmd.ClipRect.z - cmd.ClipRect.x), xx (cmd.ClipRect.w - cmd.ClipRect.y));
            kinc_g4_draw_indexed_vertices_from_to(0, xx cmd.ElemCount);
            idx_offset += cmd.ElemCount;
            
        }
        kinc_g4_disable_scissor();
    }
    
}