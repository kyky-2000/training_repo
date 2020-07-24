## 动态sql

### 说明

+ 动态SQL指的是根据不同的查询条件 , 生成不同的Sql语句

+ 灵活使用if, choose, when, otherwise, trim, where, set, foreach等标签完成不同需求的sql语句的拼接

### 具体实现

#### 配置开发环境

1. **建表**

```mysql
CREATE TABLE `blog` (
`id` varchar(50) NOT NULL COMMENT '博客id',
`title` varchar(100) NOT NULL COMMENT '博客标题',
`author` varchar(30) NOT NULL COMMENT '博客作者',
`create_time` datetime NOT NULL COMMENT '创建时间',
`views` int(30) NOT NULL COMMENT '浏览量'
) ENGINE=InnoDB DEFAULT CHARSET=utf8
```

2. **创建工程**

3. **编写实体类**    *这里省略了基本方法*

```java
public class Blog {
   private String id;
   private String title;
   private String author;
   private Date createTime;
   private int views;
}
```

​       ***备注***

​		这里的createTime和表中的create_time的命名规则不同，需要在核心配置文件中开启一个设置让其自动匹配，createTime和create_time虽然命名规则不同，但都必须按照各自的规则严格命名才能映射成功

```xml
<settings>
	<!--开启实体类的驼峰命名属性和数据库表的经典命名的映射-->
    <setting name="mapUnderscoreToCamelCase" value="true"/>
</settings>
```

4. **编写mapper接口和xml文件**

5. **编写生成随机id的工具类**

```java
public class IDUtil {
    public static String getId(){
        return UUID.randomUUID().toString().replaceAll("-", "");
    }
}
```

6. **测试环境是否配置成功**

```java
//向数据库的表插入数据
@Insert("insert into blog(id, title, author, create_time, views) values(#{id}, #{title}, #{author}, #{createTime}, #{views})")
int addBlog(Blog blog);
```

```java
//向数据库的表插入数据的一种方式，可生成java脚本
@Test
public void testAddBlog(){
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    BlogMapper mapper = sqlSession.getMapper(BlogMapper.class);

    Blog blog = new Blog();
    blog.setId(IDUtil.getId());
    blog.setTitle("卢本伟传记");
    blog.setAuthor("嫖老师");
    blog.setCreateTime(new Date());
    blog.setViews(666);
    mapper.addBlog(blog);

    blog.setId(IDUtil.getId());
    blog.setTitle("雷霆嘎巴");
    blog.setAuthor("无情辣少");
    blog.setViews(222);
    mapper.addBlog(blog);

    blog.setId(IDUtil.getId());
    blog.setTitle("阴阳师");
    blog.setAuthor("无名氏");
    blog.setViews(423);
    mapper.addBlog(blog);

    blog.setId(IDUtil.getId());
    blog.setTitle("不会吧不会吧");
    blog.setAuthor("网友");
    blog.setViews(456);
    mapper.addBlog(blog);

    blog.setId(IDUtil.getId());
    blog.setTitle("你干嘛~");
    blog.setAuthor("蔡徐坤");
    blog.setViews(1);
    mapper.addBlog(blog);

    sqlSession.commit();
    sqlSession.close();
}
```

### 编写案例

#### 拼接查询语句

+ **编写接口方法**

```java
//简单写法
List<Blog> searchBlogIf1(Map map);

//用where和if语句拼接sql语句实现动态sql
List<Blog> searchBlogIf2(Map map);

//用where和choose语句拼接sql语句实现动态sql
List<Blog> searchBlogIf3(Map map);

//用trim和if语句拼接sql语句实现动态sql
List<Blog> searchBlogIf4(Map map);
```

+ **在xml中编写sql语句实现方法**

