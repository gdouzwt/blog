---
layout:     post
title:      学习MyBatis基础知识
date:       '2019-09-28 11:32:02'
subtitle:   学习笔记
author:     招文桃
catalog:    true
tags:
    - MyBatis
    - 数据库
---

### 目录

#### 第1章 MyBatis入门 1

##### 1.1 MyBatis简介 2

与其他的ORM不同，MyBatis没有将Java对象与数据库表关联起来，而是将Java方法与SQL语句关联。SQL语句可以被动态生成。

##### 1.2 创建Maven项目 3

Maven配置参考pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <properties>
<!--        <maven.compiler.source>1.8</maven.compiler.source>-->
<!--        <maven.compiler.target>1.8</maven.compiler.target>-->
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <groupId>io.zwt</groupId>
    <artifactId>simple</artifactId>
    <version>1.0-SNAPSHOT</version>

    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
        </dependency>
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis</artifactId>
            <version>3.3.0</version>
        </dependency>
        <dependency>
            <groupId>org.mybatis.generator</groupId>
            <artifactId>mybatis-generator</artifactId>
            <version>1.3.7</version>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>5.1.38</version>
        </dependency>
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
            <version>1.7.12</version>
        </dependency>
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-log4j12</artifactId>
            <version>1.7.12</version>
        </dependency>
        <dependency>
            <groupId>log4j</groupId>
            <artifactId>log4j</artifactId>
            <version>1.2.17</version>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <artifactId>maven-compiler-plugin</artifactId>
                <configuration>
                    <source>1.6</source>
                    <target>1.6</target>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>

```

##### 1.3 简单配置让MyBatis跑起来  7

 - 1.3.1 准备数据库 8

创建一些测试数据库。

 - 1.3.2 配置MyBatis 8

配置文件mybatis-config.xml 参考

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <settings>
        <setting name="logImpl" value="LOG4J"/>
    </settings>
    <typeAliases>
        <package name="io.zwt.simple.model"/>
    </typeAliases>

    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC">
                <property name="" value=""/>
            </transactionManager>
            <dataSource type="UNPOOLED">
                <property name="driver" value="com.mysql.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/mybatis"/>
                <property name="username" value="xxxx"/>
                <property name="password" value="xxxx"/>
            </dataSource>
        </environment>
    </environments>

    <mappers>
        <package name="io.zwt.simple.mapper"/>
<!--                <mapper resource="io/zwt/simple/mapper/CountryMapper.xml"/>-->
<!--                <mapper resource="io/zwt/simple/mapper/UserMapper.xml"/>-->
<!--                <mapper resource="io/zwt/simple/mapper/RoleMapper.xml"/>-->
<!--                <mapper resource="io/zwt/simple/mapper/PrivilegeMapper.xml"/>-->
<!--                <mapper resource="io/zwt/simple/mapper/UserRoleMapper.xml"/>-->
<!--                <mapper resource="io/zwt/simple/mapper/RolePrivilegeMapper.xml"/>-->
    </mappers>
</configuration>
```

 - 1.3.3 创建实体类和Mapper.xml文件 10

实体类就普通POJO，Mapper.xml文件可以参考如下：

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="io.zwt.simple.mapper.CountryMapper">
    <select id="selectAll" resultType="Country">
        select id, countryname, countrycode from country
    </select>
</mapper>
```

 - 1.3.4 配置Log4j以便查看MyBatis操作数据库的过程 11

Log4j挺有用的，方便，配置参考如下：

```properties
#全局配置 
log4j.rootLogger=ERROR, stdout 
#MyBatis 日志配置 
log4j.logger.io.zwt.simple.mapper=TRACE 
#控制台输出配置 
log4j.appender.stdout=org.apache.log4j.ConsoleAppender 
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout 
log4j.appender.stdout.layout.ConversionPattern=%5p [%t] - %m%n 
``` 

 - 1.3.5 编写测试代码让MyBatis跑起来 12

单元测试，使用了JUnit 4.12，熟悉下，到时候可以用JUnit 5，刚开始的单元测试代码如下：

```java
package io.zwt.simple.mapper;

import io.zwt.simple.model.Country;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.IOException;
import java.io.Reader;
import java.util.List;

public class CountryMapperTest {

    private static SqlSessionFactory sqlSessionFactory;

