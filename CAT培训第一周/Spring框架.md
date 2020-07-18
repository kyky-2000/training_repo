# Spring框架

+++

## IOC（控制反转）

### 原理理解：

- IOC是一个容器，用注解或xml的方式创建对象放到其中，由spring统一管理

+ 在一个类对象new一个别的类对象耦合度过高，在修改项目的时候修改一个类的代码经常要把与其相关的其他类一起修改，网课老师称之为：“牵一发而动全身”。而如果用IOC工厂模式来创建和管理对象，可以很大限度的降低类与类之间耦合度，提高编程的效率

+++

### 技术原理：

xml解析、注解、反射

+++

### 准备工作：

***导包***：

commons-logging-1.1.1.jar

spring-beans-5.2.7.RELEASE.jar

spring-context-5.2.7.RELEASE.jar

spring-core-5.2.7.RELEASE.jar

spring-expression-5.2.7.RELEASE.jar

+++

### 知识点：

#### IOC容器的两个实现接口

**BeanFactory**：一般是spring内部人员使用，在加载配置文件的时候不会创建对象，获取、使用对象的时候创建

**ApplicationContext**：开发人员使用，在加载配置文件时就会创建对象

*ApplicationContext两个实现类ClassPathXmlApplicationContext（参数是 src下的路径）、*

​                                                   *FileSystemXmlApplicationContext（参数是C盘下的路径）*

+++

#### Bean的生命周期

> ```
> 第一步，创建bean无参实例
> 第二步，注入属性
> 第三步，初始化之前
> 第四步，初始化bean的对象
> 第五步，初始化之后
> 第六步，使用bean对象
> 第七步，销毁bean对象
> ```

**初始化前后的两步需要进行特殊配置**

```java
/**
 * bean的后置处理器，两个方法分别在bean实例初始化前后执行
 * 有定义和配置bean后置处理器才有这两个方法的实行
 */
public class MyBeanPost implements BeanPostProcessor {
    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("--初始化之前搞事情" + beanName);
        return bean;
    }

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("--初始化之后搞事情" + beanName);
        return bean;
    }

}
```

```java
<!--bean后置处理器一旦配置将对本xml文件里的所有bean都起作用-->
<bean id="myBeanPost" class="com.hky.testspring.bean.MyBeanPost"></bean>
```

**初始化和销毁方法的配置**

```java
public class MyBean {
    private String name;

    public MyBean(){
        System.out.println("第一步， 创建bean无参实例");
    }

    public void setName(String name) {
        this.name = name;
        System.out.println("第二步，注入属性");
    }

    public void initMethod(){
        System.out.println("第三步，初始化bean的对象");
    }

    public void destroyMethod(){
        System.out.println("第五步，销毁bean对象");
    }
}
```

```xml
<bean id="myBean" class="com.hky.testspring.bean.MyBean" 
    init-method="initMethod" destroy-method="destroyMethod">
    <property name="name" value="myBean"></property>
</bean>
```

+++

#### Bean管理（Xml方式）

+ **创建对象**

```xml
<bean id="user" class="com.hky.testspring.User"></bean
```

+ **注入属性的两种方式**

```xml
<!--setter方式注入属性(常用)-->
<bean id="user" class="com.hky.testspring.User">
    <property name="name" value="张三"></property>
</bean>
        
<!--通过构造方法注入属性-->
<bean id="person" class="com.hky.testspring.Person">
    <constructor-arg name="name" value="李四"></constructor-arg>
    <constructor-arg name="birthPlace" value="China"></constructor-arg>
</bean>          
```

+ **当属性的值包含特殊符号时**

```xml
<!--值为空时-->
<bean id="user" class="com.hky.testspring.User">
    <property name="name">
        <null/>
    </property>
</bean>

    <!--值里含有尖括号等其他特殊符号
    处理方法：
        1.用转义字符(&lt;&gt)
        2.用CDATA：![CDATA[<<XXX>>]]
    -->
<bean id="user" class="com.hky.testspring.User">
    <property name="name">
        <value><![CDATA[<<张三>>]]></value>
    </property>
</bean>
```

