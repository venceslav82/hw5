<?php
print "<h3>Hello Docker Swarm!</h3>\n";
if (getenv('APP_MODE')) print "Running in ".getenv('APP_MODE')." mode.<br />\n";
print "<hr />\n";
print "<small><i>Served by: <b>".gethostname()."</b></i></small>\n";
?>
