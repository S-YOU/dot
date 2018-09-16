<?php

ini_set('display_errors', 1);
error_reporting(E_ALL & ~E_DEPRECATED);
date_default_timezone_set('Asia/Tokyo');
mb_internal_encoding('UTF-8');
mb_language('uni');



?>
<!DOCTYPE html>
<head>
<meta charset="utf-8">
<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=edge"><![endif]-->
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><?vim expand("%") ?></title>
<link rel="stylesheet" href="base.css">
</head>
<body>
	<div class="container1">
		<h1 class="header">タイトル</h1>

		<div class="container2">
			<div class="container2">
				<p id="asd" data-text="本文&amp;JavaScript"></p>
			</div>
		</div>

		<div class="footer">
			Copyright(C) <?vim strftime("%Y") ?> Aoyama, Shotaro All Rights Reserved.
		</div>
	</div>
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/sugar/1.4.1/sugar.min.js"></script>
	<script type="text/javascript">
		$(function() {
			var $asd = $('#asd');
			$asd.text($asd.data('text'));
		});
	</script>
</body>
</html>
