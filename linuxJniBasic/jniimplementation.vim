1.创建Java类 eg.HelloJNI.java

class HelloJNI{
	// 本地方法声明
	native void printHello();
 	native void printString(String str);
	
	// 加载库
	static { System.loadLibrary("hello_jni");}

	public static void main(String args[]){
    	HelloJNI myJNI = new HelloJNI();

		// 调用本地方法，实际调用的是C语言编写的JNI本地函数
		myJNI.printHello();
		myJNI.printString("Hello world from printString fun");
	}
}

主要工作:1.jni层库的加载libhello_jni.so的加载；
	 2.native本地方法声明(哪些方法需要通过jni层调用C/C++代码)
	 3.通过Java层对象开始调用方法

2.JNI的静态注册(android中使用的是JNI的动态注册，此处讲简单案例，所以采用静态注册的方式)
	A.首先利用javac编译器生成HelloJNI.class类文件 javac HelloJNI.java
	B.利用javah工具生成java本地方法所对应的jni层函数声明HelloJNI.h 
		javah -o HelloJNI.h HelloJNI
	C.查看HelloJNI.h的函数声明,然后实现jni层函数

/* DO NOT EDIT THIS FILE - it is machine generated */
#include <jni.h>
/* Header for class HelloJNI */

#ifndef _Included_HelloJNI
#define _Included_HelloJNI
#ifdef __cplusplus
extern "C" {
#endif
/*
 * Class:     HelloJNI
 * Method:    printHello
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_HelloJNI_printHello
  (JNIEnv *, jobject);

/*
 * Class:     HelloJNI
 * Method:    printString
 * Signature: (Ljava/lang/String;)V
 */
JNIEXPORT void JNICALL Java_HelloJNI_printString
  (JNIEnv *, jobject, jstring);

#ifdef __cplusplus
}
#endif
#endif

3.按照2中获得的JNI层函数声明对函数进行实现

情况一:jni层代码实现调用的是标准的C库/C++库的函数，也就是没有自己编译的本地.so库

例如:如下代码只是使用了C函数stdio标准库函数，在该jni层代码（c语言实现的）即可调用
#include <jni.h>
#include <jni_md.h>
#include <stdio.h>

JNIEXPORT void JNICALL Java_HelloJNI_printHello
  (JNIEnv *env, jobject obj)
{
	printf("Hello World!\n");
	return ;
}

/*
 * Class:     HelloJNI
 * Method:    printString
 * Signature: (Ljava/lang/String;)V
 */
JNIEXPORT void JNICALL Java_HelloJNI_printString
  (JNIEnv *env, jobject obj, jstring string)
{
	// 每个Java进程会创建一个JVM虚拟机指针，该JVM指针通过attach*和Detach*方法可以获得线程相关的JNIEnv env结构指针
	// 通过JNIEnv又可以在jni层代码中得到java对应的类信息/域/方法等，从而可以在jni层调用java方法
	// 其次通过JNIEnv又可以在jni层得到本地C++的类C的结构/域等，从而也可以去调用本地Native方法
	// 这样JNI技术既可以在Java层调用Native方法，也可以从Native层调用Java方法，其中JVM获得的JNIEnv变量是核心中介。
	const char *str = (*env)->GetStringUTFChars(env, string, 0);
	// printf函数来自标准C库
	// 所以此句是jni层代码调用本地C库函数
	// 如果有自己写的C库，此处就是加载和调用自己的Native代码库函数了。
	printf("%s!\n",str);
}

情况二.在jni层代码中比如printStirng函数中需要访问自己创建的so库:liblimao.so
	那么需要导入所需头文件，并且使用该动态库liblimao.so

4.Jni层C/C++代码实现之后，需要编译jni层的动态库libhello_jni.so

gcc -fPIC -shared -o libhello.so hellojni.c -I /home/lee/mount/michael/2-AppTools/jdk1.8.0_31/include/ -I /home/lee/mount/michael/2-AppTools/jdk1.8.0_31/include/linux/

5.到此从java层到jni层的映射完成，jni层也调用了标准的C库stdio.h的函数

java HelloJNI执行代码，即可看到输出结果，java方法通过JNI技术成功调用了C标准库中的方法
或者 java -Djava.library.path="." HelloJNI




