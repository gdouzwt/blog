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