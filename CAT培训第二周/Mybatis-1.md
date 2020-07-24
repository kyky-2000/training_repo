# Mybatis

## 什么是Mybatis

+ Mybatis是一款持久层框架
+ Mybatis避免了几乎所有的JDBC代码和手动设置参数以及获取结果集的操作
+ Mybatis利用反射的原理，面向接口开发的思想，用xml或注解的方式来执行sql语句，操作数据库

*Mybatis官方文档：*http://www.mybatis.org/mybatis-3/zh/index.html

## 第一个Mybatis程序

### 思想流程：

***搭建环境--》导入Mybatis--》编写代码--》测试***

### 具体流程：

1. **搭建项目的数据库，创建表单，插入数据。**
2. **创建maven项目并在pom.xml中添加依赖**

```xml
<dependencies>
    <!--mysql依赖-->
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>5.1.9</version>
    </dependency>
    <!--mybatis-->
    <dependency>
        <groupId>org.mybatis</groupId>
        <artifactId>mybatis</artifactId>
        <version>3.5.2</version>
    </dependency>
    <!--junit-->
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.12</version>
    </dependency>
</dependencies>
```

3. **编写Mybatis核心配置文件：mybatis-config.xml**       *查看帮助文档*

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<!--核心配置文件-->
<configuration>
    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC"/>
            <dataSource type="POOLED">
                <property name="driver" value="com.mysql.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/mybatis?useSSL=true&amp;useUnicode=true&amp;characterEncoding=UTF-8"/>
                <property name="username" value="root"/>
                <property name="password" value="abc369"/>
            </dataSource>
        </environment>
    </environments>
    <!--每一个xml文件都需要在核心配置文件中注册-->
    <mappers>
        <mapper resource="com/hky/dao/UserMapper.xml"></mapper>
    </mappers>
</configuration>
```

4. **编写Mybatis工具类**     *抽取获取SqlSession的代码*

```java
/**
 * 获取SqlSession对象的工具类
 * 步骤： 1、调用SQLSessionFactoryBuilder的build方法，加载xml文件获取SQLSessionFactory对象
 *       2、用SqlSessionFactory的openSession方法获取SqlSession对象
 */
public class MybatisUtils {
    private static SqlSessionFactory sqlSessionFactory;

    //获取SqlSessionFactory对象(静态代码块，加载类的时候就会运行)
    static{
        try{
            String resource = "mybatis-config.xml";
            InputStream inputStream = Resources.getResourceAsStream(resource);
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        }catch(IOException e){
            e.printStackTrace();
        }
    }

    //获取SqlSession实例，SqlSession完全包含了面向数据库执行SQL命令的所有方法
    public static SqlSession getSqlSession(){
        return sqlSessionFactory.openSession();
    }

}
```

5. **创建实体类对象**
6. **编写Mapper接口类**

```java
public interface UserMapper {

    /**
     * 查询表单中全部用户的信息
     * @return
     */
    List<User> findAllUsers();
}
```

7. **编写Mapper.xml配置文件**

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<!--替换dao层接口的实现类，将sql语句写到xml文件中，降低数据库和项目的耦合度，且方便修改-->
<!--namespace的值是接口的全名(十分重要)-->
<mapper namespace="com.hky.dao.UserMapper">
    <!--id的值是namespace对应接口的方法，resultType的值是返回数据类型中对象的全类名-->
    <select id="findAllUsers" resultType="com.User">
        select * from user
    </select>
</mapper>
```

8. **编写测试类**

```java
/**
 * 每次执行会创建一个SqlSession对象，用完要记得关闭（重点）；官方说SqlSession线程不安全，建议进行异常捕捉
 * 顺便将关闭资源放到finally中去
 */
public class UserMapperTest {
    @Test
    public void testFindAllUsers(){
        //获取SqlSession的对象
        SqlSession sqlSession = MybatisUtils.getSqlSession();

        //方式一：利用SqlSession的getMapper方法
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        List<User> users = userMapper.findAllUsers();

        //方式二：(老方法了，不推荐使用)
//        List<User> users = sqlSession.selectList("com.hky.dao.UserMapper.findAllUsers");
        //遍历集合
        for(User user : users){
            System.out.println(user);
        }

        sqlSession.close();
    }
}
```

