# SpringMVC

## 框架介绍

### 个人理解：

SpringMVC是一个控制层的框架，将控制层的功能分解成多个模块，各个模块（XX器）工作的时候相对独立。核心是前端控制器，作为各个模块工作的交接点，接收前端的请求，将工作分发给对应的模块，再接收它们返回的结果，最后响应给前端页面进行渲染。

### 工作原理图：

![](D:\training\学习笔记\网课截图\springmvc\工作原理.png)

+++

## 入门案例

### SpringMVC项目基本思路

![](D:\training\学习笔记\网课截图\springmvc\入门案例.png)

### 创建项目：

1. 新建SpringMVC项目，下载相应的包（不要自己去复制，容易出事），项目新建成功后加lib目录复制一份到WEB-INF目录下并add as library 

2. 配置xml文件

   ```xml
   <servlet>
       <servlet-name>dispatcher</servlet-name>
       <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
       <!--配置核心控制器dispatcher-->
       <init-param>
           <param-name>contextConfigLocation</param-name>
           <param-value>/WEB-INF/dispatcher-servlet.xml</param-value>
       </init-param>
       <load-on-startup>1</load-on-startup>
   </servlet>
   <!--配置控制器的映射-->
   <servlet-mapping>
       <servlet-name>dispatcher</servlet-name>
       <!--“/”表示拦截所有-->
       <url-pattern>/</url-pattern>
   </servlet-mapping>
   
   <!--配置过滤器解决乱码问题-->
   <filter>
       <filter-name>characterEncodingFilter</filter-name>
       <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
       <init-param>
           <param-name>Encoding</param-name>
           <param-value>UTF-8</param-value>
       </init-param>
   </filter>
   <filter-mapping>
       <filter-name>characterEncodingFilter</filter-name>
       <url-pattern>/*</url-pattern>
   </filter-mapping>
   ```

3. 配置dispatcher-servlet.xml

   1. 先开辟mvc和context两个空间

   2. 配置组件扫描、视图解析器、注解驱动

      ```xml
      <!--开启组件扫描-->
      <context:component-scan base-package="com.hky.springmvc.controller" />
      
      <!--视图解析器对象（转发请求跳转页面会在相应的文件夹中找页面）-->
      <bean id="internalResourceViewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
          <property name="prefix" value="/WEB-INF/jsp/"></property>
          <property name="suffix" value=".jsp"></property>
      </bean>
      
      <mvc:annotation-driven/>
      ```

4. 在src目录下写类，在WEB-INF目录下创建lib目录，在里面写页面

### @RequestMapping注解参数：

+ path：指定请求的url

+ value：和path使用方式一样

+ method：指定请求的方式（get、post、put），是个数组。*超链接都是get*

  值：RequestMethod.POST、RequestMethod.GET等

+ params：指定请求参数的条件，是个数组

  ​      例子：

  ​				  params={"username"} 请求参数必须含有key为username的键值对

  ​				  params={"username=hehe"} 请求参数必须username=hehe这对键值对

  ​				  params={"username!hehe"} 请求参数username的值不能是hehe

+ headers：指定请求头的条件，是个数组

  ​      例子：headers={"Accept"} 请求头必须含有key为username的键值对

+++

## 请求参数的绑定

### 归纳：

```中文
参数封装成什么对象由方法的参数决定，注意表单的参数的名称要符合命名规则才能封装成功
```

### 分类：

+ **普通类型**

  方法参数名称和表单数据的名称一样，直接传递过来

```jsp
<form action="user/testParams" method="post"><br>
  姓名：<input type="text" name="name"><br>
  密码：<input type="text" name="password"><br>
  <input type="submit" value="提交">
</form>
```

```java
@RequestMapping("/testParams")
public String testParams(String name, String password){
    System.out.println(name + ":" + password);
    return "success";
}
```

+ **封装成对象**

  表单数据的名称要注意按命名规则才能封装成功，表单名称要和类的属性名称相同

```jsp
<form action="user/testParams" method="post"><br>
  姓名：<input type="text" name="name"><br>
  密码：<input type="text" name="password"><br>
  <input type="submit" value="提交">
</form>
```

```java
@RequestMapping("/testParams")
public String testParams(User user){
    System.out.println(user);
    return "success";
}
```

+ **封装成复杂对象**           *对象中含有其他对象*

  注意对象中其他对象的属性在表单中的命名规则

```jsp
<form action="user/testParams" method="post"><br>
    <%--重点命名规则--%>
  姓名：<input type="text" name="user.name"><br>
  密码：<input type="text" name="user.password"><br>
    
  金额：<input type="text" name="money"><br>
  <input type="submit" value="提交">
</form>
```

