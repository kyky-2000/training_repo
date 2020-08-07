# JAVA高级篇

## 一、多线程

### 1.创建线程方法

#### 1.1两种旧方法

##### 1.1.1 方法介绍

**①继承Thread类**

继承Thread，重写run方法，在run方法中写我们在在新线程中执行的逻辑    

*Thread的乱方法也是实现RUnnable接口来的*

```java
class MyThread extends Thread{
    @Override
    public void run() {
        for (int i = 0; i < 100; i++) {
            if(i%2 == 0){
                System.out.println(getName() + "  :  " + i);
            }
        }
    }
}
```

实例继承Tread的类，调用start方法

```java
public class ThreadTest {
    public static void main(String[] args) {
        //创建线程的方法一
        MyThread mt1 = new MyThread();
        //直接调用run方法不会新建一个新线程
        // mt1.run();
        mt1.start();
        

        //一个线程只能被开启一次，所以只能进行一次 xxx.start();
        //当start方法被调用了之后，Thread源码中的threadStatus（线程状态会由0改变为1），此时再次开启线程则会抛出异常
        MyThread mt2 = new MyThread();
        mt2.start();

       
        for (int i = 0; i < 100; i++) {
            if(0 == i%2){
                System.out.println(Thread.currentThread().getName() + "  :  " + i);
            }

        }
    }
}
```

**②实现Runnable接口**

实现Runnable接口，实现run方法

```java
class MyThread2 implements Runnable{
    //无需加static，通常情况下，只有一个MyThread2实例，属性是唯一的
    private int ticket = 100;
    @Override
    public void run() {
        for (int i = 0; i < 100; i++) {
            if(i%2 == 0){
                System.out.println(Thread.currentThread().getName() + "  :  " + i);
            }
        }
    }
}
```

实例实现接口的类，传入Thread的构造器实例一个Thread对象

```java
public class ThreadTest {
    public static void main(String[] args) {

        //创建线程的方法二
        MyThread2 myThread2 = new MyThread2();
        Thread thread1 = new Thread(myThread2);
        //start方法会开启线程并执行当前线程中的run方法，
        /*在Thread里，有一个属性Runnable target，
              若target不为空则执行target的run方法
          	  若target为空，则执行Thread的run方法
        */                                                                       
        thread1.start();
        thread1.setName("线程1");
        Thread thread2 = new Thread(myThread2);
        thread2.start();
        thread2.setName("线程2");


        for (int i = 0; i < 100; i++) {
            if(0 == i%2){
                System.out.println(Thread.currentThread().getName() + "  :  " + i);
            }

        }
    }
}
```

##### 1.1.2对比两种旧方法

+ **开发中优先选择第二种方法：**

  原因：

  + 方法一是继承Thread的方式，有单继承的局限性；而方法二是实现Runnable的方式，实现接口可以多实现
  + 方法二有天然的共享属性，用起来比较方便

+ **联系：**

  Thread也实现了Runnable接口，实现了Runnable的run方法

+ **共同点：**

  都需要重写run方法，写入我们要在线程中执行的逻辑

##### 1.1.3注意点

start方法有开启线程和执行当前线程中的run方法两个功能，如果实例新线程之后直接调用run方法是不会开启新线程的，还是只有主线程一个线程

#### 1.2  JDK5.0 之后新增了两种新的创建线程的方法

##### 1.2.1  方法介绍

**①实现Callable接口**

*和实现Runnable接口的方法类似*

实现Callable接口，实现接口的call方法

```java
//1.创建一个实现Callable的实现类
class NumThread implements Callable{
    //2.实现call方法，将此线程需要执行的操作声明在call()中（实现Runnable接口则实现run方法）
    @Override
    public Object call() throws Exception {
        int sum = 0;
        for (int i = 1; i <= 100; i++) {
            if(i % 2 == 0){
                System.out.println(Thread.currentThread().getName() + ":  " + i);
                sum += i;
                Thread.sleep(50);
            }
        }
        return sum;
    }
}
```

实例实现接口的类，传入FutureTask的构造器中，创建FutureTask的对象，再传入Thread的构造器，新建线程

```java
public class ThreadNew {
    public static void main(String[] args) {
        for (int i = 0; i < 200; i++) {
            System.out.println(Thread.currentThread().getName() + "。。。。。:  " + i);
        }

        //3.创建Callable接口实现类的对象
        NumThread numThread = new NumThread();
        //4.将此Callable接口实现类的对象作为参数传递到FutureTask构造器中，创建FutureTask的对象
        FutureTask futureTask = new FutureTask(numThread);
        //5.将FutureTask的对象作为参数传递到Thread类的构造器中（FutureTask间接实现了Runnable接口，所以可以传），创建Thread对象，并调用start()
        new Thread(futureTask).start();

        try {
            //6.获取Callable中call方法的返回值
            //get()返回值即为FutureTask构造器参数Callable实现类重写的call()的返回值。
            Object sum = futureTask.get();
            System.out.println("总和为：" + sum);
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
        for (int i = 0; i < 50; i++) {
            System.out.println(Thread.currentThread().getName() + ":  " + i);
        }
    }

}
```

**②线程池方式**

还是需要实现Runnable接口或者Callable接口，因为我们要实现run方法，写自己的逻辑

```java
class NumberThread implements Runnable{

    @Override
    public void run() {
        for(int i = 0;i <= 100;i++){
            if(i % 2 == 0){
                System.out.println(Thread.currentThread().getName() + ": " + i);
            }
        }
    }
}
```

创建线程池，调用service的方法，传入实现类，创建线程

```java
/*
线程池的属性：
    corePoolSize：核心池的大小
    maximumPoolSize：最大线程数
	keepAliveTime：线程没有任务时最多保持多长时间后会终止

*/

public class ThreadPool {

    public static void main(String[] args) {
        //1. 提供指定线程数量的线程池，之后学习一下如何手动创建连接池
        ExecutorService service = Executors.newFixedThreadPool(10);

        //设置线程池的属性，ExecutorService是接口，故无法用service设置属性
        //查看service指向的对象的类加载器，从而得知它本身是什么类
//        System.out.println(service.getClass());
        //强转为它原来的类
        ThreadPoolExecutor service1 = (ThreadPoolExecutor) service;
        //设置属性
//        System.out.println(service.getClass());
//        service1.setCorePoolSize(15);
//        service1.setKeepAliveTime();


        //2.执行指定的线程的操作。需要提供实现Runnable接口或Callable接口实现类的对象
        service.execute(new NumberThread());//适合适用于Runnable
        service.execute(new NumberThread1());//适合适用于Runnable

//        service.submit(Callable callable);//适合使用于Callable
        //3.关闭连接池，重点
        service.shutdown();
    }

}
```

##### 1.2.2对比Runnable和Callable接口

+ Callable可以设置泛型，该泛型为call方法的返回值类型，Runnable的run方法没有返回值
+ call可以抛出异常，被外面的操作捕获，获取异常的信息，run方法不可以

+ Callable的功能要比Runnable强大

##### 1.2.3Callable的call的返回值问题

+ 若要执行第六步获取分线程返回值操作，会自动将主线程阻塞，直到获取到返回值之后继续执行主线程，此时变成了单线程

+ 若不执行第六步获取分线程返回值操作，new Thread(futureTask).start();还是多线程

#### 1.3创建线程的简略写法（内部类）

```java
//继承Thread方式的简略写法
new Thread(){
    @Override
    public void run() {
        System.out.println("新线程。。。");
    }
}.start();

//实现Runnable方式的简略写法
new Thread(new Runnable(){
    @Override
    public void run() {
        System.out.println("新线程。。。");
    }
}).start();
```

#### 1.4线程池的优势

+ 提高响应速度（减少了创建新线程的时间）

+ 降低资源消耗（重复利用线程池中线程，不需要每次都创建）

+ 便于线程管理

### 2.多线程的相关方法

#### 2.1方法介绍

+ start()
+ run()
+ currentThread()  静态方法，获取当前线程，返回值为Thread类型
+ getName()

+ setName()

+ yield()
+ join()            让当前线程进入阻塞状态，把CPU执行权给方法调用者的线程，直到该线程执行结束之后才结束    			         阻塞状态

+ stop()           已过时，强行结束当前线程

+ sleep()          让当前线程睡眠，进入指定时间的阻塞状态

+ isAlive()        判断线程是否存活

+ getPriority() 获取当前线程的优先级

+ setPriority(int p)  设置当前线程的优先级

  优先级：

  ​    MAX_PRIORITY   10

  ​    MIN_PRIORITY   1

  ​    NORM_PRIORITY  5  默认值    

  说明：

  ​    不是说高优先级的执行完才执行低优先级的，高优先级只是大概率上先于低优级执行，不一定能成功抢占低优先级的资源（执行权）

#### 2.2 方法演示

```java
class MyThread1 extends Thread{
    //修改线程的名称
    public MyThread1(String name){
        super(name);
    }

    @Override
    public void run() {
        //修改线程的名称
//        this.setName("线程1。。。");
//        setName("线程1.。。");

        //获取线程的名称
//        this.getName();
//        getName();

        for (int i = 0; i < 50; i++) {

            //必须捕捉异常，因为父类的run方法为抛异常，所以这里抛不出
            try {
                //单位是毫秒（ms）
                sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            System.out.println(getName() + " : " + i);

            if (20 == i){
                //释放当前cpu的执行权，所有线程公平竞争，自身有可能释放了之后又再次抢回来
                yield();
            }
        }

    }
}
public class ThreadMethodTest {
    public static void main(String[] args) throws InterruptedException {
        //修改非Thread子类的线程的名称的方法
        Thread.currentThread().setName("主线程。。。");

        MyThread1 myThread1 = new MyThread1("线程1。。。");
        myThread1.start();

        for (int i = 51; i < 100; i++) {
            System.out.println(Thread.currentThread().getName() + " : " + i);

            //条件成立，主线程进入阻塞状态，将CPU的执行权给myThread1线程，直到myThread1线程执行结束，主线程才结束阻塞状态
            if(80 == i){
                myThread1.join();
            }
        }

    }
}
```

### 3.线程同步

#### 3.1线程同步的三种方式

+ **同步代码块**

  注意：不要包多了（效率低，还可能会出问题）,也不要包少了（可能会出问题）

+ **同步方法**

  注意：

  + 此方式不用显示写出同步监听器，监听器为调用同步方法的对象
  + 此方式适用于处理共享数据的代码块方便提取出来做为一个方法的程序
  + 同步监听器必须唯一

+ **lock锁**

#### 3.2三种方式的具体演示

+ 同步代码块

```java
class Window implements Runnable{
    //共享数据
    private int ticket = 100;

    //同步监听器，相当于一把锁，可以为任意类对象，但一块同步代码块的锁必须只能是一个
    //继承Thread的方式创建的线程要注意加上static关键字
    private Object object = new Object();

    @Override
    public void run() {

        //处理线程安全问题方法一（同步代码块）
        //将操作共享数据（此处为ticket）的代码块包起来处理为同步代码块，相当于上锁
        while(true){
            //直接传一个this最方便
            //继承Thread的方式创建的线程不能用this，但可以用Window.class（也是一个对象，类对象，且唯			一）
            synchronized(object) {
                if (ticket > 0) {
                    try {
                        Thread.sleep(10);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    System.out.println(Thread.currentThread().getName() + "卖出了" + ticket + "张票");
                    ticket--;
                } else {
                    break;
                }
            }
        }
    }
}
public class WindowTest1 {
    public static void main(String[] args) {
        Window window = new Window();

        Thread t1 = new Thread(window);
        t1.setName("窗口一");
        Thread t2 = new Thread(window);
        t2.setName("窗口二");
        Thread t3 = new Thread(window);
        t3.setName("窗口三");

        t1.start();
        t2.start();
        t3.start();

    }
}
```

+ 同步方法

