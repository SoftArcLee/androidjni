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
	const char *str = (*env)->GetStringUTFChars(env, string, 0);
	// printf函数来自标准C库
	// 所以此句是jni层代码调用本地C库函数
	// 如果有自己写的C库，此处就是加载和调用自己的Native代码库函数了。
	printf("%s!\n",str);
}