### 存在的问题

+ **maven静态资源过滤问题**

  在此项目中xml文件放在java.com.hky.dao包下，未放在resources目录下，编译的时候可能会找不到包，所以要在pom.xml文件下加上以下配置

*可直接放在父工程的pom.xml里，对所有子工程都生效*

```xml
<!--此配置解决maven静态资源过滤问题（本来UserMapper.xml作为xml文件应该在resource文件夹里的，所以编译时找不到，加上以下配置就能够找到并加载）-->
<build>
    <resources>
        <resource>
            <directory>src/main/java</directory>
            <includes>
                <include>**/*.properties</include>
                <include>**/*.xml</include>
            </includes>
            <filtering>false</filtering>
        </resource>
        <resource>
            <directory>src/main/resource</directory>
            <includes>
                <include>**/*.properties</include>
                <include>**/*.xml</include>
            </includes>
            <filtering>true</filtering>
        </resource>
    </resources>
</build>
```

+ **每一个mapper都要进行注册**     *三种方式可进行注册*

  + 按resources方式注册   *没什么限制，路径写对了即可*

  ```xml
  <mappers>
      <mapper resource="com/hky/dao/UserMapper.xml"></mapper>
  </mappers>
  ```

  + 按接口注册   

    *这种注册方式可用注解的方式执行sql语句，但要用xml执行的话必须保证接口和对应的xml文件同名同包*

  ```xml
  <mappers>
      <mapper class="com.hky.dao.UserMapper"></mapper>
  </mappers>
  ```

  + 按包注册    必须保证接口和对应的xml文件同名同包

  ```xml
  <mappers>
      <package class="com.hky.dao"></mapper>
  </mappers>
  ```

  

+++

## CRUD操作

### 基本操作

+ **编写接口方法**

```java
public interface UserMapper {
    //查询表单中全部用户的信息
    List<User> findAllUsers();

	//根据id查询用户
    User selectById(int id);

    //插入方法
    int insertUser(User user);

    //修改用户方法
    int updateUser(User user);

    //删除用户的方法
    int deleteUser(int id);

    //用map传参，非正规写法
    int addUser(Map<String, Object> map);
}
```

+ **在对应的xml文件中编写sql语句**

```xml
<!--namespace的值是接口的全名-->
<mapper namespace="com.hky.dao.UserMapper">
    <!--id的值是namespace对应接口的方法，resultType的值是返回数据类型中对象的全类名-->
    <select id="findAllUsers" resultType="com.hky.entity.User">
        select * from user
    </select>

    <!--parameterType是参数的数据类型-->
    <select id="selectById" parameterType="int" resultType="com.hky.entity.User">
        select * from user where id = #{id}
    </select>

    <insert id="insertUser" parameterType="com.hky.entity.User">
        insert into user value(#{id}, #{name}, #{pwd})
    </insert>

    <update id="updateUser" parameterType="com.hky.entity.User">
        update user set name = #{name}, pwd = #{pwd} where id = #{id}
    </update>

    <delete id="deleteUser" parameterType="int">
        delete from user where id = #{id}
    </delete>

    <insert id="addUser" parameterType="map">
        insert into user value(#{uID}, #{uName}, #{password})
    </insert>
</mapper>
```

+ **写测试方法做测试**      *注意增删改操作必须手动提交事务*

