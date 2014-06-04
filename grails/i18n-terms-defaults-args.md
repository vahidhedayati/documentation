```bash
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
                                colons=code1"="code4;
                        }else{
                                code4=substr(code2,  index(code2,"'\''")+1,RLENGTH);
                                if (code4 ~ /'\''/) {
                                	code5=substr(code4,  0,index(code4,"'\''")-1)
                                        colons=code1"="code5;
                                }else{
                                        colons=code1"="code4;
                                }
                        }
                }
		y=0;
		vars="";
		if( match(str1, /args:.*/) ) {
		 	str3=substr(str1,  index(str1,"args:"), RLENGTH);
			str4=substr(str3,  index(str3,"["), index(str3,"]"));		
			if (str4 ~ /.*,.*/) { 
				y=0;
				for (i=1;i<=NF;i++) { if ( $i ~ str4)   {if ( $i ~ ",")  {y++;} } }
			}else{
				y=0;
			}
			for (i=0; i < y; i++) { 
				vars=vars" {"i"}"
			}
				colons=colons" "vars"\n"
				

		}else{
			colons=colons"\n"
		}
		print colons

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
				equates=code1"="code4;

                        }else{
                                code4=substr(code2,  index(code2,"\"")+1,RLENGTH)
                                i=1;
                                if (code4 ~ /^ [A-z]+/) { i=2; }
                                code5=substr(code4,  i,index(code4,"\"")-1)
				 equates=code1"="code5;

                        }
                }
		y=0;
                vars1="";
                if( match(str1, /args=.*/) ) {
                        str3=substr(str1,  index(str1,"args="), RLENGTH);
                        str4=substr(str3,  index(str3,"[")+1, (index(str3,"]")-(index(str3,"\"")+2)));
                        if (str4 ~ /.*,.*/) {
                                for (i=1;i<=NF;i++) { if ( $i ~ str4)   {if ( $i ~ ",")  {y++;} } }
                        }else{
                                y=0;
                        }
                        for (i=0; i < y; i++) {
                                vars1=vars1" {"i"}"
                        }
                                equates=equates" "vars1"\n"


                }else{
                        equates=equates"\n"
                }
                print equates



        }
   }'|sort|uniq

```

Ok so this works - but there is an issue with bottom vars for = arguments 