    @BeforeClass
    public static void init() {
        try {
            Reader reader = Resources.getResourceAsReader("mybatis-config.xml");
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);
            reader.close();
        } catch (IOException ignore) {
            ignore.printStackTrace();
        }
    }

    @Test
    public void testSelectAll() {
        SqlSession sqlSession = sqlSessionFactory.openSession();
        try {
            List<Country> countryList = sqlSession.selectList("selectAll");
            printCountryList(countryList);
        } finally {
            sqlSession.close();
        }
    }

    private void printCountryList(List<Country> countryList) {
        for (Country country : countryList) {
            System.out.printf("%-4d%4s%4s\n",
                    country.getId(), country.getCountryname(), country.getCountrycode());
        }
    }
}
```

##### 1.4 本章小结 14

上手简单，感觉还不错的样子。



#### 第2章 MyBatis XML方式的基本用法 15

##### 2.1 一个简单的权限控制需求 16

搞个简单的RBAC做例子。

2.1.1 创建数据库表 16 16

创建了五个表：用户表、角色表、权限表、用户角色关系表和角色权限关系表。

2.1.2 创建实体类 19 19

实体类也是很常规的POJO，后期可以使用MBG生成。

##### 2.2 使用XML方式 21

语句映射是特点。MyBatis 3.0 支持使用接口来调用方法。命名空间和方法id

##### 2.3 select用法 23

在接口（例如UserMapper)中添加一个`selectById`方法，后面代码参考如下：

```java
package io.zwt.simple.mapper;

import io.zwt.simple.model.SysRole;
import io.zwt.simple.model.SysUser;

import java.util.List;

public interface UserMapper {

    /**
     * 通过id查询用户
     *
     * @param id
     * @return
     */

    SysUser selectById(Long id);

    /**
     * 查询全部用户
     *
     * @return
     */
    List<SysUser> selectAll();

    /**
     * 根据用户 id 获取角色信息
     *
     * @param userId
     * @return
     */
    List<SysRole> selectRolesByUserId(Long userId);
}

```

接着在对应的Mapper.xml文件（例如UserMapper.xml）里面添加`<resultMap>`和`<select>`部分代码，参考如下：

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="io.zwt.simple.mapper.UserMapper">
    <resultMap id="userMap" type="io.zwt.simple.model.SysUser">
        <id property="id" column="id"/>
        <result property="userName" column="user_name"/>
        <result property="userPassword" column="user_password"/>
        <result property="userEmail" column="user_email"/>
        <result property="userInfo" column="user_info"/>
        <result property="headImg" column="head_img" jdbcType="BLOB"/>
        <result property="createTime" column="create_time" jdbcType="TIMESTAMP"/>
    </resultMap>

    <select id="selectById" resultMap="userMap">
        select * from sys_user where id = #{id}
    </select>

    <select id="selectAll" resultType="io.zwt.simple.model.SysUser">
        select id,
            user_name userName,
            user_password userPassword,
            user_email uersEmail,
            user_info userInfo,
            head_img headImg,
            create_time createTime
        from sys_user
    </select>

    <select id="selectRolesByUserId" resultType="io.zwt.simple.model.SysRole">
        select
            r.id,
            r.role_name roleName,
            r.enabled,
            r.create_by createBy,
            r.create_time createTime
        from sys_user u
        inner join sys_user_role ur on u.id = ur.user_id
        inner join sys_role r on ur.role_id = r.id
        where u.id = #{userId}
    </select>
</mapper>
```

接口和XML通过将namespace的值设置为接口的全限定名称来进行关联的，接口中方法名和XML中的`select`标签的`id`属性值对应。

##### 2.4 insert用法 35

 - 2.4.1 简单的insert方法 35

基本使用

 - 2.4.2 使用JDBC方式返回主键自增的值 38

id 回写

 - 2.4.3 使用selectKey返回主键的值 40

不同数据库的selectKey使用方式不同

##### 2.5 update用法 42



##### 2.6 delete用法 45

##### 2.7 多个接口参数的用法 47

##### 2.8 Mapper接口动态代理实现原理 50

##### 2.9 本章小结 51

#### 第3章 MyBatis注解方式的基本用法 53

##### 3.1 @Select注解 54

 - 3.1.1 使用mapUnderscoreToCamelCase配置 55

 - 3.1.2 使用resultMap方式 55

##### 3.2 @Insert注解 58

 - 3.2.1 不需要返回主键 58

 - 3.2.2 返回自增主键 58

 - 3.2.3 返回非自增主键 59

##### 3.3 @Update注解和@Delete注解 59

##### 3.4 Provider注解 60

##### 3.5 本章小结 61

#### 第4章 MyBatis动态SQL

##### 4.1 if用法 64

4.1.1 在WHERE条件中使用if 64

4.1.2 在UPDATE更新列中使用if 68

4.1.3 在INSERT动态插入列中使用if 70

##### 4.2 choose用法 72

##### 4.3 where、set、trim用法 75

 - 4.3.1 where用法 75

 - 4.3.2 set用法 76

 - 4.3.3 trim用法 77

##### 4.4 foreach用法 78

 - 4.4.1 foreach实现in集合 78

 - 4.4.2 foreach实现批量插入 81

 - 4.4.3 foreach实现动态UPDATE 84