```java
public class UserMapperTest {
	@Test
    public void testSelectById(){
        SqlSession sqlSession = MybatisUtils.getSqlSession();

        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        User user = userMapper.selectById(3);
        System.out.println(user);

        sqlSession.close();

    }

    /**
     * 测试插入数据的方法（默认开启事务）
     */
    @Test
    public void testInsertUser(){
        SqlSession sqlSession = MybatisUtils.getSqlSession();

        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        int res = userMapper.insertUser(new User(5, "何七", "852"));
        if(1 == res){
            System.out.println("插入成功");
            //必须commit，数据才会进入表中
            sqlSession.commit();
        }

        sqlSession.close();
    }

    @Test
    public void testUpdateUser(){
        SqlSession sqlSession = MybatisUtils.getSqlSession();

        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        int res = userMapper.updateUser(new User(2, "不是李四", "741"));

        if(1 == res){
            sqlSession.commit();
            System.out.println("修改成功");
        }

        sqlSession.close();
    }

    @Test
    public void testAddUser(){
        SqlSession sqlSession = MybatisUtils.getSqlSession();

        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("uID", 2);
        map.put("uName", "李四");
        map.put("password", "951");
        userMapper.insertUser(new User(2, "李四", "951"));

        sqlSession.commit();
        sqlSession.close();
    }
}
```

+ **备注**

  + 给sql语句传参的时候用${}相当于用Statement对象操作，可能会有sql注入问题。用#{}相当于PrepareStatement，可以避免sql注入问题。

  + 上方最后一个方法传参用map来传，通常情况下用实体类对象类传更规范且效果一样，除非参数特别复杂。这是非正规的写法，不建议使用，作为一种思路解决复杂问题

### 模糊查询

+ **第一种方式，直接在sql语句上拼接通配符**     *可能引起sql注入问题*

```xml
<select id="selectUserLike" parameterType="User" resultType="User">
    select * from user where name like "%"#{name}"%"
</select>
```

+ **第二种方式，在传入的参数上拼接通配符**

```xml
<select id="selectUserLike" parameterType="User" resultType="User">
    select * from user where name like #{name}
</select>
```

```java
@Test
public void testSelectUserLike(){
    SqlSession sqlSession = MybatisUtils.getSqlSession();

    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    User user = new User();
    //调用方法时在传入的参数上拼接通配符
    user.setName("%李%");
    List<User> users = userMapper.selectUserLike(user);

    for(User _user : users){
        System.out.println(_user);
    }

    sqlSession.close();
}
```

++++

## 配置解析

### 说明

+ **在核心配置mybatis-config文件上进行配置**

+ **配置顺序**

  properties---settings---typeAliases---typeHandlers---objectFactory---objectWrapperFactory---reflectorFactory---plugins---environments---databaseIdProvider---mappers

### enviroments

```xml
<!--可配置多套环境，连接多个数据库，但必须指定一个默认的数据库-->
<environments default="development">
    <environment id="development">
        <!--操作数据库的事务，一般为JDBC就好了-->
        <transactionManager type="JDBC"/>
        <!--dataSource的type还可换成unpooled：无连接池，或者jnd：应用其他容器，有外置数据源-->
        <dataSource type="POOLED">
                <property name="driver" value="com.mysql.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/mybatis?useSSL=true&amp;useUnicode=true&amp;characterEncoding=UTF-8"/>
                <property name="username" value="root"/>
                <property name="password" value="abc369"/>
            </dataSource>
    </environment>
</environments>
```

*注意上方url中&的转义字符形式*

### mappers

+ **映射器：**注册映射sql语句的xml文件

+ **注册方式：**
  + 按接口注册
  + 按resource方式注册  注意路径中是"/"不是"."
  + 按包注册

+ **mapper文件**
  + namespace的命名必须跟某个接口同名
  + 接口中的方法与映射文件中sql语句id应该一一对应

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
       PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
       "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.hky.mapper.UserMapper">
   
