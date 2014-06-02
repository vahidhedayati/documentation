```  
import grails.converters.JSON
import grails.converters.XML


class MyClass { 

def listCountries() { 
	def countries = [] as SortedSet
	
	Locale.availableLocales*.displayCountry.each {
	  if (it) {
		countries << it
	  }
	}
	
	render countries as JSON
}


	def listLocale() {
		def countries = [] 
		def supported=['*']
		def locale = Locale.getAvailableLocales().collect { availableLocale ->
			def countryMap = [:]
			def lang=availableLocale?.getLanguage()?.toString() ?: availableLocale.toString()
			def countryname=availableLocale?.getDisplayName()?.toString() ?: availableLocale.toString()
			if (supported.find{((it==availableLocale as String)||(it=='*'))}) {
			countryMap.put('value', availableLocale as String)
			countryMap.put('text', countryname)
			countries?.add(countryMap)
			}
		}
	
		countries = countries.sort { it }
		withFormat{
			xml {
				render countries as XML
			}
			json {
				render countries as JSON
			}
		}
	}
	
}	
    
```    
    