+ **复杂属性**（一个对象的属性是另一个类的对象）

```xml
<!--外部bean-->
<bean id="userService" class="com.hky.testspring.service.UserService">
    <property name="userDao" ref="userDao"></property>
</bean>
<bean id="userDao" class="com.hky.testspring.dao.UserDao"></bean>
    
<!--内部bean-->
<bean id="userService" class="com.hky.testspring.service.UserService">           	 <property name="userDao">
   	    <bean id="userDao" class="com.hky.testspring.dao.UserDao">
			<property name="name" value="dao层"></property>
		</bean>
    </property>
</bean>    
            
<!--级联赋值-->
<!--某个类中有多个属性，包含有几个基本属性和几个其他类对象的属性，基本属性按普通的setter方式赋值，其他类对象的属性用外部bean的方式赋值-->
<bean id="userService" class="com.hky.testspring.service.UserService">
    <property name="userDao" ref="userDao"></property>
    <property name="userDao.name" value="dao层啊"></property>
</bean>
<bean id="userDao" class="com.hky.testspring.dao.UserDao">
    <property name="name" value="dao层"></property>
</bean>            
```

+ **数组集合类型属性的注入**

```xml
<bean id="student" class="com.hky.testspring.bean.Student">
    <!--数组集合类型-->
    <property name="cources">
        <array>             //这里可以换成list、set
            <value>高数</value>
            <value>电工</value>
        </array>
    </property>
    
    <!--map类型-->
    <property name="map">
        <map>
            <entry key="爱好" value="篮球"></entry>
    		<entry key="性格" value="外向"></entry>
    	</map>
    </property>
    
    <!--集合中存放的是其他类的对象-->
    <property name="classmates">
    	<list>
    		<ref bean="user1"></ref>  //注入下方创建的对象
    		<ref bean="user2"></ref>
    	</list>
    </property>
</bean>    
<bean name="user1" class="com.hky.testspring.User">
    <property name="name" value="李四"></property>
</bean>
<bean name="user2" class="com.hky.testspring.User">
    <property name="name" value="王五"></property>
</bean>    

    
<!--抽取list集合类型属性注入--> 
<!--开辟一块util空间--> 
xmlns:util="http://www.springframework.org/schema/util"
http://www.springframework.org/schema/util
    http://www.springframework.org/schema/util/spring-util.xsd
<!--抽取属性注入-->
<util:list id="bookList">
    <value>活着</value>
    <value>红楼梦</value>
    <value>西游记</value>
</util:list>
<!--使用上方的抽取-->
<bean id="bookstore" class="com.hky.testspring.bean.Bookstore">
    <property name="bookList" ref="bookList"></property>
</bean>    
```

+ **p空间注入**

![](D:\training\学习笔记\网课截图\Spring框架\p空间注入.png)

+ **自动装配**

```xml
<!--byName通过bean名称，bean的id的值和类的属性名称一样-->
<bean id="emp" class="com.hky.testspring.autowire.Emp" autowire="byName"></bean>
<bean id="dept" class="com.hky.testspring.autowire.Dept"></bean>

    <!--byType通过bean类型，但有多个bean的类型和属性类型相同时会不知道装哪个而报错-->
<bean id="emp" class="com.hky.testspring.autowire.Emp" autowire="byType"></bean>
<bean id="dept1" class="com.hky.testspring.autowire.Dept"></bean>
<bean id="dept2" class="com.hky.testspring.autowire.Dept"></bean>
```

+ **Bean的作用域（单例和多例问题）**

```xml
<!--scope默认值为singleton，为单实例；可改为prototype（多实例）;还有request和session两个值，了解-->
<!--singleton在加载xml文件的时候就创建对象，prototype在调用getBean方法时才创建对象-->
<bean id="person" class="com.hky.testspring.bean.Myfactory" scope="singleton">
</bean>
```

