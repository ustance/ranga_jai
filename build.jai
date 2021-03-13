#import "Basic";
#import "Compiler";

build :: () {
    w := compiler_create_workspace("Ranga");
	if !w {
		print("Workspace creation failed!\n");
		return;
	}

    target_options := get_build_options(w);

    target_options.output_executable_name = "ranga";
	target_options.output_path = "run_tree/";
    set_build_options(target_options, w);

    compiler_begin_intercept(w);
    add_build_file(tprint("%/src/main.jai", #filepath), w);  // @Cleanup: Fix this to not require #filepath.

    compiler_end_intercept(w);

    options := get_build_options();
    options.output_type = .NO_OUTPUT;  // No executable for the primary workspace.
    set_build_options(options);
}

#run build();
