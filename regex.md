```
Regex to replace key=value to key = value
(.*[A-z0-9])=([0-9A-z].*)
$1 = $2
			

Regex to replace value1,value2 to value1, value2
(.*[A-z0-9])\,([0-9A-z].*)
	$1\, $2

```