+ **配置数据库连接**
  + 导包：druid-1.1.9.jar

```xml
<!--不导入配置文件-->
<bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
    <property name="driverClassName" value="com.mysql.jdbc.Driver"></property>
    <property name="url" value="jdbc:mysql://localhost:3306/myDatabase"></property>
    <property name="username" value="root"></property>
    <property name="password" value="369"></property>
</bean>
    
<!--导入配置文件（配置文件放到src目录下）-->
<context:property-placeholder location="classpath:jdbc.properties"/>
<!-- 获取properties文件内容，根据key获取，使用spring表达式获取 -->
<bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
<!-- 获取properties文件内容，根据key获取，使用spring表达式获取 -->
    <property name="driverClassName" value="${prop.driverClass}"></property>
    <property name="url" value="${prop.url}"></property>
    <property name="username" value="${prop.username}"></property>
    <property name="password" value="${prop.password}"></property>
</bean>
```

+ ***测试方法***

```java
public class Test {
    @Test
    public void test(){
        ApplicationContext context = new ClassPathXmlApplicationContext("XXX.xml");
        bean对象 = context.getBean("bean的id", XXX.class);
        //执行对象的方法
    }
}
```

++++

#### Bean管理（注解方式）

+ **开启组件扫描**

*xml方式*

```xml
<!--开辟context空间-->
xmlns:context="http://www.springframework.org/schema/context"
http://www.springframework.org/schema/context    https://www.springframework.org/schema/context/spring-context.xsd    
    
<!--开启组件扫描，开启之后spring容器才会去扫描包里面的注解-->
<!--多包第一种写法，加逗号隔开-->
<context:component-scan base-package="com.hky.testspring.service,com.hky.testspring.dao">
</context:component-scan>
<!--多包第二种写法，写上层目录-->
<context:component-scan base-package="com.hky.testspring"></context:component-scan>
    
<!--加限制，不完全扫描包里的所有类-->
<!--use-default-filters="false"关掉默认的全扫描-->
<!--include-filter只扫描我们自己限制的类-->
<context:component-scan base-package="com.hky.testspring" 	 usedefaultfilters="false">
    <context:include-filter type="annotation"                               			 expression="org.springframework.stereotype.Controller"/>
</context:component-scan>

<!--不扫描我们描述的包（不用关掉全扫描）-->
<context:component-scan base-package="com.hky.testspring">
     <context:exclude-filter type="annotation"
          expression="org.springframework.stereotype.Controller"/>
</context:component-scan>    
```

*配置类方式（完全注解开发，实际中较常用）*

```java
/**
 * 创建配置类，替代配置文件，实现完全注解开发
 * @Configuration标志这是配置类
 * 这么写等同于配置文件中的<context:component-scan base-package="com.hky.testspring"></context:component-scan>
 */
@Configuration
@ComponentScan(basePackages = "com.hky.testspring")
public class SpringConfig {
}
```

+ **创建对象**

  + 在类上加注解：@Component、 @Controller、 @Service、 @Repository   

    效果是一样，但为了分包清晰、代码可读性高，一般在特定的包使用特定的注解

  + 等同于<bean id="userService" class="com.hky.testspring.service.UserService"></bean>

  + 注解有一个参数value，value的值可不加，不加默认值为：UserService-->userService

+ **注入普通属性**

```java
@Value(value = "张三")
private String userName;
```

+ **属性注入**

  *以注解的方式注入属性不需要有setter方法，封装好了*

  + @Autowired：根据属性类型进行自动装配

  + @Qualifier（value = ...）：根据名称注入，一个接口可能有多个实现类，可以用根据名称填充防止不知道填充哪个类报错（要和@Autowired一起使用）

  + @Resource：可根据类型或名称注入，但是它是java拓展包的，不是spring框架包的，不推荐使用。

    不为参数name赋值则根据类型注入，赋值了则根据名称注入

+ ***测试方法***

```java
@Test
public void test1(){
    ApplicationContext context = new AnnotationConfigApplicationContext(TxConfig.class);
    UserService userService = context.getBean("userService", UserService.class);
    userService.trader();
}
```

