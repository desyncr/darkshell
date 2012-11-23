<?php
interface Engine {
    public function resumeState($state);
    public function executeCmd($cmd);
}
class Bash implements Engine {
    private $current_dir;
    public function resumeState($state){
        $this->state = $state->state;
        if (isset($this->state->{'current_dir'})) {
            if (file_exists($this->state->{'current_dir'})){
                chdir($this->state->{'current_dir'});
                $this->current_dir = $this->state->{'current_dir'};
            }else{
                $this->current_dir = getcwd();
            }
        }
    }
    public function executeCmd($cmd){
        return shell_exec(
                #'cd "' . $this->current_dir . '" 2>&1 &' .
                $cmd . " 2>&1");
    }
}
class Php implements Engine {
    private $state;
    public function resumeState($state){
        $this->state = $state->state;
        if (isset($this->state->{'current_dir'})) {
            chdir($this->state->{'current_dir'});
        }
    }
    public function executeCmd($cmd) {
        ob_start(); 
        @eval("$cmd");
        $return = ob_get_contents(); 
        ob_end_clean();
        return $return;
    }
}
class Perl implements Engine {
    public function resumeState($state){
        return "Resuming state from Perl";
    }
    public function executeCmd($cmd) {
        return "Executing cmd from Perl";
    }
}
class Mysql implements Engine {
    public function resumeState($state){
        return "Resuming state from Mysql";
    }
    public function executeCmd($cmd) {
        return "Executing cmd from Mysql";
    }
}

class Engineer {
    public static function create($engine){
        if (!isset($engine) || !(in_array(lcfirst($engine), array('bash', 'perl', 'mysql', 'php')))) {
            $engine = 'Bash';
        }
        return eval ("return new $engine();");
    }
}
