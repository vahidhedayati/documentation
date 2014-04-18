http://www.howtoforge.com/how-to-encrypt-directories-partitions-with-ecryptfs-on-debian-squeeze

# mkdir encrypt-test


#cp -r vahid/Documents/Test encrypt-test/


mount -t ecryptfs /home/encrypt-test /home/encrypt-test/
```
Passphrase: 
Select cipher: 
 1) aes: blocksize = 16; min keysize = 16; max keysize = 32
 2) blowfish: blocksize = 8; min keysize = 16; max keysize = 56
 3) des3_ede: blocksize = 8; min keysize = 24; max keysize = 24
 4) twofish: blocksize = 16; min keysize = 16; max keysize = 32
 5) cast6: blocksize = 16; min keysize = 16; max keysize = 32
 6) cast5: blocksize = 8; min keysize = 5; max keysize = 16
Selection [aes]:  
Select key bytes: 
 1) 16
 2) 32
 3) 24
Selection [16]: 1
Enable plaintext passthrough (y/n) [n]: 
Enable filename encryption (y/n) [n]: 
Attempting to mount with the following options:
  ecryptfs_unlink_sigs
  ecryptfs_key_bytes=16
  ecryptfs_cipher=aes
  ecryptfs_sig=12071bd24ecadf02
WARNING: Based on the contents of [/root/.ecryptfs/sig-cache.txt],
it looks like you have never mounted with this key 
before. This could mean that you have typed your 
passphrase wrong.

Would you like to proceed with the mount (yes/no)? : yes
Would you like to append sig [12071bd24ecadf02] to
[/root/.ecryptfs/sig-cache.txt] 
in order to avoid this warning in the future (yes/no)? : yes
Successfully appended new sig to user sig cache file
Mounted eCryptfs
```

mount
```
/home/encrypt-test on /home/encrypt-test type ecryptfs (rw,ecryptfs_sig=12071bd24ecadf02,ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_unlink_sigs)
```


root@myhost:/home# umount encrypt-test/


root@myhost:/home# ls -l
```
total 24
drwxr-xr-x  3 root  root   4096 Jul 10 14:55 encrypt-test
drwx------ 45 vahid vahid 16384 Jul 10 14:24 vahid
```

root@myhost:/home# ls -l encrypt-test/
```
-rw-r--r-- 1 root root 12288 Jul 10 14:55 hosts
```

root@myhost:/home# ls -l encrypt-test/hosts 
```
-rw-r--r-- 1 root root 12288 Jul 10 14:55 encrypt-test/hosts
```
root@myhost:/home# cat encrypt-test/hosts 
```

[�^�.]�#Nu礶���q�:�,c6o/z�Y��L���>�#��H�����D���Ԫ��,΍�v�u��3L���K�/��k��
```




mount -t ecryptfs /home/encrypt-test /home/encrypt-test
```
Passphrase: 
Select cipher: 
 1) aes: blocksize = 16; min keysize = 16; max keysize = 32
 2) blowfish: blocksize = 8; min keysize = 16; max keysize = 56
 3) des3_ede: blocksize = 8; min keysize = 24; max keysize = 24
 4) twofish: blocksize = 16; min keysize = 16; max keysize = 32
 5) cast6: blocksize = 16; min keysize = 16; max keysize = 32
 6) cast5: blocksize = 8; min keysize = 5; max keysize = 16
Selection [aes]: 
Select key bytes: 
 1) 16
 2) 32
 3) 24
Selection [16]: 
Enable plaintext passthrough (y/n) [n]: 
Enable filename encryption (y/n) [n]: 
Attempting to mount with the following options:
  ecryptfs_unlink_sigs
  ecryptfs_key_bytes=16
  ecryptfs_cipher=aes
  ecryptfs_sig=12071bd24ecadf02
Mounted eCryptfs
```

root@myhost:/root/.ecryptfs# df -k
```
Filesystem           1K-blocks     Used Available Use% Mounted on
/dev/sda2            239723544 28150284 199572188  13% /
udev                   1954852        4   1954848   1% /dev
tmpfs                   787056      904    786152   1% /run
none                      5120        0      5120   0% /run/lock
none                   1967632       92   1967540   1% /run/shm
/dev/sda1                96880      118     96762   1% /boot/efi
/home/vahid/.Private 239723544 28150284 199572188  13% /home/vahid
/home/encrypt-test   239723544 28150284 199572188  13% /home/encrypt-test
```


root@myhost:/root/.ecryptfs# cat /home/encrypt-test/
```
hosts  
```

root@myhost:/root/.ecryptfs# cat /home/encrypt-test/hosts 
```
127.0.0.1	localhost
# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
```



Above is all the manual way


cat /root/.ecryptfs/sig-cache.txt


cat /root/.ecryptfs/sig-cache.txt
```
12071bd24ecadf02
```



vi /root/.ecryptfsrc
```
key=passphrase:passphrase_passwd_file=/home/vahid/2ndmount.txt
ecryptfs_sig=12071bd24ecadf02
ecryptfs_cipher=aes
ecryptfs_key_bytes=16
ecryptfs_passthrough=n
ecryptfs_enable_filename_crypto=n
```




vi /home/vahid/2ndmount.txt
```
passphrase_passwd=YOUR SET PASS
```


vi /etc/fstab
```
/home/encrypt-test /home/encrypt-test ecryptfs defaults 0 0
```

