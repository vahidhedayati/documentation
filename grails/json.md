Whilst building json I hit an issue which resembled something like:

groovy.lang.MissingMethodException: No signature of method: java.util.ArrayList.call() is applicable for argument types: (java.util.LinkedHashMap, xmlmessage$_run_closure1_closure2) values


The solution was to add delegate. to each field within json string:


http://mrhaki.blogspot.co.uk/2012/01/groovy-goodness-solve-naming-conflicts.html



				 def builder = new JsonBuilder()
				 def root = builder.data {
					 delegate.type "roomCreated"
					 delegate.payload "${username}"
				 }

				 def root = builder.data {
					 type "roomCreated"
					 payload "${username}"
				 }
				 

        def json = new JsonBuilder()
				json.data {
					type "roomCreated"
					payload "${username}"
				}
				
				
				
        def json = new JsonBuilder()
				json.data {
					delegate.type "roomCreated"
					delegate.payload "${username}"
				}
				
				
