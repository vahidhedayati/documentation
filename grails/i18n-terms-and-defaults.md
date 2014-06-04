```
grep -r message *|grep "code"|grep "default"|awk '{
        if( match($0, /code:.*'[A-z]+'/) ) {
                str1=substr($0, RSTART, RLENGTH);
                code=substr(str1, index(str1,":"));
                code1=substr(code,  index(code,":")+index(code,"'\''"),index(code,",")-(index(code,"'\''")+2));

                if( match(str1, /default:.*'[A-z]+'/) ) {
                        str2=substr(str1, RSTART, RLENGTH);
                        code2=substr(str2, index(str2,":"));

                        code3=substr(code2,  index(code2,"'\''")+1,RLENGTH)
                        if (code3 ~ /{.*}/ ) {
                                code4=substr(code2,  index(code2,"{")+1,index(code2,"}")-(index(code2,"'\''")+3));
                                print code1"="code4;
                        }else{
                                code4=substr(code2,  index(code2,"'\''")+1,RLENGTH);
                                if (code4 ~ /'\''/) {
                                code5=substr(code4,  0,index(code4,"'\''")-1)
                                        print code1"="code5;
                                }else{
                                        print code1"="code4;
                                }
                        }
                }
        }
        if( match($0, /code=.*/) ) {
                str1=substr($0, RSTART, RLENGTH);
                code=substr(str1, index(str1,"="));
                code1=substr(code,  index(code,"=")+index(code,"\""),index(code," ")-(index(code,"\"")+2));
                if( match(str1, /default=.*/) ) {
                        str2=substr(str1, RSTART, RLENGTH);
                        code2=substr(str2, index(str2,":"));
                        code3=substr(code2,  index(code2,"\"")+1,RLENGTH)
                        if (code3 ~ /{.*}/ ) {

                                code4=substr(code2,  index(code2,"{")+1,index(code2,"}")-(index(code2,"\"")+3));
                                print code1"="code4;
                        }else{
                                code4=substr(code2,  index(code2,"\"")+1,RLENGTH)
                                i=1;
                                if (code4 ~ /^ [A-z]+/) { i=2; }
                                code5=substr(code4,  i,index(code4,"\"")-1)
                                print code1"="code5;
                        }
                }


        }
   }'|sort|uniq
```

returns:

```
default.add.label=property.referencedDomainClass.shortName
default.Authors.deleted.label=Authors deleted
default.authors.label=Authors
default.authors}.label=Authors
default.Authors.missing.label=Authors missing
default.Authors.notfound.label=Authors not found
default.Books.deleted.label=Books deleted
default.books.label=Books
default.books}.label=Books
default.Books.missing.label=Books missing
default.Books.notfound.label=Books not found
default.button.create.label=Create
default.button.delete.label=Delete
default.button.edit.label=
default.button.update.label=Update
default.created.message=className
default.deleted.message=className
default.delete.label=Delete
default.details.updated.label=Information has been updated
default.id.missing.label=id missing
default.invalid.label=
default.invalid.label=/> <g:message code=
default.invalid.number.label=Invalid firstNumber "
default.invalid.number.label=Invalid orderby "
default.invalid.number.label=Invalid pricerange "
default.lang.changed.label=Language changed
default.link.skip.label=Skip to content&hellip;
default.list.label=List
default.logout.success.label=Logout successfully
default.long.label=name too long "
default.maxlength.label=Confirmation too long "
default.maxlength.label=Password too long "
default.maxlength.label=Username too long "
default.maxSize.label=
default.minlength.label=Password too short "
default.minlength.label=Username too short "
default.minlength.label=Username too short"
default.new.label=New authors
default.new.label=New books
default.new.label=New numbers
default.not.found.message=className
default.Numbers.deleted.label=Numbers deleted
default.numbers.label=Numbers
default.numbers}.label=Numbers
default.Numbers.missing.label=Numbers missing
default.Numbers.notfound.label=Numbers not found
default.own.username.label=Can not set username to existing username
default.password.missing.label=PasswordHash missing
default.password.pattern.label=password must be 8 characters, at least 1 uppercase character and 1 digit or special character."
default.password.pattern.label=Password must be 8 characters, at least 1 uppercase character and 1 digit or special character. "
default.password.unique.label=Confirmation does not match Password "
default.password.update=Update password
default.password.update=Update Password
default.save.label=Save
default.short.label=name too short "
default.token.missing.label=Token missing
default.token.notfound.label=Token not found
default.unique.label=Username already taken "
default.updated.message=className
default.update.label=Update
default.user.label={user.usernam
default.username.available.label=Username available
default.username.deleted.label=User deleted
default.username.missing.label=Username missing
default.usernamepassword.invalid.label=Username and/or password incorrect
default.username.update=Update username
default.username.update=Update Username
default.username.used.label=Username already in use
default.user.notfound.label=User not found
${domainClass.propertyName}.label=${className
${domainClass.propertyName}.${p.name}.label=${p.naturalName
${domainClass.propertyName}.${p.name}.label=p.naturalName
${domainClass.propertyName}.${prefix}${p.name}.label=p.naturalName
language.{{c.value}}={c.valu
language.de=de
language.en=en
security.newusername.label=New username
security.password.confirm.label=Confirm Password
security.password.label=Password
security.register.label=Register
security.signin.label=Sign in
security.signoff.label=Log out
security.signoff.label=Sign Off
security.username.label=Username
```
