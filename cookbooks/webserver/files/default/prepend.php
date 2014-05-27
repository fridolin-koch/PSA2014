<?php

// This script is run before EVERY request. We will use it to assert some
// security parameters. We don't bother with setting the CWD because php-cgi
// does that for us.

// This is the file that is going to run.
$filename = $_SERVER["SCRIPT_FILENAME"];

// Retrieve the UID/GID of the PHP script about to run.
$uid = fileowner($filename);
$gid = filegroup($filename);

//don't execute files owned by root
if ($uid == 0 || $gid == 0) {
  trigger_error('Executing files owned by root is not allowed.', E_USER);
  exit(0);
}

// Set permissions on all files that were uploaded; we will not be able to move
// them afterwards if we leave them owned by root.
foreach($_FILES as $file) {
    chown($file['tmp_name'], $uid);
    chgrp($file['tmp_name'], $gid);
}

// Change the session directory to something user specific.
$session_dir = '/var/lib/php5/' . $uid;
if (!file_exists($session_dir)) {
    mkdir($session_dir, 0700);
    chown($session_dir, $uid);
}
session_save_path($session_dir);

// Run as the user/group of the target file; must do group then user.
posix_setgid($gid);
posix_setuid($uid);

// Cleanup.
unset($uid);
unset($gid);
unset($filename);
unset($session_dir);