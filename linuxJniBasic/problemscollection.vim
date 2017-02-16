1.problems

Exception in thread "main" java.lang.IllegalArgumentException: Not a valid class name: HelloJNI.class
	at com.sun.tools.javac.api.JavacTool.getTask(JavacTool.java:129)
	at com.sun.tools.javac.api.JavacTool.getTask(JavacTool.java:107)
	at com.sun.tools.javac.api.JavacTool.getTask(JavacTool.java:64)
	at com.sun.tools.javah.JavahTask.run(JavahTask.java:503)
	at com.sun.tools.javah.JavahTask.run(JavahTask.java:329)
	at com.sun.tools.javah.Main.main(Main.java:46)


解决方法:将javah -o HelloJNI.h HelloJNI.class====>javah -o HelloJNI.h HelloJNI 去掉.class后缀

2.libhello_jni.so库被移到/usr/lib/目录下，这样编译的时候会去该目录下找

Java HotSpot(TM) 64-Bit Server VM warning: You have loaded library /usr/lib/libhello_jni.so which might have disabled stack guard. The VM will try to fix the stack guard now.
It's highly recommended that you fix the library with 'execstack -c <libfile>', or link it with '-z noexecstack'.
Exception in thread "main" java.lang.UnsatisfiedLinkError: /usr/lib/libhello_jni.so: /usr/lib/libhello_jni.so: wrong ELF class: ELFCLASS32 (Possible cause: architecture word width mismatch)
	at java.lang.ClassLoader$NativeLibrary.load(Native Method)
	at java.lang.ClassLoader.loadLibrary0(ClassLoader.java:1937)
	at java.lang.ClassLoader.loadLibrary(ClassLoader.java:1855)
	at java.lang.Runtime.loadLibrary0(Runtime.java:870)
	at java.lang.System.loadLibrary(System.java:1119)
	at HelloJNI.<clinit>(HelloJNI.java:7)

3.ubuntu jni.h: No such file or directory jni_md.h:No such file or directory

gcc编译的时候使用-I参数指定include文件所在目录

4.gcc -fPIC -shared -o libhello.so hellojni.o jni动态so库生成失败
/usr/bin/ld: hellojni.o: relocation R_X86_64_32 against `.rodata' can not be used when making a shared object; recompile with -fPIC
hellojni.o: could not read symbols: Bad value
collect2: ld returned 1 exit status

修改方法:直接用.c文件开始编译生成.so就是OK的
gcc -fPIC -shared -o libhello.so hellojni.c -I /home/lee/mount/michael/2-AppTools/jdk1.8.0_31/include/ -I /home/lee/mount/michael/2-AppTools/jdk1.8.0_31/include/linux/

问题可能原因分析:单纯的.o文件可能还不够，或许还需要其他的文件参与 必须.h文件