```xml
<!--将多次重复写的sql代码抽取出来，要用的时候直接用include标签的refid属性引入就行
        一般只抽取if部分，将其他标签（如where等）保留在原语句中，减少不必要的出错
        引用方式见下方的searchBlogIf2方法
        -->
<select id="searchBlogIf1" parameterType="map" resultType="Blog">
    select * from blog where 1 = 1
    <if test="author != null">
        AND author = #{author}
    </if>
    <if test="title != null">
        AND title = #{title}
    </if>
</select>

<!--另一种写法，灵活的where标签
    where标签会判断包含的内容是否有返回值，如果有则向sql语句中插入一个where，
    如果返回值是以AND或者OR开头则自动将其剔除
-->
<select id="searchBlogIf2" parameterType="map" resultType="Blog">
    select * from blog
    <where>
        <!--对sql片段进行抽取，在上方，这里直接引-->
        <include refid="if-title-author"/>
    </where>
</select>

<!--choose相当于switch（已经自动加break的那种），外层套一个where帮我们在适当的时候加where和剔除多余的and-->
<select id="searchBlogIf3" parameterType="map" resultType="Blog">
    select * from blog
    <where>
        <choose>
            <when test="author != null">
                author = #{author}
            </when>
            <when test="title != null">
                AND title = #{title}
            </when>
            <otherwise>
                and views = #{views}
            </otherwise>
        </choose>
    </where>
</select>

<!--用trim代替where（trim是where和set的结合体，要注意设置好前缀和要覆盖的东西）-->
<select id="searchBlogIf4" parameterType="map" resultType="Blog">
    select * from blog
    <trim prefix="where" prefixOverrides="AND | OR">
        <if test="author != null">
            author = #{author}
        </if>
        <if test="title != null">
            AND title = #{title}
        </if>
    </trim>
</select>
```

+ **测试**

```java
@Test
public void testSearchBlogIf3(){
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    BlogMapper blogMapper = sqlSession.getMapper(BlogMapper.class);

    Map<String, Object> map = new HashMap<String, Object>();

    map.put("author", "嫖老师");
    map.put("title", "哦豁");
    map.put("views", 999);

    List<Blog> blogList = blogMapper.searchBlogIf3(map);

    for(Blog blog : blogList){
        System.out.println(blog);
    }
    sqlSession.close();
}
```

#### 拼接修改的sql语句

+ **编写接口方法**

```java
//更新记录（使用set标签）
int updateBlog(Map map);

//更新记录(用trim标签代替set标签)
int updateBlog1(Map map);
```

+ **编写xml文件实现方法**

```xml
<!--set标签和where用法差不多，不同的是set是剔除多余的后缀“，”-->
<update id="updateBlog" parameterType="map">
    update blog
    <set>
        <if test="title != null">
            title = #{title},
        </if>
        <if test="author != null">
            author = #{author}
        </if>
    </set>
    where id = #{id};
</update>

<!--用trim代替set（trim是where和set的结合体，要注意设置前缀以及要覆盖的东西）-->
<!--注意set是前缀，“，”是要覆盖掉的后缀-->
<update id="updateBlog1" parameterType="map">
    update blog
    <trim prefix="set" suffixOverrides=",">
        <if test="title != null">
        title = #{title},
        </if>
        <if test="author != null">
        author = #{author}
        </if>
    </trim>
    where id = #{id};
</update>
```

+ **测试**

```java
@Test
public void testUpdateBlog1() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    BlogMapper blogMapper = sqlSession.getMapper(BlogMapper.class);

    Map<String, String> map = new HashMap<String, String>();

    //map.put("author", "路人");
    map.put("title", "不会吧，会的");
    map.put("id", "70e92a1f18bb4e8cab6e5381830f042a");

    blogMapper.updateBlog1(map);

    sqlSession.commit();
    sqlSession.close();
}
```

#### foreach的使用

+ **编写接口方法**

```java
//用foreach标签遍历查询条件中包含的数组，并将数组的内容拼接到sql语句上
List<Blog> queryBlogForeach(Map map);
```

+ **编写xml文件实现方法**

```xml
<!--foreach的用法，建议先把原sql语句写出来，再按照给语句结合foreach和where的使用规则进行sql语句的书写
        要取map中的集合时，直接给属性collection赋值集合的key，不需要#{}格式-->
<select id="queryBlogForeach" parameterType="map" resultType="Blog">
    select * from blog
    <where>
        <foreach item="view" collection="views" open="(" separator="or" close=")">
        views= #{view}
        </foreach>
    </where>
</select>
<!--上方方法的另一种写法，当确保views集合里一定有数据时可以使用，views为空时会报错。不能匹配各种情况，是个失败的写法-->
<select id="queryBlogForeach1" parameterType="map" resultType="Blog">
    select * from blog
    <where>
    views in
        <foreach item="view" collection="views" open="(" separator="," close=")">
            #{view}
        </foreach>
    </where>
</select>
```

+ **测试**