```java
class Window1 extends Thread{
    //共享数据
    private static int ticket = 100;

    @Override
    public void run() {

        while(true){

            sell();
            if (ticket <= 0) {
                break;
            }
        }
    }

    //若是实现Runnable方式创建线程不用加static，同步监听器是this对象
    //此时同步监听器为Window1.class，由于方法是静态的，所以监听器是唯一的
    public static synchronized void sell(){
        if (ticket > 0) {
            try {
                Thread.sleep(10);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(Thread.currentThread().getName() + "卖出了" + ticket + "张票");
            ticket--;
        }
    }
}
public class WindowTest2 {
    public static void main(String[] args) {
        Window1 w1 = new Window1();
        Window1 w2 = new Window1();
        Window1 w3 = new Window1();
        w1.setName("窗口一");
        w2.setName("窗口二");
        w3.setName("窗口三");

        w1.start();
        w2.start();
        w3.start();

    }
}
```

+ lock锁

```java
class Window2 implements Runnable{
    //共享数据
    private int ticket = 100;

    private Object object = new Object();
    //实例一个ReentrantLock锁，参数为是否开启先进先出（lock也得保证是唯一的才有用）
    private ReentrantLock lock = new ReentrantLock(true);

    @Override
    public void run() {

        while(true){
            try {
                lock.lock();
                if (ticket > 0) {
                    try {
                        Thread.sleep(10);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    System.out.println(Thread.currentThread().getName() + "卖出了" + ticket + "张票");
                    ticket--;
                } else {
                    break;
                }
            } finally {
                lock.unlock(); //关闭同步锁
            }
        }
    }
}

public class WindowTest3 {
    public static void main(String[] args) {
        Window2 window = new Window2();

        Thread t1 = new Thread(window);
        t1.setName("窗口一");
        Thread t2 = new Thread(window);
        t2.setName("窗口二");
        Thread t3 = new Thread(window);
        t3.setName("窗口三");

        t1.start();
        t2.start();
        t3.start();

    }
}
```

#### 3.3notify和wait的使用

##### 3.3.1说明

+ notify和wait是定义在Object类中的，而不是在Thread类中的

+ notify和wait必须放在synchronize的代码块或方法中配套使用

+ lock不是用notify和wait实现通讯的

+ notify和wait的调用者必须是同步监听器

##### 3.3.2示例

```java
class Number implements Runnable{
    private int i = 1;
    @Override
    public void run() {
        while (true){

            synchronized (this) {
                //随机唤醒一个被wait阻塞的线程
                notify();
                //notifyAll，唤醒所有被wait阻塞的线程

                if (i <= 100){
                    try {
                        Thread.sleep(10);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }

                    System.out.println(Thread.currentThread().getName() + " :  " +i);
                    i++;
                }else {
                    break;
                }

                //释放同步监听器，当前线程进入阻塞状态（sleep不会释放监听器），等待notify的唤醒
                try {
                    wait();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }


        }
    }
}
public class Communication {

    public static void main(String[] args) {
        Number number = new Number();
        Thread t1 = new Thread(number);
        Thread t2 = new Thread(number);

        t1.start();
        t2.start();
    }

}

```

##### 3.3.3经典生产售卖问题

```java
//用栈模拟售卖店，连接工厂生产和顾客购买
class SynStack{
    private int cnt = 0;
    private char[] date = new char[6];

    //由于一下两个方法是在同一个类里的，所以两个锁的同步监听器是相同的，不能同时执行
    public synchronized void push(char ch){
        while (cnt == date.length){
            try{
                this.wait();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
        //共享数据
        date[cnt] = ch;
        cnt++;
        System.out.printf("生产线程正在生产第%d个产品：%c\n", cnt, ch);
        //成功生成了一个，可以唤醒下方法继续售卖
        this.notify();
    }
    public synchronized void pop(){
        while(0 == cnt){
            try{
                this.wait();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
        char ch = date[cnt-1];
        System.out.printf("消费线程正在消费第%d个产品：%c\n", cnt, ch);
        cnt--;
        //成功出售，可以唤醒上方法继续生产
        this.notify();
    }
}
class Producer implements Runnable{
    private SynStack ss = null;
    public Producer(SynStack ss){
        this.ss = ss;
    }
    @Override
    public void run(){
        for(int i=0; i<20; ++i){

            try{
                Thread.sleep(50);
            }
            catch(Exception e){
                e.printStackTrace();
            }



            char ch = (char)('a'+i);
            ss.push(ch);


        }

    }
}
class Consumer implements Runnable{
    private SynStack ss = null;
    public Consumer(SynStack ss){
        this.ss = ss;
    }
    @Override
    public void run(){
        for(int i=0; i<20; ++i){
            try{
                Thread.sleep(100);
            }
            catch(Exception e){
                e.printStackTrace();
            }

            ss.pop();
        }
    }
}
public class TestPC{

    public static void main(String[] args) {
        SynStack ss = new SynStack();
        Producer pp = new Producer(ss);
        Consumer cc = new Consumer(ss);

        Thread tt1 = new Thread(pp);
        tt1.start();

        Thread tt2 = new Thread(cc);
        tt2.start();
    }
}
```

#### 3.4解决懒汉式单例模式的线程安全问题

##### 3.4.1说明

+ 以下方法可以解决线程安全问题，但效率不高，可以尝试其他单例模式的写法
+ 写法二只能让后进来的线程不再等待，同时进来的几个线程还是要一个一个排队通过

##### 3.4.2代码演示

```java
public class Bank {
    private Bank(){};
    private static Bank instance = null;

    public static Bank getInstance(){
        //写法一，效率较低，可能会让同时进来的很多线程干等着
//        synchronized (Bank.class) {
//            if (null ==  instance){
//                instance = new Bank();
//            }
//            return instance;
//        }

        //写法二，效率稍高，可以让后进来一点的线程不用等了
        if (instance == null){
            synchronized (Bank.class) {
                if (null == instance){
                    instance = new Bank();
                }
            }
        }
        return instance;
    }
}
```

#### 3.5说明

+ 以上三种方法都可以解决线程安全问题，但降低了执行效率

+ lock和synchronize的异同

  + 相同点： 都解决了线程安全问题

  + 不同点：synchronized执行完代码块之后会自动释放同步监听器，lock要手动开关

    ​				lock方式jvm的调度更好，质量更高点

+ 优先顺序：

  lock-->synchronize代码块-->synchronize方法

### 4.死锁问题

#### 4.1产生原因

两个线程同时握着对方需要的同步锁，自己的逻辑没执行完没办法释放同步锁，于是就僵持住了，都没办法执行完线程

#### 4.2死锁模拟案例

```java
class A {
    public synchronized void foo(B b) { //同步监视器是a
        System.out.println(Thread.currentThread().getName() + "执行了A的foo方法");

        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println(Thread.currentThread().getName() + "握着a对象，企图那到b对象去执行B的last方法");
        b.last(); //执行完此方法才归还同步监视器a
    }

    public synchronized void last(){ //同步监视器是a
        System.out.println("A的last方法执行了");
    }
}

class B{
    public synchronized void foo(A a) { //同步监视器是b
        System.out.println(Thread.currentThread().getName() + "执行了B的foo方法");

        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println(Thread.currentThread().getName() + "握着b对象，企图那到a对象去执行A的last方法");
        a.last(); //执行完此方法才归还同步监视器b
    }

    public synchronized void last(){  //同步监视器是b
        System.out.println("B的last方法执行了");
    }
}

public class Deadlock implements Runnable{
    A a = new A();
    B b = new B();

    public void init(){
        Thread.currentThread().setName("主线程");
        a.foo(b);
        System.out.println("已进入主线程");
    }

    @Override
    public void run() {
        Thread.currentThread().setName("分线程");
        b.foo(a);
        System.out.println("已进入分线程");
    }

    public static void main(String[] args) {
        Deadlock deadlock = new Deadlock();
        Thread thread = new Thread(deadlock);
        thread.start();

        deadlock.init();
    }

}
```

#### 4.3解决方式

##### 4.3.1说明

准确来说不是解决方式，只是避免死锁的方式。因为我们为了线程安全加锁是必要的，一旦加锁就有可能出现死锁现象。

##### 4.3.2方法

+ 用合适的算法避免死锁

+ 少写synchronized，效率低还可能出现死锁
+ 少嵌套，嵌套的时候多注意

+++

## 二、集合

### 1.概述

集合、数组都是对多个数据进行存储操作的结构，简称Java容器。

  注意：此时的存储，主要指的是内存层面的存储，不涉及到持久化的存储（.txt,.jpg,.avi，数   据库中）

### 2.对比数组

#### 2.1数组的特点

+ 一旦初始化以后，其长度就确定了。

+ 数组一旦定义好，其元素的类型也就确定了。我们也就只能操作指定类型的数据了。需要存储多种类型的对象可用Object类型的数组

#### 2.2数组的劣势

+ 一旦初始化以后，其长度就不可修改。

+ 数组中提供的方法非常有限，对于添加、删除、插入数据等操作，非常不便，同时效率不高。

+ 数组没有现成的属性或方法可用于查看当前实际长度

+ 数组存储数据的特点：有序、可重复。对于无序、不可重复的需求，不能满足。

### 3.集合框架的介绍

> **Collection接口：单列集合，用来存储一个一个的对象**

> > List接口：存储有序的、可重复的数据。  -->“动态”数组

> > > ArrayList、LinkedList、Vector

> > Set接口：存储无序的、不可重复的数据   -->高中讲的“集合”

> > > HashSet、LinkedHashSet、TreeSet

> **Map接口：双列集合，用来存储一对(key - value)一对的数据   -->高中函数：y = f(x)**

> > HashMap、LinkedHashMap、TreeMap、Hashtable、Properties

### 4.Collection

#### 4.1Colection接口的基本方法

##### 4.1.1使用要求

自定义的类要重写equals方法，在Collection及其子类的各个方法中，涉及到比较两个元素异同都是用equals方法去比较

##### 4.1.2基本方法演示

```java
public class CollectionTest {

    @Test
    public void test1() {
        java.util.Collection<Object> coll = new ArrayList<Object>();

        //1、add(Object e):将元素e添加到集合coll中
        coll.add("AA");
        coll.add("BB");
        //自动装箱
        coll.add(123);
        coll.add(new Date());

        //2、size():获取添加的元素的个数
        System.out.println(coll.size());

        //3、addAll(Collection coll1):将coll1集合中的元素添加到当前的集合中
        java.util.Collection coll1 = new ArrayList();
        coll1.add(456);
        coll1.add("CC");
        coll.addAll(coll1);
        System.out.println(coll.size());
        System.out.println(coll);

        //4、clear():清空集合元素，集合还在，只是里面没东西
        coll.clear();

        //5、isEmpty():判断当前集合是否为空
        System.out.println(coll.isEmpty());

        //6.contains(Object obj):判断当前集合中是否包含obj
        //我们在判断时会调用obj对象所在类的equals()，自定义的类需要重写equals()方法
        boolean contains = coll.contains(123);
        System.out.println(contains);

        //7.containsAll(Collection coll1):判断形参coll1中的所有元素是否都存在于当前集合中。
        java.util.Collection coll2 = Arrays.asList(123,4567);
        System.out.println(coll.containsAll(coll1));

        //8、remove(Object obj):从当前集合中移除obj元素。
        //要先用equals方法在集合中找到对象才能移除
        coll.remove(1234);
        System.out.println(coll);

        //9、removeAll(Collection coll1):差集，从当前集合中移除coll1中所有的元素。
        java.util.Collection coll3 = Arrays.asList(123,456);
        //从coll中移除coll和coll3的交集中的所有元素
        coll.removeAll(coll1);
        System.out.println(coll);

        //10、retainAll(Collection coll1):交集：获取当前集合和coll1集合的交集，保留这些元素，其他全部移除（求交集）
//        Collection coll1 = Arrays.asList(123,456,789);
//        coll.retainAll(coll1);
//        System.out.println(coll);

        //11、equals(Object obj):要想返回true，需要当前集合和形参集合的元素完全相同。（注意可有序，可无序）
        java.util.Collection coll4 = new ArrayList();
        coll1.add(456);
        coll1.add(123);
        coll1.add(new String("Tom"));
        coll1.add(false);
        System.out.println(coll.equals(coll1));

        //12、hashCode():返回当前对象的哈希值
        System.out.println(coll.hashCode());

        //13、集合 --->数组：toArray()
        Object[] arr = coll.toArray();
        for(int i = 0;i < arr.length;i++){
            System.out.println(arr[i]);
        }

        //拓展：数组 --->集合:调用Arrays类的静态方法asList()
        List<String> list = Arrays.asList(new String[]{"AA", "BB", "CC"});
        System.out.println(list);

        //new int[]{123, 456}会被当成一个对象
        List arr1 = Arrays.asList(new int[]{123, 456});
        //值为1
        System.out.println(arr1.size());

        List arr2 = Arrays.asList(new Integer[]{123, 456});
        //值为2
        System.out.println(arr2.size());

        //14、iterator():返回Iterator接口的实例，用于遍历集合元素。下方单独演示
    }
}
```