</mapper>
```

### Properties

+ **功能：**导入文件

+ **具体运用：**

  + 只导入文件

  ```xml
  <properties resource="db.properties"/>
  ```

  + 导入文件并配置属性,数据可直接写成属性，也可写到配置文件中，读取数据的时候优先读取配置文件中的

  ```xml
  <properties resource="db.properties">
      <property name="username" value="root"/>
      <property name="password" value="abc369"/>
  </properties>
  ```

  + 导入之后的使用方法

  ```xml
  <dataSource type="POOLED">
      <property name="driver" value="${driver}"/>
      <property name="url" value="${url}"/>
      <property name="username" value="${username}"/>
      <property name="password" value="${password}"/>
  </dataSource>
  ```

### typeAliases

+ **起别名,针对某个类,当实体类少的时候多用这种方式，直接div类的别名**

```xml
<typeAliases>
    <typeAlias type="com.User" alias="User"/>
</typeAliases>
```

+ **扫描包起别名,实体类多的时候多用这种方式，别名某认为类名或类名首字母小写，要特别设置其他别名可加注解@Alias**

```xml
<typeAliases>
	<package name="com.hky.entity"/>
</typeAliases>
```

```java
@Alias("user")
public class User {
}
```

### 其他配置

***只做了解***

#### setting

+ 开启缓存

```xml
<settings>
    <!--开启全局缓存（默认是开启的，但一般定性的写出来）-->
    <setting name="cacheEnabled" value="true"/>
</settings>
```

+ 开启、配置日志

```xml
<settings>
    <!--指定mybatis使用STDOUT_LOGGING日志记录-->
    <setting name="logImpl" value="STDOUT_LOGGING"/>
