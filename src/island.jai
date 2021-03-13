#import "Basic";


Island :: struct {
	x: float;
	y: float;
	width: int;
	height: int;
    
    tiles: [32][32]Tile_Data;
}

TILE_SIZE :: 256;

create_island :: (using game_context: *Game_Context, x: float, y: float, width: int, height: int) {
	island: Island;
    
	island.x = x;
	island.y = y;
	island.width = width;
	island.height = height;
    
    for tx: 0..width-1 {
        for ty: 0..height-1 {
            tile := *island.tiles[tx][ty];
            tile.x = tx;
            tile.y = ty;
            tile.tile_type = 0;
            tile.tile_direction = .CENTER;
        }
    }
    
    autotile(*island);
    array_add(*islands, island);
    
    
    generate_minables(*game_context.entity_manager, island);
}


generate_minables :: (entity_manager: *Entity_Manager, island: Island) {
    count := kinc_random_get_in(2, 5);
    
    for i: 0..count-1 {
        minable_x := island.x + cast(float)(kinc_random_get_in(0, cast(s32)island.width-1))*TILE_SIZE + TILE_SIZE/2;
        minable_y := island.y + cast(float)(kinc_random_get_in(0, cast(s32)island.height-1))*TILE_SIZE + TILE_SIZE /2;
        
        create_minable(entity_manager, minable_x, minable_y);
    }
    
}

is_island_on_position :: (using game_context: *Game_Context, position: Vector2) -> bool {
    for islands {
        if position.x >= it.x && position.y >= it.y && position.x <= it.x + it.width * TILE_SIZE && position.y <= it.y + it.height * TILE_SIZE {
            return true;
        }
    }
    return false;
}

is_island_on_position :: (using game_context: *Game_Context, x: float, y: float) -> bool {
    for islands {
        if x >= it.x && y >= it.y && x <= it.x + it.width * TILE_SIZE && y <= it.y + it.height * TILE_SIZE {
            return true;
        }
    }
    return false;
    
    
}


update_islands :: (using game_context: *Game_Context) {
    camera := *render_context.camera;
    mx, my := get_mouse_position_from_camera(camera, mouse_x, mouse_y);
    for * islands {
        island := it;
        
        if check_key_pressed(*input_manager, KEY_SPACE) {
            tx := cast(int)((mx - island.x)/256.0);
            ty := cast(int)((my - island.y)/256.0);
            island.tiles[tx][ty].tile_type = 1;
            autotile(island);
        }
    }
}


draw_islands :: (using game_context: *Game_Context) {
    set_default_shader(*render_context);
    
	for islands {
		for ix: 0..it.width-1 {
			for iy: 0..it.height-1 {
                tile := it.tiles[ix][iy];
                
                if tile.tile_type == {
                    case 1; // sand
                    draw_tile(*game_context.render_context, "sand", it.x + cast(float) ix*256, it.y + cast(float) iy*256, tile.tile_direction);
                    case 2;
                    draw_tile(*game_context.render_context, "grass", it.x + cast(float) ix*256, it.y + cast(float) iy*256, tile.tile_direction);
                }
                
			}
		}
	}
    
    flush(*render_context);
}

get_tile_not_empty :: (island: *Island, x: int, y: int) -> bool {
    return island.tiles[x][y].tile_type != 0;
}

Tile_Data :: struct {
    x: int;
    y: int;
    tile_type: int; // 0 none 1 sand 2 grass 3 dk_grass
    tile_direction: Tile_Direction = .CENTER;
}