##### 4.1.2使用iterator迭代器遍历

+ **说明**

  + 集合元素的遍历操作，使用迭代器Iterator接口（相当于一个指针在集合上从头移到尾）
  + 默认游标都在集合的第一个元素之前

  + iterator内部的方法：hasNext() 和  next()
  + 集合对象每次调用iterator()方法都得到一个全新的迭代器对象
  + iterator内部定义了remove(),可以在遍历的时候，删除集合中的元素。此方法不同于集合直接调用remove()

+ **代码演示**

```java
public void test1(){
    Collection coll = new ArrayList();
    coll.add(123);
    coll.add(456);
    coll.add(new String("Tom"));
    coll.add(false);

    Iterator iterator = coll.iterator();
    //方式一：
    System.out.println(iterator.next());
    System.out.println(iterator.next());
    System.out.println(iterator.next());
    System.out.println(iterator.next());
    System.out.println(iterator.next());
    //报异常：NoSuchElementException，指针移动越界了
    System.out.println(iterator.next());

    //方式二：不推荐，可以实现功能，但没有next和hasNext配套使用规范
    for(int i = 0;i < coll.size();i++){
        System.out.println(iterator.next());
    }

    //方式三：推荐
    //hasNext():判断是否还有下一个元素
    while(iterator.hasNext()){
        //next():①指针下移 ②将下移以后集合位置上的元素返回
        System.out.println(iterator.next());
    }

    //方式四：for（补充）
    for (Object object : coll) {
        System.out.println(object);
        //不会修改原集合中的元素
        object = "GG";
    }

}
```

+ **常见错误**

```java
public void test2(){

    Collection coll = new ArrayList();
    coll.add(123);
    coll.add(456);
    coll.add(new String("Tom"));
    coll.add(false);

    //错误一：
    Iterator iterator = coll.iterator();
    //此时next（）在一次循环中移动了两次，却只输出一次，第二次还可能会越界
    while((iterator.next()) != null){
        System.out.println(iterator.next());
    }

    //错误二：
    //集合对象每次调用iterator()方法都得到一个全新的迭代器对象，默认游标都在集合的第一个元素之前。
    while (coll.iterator().hasNext()){
        System.out.println(coll.iterator().next());
    }


}
```

+ **测试Iterator中的remove()**

```java
/*
  如果还未调用next()或在上一次调用 next 方法之后已经调用了 remove 方法，
  再调用remove都会报IllegalStateException。
*/
public void test3(){
    Collection coll = new ArrayList();
    coll.add(123);
    coll.add(456);
    coll.add(new String("Tom"));
    coll.add(false);

    //删除集合中"Tom"
    Iterator iterator = coll.iterator();
    while (iterator.hasNext()){
        //在调用next()之前指针还未后移，直接删除删不到东西
        //            iterator.remove();
        Object obj = iterator.next();
        if("Tom".equals(obj)){
            iterator.remove();
            //不可重复删除同一个元素
            //                iterator.remove();
        }

    }
    //遍历集合
    iterator = coll.iterator();
    while (iterator.hasNext()){
        System.out.println(iterator.next());
    }
}
```

#### 4.2List接口

##### 4.2.1实现类概述

+ ArrayList：作为List接口的主要实现类；线程不安全的，效率高；底层使用Object[] elementData存储

+ LinkedList：对于频繁的插入、删除操作，使用此类效率比ArrayList高；底层使用双向链表存储

+ Vector：作为List接口的古老实现类；线程安全的，效率低；底层使用Object[] elementData存储

##### 4.2.2ArrayList源码分析

+ **jdk7版本**

  + 创建对象：

    ArrayList list = new ArrayList();    在创建对象的时候，底层创建了长度是10的Object[]数组elementData

  + 添加元素方法：

    底层原理：list.add(123);//elementData[0] = new Integer(123);

  + 扩容：

    当底层数组满了之后会自动扩容，默认情况下，扩容为原来的容量的1.5倍，同时需要将原有数组中的数据复制到新的数组中。

+ **jdk8版本改进**

  + 创建对象：

    ArrayList list = new ArrayList();    在创建对象的时候，底层Object[] elementData初始化为{}，没有创建长度为10的数组

    list.add(123);//第一次调用add()时，底层才创建了长度10的数组，并将数据123添加到elementData[0]

  + 添加元素方法：

    和jdk7一样

  + 扩容

    和jdk7一样

+ **小结**

  + 建议开发中使用带参的构造器：ArrayList list = new ArrayList(int capacity)

    设置我们需要的长度的底层数组，减少自动扩容，既提高了效率，又可以减少资源的浪费

  + jdk7中的ArrayList的对象的创建类似于单例的饿汉式，而jdk8中的ArrayList的对的创建类似于单例的懒汉式，延迟了数组的创建，节省内存。

##### 4.2.3LinkedList的源码分析

+ 创建对象
  + LinkedList list = new LinkedList(); 内部声明了Node类型的first和last属性，默认值为null
+ 添加属性的方法
  + list.add(123);//将123封装到Node中，创建了Node对象。
+ Node类源码

```java
private static class Node<E> {
    E item;
    Node<E> next;
    Node<E> prev;

    Node(Node<E> prev, E element, Node<E> next) {
        this.item = element;
        this.next = next;
        this.prev = prev;
    }
}
```

##### 4.2.4Vector的源码分析

jdk7和jdk8中通过Vector()构造器创建对象时，底层都创建了长度为10的数组。在扩容方面，默认扩容为原来的数组长度的2倍。

##### 4.2.5小结

+ 三个类都是实现了List接口，存储数据的特点相同：存储有序的、可重复的数据

+ ArrayList是主要实现类，适用的场景较多，缺点是当集合中数据较多时，不利于增添或删除元素，效率会比较低，而LinkedList正好在这方面比较方便，所以增加删除操作频繁时多使用LinkedArrayList
+ Vector比较古老，甚至比Collection接口出现的都早，现在没怎么使用了。虽然线程安全，但是效率很低，当我们需要一个线程安全的List实现类对象时，可以使用Collections工具类的方法将ArrayList对象转成线程安全的对象使用。

##### 4.2.6List实现类的特有方法

```java
public class ListTest {

    @Test
    public void test1(){
        ArrayList list = new ArrayList();
        list.add(123);
        list.add(456);
        list.add("AA");
        list.add(456);
        //int indexOf(Object obj):返回obj在集合中首次出现的位置。如果不存在，返回-1.
        int index = list.indexOf(4567);
        System.out.println(index);

        //int lastIndexOf(Object obj):返回obj在当前集合中末次出现的位置。如果不存在，返回-1.
        System.out.println(list.lastIndexOf(456));

        //Object remove(int index):移除指定index位置的元素，并返回此元素
        Object obj = list.remove(0);
        System.out.println(obj);
        System.out.println(list);

        //Object set(int index, Object ele):设置指定index位置的元素为ele
        list.set(1,"CC");
        System.out.println(list);

        //List subList(int fromIndex, int toIndex):返回从fromIndex到toIndex位置的左闭右开区间的子集合
        java.util.List subList = list.subList(2, 4);
        System.out.println(subList);
        System.out.println(list);


    }


    @Test
    public void test2(){
        ArrayList<Object> list = new ArrayList();
        list.add(123);
        list.add(456);
        list.add("AA");
        list.add(456);

        System.out.println(list);

        //void add(int index, Object ele):在index位置插入ele元素
        list.add(1,"BB");
        System.out.println(list);

        //boolean addAll(int index, Collection eles):从index位置开始将eles中的所有元素添加进来
        List<Object> list1 = Arrays.asList(1, 2, 3);
        list.addAll(list1);
//        list.add(list1);
        System.out.println(list.size());//9

        //Object get(int index):获取指定index位置的元素
        System.out.println(list.get(0));
        

    }


}
```

#### 4.3set接口

##### 4.3.1实现类概述

+ HashSet：作为Set接口的主要实现类；线程不安全的；可以存储null值

  + LinkedHashSet：作为HashSet的子类；遍历其内部数据时，可以按照添加的顺序遍历

    对于频繁的遍历操作，LinkedHashSet效率高于HashSet.

+ TreeSet：可以按照添加对象的指定属性，进行排序。

##### 4.3.2方法说明

Set接口中没有额外定义新的方法，使用的都是Collection中声明过的方法。

##### 4.3.3使用要求     

*针对HashSet、LinkedHashSet*

+ 向Set中添加的数据，其所在的类一定要重写hashCode()和equals()

+ 重写的hashCode()和equals()尽可能保持一致性：相等的对象必须具有相等的散列码（这样根据哈希码可以直接判定俩对象不同，不用再到链表中比较，更高效）

+ 重写两个方法的小技巧：对象中用作 equals() 方法比较的 Field，都应该用来计算 hashCode 值。

##### 4.3.4Set的特性

+ 无序性：不等于随机性，无序性指的是底层存储的时候无序。底层存储的时候也是一个数组在存，但存储数据的时候并非按照数组索引的顺序添加，而是根据数据的哈希值决定在数组的位置存。
+ 不可重复性：保证添加的元素按照equals()判断时，不能返回true.即：相同的元素只能添加一个。

##### 4.3.5HashSet源码分析

+ **底层结构：**

  HashSet底层是一个HashMap，原理和HashMap一样

