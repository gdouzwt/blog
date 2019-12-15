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

    这个题有点怀疑它的准确性，单选题又问“哪些说法是正确的”……<!--more-->

2. 在设计接口定义时，不用声明可能抛出的异常，可以把它放在具体实现类里处理。（）

    > A. 错
    >
    > B. 对

    A 错的

3. 定义一个接口使用的关键字是（）

    > A. interface
    >
    > B. class
    >
    > C. extends
    >
    > D. implements

    A

4. 在hibernate的多对多关系中，对inverse属性描述正确的是（）

    > A. 关系双方都在`<set>`节点中设置inverse="true"属性
    >
    > B. 一方在`<set>`节点中设置inverse="false"属性，另一方不设置
    >
    > C. 关系双方都在`<set>`节点中设置inverse="false"属性
    >
    > D. 关系双方都在`<set>`节点中去掉inverse属性

    很少直接用 hibernate 用Spring Data JPA，还要查一下文档。

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

    A

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

   spring 的 xml 配置方式也要熟悉啊，虽然现在基本用 Spring Boot，而且多采用 Java 配置。

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

#### 数据库 - 6题

##### Oracle

1. 如下语句：

   ```plsql
   if v_num>5 then
   	v_example: =1:
   elsif v_num>10 then
   	v_example: =2:
   elsif v_hum<20 then
   	v_example: =3:
   elsif v_num<39 then
   	v_example: =4:
   else
   	v_example: =5:
   ```

   如果v_num=37, 则v_example的值是多少？

   > A. 4
   >
   > B. 5
   >
   > C. 1
   >
   > D. 3
   >
   > E. 2

##### MySQL

2. 数据库恢复的重要依据是什么？

   > A. DD
   >
   > B. 文档
   >
   > C. DBA
   >
   > D. 事务日志

3. 用户经常查询雇员工资增长12%的情况，为提高性能需要建立一个索引，下列那条语句比较合适？

   > A. create bitmap index my_idx_1 on employee (salary)
   >
   > B. create unique index my_idex_1 on employee (salary)
   >
   > C. create index my_idx_1 on employee (salary * 1.12)
   >
   > D. create index my_idx_1 on employee (salary) reverse

4. 在创建触发器时，哪一个语句决定了触发器是针对每一行执行一次，还是针对每个语句执行一次？

   > A. REFERENCING
   >
   > B. FOR EACH
   >
   > C. NEW
   >
   > D. ON

5. MySQL的数值处理函数不包含（）。

   > A. Exp()
   >
   > B. Cot()
   >
   > C. Cos()
   >
   > D. Tan()

6. MySQL中，以下哪个函数可以计算出日期之差？

   > A. DateDiff()
   >
   > B. DateSub()
   >
   > C. SubDate()
   >
   > D. DiffDate()

   这题选 **A** 测试过了。`SELECT DateDiff('2019-10-25', now())` 现在到 2019 年 10 月 25 日还有几天？

#### Web基础 - 6题

1. 假设有以下的web.xml设定档：  ---- 多选题

   ```xml
   <security-constraint>
       <web-resource-collection>
           <web-resource-name>Login Required</web-resource-name>
           <url-pattern>/delete.jsp</url-pattern>
           <url-pattern>/delete.do</url-pattern>
           <http-method>GET</http-method>
           <http-method>POST</http-method>
       </web-resource-collection>
       <auth-constraint>
           <role-name>admin</role-name>
       </auth-constraint>
   </security-constraint>
   ```

   以下描述何者正确？

   >  - [ ] A. 其他角色可以使用GET、POST以外的HTTP方法存取
   >  - [ ] B. GET与POST方法只允许admin使用
   >  - [ ] C. admin角色只允许使用GET和POST方法
   >  - [ ] D. 只有admin角色才可以存取/delete.jsp与/delete.do

#### HTML

2. HTML中，target属性等于什么值，浏览器才会在一个新的、未命名的窗口中加载文档？

   > A. _blank
   >
   > B. _top
   >
   > C. _self
   >
   > D. _parent

3. 在HTML页面中，CSS样式的属性名为background-image对应的style对象的属性名是

   > A. back-ground
   >
   > B. background
   >
   > C. image
   >
   > D. backgroundImage

4. 表示放在每个定义术语词之前的HTML代码是？

   > A. `<dt>`
   >
   > B. `<dl></dl>`
   >
   > C. `<dd>`

5. 哪个HTML标签用来包含外部的样式表？

   > A. `<STYLE>`
   >
   > B. `<INCLUDE>`
   >
   > C. `<LINK>`
   >
   > D. `<CSS>`

