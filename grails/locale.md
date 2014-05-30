```  
def listCountries() {
        def countries = []
        def locale = Locale.getAvailableLocales().find { availableLocale ->
            def lang=availableLocale?.getLanguage()?.toString()
            def country=availableLocale?.getCountry()?.toString()
            countries << "${lang},${country}"           
        }
        /*
         * Locale.availableLocales*.displayLanguage.each {    if (it) {countries << it }}
         * Locale.availableLocales*.displayCountry.each { if (it) {countries << it }}
         */
   
        render countries as List
    }
    
```    
    
