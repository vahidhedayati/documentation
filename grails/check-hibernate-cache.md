	```
	def checkCache() { 
		
		//def statistics = ctx.sessionFactory.statistics
		//statistics.statisticsEnabled = true
		def result
		ApplicationContext ctx = (ApplicationContext) org.codehaus.groovy.grails.web.context.ServletContextHolder.getServletContext().getAttribute(org.codehaus.groovy.grails.web.servlet.GrailsApplicationAttributes.APPLICATION_CONTEXT);
		
		ctx.sessionFactory.queryCache.region.toMap().each { k, v ->
			println "Cache entry: key=$k\nvalue=$v"
			result +="Cache entry: key=$k\nvalue=$v<br>"
		}
		
			render result
	}
	
	def checkCache2() {
		
		def result
		ApplicationContext ctx = (ApplicationContext) org.codehaus.groovy.grails.web.context.ServletContextHolder.getServletContext().getAttribute(org.codehaus.groovy.grails.web.servlet.GrailsApplicationAttributes.APPLICATION_CONTEXT);
		ctx.sessionFactory.getSecondLevelCacheRegion(Servers.name).toMap().each { k, v ->
			println "2nd level Cache entry: key=$k\nvalue=$v"
			result +="Cache entry: key=$k\nvalue=$v<br>"
		}
		render result
	}
```