```java
@RequestMapping("/testParams")
public String testParams(Account account){
    System.out.println(account);
    return "success";
}
```

+ **封装成含有集合的对象**

```jsp
<h1>测试集合类型的参数传递</h1>
<form action="user/testList" method="post"><br>
    <%--集合类型命名规则--%>
  姓名1：<input type="text" name="users[0].name"><br>
  密码1：<input type="text" name="users[0].password"><br>
  姓名2：<input type="text" name="users[1].name"><br>
  密码2：<input type="text" name="users[1].password"><br>
    <%--map类型命名规则--%>
  姓名3：<input type="text" name="map['VIP'].name"><br>
  密码3：<input type="text" name="map['VIP'].password"><br>
  <input type="submit" value="提交">
</form>
```

```java
/*
*People类中含有list集合和map的类型的属性
*/
@RequestMapping("/testList")
public String testList(People people){
    System.out.println(people);
    return "success";
}
```

+ **自定义类型转换器**

1. 写一个转换器类（继承Converter<被转换数据类型，要转换的数据类型>），实现它的convert方法

   ```java
   public class StringToDateConverter implements Converter<String, Date> {
   
       @Override
       public Date convert(String s) {
           if(null ==  s){
               throw new RuntimeException("输入为空");
           }
           DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
   
           try {
               return dateFormat.parse(s);
           } catch (ParseException e) {
               throw new RuntimeException("时间变量转换失败");
           }
   
       }
   }
   ```

2. 在dispatcher-servlet.xml文件中配置自定义的转换器

   ```xml
   <!--配置自定义类型转换器-->
   <bean id="conversionService2" class="org.springframework.context.support.ConversionServiceFactoryBean">
       <property name="converters">
           <set>
               <bean class="com.hky.springmvc.utils.StringToDateConverter"></bean>
           </set>
       </property>
   </bean>
   ```

3. 使用：配置完之后，在参数传递封装的时候，框架会按照我们定的规则处理时间的数据

+ **页面传数据到后台的中文乱码问题**

  在web.xml文件中配置过滤器

