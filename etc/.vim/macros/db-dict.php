<?php

// Usage: php db-dict.php mysqli://user:pass@localhost/database

require_once 'DB.php';

function main($args) {
	$dsn = $args[1];

	echo $dbn;

    $option = array(
      "autofree" => TRUE,
      "debug" => 1,
      "portability" => DB_PORTABILITY_ALL
    );

    $db = DB::connect($dsn, $option);
	if (DB::isError($db)) {
		die("Connecting DB failed: " . $dsn);
	}

    $db->query("SET NAMES UTF8");

	$fp = fopen($_ENV["HOME"] . "/.db-dict", "w");
	if ($fp == null) {
		die("failed to open file");
	}

	$rows = $db->getAll("SELECT table_name FROM information_schema.tables");
	if (DB::isError($rows)) {
		die("Error!\n");
	}

	foreach ($rows as $row) {
		fputs($fp, $row[0]."\n");
	}

	$rows = $db->getAll("SELECT column_name FROM information_schema.columns");
	foreach ($rows as $row) {
		fputs($fp, $row[0]."\n");
	}

	fclose($fp);

	echo "Finish db-dict.php";
}


main($argv);


