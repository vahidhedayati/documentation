```goovy

class MyClass {

CategoryBase categories

static mapping = { 


  categories ignoreNotFound : true
}


```

The above will ensure records are listed even though it may not find a category bound to myClass record... useful if mappings have been missed 
