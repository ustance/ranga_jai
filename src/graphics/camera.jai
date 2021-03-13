#import "Basic";
#import "kinc";

math :: #import "Math";

Camera :: struct {
	x: float32 = 0;
	y: float32 = 0;
	zoom: float32 = 1.0;
    
	matrix: Matrix4x4;
}

get_mouse_position_from_camera :: (camera: *Camera, x: int, y: int) -> float, float {
	//
	world_space_x, world_space_y: float;
	//
	//----------------------------------
	
    world_space_x = xx (x + camera.x) / camera.zoom;
    world_space_y = xx (y + camera.y) / camera.zoom;
    
	//----------------------------------
	//
	return world_space_x, world_space_y;
	//
}

camera_update :: (camera: *Camera) {
	//TODO: camera moving and scrolling and stuuf and so on
}

//TODO: cam width
camera_set_centered_position_from_world :: (camera: *Camera, x: float, y: float) {
	camera.x = (x - 1280/camera.zoom/2)*camera.zoom;
	camera.y = (y - 800/camera.zoom/2)*camera.zoom;
}

//TODO: think about it;
update_camera_matrix :: (camera: *Camera) {
	mat := math.matrix4_identity();
    
	// Translate the matrix.
	pos: math.Vector3;
	pos.x = -camera.x;
	pos.y = -camera.y;
	mat = math.translate(mat, pos);
    
	// Scale it.
	scaler: math.Vector3;
	scaler.x = camera.zoom;
	scaler.y = camera.zoom;
	scaler.z = 1.0;
	mat = math.scale(mat, scaler);
    
	//TODO: rotation?
    
	// Aaaand done.
	mat = math.transpose(mat);
    
	camera.matrix.m = mat.floats;
}
