---
layout:     post
title:      笔试题目回顾
date:       '2019-09-26 21:30:02'
subtitle:   做过的题目值得总结下
author:     招文桃
catalog:    true
tags:
    - 笔试面试
---

### 多选一选择题和编程题

#### JavaCore - 14题

1. 下述哪些说法是正确的？（）

    > A. 实例变量是用static关键字声明的
    >
    > B. 方法变量在方法执行时创建
    >
    > C. 实例变量是类的成员变量
    >
    > D. 方法变量在使用之前必须初始化

2. 在设计接口定义时，不用声明可能抛出的异常，可以把它放在具体实现类里处理。（）

    > A. 错
    >
    > B. 对

3. 定义一个接口使用的关键字是（）

    > A. interface
    >
    > B. class
    >
    > C. extends
    >
    > D. implements

4. 在hibernate的多对多关系中，对inverse属性描述正确的是（）

    > A. 关系双方都在<set>节点中设置inverse="true"属性
    >
    > B. 一方在<set>节点中设置inverse="false"属性，另一方不设置
    >
    > C. 关系双方都在<set>节点中设置inverse="false"属性
    >
    > D. 关系双方都在<set>节点中去掉inverse属性

5. 下列代码的输出是什么？

    ```java
    int[] xxx = {10,20};
    List<String> list = new ArrayList<String>(10);
    list.add("01");
    list.add("02");
    System.out.println(xxx.length + "," + list.size());
    ```

    > A. 2,2
    >
    > B. 10,2
    >
    > C. 2,10
    >
    > D. 1,2
    >
    > E. 编译错误

6. 在spring中， applicationContext.xml如下：

   ```xml
   <bean id="chinese1" class="test1.Chinese" >
       <!--设置注入：主要方式-->
       <constructor-arg>
           <ref local="steelAxe"/>
       </constructor-arg>
   </bean>
   <bean id="stoneAxe" class="test1.StoneAxe">
   </bean>
   <bean id="steelAxe" class="test1.SteelAxe">
   </bean>
   ```

   Beantest.java如下：

   `ApplicationContext ctx=new ClassPathxmlApplicationContext("applicationContext.xml");`

   以下说法错误的是（）

   > A. ApplicationContext实例化时，将所有对象都实例化了
   >
   > B. ApplicationContext实例化时，没有实例化Chinese对象
   >
   > C. 所有类都只能生成一个对象（即支持单例模式）
   >
   > D. 当前的依赖注入方式时构造方法注入

7. JDBC中，一条SQL语句的执行结果存放在一个类的对象中，这个类时（）

   > A. ResultSetMetaData
   >
   > B. Driver
   >
   > C. DatabaseMetaData
   >
   > D. ResultSet

8. 关于持久化状态的说法正确的是（）

   > A. 持久化状态只能由load方法转换过来；
   >
   > B. 持久化状态和游离状态的区别在于游离态没有对应的数据库记录；
   >
   > C. 持久化状态不能改变；
   >
   > D. 调用session的save方法可以改变变成持久化状态

9. JDBC中向MySQL发送并执行一个静态sql语句，应创建SQL语句对象的类是（）

   > A. Statement
   >
   > B. ResultSet
   >
   > C. Connection
   >
   > D. Driver

10. 下列说法中错误的是：

    > A. 没有在方法定义中指明throws的方法，不可能抛出checked异常
    >
    > B.程序不应该尝试捕捉处理Error
    >
    > C. 任何情况下，catch块都不应该将捕获的异常重新抛出
    >
    > D. 异常的逃逸可能会导致线程的终止

11. System.out.println(Math.floor(-2.1));

    打印的结果为：

    > A. 2.0
    >
    > B. -2.0
    >
    > C. -3.0

12. 以下声明中，错误的是？

    > A. float f = 1;
    >
    > B. float f = 1.2;
    >
    > C. float f = (float)1.2;
    >
    > D. float f = 12.f;

13. 设数组Array由以下语句定义int Array = new int[10];则数组的第一个元素的正确引用方法为：

    > A. Array[]
    >
    > B. Array
    >
    > C. Array[0]
    >
    > D. Array[1]

14. try {}里有一个return语句，那么紧跟在这个try后的finally {}里的code会不会被执行？

    > A. 会执行，在return前执行。
    >
    > B. 会执行，在return后执行。
    >
    > C. 其余三种说法全错
    >
    > D. 不会执行。

#### JSP - 4题

1. 要设置某个JSP页面为错误处理页面，以下page指令正确的是

   > A. `%@ page extends="javax.servlet.jsp.JspErrorPage"%`
   >
   > B. `%@ page isErrorPage="true"%`
   >
   > C. `%@ page info="error"%`
   >
   > D. `%@ page errorPage="true"%`

2. 在J2EE中，${2 + "4"}将输出（）

   > A. 2 + 4
   >
   > B. 6
   >
   > C. 不会输出，因为表达式是错误的
   >
   > D. 24

3. servlet的声明周期由一系列事件组成，把这些事件按照先后顺序排序，以下正确的是（）

   > A. 实例化，加载类，初始化，请求处理，销毁
   >
   > B. 加载类，实例化，初始化，请求处理，销毁
   >
   > C. 加载类，实例化，请求处理，初始化，销毁
   >
   > D. 加载类，初始化，实例化，请求处理，销毁

4. 在JSP中，只有一行代码：`<%=' A' + ' B' %>`，运行将输出（）

   > A. 131
   >
   > B. AB
   >
   > C. A+B
   >
   > D. 错误信息，因为表式是错误

