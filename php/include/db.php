<?php
class DbJson {
    private $spec;
    private $file;
    private $path;
    public function __construct(){
        $this->path = getcwd();
    }

    # return parsed data from a file
    public function load($spec) {
        $this->spec = $this->path . "/" . $spec;

        if (!file_exists($this->spec)) {
            $this->save(array('DbVersion' => 1));
        }
        $this->file = @fopen($this->spec, 'r');
        if (!$this->file) return false;

        $data = fread($this->file, filesize($this->spec));
        fclose($this->file);
        return json_decode($data);
    }

    public function save($data) {
        $data = json_encode($data);
        #if (!isset($this->file)){
            $this->file = @fopen($this->spec, 'w+');
        #}
        if (!$this->file) return false;
        fwrite($this->file, $data);
        fclose($this->file);
    }
}
class State {
    private $encoder;
    private $spec;

    public function __construct ($spec = null, $encoder = null){
        $this->spec     = !is_null($spec)    ? $spec    : 'state.json.php';
        $this->encoder  = !is_null($encoder) ? $encoder : new DbJson();

        $this->state    = $this->encoder->load($this->spec);
    }

    public function save(){# should be __destruct
        $this->encoder->save($this->state);
    }
}