```java
@Test
public void testQueryBlogForeach(){
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    BlogMapper blogMapper = sqlSession.getMapper(BlogMapper.class);

    HashMap map = new HashMap();
    List<Integer> views = new ArrayList<Integer>();
    //views.add(666);
    //views.add(222);
    map.put("views", views);
    List<Blog> blogList = blogMapper.queryBlogForeach(map);

    for(Blog blog : blogList){
        System.out.println(blog);
    }
    sqlSession.close();
}
```

#### 小结

+ 要写拼接sql之前，先写一个sql实例到数据库进行操作，若成功了则将其作为模板，进行切割，再加入合适的标签
+ 标签种类很多，都能实现一些功能，在使用前挑选最合适能简化一些操作，逻辑更加清晰。

+++

## 缓存

### 理解

+ 将用户多次重复查询，又很少更改的数据从数据库中取出之后放到内存中暂存，下次需要取时直接从内存中拿
+ 用户不用每次要去数据都去磁盘上查询，解决了高并发系统性能问题。
+ 查询速度更快，但内存有限，能缓存的东西不多。
+ 减少和数据库的交互次数，减少系统开销，提高系统效率。

### 一级缓存

#### 作用域

在一次会话中的查询到的内容会在本地缓存中暂存

*一次会话：SqlSession从获取到关闭这段时间内*

#### 测试

十分简单，就不做了

#### 失效的情况

+ **SqlSession对象不同**     每个SqlSession对象的缓存相对独立

```java
@Test
public void testQueryUserById(){
   SqlSession session = MybatisUtils.getSession();
   SqlSession session2 = MybatisUtils.getSession();
   UserMapper mapper = session.getMapper(UserMapper.class);
   UserMapper mapper2 = session2.getMapper(UserMapper.class);

   User user = mapper.queryUserById(1);
   System.out.println(user);
   User user2 = mapper2.queryUserById(1);
   System.out.println(user2);
   System.out.println(user==user2);

   session.close();
   session2.close();
}
```

+ **查询条件不同**

  必须在一次会话中第二次查了和第一次一样的东西才能直接从缓存中拿

+ **两次查询之间做了增删改的操作**

  因为增删改的操作可能会导致查询的数据发生变更，所以缓存失效了

+ **手动清理**

  调用了SqlSession对象的clearCache方法

#### 小结

一级缓存是框架自动开启的，像一个map一样保存信息。

### 二级缓存

#### 知识点 

+ 二级缓存也叫全局缓存。

+ 基于namespace级别的缓存，一个名称空间，对应一个二级缓存。

  即：我们在同一个Mapper中的查询，可以在二级缓存中拿到数据。

+ 查出的数据优先放在一级缓存，当会话结束之后一级缓存的东西会自动移动到二级缓存的空间中。

+ 要从缓存中去数据是先看二级缓存中有没有，没找到才看一级缓存中有没有。

#### 使用

+ 开启全局缓存

```xml
<!--开启全局缓存（默认是开启的，但一般定性的写出来）-->
<setting name="cacheEnabled" value="true"/>
```

+ 去要开启二级缓存的mapper.xml中添加配置

```xml
<!--为本mapper开启二级缓存，只对本mapper有效（简单写法）-->
<!--    <cache/>-->


<!--详细的写法，可手动设置参数
        参数：eviction="FIFO"          开启快进快出模式
             flushInterval="60000"    自动刷新时间为60000毫秒
             size="512"               缓存空间为512个引用
             readOnly="true"          开启只读，一般情况下是只读，否则可能会在不同线程下引起冲突-->
<cache
       eviction="FIFO"
       flushInterval="60000"
       size="512"
       readOnly="true"
       />
```

+ 测试

```java
public class UserMapperTest {
    @Test
    public void testSelectUserById(){
        SqlSession sqlSession1 = MybatisUtils.getSqlSession();
        SqlSession sqlSession2 = MybatisUtils.getSqlSession();

        UserMapper userMapper1 = sqlSession1.getMapper(UserMapper.class);
        User user1 = userMapper1.selectUserById(1);
        System.out.println(user1);
        sqlSession1.close();
        System.out.println("<====================================================================================>");

        UserMapper userMapper2 = sqlSession2.getMapper(UserMapper.class);
        User user2 = userMapper2.selectUserById(1);
        System.out.println(user2);
        System.out.println("<====================================================================================>");

        User user3 = userMapper2.selectUserById(2);
        System.out.println(user3);
        System.out.println("<====================================================================================>");

        User user4 = userMapper2.selectUserById(1);
        System.out.println(user4);
        System.out.println("<====================================================================================>");
        sqlSession2.close();
    }
}
```

