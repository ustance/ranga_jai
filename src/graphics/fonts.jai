#import "Basic";

#load "Font.jai";

GLOBAL_FONT: *Dynamic_Font;

fonts_init :: () {
    print("Font rendering inited!\n");
    
    font, size := load_font("assets", "future.ttf", 72);
    GLOBAL_FONT = font;
}