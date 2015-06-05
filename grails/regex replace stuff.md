###GGTS

###replace regex pattern of 

where you have 
```
if (a=b) {
```
it will become
```
if (a = b) {
```

Use this:
```
(.*[A-z])=([A-z].*)	

```
With
```
$1 = $2
```

where you have 
```
if (something=='something') {
```
it will become
```
if (something == 'something') {
```
Use this

```
(.*[A-z'])==([A-z'].*)
$1 == $2
```


replace regex pattern of 
Where you have

```
service.Caller(a,b,c)
```

It will become

```
service.Caller(a, b, c)
```

Use this:

```
([A-Za-z])\,([A-Za-z]) 
```
With
```
$1\, $2
```
