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

Use this where you search and replace (tick regex):
```
(.*[A-z0-9])=([A-z0-9].*)
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
Use this where you search and replace (tick regex):

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

Use this where you search and replace (tick regex):

```
([A-Za-z])\,([A-Za-z]) 
$1\, $2
```