autotile :: (island: *Island) {
    for tx: 0..island.width-1 {
        for ty: 0..island.height-1 {
            tile := *island.tiles[tx][ty];
            
            if tile.tile_type == {
                
                case 2;
#through;
                case 3;//grass
                right:= get_tile_not_empty(island, tx+1, ty);
                left := get_tile_not_empty(island, tx-1, ty);
                up   := get_tile_not_empty(island, tx, ty-1);
                down := get_tile_not_empty(island, tx, ty+1);
                
                tr := get_tile_not_empty(island, tx+1, ty-1);
                tl := get_tile_not_empty(island, tx-1, ty-1);
                br := get_tile_not_empty(island, tx+1, ty+1);
                bl := get_tile_not_empty(island, tx-1, ty+1);
                
                if left == false && right == false && up == false && down == false {
                    tile.tile_direction = .ALONE;
                }else if left != false && right != false && up != false && down != false {
                    tile.tile_direction = .CENTER;
                }else if left == false && right != false && up != false && down != false {
                    tile.tile_direction = .SIDE_LEFT;
                }else if left != false && right == false && up != false && down != false {
                    tile.tile_direction = .SIDE_RIGHT;
                }else if left == false && up == false && right != false && down != false {
                    tile.tile_direction = .UPSIDE_LEFT;
                }else if left != false && up == false && right == false && down != false {
                    tile.tile_direction = .UPSIDE_RIGHT;
                }else if left == false && down == false && right != false && up != false {
                    tile.tile_direction = .DOWNSIDE_LEFT;
                }else if left != false && down == false && right == false && up != false {
                    tile.tile_direction = .DOWNSIDE_RIGHT;
                }else if left != false && right != false && up != false && down == false {
                    tile.tile_direction = .DOWN;
                }else if left != false && right != false && up == false && down != false {
                    tile.tile_direction = .UP;
                }else if left == false && right == false && up != false && down != false {
                    tile.tile_direction = .SINGLE_VERT;
                }else if left != false && right != false && up == false && down == false {
                    tile.tile_direction = .SINGLE_HORIZ;
                }else if left == false && right == false && up == false && down != false {
                    tile.tile_direction = .SINGLE_VERT_END_UP;
                }else if left != false && right == false && up == false && down == false {
                    tile.tile_direction = .SINGLE_HORIZ_END_RIGHT;
                }else if left == false && right == false && up != false && down == false {
                    tile.tile_direction = .SINGLE_VERT_END_DOWN;
                }else if left == false && right != false && up == false && down == false {
                    tile.tile_direction = .SINGLE_HORIZ_END_LEFT;
                }
                
                case 1;// SAND
                right:= get_tile_not_empty(island, tx+1, ty);
                left := get_tile_not_empty(island, tx-1, ty);
                up   := get_tile_not_empty(island, tx, ty-1);
                down := get_tile_not_empty(island, tx, ty+1);
                
                tr := get_tile_not_empty(island, tx+1,ty-1);
                tl := get_tile_not_empty(island, tx-1,ty-1);
                br := get_tile_not_empty(island, tx+1,ty+1);
                bl := get_tile_not_empty(island, tx-1,ty+1);
                
                if(left != false && right != false && up != false && down != false) {
                    tile.tile_direction = .CENTER;
                }else if(left == false && right != false && up != false && down != false) {
                    tile.tile_direction = .SIDE_LEFT;
                }else if(left != false && right == false && up != false && down != false) {
                    tile.tile_direction = .SIDE_RIGHT;
                }else if(left == false && up == false && right != false && down != false) {
                    tile.tile_direction = .UPSIDE_LEFT;
                }else if(left != false && up == false && right == false && down != false) {
                    tile.tile_direction = .UPSIDE_RIGHT;
                }else if(left == false && down == false && right != false && up != false) {
                    tile.tile_direction = .DOWNSIDE_LEFT;
                }else if(left != false && down == false && right == false && up != false) {
                    tile.tile_direction = .DOWNSIDE_RIGHT;
                }else if(left != false && right != false && up != false && down == false) {
                    tile.tile_direction = .DOWN;
                }else if(left != false && right != false && up == false && down != false) {
                    tile.tile_direction = .UP;
                }else if(left == false && right == false && up != false && down != false) {
                    tile.tile_direction = .SINGLE_VERT;
                }else if(left != false && right != false && up == false && down == false) {
                    tile.tile_direction = .SINGLE_HORIZ;
                }else if(left == false && right == false && up == false && down != false) {
                    tile.tile_direction = .SINGLE_VERT_END_UP;
                }else if(left != false && right == false && up == false && down == false) {
                    tile.tile_direction = .SINGLE_HORIZ_END_RIGHT;
                }else if(left == false && right == false && up != false && down == false) {
                    tile.tile_direction = .SINGLE_VERT_END_DOWN;
                }else if(left == false && right != false && up == false && down == false) {
                    tile.tile_direction = .SINGLE_HORIZ_END_LEFT;
                }
                
                if(tile.tile_direction == .UPSIDE_RIGHT) {
                    if(bl == false) {
                        tile.tile_direction = .UPSIDE_RIGHT_CORNER;
                    }
                }
                if(tile.tile_direction == .UPSIDE_LEFT) {
                    if(br == false) {
                        tile.tile_direction = .UPSIDE_LEFT_CORNER;
                    }
                }
                
                if(tile.tile_direction == .DOWNSIDE_LEFT) {
                    if(tr == false) {
                        tile.tile_direction = .DOWNSIDE_LEFT_CORNER;
                    }
                }
                if(tile.tile_direction == .DOWNSIDE_RIGHT) {
                    if(tl == false) {
                        tile.tile_direction = .DOWNSIDE_RIGHT_CORNER;
                    }
                }
                
                if(tile.tile_direction == .SIDE_LEFT) {
                    if(tr == false && br != false) {
                        tile.tile_direction = .SIDE_LEFT_CORNER_UP;
                    }else
                        if(tr != false && br == false) {
                        tile.tile_direction = .SIDE_LEFT_CORNER_DOWN;
                    }else
                        if(tr == false && br == false) {
                        tile.tile_direction = .SIDE_LEFT_CORNER_ALL;
                    }
                }
                
                if(tile.tile_direction == .SIDE_RIGHT) {
                    if(tl == false && bl != false) {
                        tile.tile_direction = .SIDE_RIGHT_CORNER_UP;
                    }else
                        if(tl != false && bl == false) {
                        tile.tile_direction = .SIDE_RIGHT_CORNER_DOWN;
                    }else
                        if(tl == false && bl == false) {
                        tile.tile_direction = .SIDE_RIGHT_CORNER_ALL;
                    }
                }
                if(tile.tile_direction == .UP) {
                    if(bl == false && br == false) {
                        tile.tile_direction = .UP_CORNER_ALL;
                    }else
                        if(bl != false && br == false) {
                        tile.tile_direction = .UP_CORNER_RIGHT;
                    }else
                        if(bl == false && br != false) {
                        tile.tile_direction = .UP_CORNER_LEFT;
                    }
                }
                
                if(tile.tile_direction == .DOWN) {
                    if(tl == false && tr == false) {
                        tile.tile_direction = .DOWN_CORNER_ALL;
                    }else
                        if(tl != false && tr == false) {
                        tile.tile_direction = .DOWN_CORNER_RIGHT;
                    }else
                        if(tl == false && tr != false) {
                        tile.tile_direction = .DOWN_CORNER_LEFT;
                    }
                }
                
                if(tile.tile_direction == .CENTER) { //already l r t b are not empty
                    if(tl == false && tr == false && br == false && bl == false) {
                        tile.tile_direction = .INSIDE_ALL;
                    }else if(tl == false && tr == false && br != false && bl != false) {
                        tile.tile_direction = .INSIDE_UP;
                    }else if(tl != false && tr != false && br == false && bl == false) {
                        tile.tile_direction = .INSIDE_DOWN;
                    }else if(tl != false && tr == false && br == false && bl != false) {
                        tile.tile_direction = .INSIDE_SIDE_RIGHT;
                    }else if(tl == false && tr != false && br != false && bl == false) {
                        tile.tile_direction = .INSIDE_SIDE_LEFT;
                    }else if(tl != false && tr != false && br != false && bl == false) {
                        tile.tile_direction = .INSIDE_DOWN_SIDE_LEFT;
                    }else if(tl != false && tr != false && br == false && bl != false) {
                        tile.tile_direction = .INSIDE_DOWN_SIDE_RIGHT;
                    }else if(tl == false && tr != false && br != false && bl != false) {
                        tile.tile_direction = .INSIDE_UP_SIDE_LEFT;
                    }else if(tl != false && tr == false && br != false && bl != false) {
                        tile.tile_direction = .INSIDE_UP_SIDE_RIGHT;
                    }else if(tl != false && br != false && tr == false && bl == false) {
                        tile.tile_direction = .INSIDE_TOP_LEFT_BOTTOM_RIGHT;
                    }else if(tl == false && br == false && tr != false && bl != false) {
                        tile.tile_direction = .INSIDE_TOP_RIGHT_BOTTOM_LEFT;
                    }else if(tl != false && br == false && tr == false && bl == false) {
                        tile.tile_direction = .INSIDE_EXCEPT_TOP_LEFT;
                    }else if(tl == false && br == false && tr != false && bl == false) {
                        tile.tile_direction = .INSIDE_EXCEPT_TOP_RIGHT;
                    }else if(tl == false && br != false && tr == false && bl == false) {
                        tile.tile_direction = .INSIDE_EXCEPT_BOTTOM_RIGHT;
                    }else if(tl == false && br == false && tr == false && bl != false) {
                        tile.tile_direction = .INSIDE_EXCEPT_BOTTOM_LEFT;
                    }
                }
            }
        }
    }
}


