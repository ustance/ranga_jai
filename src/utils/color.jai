#import "Basic";

make_color_u32 :: (r: float, g: float, b: float, a: float) -> u32 {
    result: u32 = 0;
    
    ur := cast(u32) (r*255);
    ug := cast(u32) (g*255);
    ub := cast(u32) (b*255);
    ua := cast(u32) (a*255);
    
    result = (ua << 24) | (ur << 16) | (ug << 8) | (ub);
    
    return result;
}

color_u32_to_floats :: (color: u32) -> float, float, float, float {
    
    r := (cast(float) ((0x00FF0000 & color) >>> 16)) / 255.0;
    g := (cast(float) ((0x0000FF00 & color) >>> 8)) / 255.0; 
    b := (cast(float) ((0x000000FF & color) >>> 0)) / 255.0; 
    a := (cast(float) ((0xFF000000 & color) >>> 24)) / 255.0;
    
    return r, g, b, a;
}