+++

+++

## AOP（面向切面开发）

### 底层原理

动态代理

+++

### 术语

![](D:\training\学习笔记\网课截图\Spring框架\aop术语.png)

+++

### 准备工作

+ Spring框架一般都是基于AspectJ实现AOP操作
  + AspectJ不是Spring的一部分，是独立的AOP框架，一般把AspectJ和Spring框架一起使用，完成AOP操作
+ 基于AspectJ实现AOP操作
  + 基于xml配置文件实现
  + 基于注解方式实现（常用）
+ 导AOP依赖：
  + spring-aop-5.2.7.RELEASE.jar

+++

### 具体实现

+ **有接口，使用JDK动态代理**

```java
//被增强的方法的类
public class UserServiceImpl implements UserService{
    @Override
    public int add(int a, int b) {
        System.out.println("正在执行加法。。。。。。。。。。。");
        return a+b;
    }
    @Override
    public int update(int n) {
        System.out.println("正在执行更新。。。。。。。。。");
        return n;
    }
}

//增强方法的类
//实现接口InvocationHandler，写增强部分
public class UserServiceProxy implements InvocationHandler {
    //将要被增强的类的对象作为构造函数的参数传入，在invoke方法里调用其增强前的方法
    private Object obj;
    public UserServiceProxy(Object object){
        this.obj = object;
    }
    //参数method为要被增强的方法，args为method的参数列表
    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        //做增强方法的操作，在原方法执行前
        System.out.println(method.getName() + "方法执行之前,参数为" + Arrays.toString(args));
        //执行原方法
        Object result = method.invoke(obj, args);
        //做增强方法的操作，在原方法执行后
        System.out.println("方法执行后，结果为：" + result);
        return result;
    }
}

//结合上面两个为，完成AOP操作
public class JDKProxy {
    public static void main(String[] args) {
        //要被增强的方法的类继承的接口，可以是多个
        Class[] interfaces = {UserService.class};
        //创建原方法的类的对象
        UserServiceImpl userService = new UserServiceImpl();
        //调用Procy的newProxyInstance方法，传入（任意）类加载器，被增强的类实现的接口，增强方法的类的对象（new的时候传入原方法的类的对象）三个参数，放回代理对象
        UserService service = (UserService) Proxy.newProxyInstance(JDKProxy.class.getClassLoader(), interfaces, new UserServiceProxy(userService));
        //调用代理对象的方法实现AOP操作
        service.add(1, 2);
    }
}
```

+ **无接口，使用CGLIB动态代理**
  
  + 导包:
  
    spring-aspects-5.2.7.RELEASE.jar
  
    com.springsource.net.sf.cglib-2.2.0.jar
  
    com.springsource.org.aopalliance-1.0.0.jar
  
    com.springsource.org.aspectj.weaver-1.6.8.RELEASE.jar
  
  + AspectJ注解

```xml
<!--开辟aop、context空间-->
xmlns:context="http://www.springframework.org/schema/context"
xmlns:aop="http://www.springframework.org/schema/aop"
http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd
http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop.xsd

<!--开启组件扫描-->
<context:component-scan base-package="com.hky.testspring.aopanno"></context:component-scan>

<!--开启Aspect生成代理对象-->
<!--开启之后@Aspect标记的类会生成代理对象-->
<aop:aspectj-autoproxy></aop:aspectj-autoproxy>
```

*切点表达式*

![](D:\training\学习笔记\网课截图\Spring框架\切点表达式.png)

​           举例3：对com.atguigu.dao包下的所有类的所有方法进行加强  

​		   execution(* com.atguigu.dao.*.* (..))

*通知的注解,注在增强方法上*