</settings>
```

+ 其他功能需要时查文档即可

#### typeHandler

*类型处理器*

+ 无论是 MyBatis 在预处理语句（PreparedStatement）中设置一个参数时，还是从结果集中取出一个值时， 都会用类型处理器将获取的值以合适的方式转换成 Java 类型。

+ 你可以重写类型处理器或创建你自己的类型处理器来处理不支持的或非标准的类型。  【了解即可】

#### objectFactory

+ MyBatis 每次创建结果对象的新实例时，它都会使用一个对象工厂（ObjectFactory）实例来完成。
+ 默认的对象工厂需要做的仅仅是实例化目标类，要么通过默认构造方法，要么在参数映射存在的时候通过有参构造方法来实例化。
+ 如果想覆盖对象工厂的默认行为，则可以通过创建自己的对象工厂来实现。【了解即可】

+++

## 作用域和生命周期

### Mybatis执行过程

1. 创建SqlSessionFactoryBuilder对象，传入核心配置文件的输入流调用buid方法。
2. 在build方法里，XmlConfigBuilder对象会解析输入流，将其中的环境配置信息获取出来，放到生成的Configuration对象中。
3. 然后再将Configuration传给新创建的SqlSessionFactory作为工厂创建SqlSession的核心配置。
4. 每次新建一个SqlSession就会传入Configuration存放配置信息的对象和Execution执行器、Transaction事务对象等
5. SqlSession调用getMapper方法通过传入的接口的class文件和核心配置文件中mapper的注册，映射到接口对应的xml文件或注解，获取该接口方法的实现sql语句，返回接口对象。
6. 再用接口执行方法。
7. 关闭SqlSession连接，将资源返还给SqlSessionFactory。
8. 最终功能都执行完了就关闭SqlSessionFactory，程序终止。

### 各对象理解

+ **SqlSessionFactoryBuilder** 

  SqlSessionFactoryBuilder 的生成只为创建SqlSessionFactory对象，创建为就没作用了，它是一个方法中的局部变量

+ **SqlSessionFactory**

  + 相当于一个数据库的连接池，被创建在项目运行的整个过程中一直存在，为所有方法执行sql语句时提供SqlSession对象。

  + SqlSessionFactory占据着数据库的连接资源。如果创建多个 SqlSessionFactory，那么就存在多个数据库连接池，这样不利于对数据库资源的控制，也会导致数据库连接资源被消耗光，出现系统宕机等情况。所以一般SqlSessionFactory是单例的，在整个应用过程中发挥作用。

+ **SqlSession**

  + 相当于对SqlSessionFactory连接池的一个连接。
  + 每次获取SqlSession（获取对数据库的连接），执行完操作数据库的方法之后要记得调用S起来SqlSession的close方法关闭连接，将资源返给SqlSessionFactory，减少资源的浪费。否则数据库资源会被耗光，系统将会瘫痪。
  + 官方说SqlSession不是线程安全的，建议在创建、使用的时候加上try...catch...finally来保证正常时候和最终关闭
  + Sql只在一个方法中创建到关闭这段时间内发挥作用。

+++

## ResultMap

+ **应用环境**

  实体类的属性名和数据库中表的字段不一致

+ **解决方法**

  1. 为查询结果集中的列取别名，使其和Bean对象的属性名一致

  ```xml
  <select id="selectUserById" resultType="User">
    select id , name , pwd as password from user where id = #{id}
  </select>
  ```

  2. 用resultMap处理

  ```xml
      <!--相当于给表中字段起别名，映射到实体类对象的各个属性，这么做之后，实体类对象中的属性不和数据库的表字段一样也可以成功封装结果集-->
      <resultMap id="UserMapper" type="User">
          <!--相同的可以不映射，只映射不同的就好了-->
  <!--        <result column="id" property="id"/>-->
  <!--        <result column="name" property="name"/>-->
          <result column="pwd" property="password"/>
      </resultMap>
  
  <select id="findAllUsers" resultMap="UserMapper">
      select * from user
  </select>
  ```

+ 

+++

## 分页查询

*limit的使用*

### 常用方法

```java
@Test
public void testFindUserByLimit(){
    SqlSession sqlSession = MybatisUtils.getSqlSession();

    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    Map<String, Object> condition = new HashMap<String, Object>();
    //跟数组一样，第一条记录的下标是0
    condition.put("startIndex", 2);
    condition.put("pageSize", 3);
    List<User> userList =  userMapper.findUserByLimit(condition);

    for(User user: userList){
        System.out.println(user);
    }

    sqlSession.close();
}
```

```xml
<!--分页查询-->
<select id="findUserByLimit" parameterType="map" resultMap="UserMapper">
    select * from user limit #{startIndex}, #{pageSize}
</select>
```

### 老方法

```java
/**
 * 测试RowBounds方式实现分页查询，老方法了，现在一般不用
 * 网上还有专门的分页插件PageHelper，提供了所有分页查询的所有形式
 */
@Test
public void testFindUserByLimit2(){
    SqlSession sqlSession = MybatisUtils.getSqlSession();

    RowBounds rowBounds = new RowBounds(1, 3);
    List<User> userList = sqlSession.selectList("com.hky.dao.UserMapper.findUserByLimit2", null, rowBounds);

    for(User user: userList){
        System.out.println(user);
    }

    sqlSession.close();
}
```

```xml
<!--RowBounds方式分页查询-->
<select id="findUserByLimit2" resultMap="UserMapper">
    select * from user
</select>
```

### 分页插件（PageHelper）

有时间去了解一下，功能比较齐全

+++

## 日志

### 理解：

​		在运行时如果出现bug，光看控制台爆的异常信息是比较难以识别出出错点具体在哪的。而debug虽好却比较麻烦，且在有些地方不太适用。这个时候看日志是比较好的方法，日志可以显示程序运行过程中的各种信息，学会看日志能够方便调错，且好一点的日志实现会自动备份到文件中，方便在项目运行完之后回过头来看程序运行情况

### 标准日志实现

在核心配置文件的settings属性中配置

*可以看到控制台输出详细的日志信息，但没有自动备份到文件中去*

```xml
<settings>
       <setting name="logImpl" value="STDOUT_LOGGING"/>