##### 4.5 bind用法 86

##### 4.6 多数据库支持 86

##### 4.7 OGNL用法 89

##### 4.8 本章小结 90

#### 第5章 Mybatis代码生成器 91

##### 5.1 XML配置详解 92

 - 5.1.1 property标签 95

 - 5.1.2 plugin标签 96

 - 5.1.3 commentGenerator标签 97

 - 5.1.4 jdbcConnection标签 99

 - 5.1.5 javaTypeResolver标签 100

 - 5.1.6 javaModelGenerator标签 101

 - 5.1.7 sqlMapGenerator标签 102

 - 5.1.8 javaClientGenerator标签 103

 - 5.1.9 table标签 104

##### 5.2 一个配置参考示例 109

##### 5.3 运行MyBatis Generator 111

 - 5.3.1 使用Java编写代码运行 111

 - 5.3.2 从命令提示符运行 113

 - 5.3.3 使用Maven Plugin运行 115

 - 5.3.4 使用Eclipse插件运行 117

##### 5.4 Example介绍 119

##### 5.5 本章小结 124

#### 第6章 MyBatis高级查询 125

##### 6.1 高级结果映射 126

 - 6.1.1 一对一映射 126

 - 6.1.2 一对多映射 140

 - 6.1.3 鉴别器映射 156

##### 6.2 存储过程 159

 - 6.2.1 第一个存储过程 162

 - 6.2.2 第二个存储过程 164

 - 6.2.3 第三个和第四个存储过程 166

 - 6.2.4 在Oracle中使用游标参数的存储过程 168

##### 6.3 使用枚举或其他对象 170

 - 6.3.1 使用MyBatis提供的枚举处理器 170

 - 6.3.2 使用自定义的类型处理器 172

 - 6.3.3 对Java 8日期（JSR-310）的支持 175

##### 6.4 本章小结 176

#### 第7章 MyBatis缓存配置 177

##### 7.1 一级缓存 178

##### 7.2 二级缓存 181

 - 7.2.1 配置二级缓存 181

 - 7.2.2 使用二级缓存 184

##### 7.3 集成EhCache缓存 187

##### 7.4 集成Redis缓存 190

##### 7.5 脏数据的产生和避免 191

##### 7.6 二级缓存适用场景 194

##### 7.7 本章小结 194

#### 第8章 MyBatis插件开发 195

##### 8.1 拦截器接口介绍 196

##### 8.2 拦截器签名介绍 198

 - 8.2.1 Executor接口 198

 - 8.2.2 ParameterHandler接口 200

 - 8.2.3 ResultSetHandler接口 201

 - 8.2.4 StatementHandler接口 202

##### 8.3 下画线键值转小写驼峰形式插件 203

##### 8.4 分页插件 206

 - 8.4.1 PageInterceptor拦截器类 207

 - 8.4.2 Dialect接口 212

 - 8.4.3 MySqlDialect实现 216

##### 8.5 本章小结 220

#### 第9章 Spring集成MyBatis 221

##### 9.1 创建基本的Maven Web项目 222

##### 9.2 集成Spring和Spring MVC 227

##### 9.3 集成MyBatis 232

##### 9.4 几个简单实例 234

 - 9.4.1 基本准备 235

 - 9.4.2 开发Mapper层（Dao层） 235

 - 9.4.3 开发业务层（Service层） 238

 - 9.4.4 开发控制层（Controller层） 240

 - 9.4.5 开发视图层（View层） 242

 - 9.4.6 部署和运行应用 245

##### 9.5 本章小结 246

#### 第10章 Spring Boot集成MyBatis 247

##### 10.1 基本的Spring Boot项目 248

##### 10.2 集成MyBatis 251

##### 10.3 MyBatis Starter配置介绍 253

##### 10.4 简单示例 255

 - 10.4.1 引入simple依赖 255

 - 10.4.2 开发业务（Service）层 258

 - 10.4.3 开发控制（Controller）层 259

 - 10.4.4 运行应用查看效果 259

##### 10.5 本章小结 260

#### 第11章 MyBatis开源项目 261

##### 11.1 Git入门 262

 - 11.1.1 初次运行配置 262

 - 11.1.2 初始化和克隆仓库 263

 - 11.1.3 本地操作 265

 - 11.1.4 远程操作 267

##### 11.2 GitHub入门 269

 - 11.2.1 创建并提交到仓库 269

 - 11.2.2 Fork仓库并克隆到本地 272

 - 11.2.3 社交功能 275

##### 11.3 MyBatis源码讲解 278

##### 11.4 MyBatis测试用例 290

##### 11.5 本章小结 293

#### 附录 类型处理器（TypeHandler） 295