```java
//前置通知，在方法执行前执行，在循环通知开始后才开始
@Before(value = "execution(*com.hky.testspring.aopanno.Man.common(..))")

//返回通知（后置通知），在方法执行完返回了值之后执行，若出现异常则不执行。此通知之后还有最终通知和循环通知的后半段
@AfterReturning(value = "execution(*com.hky.testspring.aopanno.Man.common(..))")

//最终通知，无论如何都会执行，类似于finally，在此通知之后还有循环通知的后半段
@After(value = "execution(*com.hky.testspring.aopanno.Man.common(..))")

//异常通知，当出现异常时执行
@AfterThrowing(value = "execution(*com.hky.testspring.aopanno.Man.common(..))")

//循环通知，在方法执行前后都执行，且是最先执行和最后执行，若出现异常则方法执行后不执行
@Around(value = "execution(* com.hky.testspring.aopanno.Man.common(..))")
public void around(ProceedingJoinPoint proceedingJoinPoint)throws Throwable{
        System.out.println("循环前。。。。。。。。。。");
        proceedingJoinPoint.proceed();
        System.out.println("循环后。。。。。。。。。。");
}


//相同切入点的抽取
@Pointcut(value = "execution(* com.hky.testspring.aopanno.Man.common(..))")
public void pointcut(){
}
@Before(value = "pointcut()")
```

*优先级设置，值越小，优先级越高，注解在增强方法的类上*

```java
@Order(0)
```

+ + AspectJ配置文件

```xml
<!--创建对象-->
<bean id="man" class="com.hky.testspring.aopanno.Man"></bean>
<bean id="supperman" class="com.hky.testspring.aopanno.Supperman"></bean>

<!--aop配置-->
<aop:config>
<!--配置切入点-->
    <aop:pointcut id="p" expression="
         execution(* com.hky.testspring.aopanno.Man.common(..))"></aop:pointcut>
    <!--配置切面-->
    <aop:aspect ref="supperman">
        <aop:before method="before" pointcut-ref="p"></aop:before>
        <!--不配切入点，直接配切面 <aop:before method="before" pointcut=
"execution(* com.hky.testspring.aopanno.Man.common(..))"></aop:before>-->
    </aop:aspect>
</aop:config>

```

+++

+++

## JdbcTemplate

### 概念：

Spring对jdbc的封装，方便对数据库的操作

+++

### 准备工作：

+ 导包

  mysql-connector-java-5.1.7-bin.jar

  spring-jdbc-5.2.7.RELEASE.jar

  spring-orm-5.2.7.RELEASE.jar

  spring-tx-5.2.7.RELEASE.jar

+ 在xml文件中配置数据库连接池

```xml
<!--1. 配置连接池 -->
<bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
    <property name="driverClassName" value="com.mysql.jdbc.Driver"></property>
    <property name="url" value="jdbc:mysql://localhost:3306/springBase"></property>
    <property name="username" value="root"></property>
    <property name="password" value="abc369"></property>
</bean>

<!--2. 导入配置文件（配置文件放到src目录下）-->
<context:property-placeholder location="classpath:jdbc.properties"/>
<bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
    <property name="driverClassName" value="${prop.driverClass}"></property>
    <property name="url" value="${prop.url}"></property>
    <property name="username" value="${prop.username}"></property>
    <property name="password" value="${prop.password}"></property>
</bean>
```

+ 配置JdbcTemplate对象，注入DataSource

```xml
<!--jdbcTemplate对象-->
<bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
    <!--注入dataSource-->
    <property name="dataSource" ref="dataSource"></property>
</bean>
```

+ 创建service、dao类，在service类对象中注入dao类对象，在dao类对象中注入JdbcTemplate对象

```java
@Service
public class UserService {
    @Autowired
    private UserDao userDao;
}

@Repository
public class UserDaoImpl implements UserDao{
    @Autowired
    private JdbcTemplate jdbcTemplate;
}    
```

#### 注解方式配置