</settings>
```

### Log4j

+ **介绍：**

  + Log4j是Apache的一个开源项目
  + 配置完成之后能在控制台输出详细的程序运行信息
  + 可自己进行一些手动配置
  + 日志信息会记录到文件中

+ **使用步骤**

  1. 导入依赖

  ```xml
  <dependency>
     <groupId>log4j</groupId>
     <artifactId>log4j</artifactId>
     <version>1.2.17</version>
  </dependency>
  ```

  2. 编写配置文件

  ```properties
  #将等级为DEBUG的日志信息输出到console和file这两个目的地，console和file的定义在下面的代码
  log4j.rootLogger=DEBUG,console,file
  
  #控制台输出的相关设置
  log4j.appender.console = org.apache.log4j.ConsoleAppender
  log4j.appender.console.Target = System.out
  log4j.appender.console.Threshold=DEBUG
  log4j.appender.console.layout = org.apache.log4j.PatternLayout
  log4j.appender.console.layout.ConversionPattern=[%c]-%m%n
  
  #文件输出的相关设置
  log4j.appender.file = org.apache.log4j.RollingFileAppender
  log4j.appender.file.File=./log/kuang.log
  log4j.appender.file.MaxFileSize=10mb
  log4j.appender.file.Threshold=DEBUG
  log4j.appender.file.layout=org.apache.log4j.PatternLayout
  log4j.appender.file.layout.ConversionPattern=[%p][%d{yy-MM-dd}][%c]%m%n
  
  #日志输出级别
  log4j.logger.org.mybatis=DEBUG
  log4j.logger.java.sql=DEBUG
  log4j.logger.java.sql.Statement=DEBUG
  log4j.logger.java.sql.ResultSet=DEBUG
  log4j.logger.java.sql.PreparedStatement=DEBUG
  ```

  3. 在核心配置文件中的settings中配置

  ```xml
  <settings>
     <setting name="logImpl" value="LOG4J"/>
  </settings>
  ```

  4. 测试

  ```java
  @Test
  public void testLog4j(){
      logger.info("info:进了进了");
  }
  ```

+++

## 注解开发

### 说明

一般情况下注解方式只用于简单的sql语句，比较复杂的还得用xml方式的，逻辑上也会更清晰

### 实现

```java
public interface UserMapper {
    //查询表单中全部用户的信息
    @Select("select * from user")
    List<User> findAllUsers();
    
    //根据id和姓名查询用户
    @Select("select * from user where id = #{id} and name = #{name}")
    User selectByCondition(@Param("id") int id,@Param("name") String name);

    //根据id和姓名查询用户
    @Select("select * from user where id = #{id}")
    User selectById(int id);
}
```

```xml
<!--注解开发一般只用类注册的方式，其他方式会出问题-->
<mappers>
    <mapper class="com.hky.dao.UserMapper"/>
</mappers>
```

```java
@Test
public void testFindAllUsers(){
    //获取SqlSession的对象
    SqlSession sqlSession = MybatisUtils.getSqlSession();

    UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    List<User> users = userMapper.findAllUsers();

    //遍历集合
    for(User user : users){
        System.out.println(user);
    }

    sqlSession.close();
}
```

### 参数传递问题

***@Param注解的使用***

+ 当方法只有一个普通变量时，可以省略
+ 当方法参数是多个普通变量时，必须加注解为参数赋上对应的key值
+ 使用方式

```java
@Select("select * from user where id = #{id} and name = #{name}")
User selectByCondition(@Param("id") int id,@Param("name") String name);
```

+++

## 多对一处理

### 说明

在查询表单中学生信息时，将学生对应的老师一并查出（学生的老师是同一个人）

### 具体实现

1. 建表（学生表和教师表），插入数据

2. 创建学生和教师的实体类（包含各种基本方法）

```java
public class Teacher {
    private int id;
    private String name;
}
```

```java
public class Student {
    private int id;
    private String name;
    private Teacher teacher;
}
```

3. 创建学生和老师对应的mapper接口和mapper.xml

```java
public interface StudentMapper {

}
```

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.hky.dao.StudentMapper">
</mapper>
```