+ 输出分析

![缓存的输出](D:\training\学习笔记\网课截图\Mybatis\缓存的输出.png)

### EhCache

***Ehcache是一种广泛使用的java分布式缓存，用于通用缓存***

+ **导依赖**     *像这种东西都可以直接到网上收（如：EhCache maven 就能搜到依赖）*

```xml
<dependency>
   <groupId>org.mybatis.caches</groupId>
   <artifactId>mybatis-ehcache</artifactId>
   <version>1.1.0</version>
</dependency>
```

+ **在mapper中配置**

```xml
<mapper namespace = “org.acme.FooMapper” > 
   <cache type = “org.mybatis.caches.ehcache.EhcacheCache” /> 
</mapper>
```

+ **添加ehcache.xml文件，设置ehcache**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ehcache xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="http://ehcache.org/ehcache.xsd"
        updateCheck="false">
   <!--
      diskStore：为缓存路径，ehcache分为内存和磁盘两级，此属性定义磁盘的缓存位置。参数解释如下：
      user.home – 用户主目录
      user.dir – 用户当前工作目录
      java.io.tmpdir – 默认临时文件路径
    -->
   <diskStore path="./tmpdir/Tmp_EhCache"/>
   
   <defaultCache
           eternal="false"
           maxElementsInMemory="10000"
           overflowToDisk="false"
           diskPersistent="false"
           timeToIdleSeconds="1800"
           timeToLiveSeconds="259200"
           memoryStoreEvictionPolicy="LRU"/>

   <cache
           name="cloud_user"
           eternal="false"
           maxElementsInMemory="5000"
           overflowToDisk="false"
           diskPersistent="false"
           timeToIdleSeconds="1800"
           timeToLiveSeconds="1800"
           memoryStoreEvictionPolicy="LRU"/>
   <!--
      defaultCache：默认缓存策略，当ehcache找不到定义的缓存时，则使用这个缓存策略。只能定义一个。
    -->
   <!--
     name:缓存名称。
     maxElementsInMemory:缓存最大数目
     maxElementsOnDisk：硬盘最大缓存个数。
     eternal:对象是否永久有效，一但设置了，timeout将不起作用。
     overflowToDisk:是否保存到磁盘，当系统当机时
     timeToIdleSeconds:设置对象在失效前的允许闲置时间（单位：秒）。仅当eternal=false对象不是永久有效时使用，可选属性，默认值是0，也就是可闲置时间无穷大。
     timeToLiveSeconds:设置对象在失效前允许存活时间（单位：秒）。最大时间介于创建时间和失效时间之间。仅当eternal=false对象不是永久有效时使用，默认是0.，也就是对象存活时间无穷大。
     diskPersistent：是否缓存虚拟机重启期数据 Whether the disk store persists between restarts of the Virtual Machine. The default value is false.
     diskSpoolBufferSizeMB：这个参数设置DiskStore（磁盘缓存）的缓存区大小。默认是30MB。每个Cache都应该有自己的一个缓冲区。
     diskExpiryThreadIntervalSeconds：磁盘失效线程运行时间间隔，默认是120秒。
     memoryStoreEvictionPolicy：当达到maxElementsInMemory限制时，Ehcache将会根据指定的策略去清理内存。默认策略是LRU（最近最少使用）。你可以设置为FIFO（先进先出）或是LFU（较少使用）。
     clearOnFlush：内存数量最大时是否清除。
     memoryStoreEvictionPolicy:可选策略有：LRU（最近最少使用，默认策略）、FIFO（先进先出）、LFU（最少访问次数）。
     FIFO，first in first out，这个是大家最熟的，先进先出。
     LFU， Less Frequently Used，就是上面例子中使用的策略，直白一点就是讲一直以来最少被使用的。如上面所讲，缓存的元素有一个hit属性，hit值最小的将会被清出缓存。
     LRU，Least Recently Used，最近最少使用的，缓存的元素有一个时间戳，当缓存容量满了，而又需要腾出地方来缓存新的元素的时候，那么现有缓存元素中时间戳离当前时间最远的元素将被清出缓存。
  -->

</ehcache>
```

##   ---完结------------------