```java
//@Configuration//配置类
@ComponentScan(basePackages = "com.hky.demo")//开启注解扫描
public class TxConfig {

    @Bean
    public DruidDataSource getDruidDataSource(){
        DruidDataSource dataSource = new DruidDataSource();
        dataSource.setDriverClassName("com.mysql.jdbc.Driver");
        dataSource.setUrl("jdbc:mysql://localhost:3306/springBase");
        dataSource.setUsername("root");
        dataSource.setPassword("abc369");
        return dataSource;
    }

    //在ioc容器中根据类型自动找到dataSource对象注入
    @Bean
    public JdbcTemplate getJdbcTemplate(DataSource dataSource){
        JdbcTemplate jdbcTemplate = new JdbcTemplate();
        jdbcTemplate.setDataSource(dataSource);
        return jdbcTemplate;
    }
}
```

+++

### 进行对数据库操作

```java
@Repository
public class UserDaoImpl implements UserDao{
    @Autowired
    private JdbcTemplate jdbcTemplate;

    //添加记录
    @Override
    public int addUser(User user) {
        String sql = "insert into user value(?, ?, ?)";
        Object[] params = {user.getId(), user.getName(), user.getStatus()};
        int result = jdbcTemplate.update(sql, params);
        return result;
    }

    //查询返回对象，可返回数量：第二个参数写Integer.class即可
    @Override
    public User findById(String id){
        String sql = "select * from user where id = ?";
        User user = jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<User>(User.class), id);
        return user;
    }

    //查询返回集合
    @Override
    public List<User> findAll() {
        String sql = "select * from user";
        List<User> users = jdbcTemplate.query(sql, new BeanPropertyRowMapper<User>(User.class));
        return users;
    }

    //批量修改记录
    @Override
    public void batchAddUsers(List<Object[]> batchArgs) {
        String sql = "insert into user value(?, ?, ?)";
        int[] result = jdbcTemplate.batchUpdate(sql, batchArgs);
        System.out.println(result);
    }

}
```

+++

+++

## 事务操作

### 经典场景：

转钱案例

+++

### 配置：

#### xml配置

```xml
<!--先进行连接池和JdbcTemplate配置-->
<!--创建事务管理器-->
<bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
    <property name="dataSource" ref="dataSource"></property>
</bean>


<!--开启事务注解，开启后spring会扫描@Transactional标注的类为其添加事务-->
<tx:annotation-driven transaction-manager="transactionManager"></tx:annotation-driven>

<!--配置通知-->
<tx:advice id="txAdvice">
    <!--指定在哪种规则的方法上添加事务-->
    <tx:attributes>
        <tx:method name="trader" propagation="REQUIRED"/>
    <!--<tx:method name="tra*" propagation="REQUIRED"/>-->
    </tx:attributes>
</tx:advice>
<!--配置切入点和切面-->
<aop:config>
    <!--配置切入点-->
    <aop:pointcut id="pt" expression="execution(* com.hky.demo.service.*(..))">               </aop:pointcut>
    <!--配置切面-->
    <aop:advisor advice-ref="txAdvice" pointcut-ref="pt"></aop:advisor>
</aop:config>
```

#### 配置类

```java
@Configuration//配置类
@ComponentScan(basePackages = "com.hky.demo")//开启注解扫描
@EnableTransactionManagement//开启事务
public class TxConfig {

    @Bean
    public DruidDataSource getDruidDataSource(){
        DruidDataSource dataSource = new DruidDataSource();
        dataSource.setDriverClassName("com.mysql.jdbc.Driver");
        dataSource.setUrl("jdbc:mysql://localhost:3306/springBase");
        dataSource.setUsername("root");
        dataSource.setPassword("abc369");
        return dataSource;
    }

    //在ioc容器中根据类型自动找到dataSource对象注入
    @Bean
    public JdbcTemplate getJdbcTemplate(DataSource dataSource){
        JdbcTemplate jdbcTemplate = new JdbcTemplate();
        jdbcTemplate.setDataSource(dataSource);
        return jdbcTemplate;
    }

    @Bean
    public DataSourceTransactionManager getDataSourceTransactionManager(DataSource dataSource){
        DataSourceTransactionManager transactionManager = new DataSourceTransactionManager();
        transactionManager.setDataSource(dataSource);
        return transactionManager;
    }
}
```