4. 先写一个简单的方法测试环境是否搭建完成

5. 开始实现功能

   + 按查询嵌套处理

   ```java
   List<Student> selectStudents();
   ```

   ```xml
   <!--按查询嵌套处理-->
   <resultMap id="StudentMap" type="com.hky.entity.Student">
       <result property="id" column="id"/>
       <result property="name" column="name"/>
       <!--当属性类型是Bean对象的时候用association，是集合的时候用collection-->
       <!--将tid传递给getTeachers方法，进行一次子查询，查询结果映射给teacher-->
       <association property="teacher" column="tid" javaType="com.hky.entity.Teacher" select="getTeachers"/>
   </resultMap>
   <select id="selectStudents" resultMap="StudentMap">
       select * from student
   </select>
   <!--上面传下来的值只有tid一个，所以下方#{tid}中的tid换成任意值都可以取到tid这个值-->
   <select id="getTeachers" resultType="com.hky.entity.Teacher">
       select * from teacher where id = #{tid}
   </select>
   ```

   + 按结果嵌套处理

   ```java
   List<Student> selectStudents1();
   ```

   ```xml
   <!--按结果嵌套处理-->
   <select id="selectStudents1" resultMap="StudentMap1">
       select s.id sid, s.name sname, t.name tname  from student s, teacher t
       where s.tid = t.id
   </select>
   <resultMap id="StudentMap1" type="com.hky.entity.Student">
       <result property="id" column="sid"/>
       <result property="name" column="sname"/>
       <!--结果嵌套-->
       <association property="teacher" javaType="com.hky.entity.Teacher">
           <result property="name" column="tname"/>
       </association>
   </resultMap>
   ```

### 小结

+ 按照查询进行嵌套处理就像SQL中的子查询

+ 按照结果进行嵌套处理就像SQL中的联表查询

+++

## 一对多

### 说明

按id查询教师表里的一个教师，并把该教师的所有学生查出来

### 具体实现

1. 建表（学生表和教师表），插入数据
2. 创建学生和教师的实体类（包含各种基本方法）

```java
public class Teacher {
    private int id;
    private String name;
    private List<Student> students;
}
```

```java
public class Student {
    private int id;
    private String name;
    private int tid;
}
```

3. 创建学生和老师对应的mapper接口和mapper.xml

4. 先写一个简单的方法测试环境是否搭建完成

5. 开始实现功能

   + 按结果嵌套处理

   ```xml
   <select id="getTeacher1" resultMap="TeacherMap1">
       select t.id tid, t.name tname, s.id sid, s.name sname
       from student s, teacher t
       where t.id = s.tid and t.id = #{tid}
   </select>
   <resultMap id="TeacherMap1" type="Teacher">
       <result property="id" column="tid"/>
       <result property="name" column="tname"/>
       <!--
           指定属性的类型用javaType
           集合中泛型的类型用ofType
       -->
       <collection property="students" ofType="Student">
           <result property="id" column="sid"/>
           <result property="name" column="sname"/>
           <result property="tid" column="tid"/>
       </collection>
   </resultMap>
   ```

   + 按查询嵌套处理

   ```xml
   <select id="getTeacher2" resultMap="TeacherMap2">
       select * from teacher
   </select>
   <resultMap id="TeacherMap2" type="Teacher">
       <result property="id" column="id"/>
       <result property="name" column="name"/>
       <collection property="students" javaType="ArrayList" ofType="Student" select="getStudentsById" column="id"/>
   </resultMap>
   <select id="getStudentsById" resultType="Student">
       select * from student where tid = #{tid}
   </select>
   ```

+++

## 到底啦，另开文件去