Tile_Direction :: enum {
    ALONE;
	CENTER;
	SIDE_LEFT;
	SIDE_RIGHT;
	UPSIDE_LEFT; 
	UPSIDE_RIGHT; 
	DOWNSIDE_LEFT; 
	DOWNSIDE_RIGHT; 
	DOWN;
	UP;
    
	UP_CORNER_LEFT;
	UP_CORNER_RIGHT;
	UP_CORNER_ALL;
    
	DOWN_CORNER_LEFT;
	DOWN_CORNER_RIGHT;
	DOWN_CORNER_ALL;
    
	SINGLE_VERT;
	SINGLE_HORIZ;
	SINGLE_VERT_END_UP;
	SINGLE_HORIZ_END_RIGHT;
	SINGLE_VERT_END_DOWN;
	SINGLE_HORIZ_END_LEFT;
    
	INSIDE_ALL;
	INSIDE_DOWN;
	INSIDE_UP;
	INSIDE_SIDE_LEFT;
	INSIDE_SIDE_RIGHT;
    
	INSIDE_DOWN_SIDE_LEFT;
	INSIDE_DOWN_SIDE_RIGHT;
	INSIDE_UP_SIDE_LEFT;
	INSIDE_UP_SIDE_RIGHT;
    
	INSIDE_TOP_LEFT_BOTTOM_RIGHT;
	INSIDE_TOP_RIGHT_BOTTOM_LEFT;
    
	INSIDE_EXCEPT_TOP_LEFT;
	INSIDE_EXCEPT_TOP_RIGHT;
	INSIDE_EXCEPT_BOTTOM_LEFT;
	INSIDE_EXCEPT_BOTTOM_RIGHT;
    
	UPSIDE_LEFT_CORNER;
	UPSIDE_RIGHT_CORNER;
	DOWNSIDE_LEFT_CORNER;
	DOWNSIDE_RIGHT_CORNER;
    
	SIDE_LEFT_CORNER_DOWN;
	SIDE_LEFT_CORNER_UP;
	SIDE_LEFT_CORNER_ALL;
    
	SIDE_RIGHT_CORNER_DOWN;
	SIDE_RIGHT_CORNER_UP;
	SIDE_RIGHT_CORNER_ALL;
}