6. 下列关于绝对路径的说法正确的一项是

   > A. 创建外部链接时，必须使用绝对路径
   >
   > B. 使用绝对路径需要考虑源文件的位置
   >
   > C. 在绝对路径中，如果目标文件被移动，则链接同时可用
   >
   > D. 绝对路径时被链接文档的完整URL，不包含使用的传输协议

#### 软件工程和计算机基础

##### 软件工程

1. 程序的三种基本控制结构的共同特点是（）。

   > A. 不能嵌套使用
   >
   > B. 仅用于自动控制系统
   >
   > C. 只能用来描述简单程序
   >
   > D. 单入口，单出口

##### 计算机基础

2. 32位处理器的最大虚拟地址空间为

   > A. 16GB
   >
   > B. 2GB
   >
   > C. 8GB
   >
   > D. 4GB

#### Linux

1. /dev/hdd3分区表示（）

   > A. 第4块IDE硬盘的第3个分区，是扩展区
   >
   > B. 第3块IDE硬盘的第3个分区，是主分区
   >
   > C. 第1块IDE硬盘的第3个分区，是逻辑分区
   >
   > D. 第4块IDE硬盘的第3个分区，是主分区或扩展分区

2. Linux管道符

   > A. `<`
   >
   > B. `>`
   >
   > C. `>>`
   >
   > D. `|`

#### 数据结构与算法

1. 设无向图G=(V, E)和G' =(V', E')，如果G'是G的生成树，则下面的说法中错误的是（）

   > A. G' 为 G的连通分量
   >
   > B. G' 是 G的一个无环子图
   >
   > C. G' 为 G的子图
   >
   > D. G' 为G的极小连通图且 V = V'

2. 若长度为 $n$ 的线性表采用顺序存储结构，在其第 $i$ 个位置插入一个新元素的算法的时间复杂度为（）(1<=i<=n+1)。

   > A. $O(0)$
   >
   > B. $O(n)$
   >
   > C. $O(1)$
   >
   > D. $O(n^2)$

3. 栈和队列的共同点是

   > A. 都是先进后出
   >
   > B. 没有共同点
   >
   > C. 都是先进先出
   >
   > D. 只允许在端点处插入和删除元素

4. 线性表的顺序存储结构和线性表的链式存储结构分别是

   > A. 顺序存取的存储结构、顺序存取的存储结构
   >
   > B. 随机存取的存储结构、随机存取的存储结构
   >
   > C. 任意存取的存储结构、任意存取的存储结构
   >
   > D. 随机存取的存储结构、顺序存取的存储结构

#### 测试理论->白盒测试

1. 有以下C语言代码段：下列测试用例可以实现条件覆盖的是（）。

   ```c
   int cal(int x,int y,int z){
   	int k = 0;
       if(x>3 || y>4){
           k = x + y;
       }
       if(z > 2){
           k += z;
       }
       return k;
   }
   ```

   > A. {x = 4、y = 4、z = 1} {x = 2、y = 5、 z = 3}
   >
   > B. {x = 4、y = 4、z = 3} {x = 2、 y = 3、z = 3}
   >
   > C. {x = 4、y = 4、z = 1} {x = 2、 y = 5、z = 2}
   >
   > D. {x = 4、y = 4、z = 4} {x = 4、 y = 4、z = 3}

2. 有以下C语言代码段：下列测试用例可以实现判定覆盖的是（）。

   ```c
   void cal(intx, int y, int z)
   {
       int k=0,j=0;
       if(x>3&&y>4){
           k=x+y;
       }
       if((x+y)>5||z>5){
           j=x+y+z;
       }
   }
   ```

   > A. {x = 3, y = 5, z = 5} {x = 2, y = 3, z = 5}
   >
   > B. {x = 4, y = 5, z = 5} {x = 3, y = 3, z = 5}
   >
   > C. {x = 4, y = 5, z = 5} {x = 2, y = 3, z = 5}
   >
   > D. {x = 4, y = 5, z = 5} {x = 2, y = 4, z = 5}

#### 编程题

按升序顺序输出begin到end闭区间的所有素数（在大于1的自然数中，除了1和它本身以外不再有其他因数）。

无需添加主函数，试题采用 JDK 1.7 编译。

样例一

> 输入
>
> int begin 1
>
> int end 10
>
> 输出（int[])
>
> 2，3，5，7

```java
package com.baiyi;

import java.util.*;

public class TestUtils {
    
    /**
     * 按升序顺序获取闭区间内的素数列表
     *
     * @param begin 开始值
     * @param end 结束值
     * @return 整型数组
     */
    public static int[] getPrimers(int begin, int end) throws Exception{
        // 请在此添加代码
    }
    
    // 若有需要，请在此处添加辅助变量、方法
}
```

