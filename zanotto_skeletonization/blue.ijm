print("Select the folder containing images with osteoid/immature component...");
// ask user to select a folder
dir = getDirectory("Select A folder");
// get the list of files (& folders) in it
fileList = getFileList(dir);
// prepare a folder to output the images
output_dir = dir + File.separator + " output_blue" + File.separator ;
File.makeDirectory(output_dir);

//activate batch mode
setBatchMode(true);

// LOOP to process the list of files
for (i = 0; i < lengthOf(fileList); i++) {
	// define the "path" 
	// by concatenation of dir and the i element of the array fileList
	current_imagePath = dir+fileList[i];
	// check that the currentFile is not a directory
	if (!File.isDirectory(current_imagePath)){

		// open the image and split
		open(current_imagePath);
		title = getTitle();

		run("Split Channels");
		selectImage(title+" (red)");

		setThreshold(0, 100);
		run("Convert to Mask", "method=Default background=Dark black");

		run("Despeckle");

		run("Remove Outliers...", "radius=15 threshold=50 which=Dark");
		run("Remove Outliers...", "radius=15 threshold=50 which=Bright");
		
		run("Fill Holes");
		for (j = 0; j < 6; j++) {
			run("Dilate");
		}
		run("Gaussian Blur...", "sigma="+2);
		run("Gaussian Blur...", "sigma="+2);		

		run("Make Binary", "thresholded remaining black");

		run("Skeletonize");
	
		run("Convert to Mask");

		run("Analyse Skeleton", "prune=shortest branch");

		selectImage(1);

		title = getTitle();
		len = lengthOf(title);
		
		output_title = substring(title, 0,lengthOf(title)-10) + ' (blue)';

		print("Image " + output_title + " done!");

		saveAs("tiff", output_dir + output_title);

		run("Close All");
	}
}
print("Images with immature material saved in: " + dir + "output_blue")
setBatchMode(false);