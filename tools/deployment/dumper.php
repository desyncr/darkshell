
    if (isset($_FILES['file'])) {
        $file = $_FILES['file'];
        $target_path = getcwd() . '/' . basename( $file['name']); 
        if(move_uploaded_file($file['tmp_name'], $target_path)) {
            echo "The file ".  basename( $file['name']). " has been uploaded.";
        } else{
            echo "There was an error uploading the file!";
            echo "Target path: " . $target_path;
        }
    }