### 给Service的类添加事务

```java
/**
 * Transactional注解是添加事务管理器的作用，可添加在类上（为类中所有方法都添加）或者单个方法上
 * Transactional有几个参数：
 *    propagation：事务传播行为，取值：required（默认值，有则用无则new）、require-new（无论有无都                    new）；这两个常用，其他的可以用时在学习
 *     isolation:  设置事务隔离级别，取值：read uncommitted（存在脏读，不可重复读、幻读问题）、read                    committed（解决了脏读）、repeatable read（默认值，仍有幻读问题）、                              serializable（解决各种问题）
 *     timeout:    若在规定时间内未提交事务则进行回滚
 *                 默认值为-1（不设时间），可手动设置时间，单位为秒
 *     readOnly:   只读，只可查询，不可增删改
 *                 默认值为false（关闭），可手动设置为true
 *    rollbackFor：遇到哪些异常回滚
 *   noRollbackFor：遇到哪些异常不回滚
 */
@Service
@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.REPEATABLE_READ, timeout = -1, readOnly = false)
public class UserService {
    @Autowired
    private UserDao userDao;
    public void trader(){

        userDao.reduceMoney();
        //模拟发生异常
        int n = 10/0;
        userDao.addMoney();

    }

}
```

+++

+++

## Spring5新功能 

### 日志功能

1. **导包**

   log4j-api-2.11.2.jar

   log4j-core-2.11.2.jar

   log4j-slf4j-impl-2.11.2.jar

   slf4j-api-1.7.30.jar

2. **配置**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--日志级别以及优先级排序: OFF > FATAL > ERROR > WARN > INFO > DEBUG > TRACE > ALL -->
<!--Configuration后面的status用于设置log4j2自身内部的信息输出，可以不设置，当设置成trace时，可以看到log4j2内部各种详细输出-->
<configuration status="INFO">
    <!--先定义所有的appender-->
    <appenders>
        <!--输出日志信息到控制台-->
        <console name="Console" target="SYSTEM_OUT">
            <!--控制日志输出的格式-->
            <PatternLayout pattern="%d{yyyy-MM-dd HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n"/>
        </console>
    </appenders>
    <!--然后定义logger，只有定义了logger并引入的appender，appender才会生效-->
    <!--root：用于指定项目的根日志，如果没有单独指定Logger，则会使用root作为默认的日志输出-->
    <loggers>
        <root level="info">
            <appender-ref ref="Console"/>
        </root>
    </loggers>
</configuration>
```

3. **测试**

```java
/**
 * 测试日志功能
 * log4j2是spring5新功能
 * 要用log4j要降到spring4
 * 下方例子和xml配置文件都是固定格式，能记就记一下吧
 */
public class TestLog {

    private static final Logger logger = LoggerFactory.getLogger(TestLog.class);
    public static void main(String[] args){
        logger.info("hello");
    }
}
```

### JUnit5单元测试框架

1. **导包**

   junit-4.11.jar

   hamcrest-core-1.3.jar

2. **使用**

```java
//JUnit4单元测试框架
@RunWith(SpringJUnit4ClassRunner.class)
//加载配置文件
@ContextConfiguration("classpath:bean.xml")
public class JTest4 {
    @Autowired
    private UserService userService;

    @Test
    public void test1(){
        userService.trader();
    }
}

//JUnit5测试框架（要特殊再导一下junit5）
//@ExtendWith(SpringExtension.class)
//@ContextConfiguration("classpath:bean.xml")

//复合了上面两个注解
@SpringJUnitConfig(locations = "classpath:bean.xml")
public class JTest5 {
    @Autowired
    private UserService userService;

    @Test
    public void test1(){
        userService.trader();
    }
}
```

### @Nullable注解

![](D:\training\学习笔记\网课截图\Spring框架\@Nullable1.png)

![](D:\training\学习笔记\网课截图\Spring框架\@Nullable2.png)