draw_tile :: (render_context: *Render_Context, tile_name: string, x: float, y: float, td: Tile_Direction) {
    //x = tx*tileSize + x;
    //y = ty*tileSize + y;
    
    if td == {
        case .ALONE;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_single_all_end", tile_name), x, y);
        case .CENTER;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_center", tile_name), x, y);
        case .SIDE_LEFT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_side", tile_name), x, y);
        case .SIDE_RIGHT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_side", tile_name), x + TILE_SIZE, y, -1);
        case .SIDE_LEFT_CORNER_UP;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_side_up_corner", tile_name), x, y);
        case .SIDE_LEFT_CORNER_DOWN;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_side_down_corner", tile_name), x, y);
        case .SIDE_LEFT_CORNER_ALL;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_side_all_corner", tile_name), x, y);
        case .SIDE_RIGHT_CORNER_UP;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_side_up_corner", tile_name), x + TILE_SIZE, y, -1);
        case .SIDE_RIGHT_CORNER_DOWN;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_side_down_corner", tile_name), x + TILE_SIZE, y, -1);
        case .SIDE_RIGHT_CORNER_ALL;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_side_all_corner", tile_name), x + TILE_SIZE, y, -1);
        case .UPSIDE_LEFT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_upside", tile_name), x, y);
        case .UPSIDE_RIGHT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_upside", tile_name), x + TILE_SIZE, y, -1);
        case .UPSIDE_LEFT_CORNER;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_upside_corner", tile_name), x, y);
        case .UPSIDE_RIGHT_CORNER;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_upside_corner", tile_name), x + TILE_SIZE, y, -1);
        case .DOWNSIDE_LEFT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_downside", tile_name), x, y);
        case .DOWNSIDE_RIGHT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_downside", tile_name), x + TILE_SIZE, y, -1);
        case .DOWNSIDE_LEFT_CORNER;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_downside_corner", tile_name), x, y);
        case .DOWNSIDE_RIGHT_CORNER;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_downside_corner", tile_name), x + TILE_SIZE, y, -1);
        case .DOWN;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_down", tile_name), x, y);
        case .UP;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_up", tile_name), x, y);
        case .UP_CORNER_ALL;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_up_both_corner", tile_name), x, y);
        case .UP_CORNER_LEFT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_up_side_corner", tile_name), x, y);
        case .UP_CORNER_RIGHT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_up_side_corner", tile_name), x + TILE_SIZE, y, -1);
        case .DOWN_CORNER_ALL;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_down_both_corner", tile_name), x, y);
        case .DOWN_CORNER_LEFT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_down_side_corner", tile_name), x, y);
        case .DOWN_CORNER_RIGHT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_down_side_corner", tile_name), x + TILE_SIZE, y, -1);
        case .SINGLE_VERT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_single_vertical", tile_name), x, y);
        case .SINGLE_HORIZ;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_single_horizontal", tile_name), x, y);
        case .SINGLE_VERT_END_UP;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_single_vertical_end", tile_name), x, y);
        case .SINGLE_HORIZ_END_RIGHT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_single_horizontal_end", tile_name), x, y);
        case .SINGLE_VERT_END_DOWN;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_single_vertical_end", tile_name), x, y + TILE_SIZE, 1, -1);
        case .SINGLE_HORIZ_END_LEFT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_single_horizontal_end", tile_name), x + TILE_SIZE, y, -1);
        case .INSIDE_TOP_LEFT_BOTTOM_RIGHT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_inside_diagonal", tile_name), x, y);
        case .INSIDE_TOP_RIGHT_BOTTOM_LEFT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_inside_diagonal", tile_name), x + TILE_SIZE, y, -1);
        case .INSIDE_EXCEPT_TOP_LEFT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_inside_triple_down", tile_name), x, y);
        case .INSIDE_EXCEPT_TOP_RIGHT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_inside_triple_down", tile_name), x + TILE_SIZE, y, -1);
        case .INSIDE_EXCEPT_BOTTOM_LEFT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_inside_triple_up", tile_name),x, y);
        case .INSIDE_EXCEPT_BOTTOM_RIGHT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_inside_triple_up", tile_name), x + TILE_SIZE, y, -1);
        case .INSIDE_ALL;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_inside_all", tile_name), x, y);
        case .INSIDE_UP;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_inside_up", tile_name), x, y);
        case .INSIDE_DOWN;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_inside_down", tile_name), x, y);
        case .INSIDE_SIDE_LEFT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_inside_side", tile_name), x, y);
        case .INSIDE_SIDE_RIGHT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_inside_side", tile_name), x + TILE_SIZE, y, -1);
        case .INSIDE_DOWN_SIDE_LEFT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_inside_down_side", tile_name), x, y);
        case .INSIDE_DOWN_SIDE_RIGHT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_inside_down_side", tile_name), x + TILE_SIZE, y, -1);
        case .INSIDE_UP_SIDE_LEFT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_inside_up_side", tile_name), x, y);
        case .INSIDE_UP_SIDE_RIGHT;
        draw_atlas_image(render_context, "tiles_atlas", tprint("%_tile_inside_up_side", tile_name), x + TILE_SIZE, y, -1);
    }
}