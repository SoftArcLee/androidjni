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
		myJNI.printString("Michale Lee, Hello world from printString fun");
	}
}