+ **添加元素的原理：**

  我们向HashSet中添加元素a,首先调用元素a所在类的hashCode()方法，计算元素a的哈希值，此哈希值接着通过某种算法计算出在HashSet底层数组中的存放位置（即为：索引位置），判断数组此位置上是否已经有元素：

  如果此位置上没有其他元素，则元素a添加成功。  --->情况1

  如果此位置上有其他元素b(或以链表形式存在的多个元素），则比较元素a与元素b的hash值：

  ​		如果hash值不相同，则元素a添加成功。--->情况2

  ​		如果hash值相同，进而需要调用元素a所在类的equals()方法：

  ​				equals()返回true,元素a添加失败

  ​				equals()返回false,则元素a添加成功。--->情况3

+ **说明：**

  对于添加成功的情况2和情况3而言：元素a 与已经存在指定索引位置上数据以链表的方式存储。

  jdk 7 :元素a放到数组中，指向原来的元素。（把数组中的元素挤出来）

  jdk 8 :原来的元素在数组中，指向元素a  （主动在数组外排队）

  **总结：**七上八下

##### 4.3.6LinkedHashSet源码分析

底层实现形式与HashSet相同，只是每个存放数据的结点新增两个属性，内容是添加元素时候前一个元素和后一个元素的引用（相当于C语言中双向链表的两个指针）

##### 4.3.7代码演示

```java
/*
  HashSet代码演示
*/
public void test1(){
    Set set = new HashSet();
    set.add(456);
    set.add(123);
    set.add(123);
    set.add("AA");
    set.add("CC");
    set.add(new User("Tom",12));
    set.add(new User("Tom",12));
    set.add(129);

    //必须同时重写User的equals和hashCode方法才能让两个User对象只有一个添加成功
    Iterator iterator = set.iterator();
    while(iterator.hasNext()){
        System.out.println(iterator.next());
    }
}

/*
  LinkedHashSet代码演示
  优点：对于频繁的遍历操作，LinkedHashSet效率高于HashSet
*/
public void test2(){
    Set set = new LinkedHashSet();
    set.add(456);
    set.add(123);
    set.add(123);
    set.add("AA");
    set.add("CC");
    set.add(new User("Tom",12));
    set.add(new User("Tom",12));
    set.add(129);

    Iterator iterator = set.iterator();
    while(iterator.hasNext()){
        System.out.println(iterator.next());
    }
}
```

##### 4.3.8自定义类对象的equals和hashCode方法重写演示

```java
@Override
public boolean equals(Object o) {
    if (this == o) {
        return true;
    }
    if (o == null || getClass() != o.getClass()) {
        return false;
    }
    User user = (User) o;
    return age == user.age &&
            Objects.equals(name, user.name);
}

@Override
public int hashCode() {
    return Objects.hash(name, age);
}
//Objects类中的hash方法
public static int hash(Object... values) {
    return Arrays.hashCode(values);
}
//Arrays的hashCode方法
public static int hashCode(Object a[]) {
    if (a == null)
        return 0;

    int result = 1;

    for (Object element : a)
        result = 31 * result + (element == null ? 0 : element.hashCode());

    return result;
}
```

##### 4.3.9TreeSet

###### 4.3.9.1底层结构

TreeSet底层是二叉树（红黑树）的结构

###### 4.3.9.2使用要求

+ 向TreeSet中添加的数据，要求是相同类的对象。

+ 两种排序方式：自然排序（实现Comparable接口） 和 定制排序（Comparator）
  + 自然排序中，比较两个对象是否相同的标准为：compareTo()返回0.不再是equals()
  + 定制排序中，比较两个对象是否相同的标准为：compare()返回0.不再是equals()

+ 当判断到TreeSet中存在元素和要添加的元素相同时，将执行替换操作，而不是添加失败

###### 4.3.9.3代码演示

```java
public void test1(){
    TreeSet set = new TreeSet();

    //失败：不能添加不同类的对象
    //set.add(123);
    //set.add(456);
    //set.add("AA");
    //set.add(new User("Tom",12));

    //举例一：
    //set.add(34);
    //set.add(-34);
    //set.add(43);
    //set.add(11);
    //set.add(8);

    //自然排序，要让自定义的类实现Comparable接口并重写compareTo方法，写入比较规则
    //举例二：
    set.add(new User("Tom",12));
    set.add(new User("Jerry",32));
    set.add(new User("Jim",2));
    set.add(new User("Mike",65));
    set.add(new User("Jack",33));
    set.add(new User("Jack",56));
    Iterator iterator = set.iterator();
    while(iterator.hasNext()){
        System.out.println(iterator.next());
    }

}

public void test2(){
    //定制排序中，把排序规则以内部类的方式写，并传入TreeSet的构造函数
    Comparator com = new Comparator() {
        //按照年龄从小到大排列
        @Override
        public int compare(Object o1, Object o2) {
            if(o1 instanceof User && o2 instanceof User){
                User u1 = (User)o1;
                User u2 = (User)o2;
                return -Integer.compare(u1.getAge(),u2.getAge());
            }else{
                throw new RuntimeException("输入的数据类型不匹配");
            }
        }
    };

    TreeSet set = new TreeSet(com);
    set.add(new User("Tom",12));
    set.add(new User("Jerry",32));
    set.add(new User("Jim",2));
    set.add(new User("Mike",65));
    set.add(new User("Mary",33));
    set.add(new User("Jack",33));
    set.add(new User("Jack",56));


    //Iterator iterator = set.iterator();
    //while(iterator.hasNext()){
    //System.out.println(iterator.next());
    //}
    //这么遍历也是可以的
    set.forEach(System.out::println);
}
```

###### 4.3.9.4自然排序的实体类演示

```java
/*
  Comparable接口可以传入泛型，为compareTo参数的类型
*/
public class User implements Comparable{
    private String name;
    private int age;

    public User() {
    }

    public User(String name, int age) {
        this.name = name;
        this.age = age;
    }

    @Override
    public int compareTo(Object o) {
        if (o instanceof User){
            User user = (User)o;
//            return this.name.compareTo(user.name);
            int result = name.compareTo(user.name);
            if (result == 0){
                return Integer.compare(this.age,user.age);
            }else{
                return result;
            }
        }else {
            throw new RuntimeException("类型不匹配");
        }
    }
}

//重写时间类型属性比较的compareTo方法
@Override
public int compareTo(Object o) {
    if(o instanceof MyDate){
        MyDate m = (MyDate)o;

        //比较年
        int minusYear = this.getYear() - m.getYear();
        if(minusYear != 0){
            return minusYear;
        }
        //比较月
        int minusMonth = this.getMonth() - m.getMonth();
        if(minusMonth != 0){
            return minusMonth;
        }
        //比较日
        return this.getDay() - m.getDay();
    }

    throw new RuntimeException("传入的数据类型不一致！");

}
```

##### 4.3.10经典面试题解析

​		将对象user1 = new User("张三", 1)和对象user2 = new User("李四", 2)放入集合hashSet中

​		再修改user1的"张三"为"张五"，此时对象信息改变（集合中查出来也是变的，C语言指针的知识）

​		但我们去remove(user1)会移除个寂寞，因为user1存储的时候计算hash值是按"张三"这个名字取计算了，修改名字再次计算hash值和原来不一样了

​		我们此时还可以向set中添加user3 = new User("张五", 1)，hash值和user1不一样，存储位置不一样

​		我们此时还可以向set中添加user4 = new User("张三", 1)，hash值和user1一样，存储位置一样，但equals方法执行结果显示两个对象不一样

### 5.Map

#### 5.1框架介绍

> Map:双列数据，存储key-value对的数据   ---类似于高中的函数：y = f(x)

> > HashMap:作为Map的主要实现类；线程不安全的，效率高；存储null的key和value

> > > LinkedHashMap:保证在遍历map元素时，可以按照添加的顺序实现遍历。
> > >
> > > 原理：在原有的HashMap底层结构基础上，添加了一对指针，指向前一个和后一个元素。
> > >
> > > 结论：对于频繁的遍历操作，此类执行效率高于HashMap。

> > TreeMap:保证按照添加的key-value对进行排序，实现排序遍历。此时考虑key的自然排序或定制排序
> >
> > 底层结构：红黑树

> > Hashtable:作为古老的实现类；线程安全的，效率低；不能存储null的key和value

> > > Properties:常用来处理配置文件。key和value都是String类型

#### 5.2底层源码分析

##### 5.2.1map结构的存储

+ Map中的key:无序的、不可重复的，使用Set存储所有的key  ---> key所在的类要重写equals()和hashCode() （以HashMap为例）

+ Map中的value:无序的、可重复的，使用Collection存储所有的value --->value所在的类要重写equals()

+ 一个键值对：key-value构成了一个Entry对象。

  Map中的entry:无序的、不可重复的，使用Set存储所有的entry

##### 5.2.2具体分析 （jdk7为例）

+ **创建对象：**

  HashMap map = new HashMap()    在实例化以后，底层创建了长度是16的一维数组Entry[] table。

+ **存储数据：**

  首先，新建一个entry对象，放入key1和value1,

  然后，调用key1所在类的hashCode()计算key1哈希值，此哈希值经过某种算法计算以后，得到在Entry数组中的存放位置。

  ​    如果此位置上的数据为空，此时的key1-value1添加成功。 -->情况1

  ​    如果此位置上的数据不为空，(意味着此位置上存在一个或多个数据(以链表形式存在)),比较   	key1和已经存在的一个或多个数据的哈希值：

  ​		如果key1的哈希值与已经存在的数据的哈希值都不相同，此时key1-value1添加成功。-->		情况2

  ​		如果key1的哈希值和已经存在的某一个数据(key2-value2)的哈希值相同，继续比较：调		用key1所在类的equals(key2)方法作比较：

  ​			如果equals()返回false:此时key1-value1添加成功。-->情况3

  ​			如果equals()返回true:使用value1替换value2。

+ **扩容问题**：

  在不断的添加过程中，会涉及到扩容问题，当超出临界值(且要存放的位置非空)时，扩容。默认的扩容方式：扩容为原来容量的2倍，并将原有的数据复制过来。

  + *说明：*

    临界值（map底层有两个临界值）：

    ​	DEFAULT_INITIAL_CAPACITY : HashMap的默认容量，16

    ​	DEFAULT_LOAD_FACTOR：HashMap的默认加载因子，0.75

    ​	TREEIFY_THRESHOLD：Bucket中链表长度大于该默认值，转化为红黑树:8

    当底层数组中某个位置上链表的长度大于TREEIFY_THRESHOLD时会进行自动扩容；

    当数组的使用率超过DEFAULT_LOAD_FACTOR时会进行自动扩容（map底层数组存储数据是无序的，使用率100%的可能性不大，经过大数据推算，算出0.75的值是比较适宜的）

##### 5.2.3底层源码中jdk8相对于jdk7的改进

+ 和ArrayList一样，new HashMap()的时候底层没有创建一个长度为16的数组，在第一次调用put方法时才创建
+ jdk 8底层的数组是：Node[],而非Entry[]
+ jdk7底层结构只有：数组+链表。jdk8中底层结构：数组+链表+红黑树。
  + 形成链表时，七上八下（jdk7:新的元素指向旧的元素。jdk8：旧的元素指向新的元素）
  + 当数组的某一个索引位置上的元素以链表形式存在的数据个数 > 8 且当前数组的长度 > 64时，此时此索引位置上的所数据改为使用红黑树存储。

##### 5.2.4LinkedHashMap源码中的Entry对象

```java
static class Entry<K,V> extends HashMap.Node<K,V> {
    Entry<K,V> before, after;//能够记录添加的元素的先后顺序
    Entry(int hash, K key, V value, Node<K,V> next) {
        super(hash, key, value, next);
    }
}
```

#### 5.3Map接口中定义的方法

+ **添加、删除、修改操作：**

  Object put(Object key,Object value)：将指定key-value添加到(或修改)当前map对象中

  void putAll(Map m):将m中的所有key-value对存放到当前map中

  Object remove(Object key)：移除指定key的key-value对，并返回value

  void clear()：清空当前map中的所有数据

**代码演示**

```javascript
public void test3(){
    Map map = new HashMap();
    //添加
    map.put("AA",123);
    map.put(45,123);
    map.put("BB",56);
    //修改（替换）
    map.put("AA",87);
    //这种操作是允许的
    map.put(null,123);

    System.out.println(map);

    Map map1 = new HashMap();
    map1.put("CC",123);
    map1.put("DD",123);

    map.putAll(map1);

    System.out.println(map);

    //remove(Object key)
    Object value = map.remove("CC");
    System.out.println(value);
    System.out.println(map);

    //clear()
    map.clear();//与map = null操作不同
    System.out.println(map.size());
    System.out.println(map);
}
```

+ **元素查询的操作**：

  Object get(Object key)：获取指定key对应的value

  boolean containsKey(Object key)：是否包含指定的key

  boolean containsValue(Object value)：是否包含指定的value

  int size()：返回map中key-value对的个数

  boolean isEmpty()：判断当前map是否为空

  boolean equals(Object obj)：判断当前map和参数对象obj是否相等

```java
public void test4(){
    Map map = new HashMap();
    map.put("AA",123);
    map.put(45,123);
    map.put("BB",56);
    // Object get(Object key)
    System.out.println(map.get(45));
    //containsKey(Object key)
    boolean isExist = map.containsKey("BB");
    System.out.println(isExist);

    isExist = map.containsValue(123);
    System.out.println(isExist);

    map.clear();

    System.out.println(map.isEmpty());

}
```

+ **视图操作的方法：**

  Set keySet()：返回所有key构成的Set集合

  Collection values()：返回所有value构成的Collection集合

  Set entrySet()：返回所有key-value对构成的Set集合

```java
public void test5(){
    Map map = new HashMap();
    map.put("AA",123);
    map.put(45,1234);
    map.put("BB",56);

    //遍历所有的key集：keySet()
    Set set = map.keySet();
    Iterator iterator = set.iterator();
    while(iterator.hasNext()){
        System.out.println(iterator.next());
    }
    
    //遍历所有的value集：values()
    Collection values = map.values();
    for(Object obj : values){
        System.out.println(obj);
    }
    System.out.println();
    
    
    //遍历所有的key-value
    //方式一：entrySet()
    Set entrySet = map.entrySet();
    Iterator iterator1 = entrySet.iterator();
    while (iterator1.hasNext()){
        Object obj = iterator1.next();
        //entrySet集合中的元素都是entry
        Map.Entry entry = (Map.Entry) obj;
        System.out.println(entry.getKey() + "---->" + entry.getValue());

    }
    System.out.println();
    //方式二：
    Set keySet = map.keySet();
    Iterator iterator2 = keySet.iterator();
    while(iterator2.hasNext()){
        Object key = iterator2.next();
        Object value = map.get(key);
        System.out.println(key + "=====" + value);

    }

}
```

#### 5.4常用方法总结

+ 添加：put(Object key,Object value)
+ 删除：remove(Object key)
+ 修改：put(Object key,Object value)
+ 查询：get(Object key)
+ 长度：size()
+ 遍历：keySet() / values() / entrySet()

#### 5.5TreeMap

##### 5.5.1说明

和TreeSet的底层实现和使用大致一样

##### 5.5.2代码演示

```java
public class TreeMapTest {

    //向TreeMap中添加key-value，要求key必须是由同一个类创建的对象
    //因为要按照key进行排序：自然排序 、定制排序
    //自然排序
    @Test
    public void test1(){
        TreeMap map = new TreeMap();
        User u1 = new User("Tom",23);
        User u2 = new User("Jerry",32);
        User u3 = new User("Jack",20);
        User u4 = new User("Rose",18);

        map.put(u1,98);
        map.put(u2,89);
        map.put(u3,76);
        map.put(u4,100);

        Set entrySet = map.entrySet();
        Iterator iterator1 = entrySet.iterator();
        while (iterator1.hasNext()){
            Object obj = iterator1.next();
            Map.Entry entry = (Map.Entry) obj;
            System.out.println(entry.getKey() + "---->" + entry.getValue());

        }
    }

    //定制排序
    @Test
    public void test2(){
        TreeMap map = new TreeMap(new Comparator() {
            @Override
            public int compare(Object o1, Object o2) {
                if(o1 instanceof User && o2 instanceof User){
                    User u1 = (User)o1;
                    User u2 = (User)o2;
                    return Integer.compare(u1.getAge(),u2.getAge());
                }
                throw new RuntimeException("输入的类型不匹配！");
            }
        });
        User u1 = new User("Tom",23);
        User u2 = new User("Jerry",32);
        User u3 = new User("Jack",20);
        User u4 = new User("Rose",18);

        map.put(u1,98);
        map.put(u2,89);
        map.put(u3,76);
        map.put(u4,100);

        Set entrySet = map.entrySet();
        Iterator iterator1 = entrySet.iterator();
        while (iterator1.hasNext()){
            Object obj = iterator1.next();
            Map.Entry entry = (Map.Entry) obj;
            System.out.println(entry.getKey() + "---->" + entry.getValue());

        }
    }


}
```

#### 5.6Properties

##### 5.6.1实际应用

常用来处理配置文件，key和value都是String类型。例如将数据库连接信息写到配置文件中，再导入进行数据库连接配置。

##### 5.6.2配置文件写法

```properties
driver=com.mysql.jdbc.Driver
url=jdbc:mysql://localhost:3306/ssm?useSSL=true&useUnicode=true&characterEncoding=UTF-8
username=root
password=abc369
```

*注意：不要加多余的空格或者符号*

##### 5.6.3代码演示

```java
public class PropertiesTest {
    public static void main(String[] args)  {
        FileInputStream fis = null;
        try {
            Properties pros = new Properties();

            //默认在工程下查找，若是在单元测试类中写则默认在模块中找
            fis = new FileInputStream("jdbc.properties");
            //加载流对应的文件
            pros.load(fis);

            String name = pros.getProperty("name");
            String password = pros.getProperty("password");

            System.out.println("name = " + name + ", password = " + password);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if(fis != null){
                try {
                    //注意流的关闭
                    fis.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }

            }
        }

    }
}
```

### 6.Collections工具类

#### 6.1说明

虽然看起来像只能操作Collection接口实现类的工具类，但Collections中定义了一些可以操作Map接口实现类的方法，如将HashMap的对象转化成线程安全的对象的方法

#### 6.2方法总览

+ **reverse(List)**：反转 List 中元素的顺序

+ **shuffle(List)**：对 List 集合元素进行随机排序

+ **sort(List)**：根据元素的自然顺序对指定 List 集合元素按升序排序

+ **sort(List，Comparator)**：根据指定的 Comparator 产生的顺序对 List 集合元素进行排序

+ **swap(List，int， int)**：将指定 list 集合中的 i 处元素和 j 处元素进行交换

+ **Object max(Collection)**：根据元素的自然顺序，返回给定集合中的最大元素

+ **Object max(Collection，Comparator)**：根据 Comparator 指定的顺序，返回给定集合中的最大元素

+ **Object min(Collection)**

+ **Object min(Collection，Comparator)**

+ **int frequency(Collection，Object)**：返回指定集合中指定元素的出现次数

+ **void copy(List dest,List src)**：将src中的内容复制到dest中

+ **boolean replaceAll(List list，Object oldVal，Object newVal)**：使用新值替换 List 对象的所有旧值

#### 6.3代码演示

```java
@Test
public void test2(){
    List list = new ArrayList();
    list.add(123);
    list.add(43);
    list.add(765);
    list.add(-97);
    list.add(0);

    //报异常：IndexOutOfBoundsException("Source does not fit in dest")
    //原因dest中的有效元素个数不能比src中的少
    //List dest = new ArrayList();
    //Collections.copy(dest,list);
    
    //正确的：
    List dest = Arrays.asList(new Object[list.size()]);
    System.out.println(dest.size());//list.size();
    Collections.copy(dest,list);

    System.out.println(dest);


    /*
        Collections 类中提供了多个 synchronizedXxx() 方法，
        该方法可使将指定集合包装成线程同步的集合，从而可以解决
        多线程并发访问集合时的线程安全问题

         */
    //返回的list1即为线程安全的List
    List list1 = Collections.synchronizedList(list);


}

@Test
public void test1(){
    List list = new ArrayList();
    list.add(123);
    list.add(43);
    list.add(765);
    list.add(765);
    list.add(765);
    list.add(-97);
    list.add(0);

    System.out.println(list);

    Collections.reverse(list);
    Collections.shuffle(list);
    Collections.sort(list);
    Collections.swap(list,1,2);
    int frequency = Collections.frequency(list, 123);

    System.out.println(list);
    System.out.println(frequency);

}
```

+++

## 三、IO流

### 1.File

#### 1.1概述

+ File类声明在java.io包下

+ File类的一个对象，代表一个文件或一个文件目录(俗称：文件夹)

+ File类中涉及到关于文件或文件目录的创建、删除、重命名、修改时间、文件大小等方法，并未涉及到写入或读取文件内容的操作。如果需要读取或写入文件内容，必须使用IO流来完成。

+ 后续File类的对象常会作为参数传递到流的构造器中，指明读取或写入的"终点".

#### 1.2创建对象

##### 1.2.1方法

+ File(String filePath)
+ File(String parentPath,String childPath)
+ File(File parentFile,String childPath)

##### 1.2.2代码演示

```java
public void test1(){
    //构造器1
    //因为是在单元测试类中写此方法，所以是相对于当前module，如果在main方法中写的话，是相对于当前工程
    File file1 = new File("hello.txt");
    File file2 =  new File("D:\\training\\java-senior\\io\\he.txt");

    System.out.println(file1);
    System.out.println(file2);

    //构造器2：
    File file3 = new File("D:\\training\\java-senior","java-senior");
    System.out.println(file3);

    //构造器3：
    File file4 = new File(file3,"hi.txt");
    System.out.println(file4);
}
```

##### 1.2.3说明

+ **路径问题**

  相对路径：相较于某个路径下，指明的路径。

  *单元测试方法中是相对于模块，main方法中是相对于工程*

  绝对路径：包含盘符在内的文件或文件目录的路径

+ **路径分隔符**

  windows:\\

  unix:/

#### 1.3File的方法

##### 1.3.1总览

```java
/*
    public String getAbsolutePath(); 获取绝对路径
    public String getPath();  获取路径
    public String getName();  获取名称
    public String getParent();  获取上层文件目录路径。若无，返回null
    public long length();  获取文件长度（即：字节数）。不能获取目录的长度。
    public long lastModified();  获取最后一次的修改时间，毫秒值
*/
@Test
public void test2(){
    File file2 = new File("d:\\io\\hi.txt");

    System.out.println(file2.getAbsolutePath());
    System.out.println(file2.getPath());
    System.out.println(file2.getName());
    System.out.println(file2.getParent());
    System.out.println(file2.length());
    System.out.println(file2.lastModified());
}

/*
    如下的两个方法适用于文件目录
    public String[] list();  获取指定目录下的所有文件或者文件目录的名称数组
    public File[] listFiles();  获取指定目录下的所有文件或者文件目录的File数组
*/
@Test
public void test3(){
    File file = new File("D:\\workspace_idea1\\JavaSenior");

    String[] list = file.list();
    for(String s : list){
        System.out.println(s);
    }

    System.out.println();

    File[] files = file.listFiles();
    for(File f : files){
        System.out.println(f);
    }

}
   
/*
    比如：file1.renameTo(file2)为例：
       要想保证返回true,需要file1在硬盘中是存在的，且file2不能在硬盘中存在。
    public boolean renameTo(File dest);  把文件重命名为指定的文件路径
*/
@Test
public void test4(){
    File file1 = new File("hello.txt");
    File file2 = new File("D:\\io\\hi.txt");

    boolean renameTo = file2.renameTo(file1);
    System.out.println(renameTo);

}

/*
    public boolean isDirectory()：判断是否是文件目录
    public boolean isFile() ：判断是否是文件
    public boolean exists() ：判断是否存在
    public boolean canRead() ：判断是否可读
    public boolean canWrite() ：判断是否可写
    public boolean isHidden() ：判断是否隐藏

*/
@Test
public void test5(){
    File file1 = new File("hello.txt");

    System.out.println(file1.isDirectory());
    System.out.println(file1.isFile());
    System.out.println(file1.exists());
    System.out.println(file1.canRead());
    System.out.println(file1.canWrite());
    System.out.println(file1.isHidden());

    System.out.println();

    File file2 = new File("d:\\io");
    file2 = new File("d:\\io1");
    System.out.println(file2.isDirectory());
    System.out.println(file2.isFile());
    System.out.println(file2.exists());
    System.out.println(file2.canRead());
    System.out.println(file2.canWrite());
    System.out.println(file2.isHidden());

}

/*
    创建硬盘中对应的文件或文件目录
    public boolean createNewFile() ：创建文件。若文件存在，则不创建，返回false
    public boolean mkdir() ：创建文件目录。如果此文件目录存在，就不创建了。如果此文件目录的上层目录不存在，也不创建。
    public boolean mkdirs() ：创建文件目录。如果此文件目录存在，就不创建了。如果上层文件目录不存在，一并创建

    删除磁盘中的文件或文件目录
    public boolean delete()：删除文件或者文件夹
    删除注意事项：Java中的删除不走回收站。
*/
@Test
public void test6() throws IOException {
    File file1 = new File("hi.txt");
    if(!file1.exists()){
        //文件的创建
        file1.createNewFile();
        System.out.println("创建成功");
    }else{//文件存在
        file1.delete();
        System.out.println("删除成功");
    }


}
@Test
public void test7(){
    //文件目录的创建
    File file1 = new File("d:\\io\\io1\\io3");

    boolean mkdir = file1.mkdir();
    if(mkdir){
        System.out.println("创建成功1");
    }

    File file2 = new File("d:\\io\\io1\\io4");

    boolean mkdir1 = file2.mkdirs();
    if(mkdir1){
        System.out.println("创建成功2");
    }
    //要想删除成功，io4文件目录下不能有子目录或文件
    File file3 = new File("D:\\io\\io1\\io4");
    file3 = new File("D:\\io\\io1");
    System.out.println(file3.delete());
}
```

### 2.流的概述

#### 2.1流的分类

+ 操作数据单位：字节流、字符流
+ 数据的流向：输入流、输出流
+ 流的角色：节点流、处理流

#### 2.2流的体系结构

```java
  抽象基类                节点流（或文件流）                         缓冲流（处理流的一种）
InputStream     FileInputStream(read(byte[] buffer))           BufferedInputStream 	  																	(read(byte[] buffer))
OutputStream            FileOutputStream                       BufferedOutputStream 	
			      (write(byte[] buffer,0,len) 		(write(byte[] buffer,0,len) / flush()	Reader          FileReader (read(char[] cbuf))                 BufferedReader 																(read(char[] cbuf) / readLine())
  Writer          FileWriter (write(char[] cbuf,0,len)           BufferedWriter 															  (write(char[] cbuf,0,len) / flush()
```

### 3.基础字符流---节点流

#### 3.1实现读取文件，输出到控制台

```java
/**
    说明点：
    1. read()的理解：返回读入的一个字符。如果达到文件末尾，返回-1
    2. 异常的处理：为了保证流资源一定可以执行关闭操作。需要使用try-catch-finally处理
    3. 读入的文件一定要存在，否则就会报FileNotFoundException。

 */
    @Test
    public void testFileReader(){
        FileReader fr = null;
        try {
            //1.实例化File类的对象，指明要操作的文件
            //相较于当前Module
            File file = new File("hello.txt");
            //2.提供具体的流
            fr = new FileReader(file);

            //3.数据的读入并输出
            //方式一
            //read():返回读入的一个字符。如果达到文件末尾，返回-1
            int data;
            while((data = fr.read()) != -1){
                System.out.print((char)data);
            }
            //方式二
            //read(char[] cbuf):返回每次读入cbuf数组中的字符的个数。如果达到文件末尾，返回-1
            char[] cbuf = new char[5];
            int len;
            while((len = fr.read(cbuf)) != -1){
                
                //将读入的数据输出到控制台
                //方式一：
                //错误的写法，不一定每次读取的数据都可以填满数组cbuf
//                for(int i = 0;i < cbuf.length;i++){
//                    System.out.print(cbuf[i]);
//                }
                //正确的写法
//                for(int i = 0;i < len;i++){
//                    System.out.print(cbuf[i]);
//                }
                //方式二：
                //错误的写法,对应着方式一的错误的写法，原因和上方一样
//                String str = new String(cbuf);
//                System.out.print(str);
                //正确的写法
                String str = new String(cbuf,0,len);
                System.out.print(str);
            }
        } catch 
                
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if(fr != null){
                try {
                    fr.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

    }
```

#### 3.2写入文件操作

##### 3.2.1说明

+ 读取操作若文件不存在会报异常；输出操作则不会，若文件不存在会自动创建

+ FileWriter构造器     第二个参数是append*（是否追加）*

  如果流使用的构造器是：FileWriter(file,false) / FileWriter(file):对原有文件的覆盖

  如果流使用的构造器是：FileWriter(file,true):不会对原有文件覆盖，而是在原有文件基础上追加内容

##### 3.2.2代码演示

```java
@Test
public void testFileWriter() {
    FileWriter fw = null;
    try {
        //1.提供File类的对象，指明写出到的文件
        File file = new File("hello1.txt");

        //2.提供FileWriter的对象，用于数据的写出
        fw = new FileWriter(file,false);

        //3.写出的操作
        //这里可以直接加‘/n’进行换行
        fw.write("I have a dream!\n");
        fw.write("you need to have a dream!");
    } catch (IOException e) {
        e.printStackTrace();
    } finally {
        //4.流资源的关闭
        if(fw != null){

            try {
                fw.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }


}
```

#### 3.3文件复制

```java
 @Test
    public void testFileReaderFileWriter() {
        FileReader fr = null;
        FileWriter fw = null;
        try {
            //1.创建File类的对象，指明读入和写出的文件
            File srcFile = new File("hello.txt");
            File destFile = new File("hello2.txt");

            //不能使用字符流来处理图片等字节数据
//            File srcFile = new File("爱情与友情.jpg");
//            File destFile = new File("爱情与友情1.jpg");


            //2.创建输入流和输出流的对象
            fr = new FileReader(srcFile);
            fw = new FileWriter(destFile);


            //3.数据的读入和写出操作
            char[] cbuf = new char[5];
            int len;//记录每次读入到cbuf数组中的字符的个数
            while((len = fr.read(cbuf)) != -1){
                //每次写出len个字符
                fw.write(cbuf,0,len);

            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            //4.关闭流资源
            //方式一：
            try {
                if(fw != null)
                    fw.close();
            } catch (IOException e) {
                e.printStackTrace();
            }finally{
                try {
                    if(fr != null)
                        fr.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
     

        }

    }
```

### 4.基础字节流 --节点流

#### 4.1实现读取文件，输出到控制台

```java
/*
   读取文件和输出内容中间的缓冲字节数组的长度设置不合适容易让中文在传输过程解码出错，导致中文乱码问题
*/
@Test
public void testFileInputStream() {
    FileInputStream fis = null;
    try {
        //1. 造文件
        File file = new File("hello.txt");

        //2.造流
        fis = new FileInputStream(file);

        //3.读数据
        byte[] buffer = new byte[5];
        int len;//记录每次读取的字节的个数
        while((len = fis.read(buffer)) != -1){

            String str = new String(buffer,0,len);
            System.out.print(str);

        }
    } catch (IOException e) {
        e.printStackTrace();
    } finally {
        if(fis != null){
            //4.关闭资源
            try {
                fis.close();
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
    }

}
```

#### 4.2实现复制文件

##### 4.2.1代码演示

```java
@Test
public void testFileInputOutputStream()  {
    FileInputStream fis = null;
    FileOutputStream fos = null;
    try {
        //造文件对象
        File srcFile = new File("爱情与友情.jpg");
        File destFile = new File("爱情与友情2.jpg");

        //造流通道
        fis = new FileInputStream(srcFile);
        fos = new FileOutputStream(destFile);

        //复制的过程
        byte[] buffer = new byte[5];
        int len;
        while((len = fis.read(buffer)) != -1){
            fos.write(buffer,0,len);
        }

    } catch (IOException e) {
        e.printStackTrace();
    } finally {
        //注意要保证出异常了还能关闭流
        //写法一
        if(fos != null){
            //
            try {
                fos.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        if(fis != null){
            try {
                fis.close();
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
        //写法二
        if(fos != null){
            //
            try {
                fos.close();
            } catch (IOException e) {
                e.printStackTrace();
            }finally{
                if(fis != null){
            		try {
                		fis.close();
            	} catch (IOException e) {
                	e.printStackTrace();
           		}

        }
            }
        }
       
    }

}
```

##### 4.2.2说明

若程序中出现多次类似的文件操作，可以文件操作的逻辑抽取出来作为工具类的方法

### 5.小结

+ 流的选择

  对于文本文件(.txt,.java,.c,.cpp)，使用字符流处理

  对于非文本文件(.jpg,.mp3,.mp4,.avi,.doc,.ppt,...)，使用字节流处理

+ 字节流实现文本文件的复制是不会出现中文乱码问题的，但如果中途在控制台将其分段输出就容易出现中文乱码问题

+ 复制非文本文件不要使用字符流，会出事的

### 6.缓冲流---处理流

#### 6.1常用缓冲流

BufferedInputStream

BufferedOutputStream

BufferedReader

BufferedWriter

#### 6.2优势

提供流的读取、写入的速度

原因：内部提供了一个缓冲区（会自动刷新）

#### 6.3使用

处理流，就是“套接”在已有的流的基础上。对原来流有增强或者增加功能的效果

#### 6.4非文本文件的复制

```java
@Test
public void BufferedStreamTest() throws FileNotFoundException {
    BufferedInputStream bis = null;
    BufferedOutputStream bos = null;

    try {
        //1.造文件
        File srcFile = new File("爱情与友情.jpg");
        File destFile = new File("爱情与友情3.jpg");
        //2.造流
        //2.1 造节点流
        FileInputStream fis = new FileInputStream((srcFile));
        FileOutputStream fos = new FileOutputStream(destFile);
        //2.2 造缓冲流（给节点流套上一层处理流）
        bis = new BufferedInputStream(fis);
        bos = new BufferedOutputStream(fos);

        //3.复制的细节：读取、写入
        byte[] buffer = new byte[10];
        int len;
        while((len = bis.read(buffer)) != -1){
            bos.write(buffer,0,len);

            //缓冲区满了之后会刷新缓冲区，我们也可以显示的在未满时候手动刷新
            //bos.flush();

        }
    } catch (IOException e) {
        e.printStackTrace();
    } finally {
        //4.资源关闭
        //要求：先关闭外层的流，再关闭内层的流
        if(bos != null){
            try {
                bos.close();
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
        if(bis != null){
            try {
                bis.close();
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
        //说明：关闭外层流的同时，内层流也会自动的进行关闭。关于内层流的关闭，我们可以省略.
        //        fos.close();
        //        fis.close();
    }
```

#### 6.5文本文件的复制

```java
/**
    使用BufferedReader和BufferedWriter实现文本文件的复制

*/
@Test
public void testBufferedReaderBufferedWriter(){
    BufferedReader br = null;
    BufferedWriter bw = null;
    try {
        //创建文件和相应的流
        br = new BufferedReader(new FileReader(new File("dbcp.txt")));
        bw = new BufferedWriter(new FileWriter(new File("dbcp1.txt")));

        //读写操作
        //方式一：使用char[]数组
        //char[] cbuf = new char[1024];
        //int len;
        //while((len = br.read(cbuf)) != -1){
        //    bw.write(cbuf,0,len);
        //    bw.flush();
        //}

        //方式二：使用String
        String data;
        while((data = br.readLine()) != null){
            //方法一：
            //bw.write(data + "\n");//data中不包含换行符
            //方法二：
            //data中不包含换行符
            bw.write(data);
            //不会自动换行，手动提供换行的操作
            bw.newLine();

        }
    } catch (IOException e) {
        e.printStackTrace();
    } finally {
        //关闭资源
        if(bw != null){

            try {
                bw.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        if(br != null){
            try {
                br.close();
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
    }

}
```

### 7.转换流---处理流

#### 7.1概述

+ InputStreamReader：将一个字节的输入流转换为字符的输入流
+ OutputStreamWriter：将一个字符的输出流转换为字节的输出流
+ 转换过程中将涉及到编码的问题

#### 7.2使用

+ **作用：**提供字节流与字符流之间的转换

+ **解码：**字节、字节数组  --->字符数组、字符串      *InputStreamReader*

+ **编码：**字符数组、字符串 ---> 字节、字节数组      OutputStreamWriter

#### 7.3字符集

+ **ASCII**：美国标准信息交换码。用一个字节的7位可以表示。
+ **ISO8859-1**：拉丁码表。欧洲码表用一个字节的8位表示。
+ **GB2312**：中国的中文编码表。最多两个字节编码所有字符

+ **GBK**：中国的中文编码表升级，融合了更多的中文文字符号。最多两个字节编码

+ **Unicode**：国际标准码，融合了目前人类使用的所有字符。为每个字符分配唯一的字符码。所有的文字都用两个字节来表示。         *英文字母用两个字节有点浪费，作为国际编码集又不太够用*
+ **UTF-8**：变长的编码方式，可用1-4个字节来表示一个字符。   中文用三个字节

#### 7.4代码演示

```java
@Test
public void test2() throws Exception {
    //1.造文件、造流
    File file1 = new File("dbcp.txt");
    File file2 = new File("dbcp_gbk.txt");

    FileInputStream fis = new FileInputStream(file1);
    FileOutputStream fos = new FileOutputStream(file2);

    //第二个参数不传值则使用默认的编码集
    //InputStreamReader具体使用什么编码集进行解码取决于该文件编码的时候使用了什么编码集
    InputStreamReader isr = new InputStreamReader(fis,"utf-8");
    //OutputStreamWriter想用什么编码集就用什么编码集，打开文件的时候设置一样的就行
    OutputStreamWriter osw = new OutputStreamWriter(fos,"gbk");

    //2.读写过程
    char[] cbuf = new char[20];
    int len;
    while((len = isr.read(cbuf)) != -1){
        osw.write(cbuf,0,len);
    }

    //3.关闭资源
    isr.close();
    osw.close();


}
```

### 8.其他流（略写）

#### 8.1标准的输入、输出流

##### 8.1.1默认

+ System.in:标准的输入流，默认从键盘输入

+ System.out:标准的输出流，默认从控制台输出

##### 8.1.2手动设置

System类的setIn(InputStream is) / setOut(PrintStream ps)方式重新指定输入和输出的流。

##### 8.1.3练习案例：

+ **描述**

  从键盘输入字符串，要求将读取到的整行字符串转成大写输出。然后继续进行输入操作，直至当输入“e”或者“exit”时，退出程序。

+ **思路**

  + 使用Scanner实现，调用next()返回一个字符串
  + 使用System.in实现。System.in  --->BufferedReader的readLine()

+ **代码实现**

```java
//第一种方法比较简单，第二种方法演示如下
public static void main(String[] args) {
    BufferedReader br = null;
    try {
        InputStreamReader isr = new InputStreamReader(System.in);
        br = new BufferedReader(isr);

        while (true) {
            System.out.println("请输入字符串：");
            String data = br.readLine();
            if ("e".equalsIgnoreCase(data) || "exit".equalsIgnoreCase(data)) {
                System.out.println("程序结束");
                break;
            }

            String upperCase = data.toUpperCase();
            System.out.println(upperCase);

        }
    } catch (IOException e) {
        e.printStackTrace();
    } finally {
        if (br != null) {
            try {
                br.close();
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
    }
}
```

#### 8.2打印流

##### 8.2.1具体流

PrintStream 和PrintWriter    *提供了一系列重载的print() 和 println()*

##### 8.2.2案例演示

```java
@Test
public void test2() {
    PrintStream ps = null;
    try {
        FileOutputStream fos = new FileOutputStream(new File("D:\\IO\\text.txt"));
        // 创建打印输出流,设置为自动刷新模式(写入换行符或字节 '\n' 时都会刷新输出缓冲区)
        ps = new PrintStream(fos, true);
        if (ps != null) {
            // 把标准输出流(控制台输出)改成文件
            System.setOut(ps);
        }

        // 输出ASCII字符
        for (int i = 0; i <= 255; i++) { 
            System.out.print((char) i);
            // 每50个数据一行
            if (i % 50 == 0) {
                // 换行
                System.out.println(); 
            }
        }
        
    } catch (FileNotFoundException e) {
        e.printStackTrace();
    } finally {
        if (ps != null) {
            ps.close();
        }
    }

}
```

#### 8.3数据流

##### 8.3.1概述

+ 流的类：DataInputStream 和 DataOutputStream

+ 作用：用于读取或写出基本数据类型的变量或字符串

##### 8.3.2代码演示

```java
/*
练习：将内存中的字符串、基本数据类型的变量写出到文件中。

注意：处理异常的话，仍然应该使用try-catch-finally.
 */
@Test
public void test3() throws IOException {
    //1.
    DataOutputStream dos = new DataOutputStream(new FileOutputStream("data.txt"));
    //2.
    dos.writeUTF("张三");
    dos.flush();//刷新操作，将内存中的数据写入文件
    dos.writeInt(23);
    dos.flush();
    dos.writeBoolean(true);
    dos.flush();
    //3.
    dos.close();


}
/**
将文件中存储的基本数据类型变量和字符串读取到内存中，保存在变量中。

注意点：读取不同类型的数据的顺序要与当初写入文件时，保存的数据的顺序一致！
 */
@Test
public void test4() throws IOException {
    //1.
    DataInputStream dis = new DataInputStream(new FileInputStream("data.txt"));
    //2.
    String name = dis.readUTF();
    int age = dis.readInt();
    boolean isMale = dis.readBoolean();

    System.out.println("name = " + name);
    System.out.println("age = " + age);
    System.out.println("isMale = " + isMale);

    //3.
    dis.close();

}
```

### 9.对象流

*ObjectInputStream 和 ObjectOutputStream*

#### 9.1作用

用于存储和读取基本数据类型数据或对象的处理流。它的强大之处就是可以把Java中的对象写入到数据源中，也能把对象从数据源中还原回来。

#### 9.2使用要求

传输的类必须是可序列化的，特别是自定的类，要手动让其可序列化

#### 9.3自定义类可序列化

```java
/**
 * Person需要满足如下的要求，方可序列化
 * 1.需要实现接口：Serializable
 * 2.当前类提供一个全局常量：serialVersionUID
 * 3.除了当前Person类需要实现Serializable接口之外，还必须保证其内部所有属性也必须是可序列化的。（默认情况下，基本数据类型可序列化）
 *
 * 补充：ObjectOutputStream和ObjectInputStream不能序列化static和transient修饰的成员变量
 */
public class Person implements Serializable{

    public static final long serialVersionUID = 475463534532L;

    private String name;
    private int age;
    private int id;
    private Account acct;

    public Person(String name, int age, int id) {
        this.name = name;
        this.age = age;
        this.id = id;
    }

    public Person(String name, int age, int id, Account acct) {
        this.name = name;
        this.age = age;
        this.id = id;
        this.acct = acct;
    }

    @Override
    public String toString() {
        return "Person{" +
                "name='" + name + '\'' +
                ", age=" + age +
                ", id=" + id +
                ", acct=" + acct +
                '}';
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public Person(String name, int age) {

        this.name = name;
        this.age = age;
    }

    public Account getAcct() {
        return acct;
    }

    public void setAcct(Account acct) {
        this.acct = acct;
    }

    public Person() {

    }
}

public class Account implements Serializable {
    public static final long serialVersionUID = 4754534532L;
    private double balance;

    @Override
    public String toString() {
        return "Account{" +
                "balance=" + balance +
                '}';
    }

    public double getBalance() {
        return balance;
    }

    public void setBalance(double balance) {
        this.balance = balance;
    }

    public Account() {
    }

    public Account(double balance) {

        this.balance = balance;
    }
}
```

#### 9.4序列化机制介绍

对象序列化机制允许把内存中的Java对象转换成平台无关的二进制流，从而允许把这种二进制流持久地保存在磁盘上，或通过网络将这种二进制流传输到另一个网络节点。当其它程序获取了这种二进制流，就可以恢复成原来的Java对象。

#### 9.5序列化和反序列化工程代码演示

```java
/**
序列化过程：将内存中的java对象保存到磁盘中或通过网络传输出去
使用ObjectOutputStream实现
 */
@Test
public void testObjectOutputStream(){
    ObjectOutputStream oos = null;

    try {
        //1.
        oos = new ObjectOutputStream(new FileOutputStream("object.dat"));
        //2.
        oos.writeObject(new String("张三"));
        oos.flush();//刷新操作

        oos.writeObject(new Person("王铭",23));
        oos.flush();

        oos.writeObject(new Person("张学良",23,1001,new Account(5000)));
        oos.flush();

    } catch (IOException e) {
        e.printStackTrace();
    } finally {
        if(oos != null){
            //3.
            try {
                oos.close();
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
    }

}

/** 
反序列化：将磁盘文件中的对象还原为内存中的一个java对象
使用ObjectInputStream来实现
 */
@Test
public void testObjectInputStream(){
    ObjectInputStream ois = null;
    try {
        ois = new ObjectInputStream(new FileInputStream("object.dat"));

        Object obj = ois.readObject();
        String str = (String) obj;

        Person p = (Person) ois.readObject();
        Person p1 = (Person) ois.readObject();

        System.out.println(str);
        System.out.println(p);
        System.out.println(p1);

    } catch (IOException e) {
        e.printStackTrace();
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    } finally {
        if(ois != null){
            try {
                ois.close();
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
    }

}
```

### 10.RandonAccessFile

#### 10.1概述

+ RandomAccessFile直接继承于java.lang.Object类，实现了DataInput和DataOutput接口
+ RandomAccessFile既可以作为一个输入流，又可以作为一个输出流
+ 如果RandomAccessFile作为输出流时，写出到的文件如果不存在，则在执行过程中自动创建。
+ 如果写出到的文件存在，则会对原有文件内容进行覆盖。（默认情况下，从头覆盖）
+ 可以通过相关的操作，实现RandomAccessFile“插入”数据的效果

#### 10.2代码演示

+ 既可以读又可以写

```java
@Test
public void test1() {

    RandomAccessFile raf1 = null;
    RandomAccessFile raf2 = null;
    try {
        //1.
        raf1 = new RandomAccessFile(new File("爱情与友情.jpg"),"r");
        raf2 = new RandomAccessFile(new File("爱情与友情1.jpg"),"rw");
        //2.
        byte[] buffer = new byte[1024];
        int len;
        while((len = raf1.read(buffer)) != -1){
            raf2.write(buffer,0,len);
        }
    } catch (IOException e) {
        e.printStackTrace();
    } finally {
        //3.
        if(raf1 != null){
            try {
                raf1.close();
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
        if(raf2 != null){
            try {
                raf2.close();
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
    }
}
```

+ 从头覆盖

```java
@Test
public void test2() throws IOException {

    RandomAccessFile raf1 = new RandomAccessFile("hello.txt","rw");

    raf1.seek(3);//将指针调到角标为3的位置
    raf1.write("hky".getBytes());//

    raf1.close();

}
```

+ 插入内容

```java
@Test
public void test3() throws IOException {

    RandomAccessFile raf1 = new RandomAccessFile("hello.txt","rw");

    //将指针调到角标为3的位置
    raf1.seek(3);
    //保存指针3后面的所有数据到StringBuilder中
    StringBuilder builder = new StringBuilder((int) new File("hello.txt").length());
    byte[] buffer = new byte[20];
    int len;
    while((len = raf1.read(buffer)) != -1){
        builder.append(new String(buffer,0,len)) ;
    }
    //调回指针，写入“xyz”
    raf1.seek(3);
    raf1.write("xyz".getBytes());

    //将StringBuilder中的数据写入到文件中
    raf1.write(builder.toString().getBytes());

    raf1.close();

    //思考：将StringBuilder替换为ByteArrayOutputStream
}
```

### 11.Path

#### 11.1概述

+ jdk 7.0 时，引入了 Path、Paths、Files三个类

+ 此三个类声明在：java.nio.file包下
+ 此三个类声明在：java.nio.file包下

#### 11.2代码演示

```java
/**
    使用Paths实例化Path
    */
@Test
public void test1() {
    //new File(String filepath)
    Path path1 = Paths.get("d:\\nio\\hello.txt");

    //new File(String parent,String filename);
    Path path2 = Paths.get("d:\\", "nio\\hello.txt");

    System.out.println(path1);
    System.out.println(path2);

    Path path3 = Paths.get("d:\\", "nio");
    System.out.println(path3);
}

//Path中的常用方法
@Test
public void test2() {
    Path path1 = Paths.get("d:\\", "nio\\nio1\\nio2\\hello.txt");
    Path path2 = Paths.get("hello.txt");

    //    String toString() ： 返回调用 Path 对象的字符串表示形式
    System.out.println(path1);

    //    boolean startsWith(String path) : 判断是否以 path 路径开始
    System.out.println(path1.startsWith("d:\\nio"));

    //    boolean endsWith(String path) : 判断是否以 path 路径结束
    System.out.println(path1.endsWith("hello.txt"));

    //    boolean isAbsolute() : 判断是否是绝对路径
    System.out.println(path1.isAbsolute() + "~");
    System.out.println(path2.isAbsolute() + "~");

    //    Path getParent() ：返回Path对象包含整个路径，不包含 Path 对象指定的文件路径
    System.out.println(path1.getParent());
    System.out.println(path2.getParent());

    //    Path getRoot() ：返回调用 Path 对象的根路径
    System.out.println(path1.getRoot());
    System.out.println(path2.getRoot());

    //    Path getFileName() : 返回与调用 Path 对象关联的文件名
    System.out.println(path1.getFileName() + "~");
    System.out.println(path2.getFileName() + "~");

    //    int getNameCount() : 返回Path 根目录后面元素的数量
    //    Path getName(int idx) : 返回指定索引位置 idx 的路径名称
    for (int i = 0; i < path1.getNameCount(); i++) {
        System.out.println(path1.getName(i) + "*****");
    }

    //    Path toAbsolutePath() : 作为绝对路径返回调用 Path 对象
    System.out.println(path1.toAbsolutePath());
    System.out.println(path2.toAbsolutePath());

    //    Path resolve(Path p) :合并两个路径，返回合并后的路径对应的Path对象
    Path path3 = Paths.get("d:\\", "nio");
    Path path4 = Paths.get("nioo\\hi.txt");
    path3 = path3.resolve(path4);
    System.out.println(path3);

    //    File toFile(): 将Path转化为File类的对象
    //Path--->File的转换
    File file = path1.toFile();

    //File--->Path的转换
    Path newPath = file.toPath();

}
```

### 12.Files

*File的工具类*

#### 12.1具体方法的代码演示

```java
@Test
public void test1() throws IOException{
    Path path1 = Paths.get("d:\\nio", "hello.txt");
    Path path2 = Paths.get("a.txt");

    //    Path copy(Path src, Path dest, CopyOption … how) : 文件的复制
    //要想复制成功，要求path2对应的物理上的文件存在。path1对应的文件没有要求。
    //    Files.copy(path1, path2, StandardCopyOption.REPLACE_EXISTING);

    //    Path createDirectory(Path path, FileAttribute<?> … attr) : 创建一个目录
    //要想执行成功，要求path对应的物理上的文件目录不存在。一旦存在，抛出异常。
    Path path3 = Paths.get("d:\\nio\\nio1");
    //    Files.createDirectory(path3);

    //    Path createFile(Path path, FileAttribute<?> … arr) : 创建一个文件
    //要想执行成功，要求path对应的物理上的文件不存在。一旦存在，抛出异常。
    Path path4 = Paths.get("d:\\nio\\hi.txt");
    //    Files.createFile(path4);

    //    void delete(Path path) : 删除一个文件/目录，如果不存在，执行报错
    //    Files.delete(path4);

    //    void deleteIfExists(Path path) : Path对应的文件/目录如果存在，执行删除.如果不存在，正常执行结束
    Files.deleteIfExists(path3);

    //    Path move(Path src, Path dest, CopyOption…how) : 将 src 移动到 dest 位置
    //要想执行成功，src对应的物理上的文件需要存在，dest对应的文件没有要求。
    //    Files.move(path1, path2, StandardCopyOption.ATOMIC_MOVE);

    //    long size(Path path) : 返回 path 指定文件的大小
    long size = Files.size(path2);
    System.out.println(size);

}

@Test
public void test2() throws IOException{
    Path path1 = Paths.get("d:\\nio", "hello.txt");
    Path path2 = Paths.get("a.txt");
    //    boolean exists(Path path, LinkOption … opts) : 判断文件是否存在
    System.out.println(Files.exists(path2, LinkOption.NOFOLLOW_LINKS));

    //    boolean isDirectory(Path path, LinkOption … opts) : 判断是否是目录
    //不要求此path对应的物理文件存在。
    System.out.println(Files.isDirectory(path1, LinkOption.NOFOLLOW_LINKS));

    //    boolean isRegularFile(Path path, LinkOption … opts) : 判断是否是文件

    //    boolean isHidden(Path path) : 判断是否是隐藏文件
    //要求此path对应的物理上的文件需要存在。才可判断是否隐藏。否则，抛异常。
    //    System.out.println(Files.isHidden(path1));

    //    boolean isReadable(Path path) : 判断文件是否可读
    System.out.println(Files.isReadable(path1));
    //    boolean isWritable(Path path) : 判断文件是否可写
    System.out.println(Files.isWritable(path1));
    //    boolean notExists(Path path, LinkOption … opts) : 判断文件是否不存在
    System.out.println(Files.notExists(path1, LinkOption.NOFOLLOW_LINKS));
}

/**
    * StandardOpenOption.READ:表示对应的Channel是可读的。
    * StandardOpenOption.WRITE：表示对应的Channel是可写的。
    * StandardOpenOption.CREATE：如果要写出的文件不存在，则创建。如果存在，忽略
    * StandardOpenOption.CREATE_NEW：如果要写出的文件不存在，则创建。如果存在，抛异常
    *
    * @throws IOException
    */
@Test
public void test3() throws IOException{
    Path path1 = Paths.get("d:\\nio", "hello.txt");

    //    InputStream newInputStream(Path path, OpenOption…how):获取 InputStream 对象
    InputStream inputStream = Files.newInputStream(path1, StandardOpenOption.READ);

    //    OutputStream newOutputStream(Path path, OpenOption…how) : 获取 OutputStream 对象
    OutputStream outputStream = Files.newOutputStream(path1, StandardOpenOption.WRITE,StandardOpenOption.CREATE);


    //    SeekableByteChannel newByteChannel(Path path, OpenOption…how) : 获取与指定文件的连接，how 指定打开方式。
    SeekableByteChannel channel = Files.newByteChannel(path1, StandardOpenOption.READ,StandardOpenOption.WRITE,StandardOpenOption.CREATE);

    //    DirectoryStream<Path>  newDirectoryStream(Path path) : 打开 path 指定的目录
    Path path2 = Paths.get("e:\\teach");
    DirectoryStream<Path> directoryStream = Files.newDirectoryStream(path2);
    Iterator<Path> iterator = directoryStream.iterator();
    while(iterator.hasNext()){
        System.out.println(iterator.next());
    }


}
```

### 13.FileUtils

```java
public static void main(String[] args) {
    File srcFile = new File("day10\\爱情与友情.jpg");
    File destFile = new File("day10\\爱情与友情2.jpg");

    try {
        FileUtils.copyFile(srcFile,destFile);
    } catch (IOException e) {
        e.printStackTrace();
    }
}
```

### 14.经典题

#### 14.1题1

##### 14.1.1描述

判断指定目录下是否有后缀名为.jpg的文件，如果有，就输出该文件名称

##### 14.1.2解法

```java
@Test
public void test1(){
   File srcFile = new File("d:\\code");
   
   String[] fileNames = srcFile.list();
   for(String fileName : fileNames){
      if(fileName.endsWith(".jpg")){
         System.out.println(fileName);
      }
   }
}
@Test
public void test2(){
   File srcFile = new File("d:\\code");
   
   File[] listFiles = srcFile.listFiles();
   for(File file : listFiles){
      if(file.getName().endsWith(".jpg")){
         System.out.println(file.getAbsolutePath());
      }
   }
}
/**
 * File类提供了两个文件过滤器方法
 * public String[] list(FilenameFilter filter)
 * public File[] listFiles(FileFilter filter)

 */
@Test
public void test3(){
   File srcFile = new File("d:\\code");
   
   File[] subFiles = srcFile.listFiles(new FilenameFilter() {
      
      @Override
      public boolean accept(File dir, String name) {
         return name.endsWith(".jpg");
      }
   });
   
   for(File file : subFiles){
      System.out.println(file.getAbsolutePath());
   }
}
```

#### 14.2题2

##### 14.2.1描述

遍历指定目录所有文件名称，包括子文件目录中的文件。

​		拓展1：并计算指定目录占用空间的大小

​		拓展2：删除指定文件目录及其下的所有文件

##### 14.2.2解法

```java
public static void main(String[] args) {
   // 递归:文件目录
   /** 打印出指定目录所有文件名称，包括子文件目录中的文件 */

   // 1.创建目录对象
   File dir = new File("D:\\a\\b\\c\\d");

   // 2.打印目录的子文件
   printSubFile(dir);
}

public static void printSubFile(File dir) {
   // 打印目录的子文件
   File[] subfiles = dir.listFiles();

   for (File f : subfiles) {
      // 文件目录
      if (f.isDirectory()) {
         printSubFile(f);
      } else {// 文件
         System.out.println(f.getAbsolutePath());
      }

   }
}

// 方式二：循环实现
// 列出file目录的下级内容，仅列出一级的话
// 使用File类的String[] list()比较简单
public void listSubFiles(File file) {
   if (file.isDirectory()) {
      String[] all = file.list();
      for (String s : all) {
         System.out.println(s);
      }
   } else {
      System.out.println(file + "是文件！");
   }
}

// 列出file目录的下级，如果它的下级还是目录，接着列出下级的下级，依次类推
// 建议使用File类的File[] listFiles()
public void listAllSubFiles(File file) {
   if (file.isFile()) {
      System.out.println(file);
   } else {
      File[] all = file.listFiles();
      // 如果all[i]是文件，直接打印
      // 如果all[i]是目录，接着再获取它的下一级
      for (File f : all) {
         // 递归调用：自己调用自己就叫递归
         listAllSubFiles(f);
      }
   }
}

// 拓展1：求指定目录所在空间的大小
// 求任意一个目录的总大小
public long getDirectorySize(File file) {
   // file是文件，那么直接返回file.length()
   // file是目录，把它的下一级的所有大小加起来就是它的总大小
   long size = 0;
   if (file.isFile()) {
      size += file.length();
   } else {
      // 获取file的下一级
      File[] all = file.listFiles();
      // 累加all[i]的大小
      for (File f : all) {
         // f的大小;
         size += getDirectorySize(f);
      }
   }
   return size;
}

// 拓展2：删除指定的目录
public void deleteDirectory(File file) {
   // 如果file是文件，直接delete
   // 如果file是目录，先把它的下一级干掉，然后删除自己
   if (file.isDirectory()) {
      File[] all = file.listFiles();
      // 循环删除的是file的下一级
      // f代表file的每一个下级
      for (File f : all) {
         deleteDirectory(f);
      }
   }
   // 删除自己
   file.delete();
}
```

+++

## 四、网络编程

### ----------未完待续---------------------