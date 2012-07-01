<?php
@ini_set("display_errors", 0);
include "include/debug.php";
include "include/db.php";
include "include/engine.php";
include "shell.php";

$shell = new Shell();
echo $shell->resumeState($_REQUEST)
				->executeCmd()
					->sendResponse();
//lol
