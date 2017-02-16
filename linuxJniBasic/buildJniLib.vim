编译JNI动态链接库的方法
1.编译c/c++本地语言编写的jni层代码，形成目标代码文件.o
gcc -I /home/lee/mount/michael/2-AppTools/jdk1.8.0_31/include/ -I /home/lee/mount/michael/2-AppTools/jdk1.8.0_31/include/linux/ -c hellojni.c

注意:因为jni编译的时候需要用到jni.h和jni_md.h头文件，而我的java环境不是安装到/usr/lib/jvm默认路径，所以要使用-I参数来指定include的头文件路径

形成hello.o文件

gcc -I /home/lee/mount/michael/2-AppTools/jdk1.8.0_31/include/ -I /home/lee/mount/michael/2-AppTools/jdk1.8.0_31/include/linux/ -c hellojni.c -o hellojni.o

2.编译生成jni so库
gcc -fPIC -shared -o libhello.so hellojni.c -I /home/lee/mount/michael/2-AppTools/jdk1.8.0_31/include/ -I /home/lee/mount/michael/2-AppTools/jdk1.8.0_31/include/linux/

3.拷贝jni so库到/usr/lib/目录下
	然后执行java HelloJNI 运行Java类文件HelloJNI 

  或者配置java编译所使用的so库路径java -Djava.library.path="." HelloJNI 指定so在当前目录

输出结果如下:Hello World!
Hello world from printString fun!

