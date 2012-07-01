<?php
class Shell{
	private $state;
	private $debug;
	private $engine;

	public function __construct($engine = null, $state = null, $debugger = null) {
		$this->debug = !is_null($debugger) 	? $debugger : new Debug();
		$this->state = !is_null($state) 	? $state 	: new State();

		if (is_null($engine)){
			$engine = isset($this->state->state->{'shell'})? $this->state->state->{'shell'} : 'bash';
			$this->engine = Engineer::create($engine);
		}else{
			$this->engine = $engine;
		}
		return $this;
	}
	public function resumeState($request) {
		$this->request = $request;
		$this->engine->resumeState($this->state);
		$this->debug->dump($this->request);
		$this->debug->dump($this->state);
		$this->debug->dump($this->engine);
		return $this;
	}
	public function executeCmd() {
		$this->debug->dump($this->request);
		switch ($this->request['action']) 
		{
			case 'INTERNAL':
				$this->debug->log("Internal command issued!");
				$cmd = $this->request['cmd'];
				$this->debug->dump($cmd);
				switch ($cmd) {
					case 'set':			// set variables SET var=value
						$this->debug->log("Setting a variable");
						$varValue = preg_split("/=/", $this->request['params']);
						$this->state->state->{"$varValue[0]"} = $varValue[1];
						break;
					case 'unset':
						$this->debug->log("Unsetting a variable");
						unset($this->state->state->{"$this->request['params']"});
						break;
					case 'shell': // Switch shell
						$this->debug->log("Switching shell engines");
						$this->state->state->{'shell'} = ucfirst($this->request['params']);
						break;
					case 'login': // log ins?
						# code...
						break;
				}
				$this->request['status_code'] = 200;
				$this->state->save();
				$this->debug->dump($this->state);
				break;
			case 'CMD':
				$this->debug->log("Simple command issued!");
				$this->request['response'] = $this->engine->executeCmd($this->request['cmd']);
				$this->debug->dump($this->request);
				break;
		}
		return $this;
	}
	public function sendResponse(){
		return json_encode($this->request);
	}
}
