<?php
class Debug {
	private $file;
	private $log;
	private $buffer;
	
	public function __construct($log = null) {
		$this->log = (!is_null($log)) ? $log : 'www.log.php';
		$this->file = @fopen($this->log,'a+');
		if (!$this->file) return false;

		$this->buffer = "[" . date("Y/m/d h:m:s") . " '" . $_SERVER['SCRIPT_NAME'] ." " . $_SERVER['QUERY_STRING'] . "' ]\n";
		$this->buffer .= print_r($_SERVER, 1) . "\n";
	}
	public function log($data) {
		$this->buffer .= $data . "\n";
	}
	public function dump($data) {
		$this->buffer .= print_r($data,1) . "\n";
	}
	public function __destruct() {
		if (!$this->file) return false;
		fwrite($this->file, $this->buffer);
		fclose($this->file);
	}
}