```xml
<!--配置过滤器解决乱码问题-->
<filter>
    <filter-name>characterEncodingFilter</filter-name>
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
    <init-param>
        <param-name>Encoding</param-name>
        <param-value>UTF-8</param-value>
    </init-param>
</filter>
<filter-mapping>
    <filter-name>characterEncodingFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

+++

## 常用注解

+ **@RequestParam**

  当前端传过来的参数的名称和后台方法的参数的名称不一样时，此注解可设定方法参数的名称。
  加上此注解之后，如果前端有另一个参数名称为username也对不上了

  ```java
  @RequestMapping("/testRequestParam")
  public String testRequestParam(@RequestParam(name = "name") String username){
      System.out.println(username);
      return "success";
  }
  ```

  ```xml
  <label>1、RequestParam</label><br>
  <a href="anno/testRequestParam?name=嘿嘿">点我跳转</a>
  ```

+ **@RequestBody**

  获取post方法的请求体，用于ajax

  ```java
  @RequestMapping("/testRequestBody")
  public String testRequestBody(@RequestBody String body){
      System.out.println(body);
      return "success";
  }
  ```

+ **@PathVariable**

  restful风格编码（利于缓存）

  ```java
  @RequestMapping("/testPathVariable/{uid}")
  public String testPathVariable(@PathVariable(name="uid") String id){
      System.out.println(id);
      return "success";
  }
  ```

  ```xml
  <label>3、PathVariable</label><br>
  <a href="anno/testPathVariable/10">点我跳转</a>
  ```

+ **@HiddenHttpMethodFilter**   *只作了解*

  可以模拟发送各种类型的浏览器请求，要先在web.xml中配置，再在表单中做处理实现功能，                                   很麻烦，有许多更好的方法

+ **@RequestHeader**

  ```
  获取请求头中某个值
  ```

  ```java
  @RequestMapping("/testRequestHeader")
  public String testRequestHeader(@RequestHeader(name = "Accept") String header){
      System.out.println(header);
      return "success";
  }
  ```

+ **@CookieValue**

  获取cookie中某个值

  ```java
  @RequestMapping("/testCookieValue")
  public String testCookieValue(@CookieValue(name = "JSESSIONID") String cookieValue){
      System.out.println(cookieValue);
      return "success";
  }
  ```

+ **@ModelAttribute**

  在请求的方法执行前先执行此注解标记的方法，多用于完善表单数据封装成的对象（有两种写法）

  + 写法一：有返回值，直接将对象返回

    ```java
    @RequestMapping("/testModelAttribute")
    public String testModelAttribute(User user){
        System.out.println(user);
        return "success";
    }
    @ModelAttribute
    public User showUser(String name){
        User user = new User("王五", "987", 23);
        return user;
    }
    ```

  + 写法二：无返回值，将对象放进map中

    ```java
    @RequestMapping("/testModelAttribute")
    public String testModelAttribute(@ModelAttribute(name="vip") User user){
        System.out.println(user);
        return "success";
    }
    @ModelAttribute
    public void showUser(String name, Map<String, User>map){
        User user = new User("王五", "987", 23);
        map.put("vip", user);
    }
    ```

+ **@SessionAttributes**

  只能注到类上，表示在此类的方法中的model将键值对放到session中去，在一次会话过程中共享该数据

  ```java
  @Controller
  @RequestMapping("/anno")
  @SessionAttributes("msg")
  public class AnnoController {
      @RequestMapping("/testSessionAttributes")
      public String testSessionAttributes(Model model){
          //将键值对放进request域中，加了@SessionAttributes之后键值对会被放进session域中
          model.addAttribute("msg", "session");
          //没办法放两对，原因未知
          //model.addAttribute("msg1", "session1");
          System.out.println("添加成功");
          return "success";
      }
      @RequestMapping("/getSessionAttributes")
      public String getSessionAttributes(ModelMap modelMap){
          //获取msg键对应的值
          String msg = (String)modelMap.get("msg");
          System.out.println(msg + "取到了");
          return "success";
      }
      @RequestMapping("/deleteSessionAttributes")
      public String deleteSessionAttributes(SessionStatus sessionStatus){
          //session域中的数据使用完成，删除
          sessionStatus.setComplete();
          System.out.println("删除完成");
          return "success";
      }
  }
  ```

+++

## 响应

+ **返回值为字符串可直接跳转**

  ```java
  @RequestMapping("/testString")
  public String testString(Model model){
      System.out.println("testString方法执行了");
      User user = new User("张三", "123", 23);
      //将user对象放到request域中，让页面通过el表达式去取值
      model.addAttribute("user", user);
      return "success";
  }
  ```

+ **无返回值跳转，和servlet一样**

  ```java
  @RequestMapping("testVoid")
  public void testVoid(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      //请求转发的写法
      request.getRequestDispatcher("/WEB-INF/jsp/success.jsp").forward(request, response);
  
      //重定向的写法
      response.sendRedirect(request.getContextPath() + "/WEB-INF/jsp/success.jsp");
  
      //直接响应
      response.setCharacterEncoding("UTF-8");//设置编码
      response.setContentType("text/html;charset=UTF-8");
      response.getWriter().print("hello");
  }
  ```

​       *要导入servlet-api.jar，不然拿不到HttpServletRequest、HttpServletResponse对象*

+ **返回ModelAndView，和返回String类似**     *做一点结合而已*

  ```java
  @RequestMapping("/testModelAndView")
  public ModelAndView testModelAndView(){
      System.out.println("testModelAndView方法执行了");
      User user = new User("张三", "123", 23);
      ModelAndView mv = new ModelAndView();
      //将user对象放到request域中
      mv.addObject(user);
      //设置跳转路径
      mv.setViewName("success");
      return mv;
  }
  ```

+ **返回请求转发和重定向的关键字完成跳转**

  ```java
  @RequestMapping("/testForwardOrRedirect")
  public String testForwardOrRedirect(){
      //请求转发
      return "forward:/WEB-INF/jsp/success.jsp";
  
      //重定向（只能转到web目录下的页面）
      return "redirect:/WEB-INF/jsp/success.jsp";//出错，访问不到资源
      return "redirect:/index.jsp";
  }
  ```

+ **异步请求**

  导入jackson的三个jar包，在参数前面之后加@RequestBody，前端传过来的json字符串会转换成对象
  在返回类型User前加@ResponseBody可以将放回的对象转成json对象

  ```js
  $(function () {
    $("#btn").click(function () {
      $.ajax({
        url: "response/testAjax",
        type: "post",
        contentType: "application/json;charset=UTF-8",
        data: '{"name":"heihei", "password":"456", "age":123}',
        dataType: "json",
        success:function (data) {
          alert(data.name);
        }
      })
    })
  })
  ```

  ```java
  @RequestMapping("/testAjax")
  public void testAjax(@RequestBody String body){
      //打印出来的是json的字符串形式
      System.out.println(body);
  }
  ```

  ```java
  @RequestMapping("/testAjax")
  public @ResponseBody User testAjax(@RequestBody User user){
      //ajax传过来的json字符串已经被自动封装javaBean成对象
      System.out.println(user);
      user.setName("zhangsan");
      return user;
  }
  ```

+++

## 文件上传

+ **使用fileLoad组件完成文件上传（传统方式）**

  ```java
  @RequestMapping("fileUpload1")
  public String fileUpload1(HttpServletRequest request) throws Exception {
      //文件上传位置
      String path = request.getSession().getServletContext().getRealPath("/uploads/");
      //判断文件路径是否存在，不存在则新建
      File file = new File(path);
      if(!file.exists()){
          file.mkdirs();
      }
  
      //解析request对象，获取文件上传项
      //创建一个工厂，作用：创建文件项
      DiskFileItemFactory diskFileItemFactory = new DiskFileItemFactory();
      //应该是加载请求，找到文件项再交给工厂的作用
      ServletFileUpload servletFileUpload = new ServletFileUpload(diskFileItemFactory);
  
      //开始解析,将其拆分成多个文件项
      List<FileItem> items = servletFileUpload.parseRequest(request);
      //遍历文件项
      for(FileItem item : items){
          //判断当前文件项是否为上传文件项
          if(item.isFormField()){
              //只是普通表单项
          }else{
              //是上传文件项
              //获取上传文件的名字
              String itemName = item.getName();
              //生成唯一文件名，防止同名覆盖(将随机码里的 - 去掉，可能是因为文件名称不能含这个吧)
              String uuid =  UUID.randomUUID().toString().replace("-", "");
              itemName = uuid + "_" + itemName;
              //完成文件上传
              item.write(new File(path, itemName));
              //删除临时文件（文件大于10kb时会生成临时文件）
              item.delete();
          }
      }
      return "success";
  }
  ```

+ **SpringMVC方式上传文件**

  *注意点：*1、表单中file类型输入框的name必须和下方方法参数MultipartFile的名称一样
                  2、要配置文件解析器，id必须为multipartResolver
                  3、表单必须设置method="post" enctype="multipart/form-data"，传统方式也要

  *配置文件解析器*

  ```xml
  <!--    配置文件解析器对象-->
  <bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
      <!--文件大小（10mb）-->
      <property name="maxUploadSize" value="10485760"/>
  </bean>
  ```

  *写文件上传的方法*

  ```java
  @RequestMapping("fileUpload2")
  public String fileUpload2(HttpServletRequest request, MultipartFile upload) throws Exception {
      //文件上传位置
      String path = request.getSession().getServletContext().getRealPath("/uploads/");
      System.out.println(path);
      //判断文件路径是否存在，不存在则新建
      File file = new File(path);
      if(!file.exists()){
          file.mkdirs();
      }
  
      //获取上传文件项的名字
      String itemName = upload.getOriginalFilename();
      //生成唯一文件名，防止同名覆盖(将随机码里的 - 去掉，可能是因为文件名称不能含这个吧)
      String uuid =  UUID.randomUUID().toString().replace("-", "");
      itemName = uuid + "_" + itemName;
      //完成文件上传
      upload.transferTo(new File(path, itemName));
  
      return "success";
  }
  ```

+ **跨服务器上传文件**

1. 创建一个新项目，部署新的Tomcat服务器（HTTP port：9090；JMX port：1090）。在项目中新建一个存放图片的文件夹

2. 在原来项目中写文件上传的方法（注意导包）

   ```java
   @RequestMapping("fileUpload3")
   public String fileUpload3(MultipartFile upload) throws Exception {
       //手写服务器存放文件的文件夹的地址
       String path = "http://localhost:9090/fileuploadserver_war_exploded/uploads/";
   
       //获取上传文件项的名字
       String itemName = upload.getOriginalFilename();
       //生成唯一文件名，防止同名覆盖(将随机码里的 - 去掉，可能是因为文件名称不能含这个吧)
       String uuid =  UUID.randomUUID().toString().replace("-", "");
       itemName = uuid + "_" + itemName;
   
       //创建客户端的对象
       Client client = Client.create();
       //和图片服务器进行连接（拿到web资源）
       WebResource webResource = client.resource(path + itemName);
       //上传文件
       webResource.put(upload);
       return "success";
   }
   ```

+ **文件上传页面表单的写法**

  ```jsp
  <form action="file/fileUpload3" method="post" enctype="multipart/form-data">
      传一传<input type="file" name="upload"/><br/>
      <input type="submit" value="上传"/>
  </form>
  ```

+++

## 异常处理器

1. **自定义异常类**

   ```java
   public class SysException extends Exception{
       //存储错误信息
       private String errorMsg;
   
       public String getErrorMsg() {
           return errorMsg;
       }
   
       public void setErrorMsg(String errorMsg) {
           this.errorMsg = errorMsg;
       }
   
       public SysException(String errorMsg) {
           this.errorMsg = errorMsg;
       }
   }
   ```

2. **自定义异常处理器**

   ```java
   public class SysExcptionResolver implements HandlerExceptionResolver {
       /**
        * 处理异常的逻辑
        * @param httpServletRequest
        * @param httpServletResponse
        * @param o
        * @param e
        * @return
        */
       @Override
       public ModelAndView resolveException(javax.servlet.http.HttpServletRequest httpServletRequest, javax.servlet.http.HttpServletResponse httpServletResponse, Object o, Exception e) {
           SysException ex = null;
           if(e instanceof SysException){
               ex = (SysException) e;
           }else{
               ex = new SysException("系统正在维护。。。。");
           }
           //创建ModelAndView对象完成信息传递和页面跳转
           ModelAndView mv = new ModelAndView();
           //将错误信息放到request域中
           mv.addObject("errorMsg", ex.getErrorMsg());
           //设置要跳转的页面
           mv.setViewName("error");
           return mv;
       }
   }
   ```

3. **配置异常处理器**

   ```xml
   <bean id="sysExcptionResolver" class="com.hky.demo.resolver.SysExcptionResolver" />
   ```

4. **写异常跳转页面**

   ```jsp
   <%@ page contentType="text/html;charset=UTF-8" language="java" %>
   <html>
   <head>
       <title>Title</title>
   </head>
   <body>
   ${errorMsg}
   </body>
   </html>
   ```

5. **测试异常处理器**

   ```java
   @Controller
   @RequestMapping("/exception")
   public class ExceptionController {
   
       @RequestMapping("/testException")
       public String testException() throws SysException{
           System.out.println("方法执行了。。。");
   
           try {
               //模拟异常
               int a = 10/0;
           } catch (Exception e) {
               e.printStackTrace();
               throw new RuntimeException();
               //手动抛出我们的自定义异常，注意方法上也要抛出
   //            throw new SysException("错误了。。。。");
           }
   
           return "success";
       }
   }
   ```

+++

## 拦截器

1. **编写自定义拦截器**     *可以有多个*

   ```java
   public class MyInterceptor implements HandlerInterceptor {
       /**
        * controller方法执行前执行，多用于处理权限问题
        * 返回true则放行，返回false则不放行
        * @param request
        * @param response
        * @param handler
        * @return
        * @throws Exception
        */
       @Override
       public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
           System.out.println("在你执行之前我已经执行了");
           //这里进行页面跳转之后controller里的跳转就无效了
           request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
   
           return true;
       }
   
       /**
        * controller方法执行后执行
        * @param request
        * @param response
        * @param handler
        * @param modelAndView
        * @throws Exception
        */
       @Override
       public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, @Nullable ModelAndView modelAndView) throws Exception {
           System.out.println("在你执行之后我才执行");
   
           //跳success后秒换error
   //        request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
       }
   
       /**
        * controller方法执行完进行页面跳转之后执行（多用于关闭资源）
        * @param request
        * @param response
        * @param handler
        * @param ex
        * @throws Exception
        */
       @Override
       public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, @Nullable Exception ex) throws Exception {
           System.out.println("我不管，我要断后。。。。");
       }
   }
   ```

2. **配置拦截器**

   ```xml
   <!--    配置拦截器（执行顺序是递归思想）-->
       <mvc:interceptors>
           <!--第一个拦截器-->
           <mvc:interceptor>
               <!--要拦截的方法（/**表示拦截所有方法）-->
               <mvc:mapping path="/interceptor/*"/>
                   <bean id="myInterceptor" class="com.hky.demo.interceptor.MyInterceptor"/>
               <!--不拦截的方法-->
   <!--            <mvc:exclude-mapping path="/**"/>-->
           </mvc:interceptor>
   
           <!--第二个拦截器-->
   <!--        <mvc:interceptor>-->
   <!--            &lt;!&ndash;要拦截的方法（/**表示拦截所有方法）&ndash;&gt;-->
   <!--            <mvc:mapping path="/user/*"/>-->
   <!--            <bean id="myInterceptor" class="com.hky.demo.interceptor.MyInterceptor"/>-->
   <!--            &lt;!&ndash;不拦截的方法&ndash;&gt;-->
   <!--            &lt;!&ndash;            <mvc:exclude-mapping path="/**"/>&ndash;&gt;-->
   <!--        </mvc:interceptor>-->
       </mvc:interceptors>
   ```

3. **请求controller方法测试拦截器**

