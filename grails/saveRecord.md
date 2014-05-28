```groovy
MyDomainClass  dr=MyDomainClass.get(currentid)
		if (dr) {
			//DeploymentRegisteration.withTransaction {
				// lock record - returns issue before attempting to save flush:true
				//dr.lock()
				dr.scheduleComplete=true
				// Merge is useful is multiple updates are happening from different calls
				dr.merge()
				dr.save(flush:true)
			//}

```
Shows to enable withTransaction - locking records, merging records and ofcourse flush:true which should occur if multiple updates are occuring
