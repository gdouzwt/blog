---
typora-root-url: ../
layout:     post
title:      816考点速记
date:       '2020-02-26T01:15'
last-modified: '2020-03-25T02:45'
subtitle:   
keywords:   Oracle Certified, OCP 11, Java 11, 1Z0-816
author:     招文桃
catalog:    true
tags:
    - Java
    - 1Z0-816
    - 认证考试
---

#### 1. Unmodifiable collections using of/copyOf and Collections.unmodifiableXXX methods  

`java.util.List` and `java.util.Set` have `of` and `copyOf` static factory methods that provide a convenient way to create unmodifiable lists/sets.  

The of methods accept either an array or multiple individual parameters. If you pass it a collection, it will be treated as a regular object i.e. it will return a list/set containing the same collection object instead of returning a list/set containing the objects that the passed collection contains.  

The `copyOf`, on the other hand, accepts only a `Collection`. It iterates through the passed `Collection` and adds all the elements of that `Collection` in the returned list/set. <!--more-->

Here are a few important points about these methods:  

1. They return unmodifiable copies of the original List/Set. Thus, any operation that tries to modify the returned list throws an `java.lang.UnsupportedOperationException`.
2. The list/set returned by the `of/copyOf` methods is completely independent of the original collection. Thus, if you modify the original collection after passing it to `of/copyOf` methods, those changes will not be reflected in the list returned by the `of/copyOf` methods.
3. They do not support `null` elements. Thus, if your array contains a `null` and if you try to create a `List` using `List.of`, it will throw a `NullPointerException`.

`Collections.unmodifiableXXX` methods  

`java.utils.Collections` class also has several variations of `unmodifiableXXX` static methods (such as `unmodifiableList(List )`, `unmodifiableSet(Set )`, and `unmodifiableMap(Map )` ). These method return an unmodifiable view of the underlying collection. The fundamental difference between `Collections.unmodifiableXXX` and `List.of/copyOf` methods is that `Collections.unmodifiableList` returns a view (instead of a copy) into the underlying list. Which means, if you make any changes to the underlying list after creating the view, those changes will be visible in the view. Further, `Collections.unmodifiableList` has no problem with nulls.  

The word unmodifiable in `unmodifiableXXX` method name refers to the fact that you cannot modify the view using a reference to view.  

---

#### 2. Top Down Approach for modularizing an application  

While modularizing an app in a top-down approach, you need to remember the following points -  

1. Any jar file can be converted into an automatic module by simply putting that jar on the module-path instead of the classpath. Java automatically derives the name of this module from the name of the jar file.  

2. Any jar that is put on classpath (instead of module-path) is loaded as a part of the "unnamed" module.  

3. An explicitly named module (which means, a module that has an explicitly defined name in its module-info.java file) can specify dependency on an automatic module just like it does for any other module i.e. by adding a requires `<module-name>;` clause in its module info but it cannot do so for the unnamed module because there is no way to write a requires clause without a name. In other words, a named module can access classes present in an automatic module but not in the unnamed module.  

4. Automatic modules are given access to classes in the unnamed module (even though there is no explicitly defined module-info and requires clause in an automatic module). In other words, a class from an automatic module will be able to read a class in the unnamed module without doing anything special.  

5. An automatic module exports all its packages and is allowed to read all packages exported by other modules. Thus, an automatic module can access: all packages of all other automatic modules + all packages exported by all explicitly named modules + all packages of the unnamed module (i.e. classes loaded from the classpath).  

Thus, if your application jar **A** directly uses a class from another jar **B**, then you would have to convert **B** into a module (either named or automatic). If **B** uses another jar **C**, then you can leave **C** on the class path if **B** hasn't yet been migrated into a named module. Otherwise, you would have to convert **C** into an automatic module as well.  

**Note:**  
There are two possible ways for an automatic module to get its name:  

1. When an Automatic-Module-Name entry is available in the manifest, its value is the name of the automatic module.
2. Otherwise, a name is derived from the JAR filename (see the ModuleFinder JavaDoc for the derivation algorithm) - Basically, hyphens are converted into dots and the version number part is ignored. So, for example, if you put mysql-connector-java-8.0.11.jar on module path, its module name would be mysql.connector.java  

---

#### 3. Bottom Up Approach for modularizing an application  

While modularizing an app using the bottom-up approach, you basically need to convert lower level libraries into modular jars before you can convert the higher level libraries. For example, if a class in **A.jar** directly uses a class from **B.jar**, and a class in **B.jar** directly uses a class from **C.jar**, you need to first modularize **C.jar** and then **B.jar** before you can modularize **A.jar**.  

Thus, bottom up approach is possible only when the dependent libraries are modularized already.  

---

#### 4. Java Module Execution Options  

You need to know about three command line options for running a class that is contained in a module:  

1. **--module-path** or -p: This option specifies the location(s) of the module(s) that are required for execution. This option is very versatile. You can specify exploded module directories, directories containing modular jars, or even specific modular or non-modular jars here. The path can be absolute or relative to the current directory. For example, --module-path c:/javatest/output/mathutils.jar or --module-path mathutils.jar  
You can also specify the location where the module's files are located. For example, if your module is named abc.math.utils and this module is stored in c:\javatest\output, then you can use: --module-path c:/javatest/output. Remember that c:\javatest\output directory must contain abc.math.utils directory and the module files (including module-info.class) must be present in their appropriate directory structure under abc.math.utils directory.  
You can specify as many jar files or module locations separated by path separator (; on windows and : on *nix) as required.  
NOTE: -p is the short form for --module-path.(Observe the single and double dashes).  

2. **--module** or **-m**: This option specifies the module that you want to run. For example, if you want to run abc.utils.Main class of abc.math.utils module, you should write --module abc.math.utils/abc.utils.Main  
If a module jar specifies the Main-Class property its MANIFEST.MF file, you can omit the main class name from --module option.  
For example, you can write, --module abc.math.utils instead of --module abc.math.utils/abc.utils.Main.  
NOTE: -m is the short form for --module.(Observe the single and double dashes).  
Thus,  
`java --module-path mathutils.jar --module abc.math.utils/abc.utils.Main` is same as  
`java -p mathutils.jar -m abc.math.utils/abc.utils.Main`  
NOTE: It is possible to treat modular code as non-modular by ignoring module options altogether. For example, if you want to run the same class using the older classpath option, you can do it like this:  
java -classpath mathutils.jar abc.utils.Main  

3. **-classpath**: Remember that modular code cannot access code present on the -classpath but "automatic modules" are an exception to this rule. When a non-modular jar is put on --module-path, it becomes an "automatic module" but it can still access all the modular as well as non-modular code. In other words, a class from an automatic module can access classes present on --module-path as well as on -classpath without having any "requires" clause (remember that there is no module-info in automatic modules).
Thus, if your modular jar A depends on a non-modular jar B, you have to put that non-modular jar B on --module-path. You must also add appropriate requires clause in your module A's module-info otherwise compilation of your module will not succeed. Further, if the non-modular jar B depends on another non-modular jar C, then the non-modular jar C may be put on the classpath or module-path.

---

#### 5. Java Module Compilation Options  

For compiling a Java class that is part of a module, you need to remember the following five command line options:  

1. --module-source-path: This option is used to specify the location of the module source files. It should point to the parent directory of the directory where module-info.java of the module is stored. For example, if your module name is moduleA, then the module-info.java for this module would be in moduleA directory and if moduleA directory exists in src directory, then --module-source-path should contain the src directory i.e. --module-source-path src  
If moduleA depends on another module named moduleB, and if moduleB directory exists in src2 directory, you can add this directory in --module-source-path as well i.e. --module-source-path src;src2. javac will compile the required files of src2 as well if the source code of moduleB is organized under src2 correctly.  
2. -d: This option is required when you use the --module-source-path option. It is used to specify the output directory. This is the directory where javac will generate the module's package driven directory structure and the class files for the sources. For example, if you specify out as the output directory, javac will create a directory under out with the same name as the name of the module and will create class files with appropriate package driven directory structure under that directory.  
3. --module or -m: This option is used when you want to compile all the source files of a particular module. This option is helpful when you want to compile all the files at once without listing any of the source files of a module individually in the command.  
For example, if you have two java files in moduleA, stored under moduleA\a\A1.java and moduleA\a\A2.java, you can compile both of them at the same time using the command: java --module-source-path src -d out --module moduleA  
Javac will find out all the java source files under moduleA and compile all of them. It will create the class files under the output directory specified in -d option i.e. out. Thus, the out directory will now have two class files - moduleA/a/A1.class and moduleA/a/A2.class.  
4. --module-path or -p: This option specifies the location(s) of any other module upon which the module to be compiled depends and is very versatile. You can specify the exploded module directories, directories containing modular jars, or specific modular jars here. For example, if you want to compile moduleA and it depends on another module named abc.util packaged as utils.jar located in thirdpartymodules directory then your module-path can be thirdpartymodules or thirdpartymodules/utils.jar. That both the following two commands will work:  
`javac --module-source-path src --module-path thirdpartymodules -d out --module moduleA` and  
`javac --module-source-path src --module-path thirdpartymodules\utils.jar -d out --module moduleA`  
**Note:**If your module depends on a non-modular third party jar, you need to do two things -Put that third party jar in --module-path.  
Putting a non-modular jar in --module-path causes that jar to be loaded as an "automatic module". The name of this module is assumed to be same as the name of the jar minus any version numbers. For example, if you put mysql-driver-6.0.jar in --module-path, it will be loaded as an automatic module with name mysql.driver. Name derivation is explained in detail in java.lang.module.ModuleFinder JavaDoc but for the exam, just remember that hyphens are converted into dots and the version number and extension part is removed.  
It is also possible for a non-modular jar to specify its module name using Automatic-Module-Name: `<module name>` entry to the jar's MANIFEST.MF.Add a requires `<module-name>;` clause in module-info of your module.  
5. **-classpath**: This option is used for compilation of non-modular code. If you are compiling regular non-modular code but that code depends on some classes, then you can put those classes or jars on the classpath using -classpath option.  
**Note:** This option is not helpful for compilation of modular code because classes of a modular cannot see classes on classpath. Modular code can only see other modular code. That is why, non-modular classes have to be converted into "automatic modules" and put on --module-path as explained above.  

---

#### 6. enum points  

You need to know the following facts about enums:  

1. Enum constructor is always private. You cannot make it public or protected. If an enum type has no constructor declarations, then a private constructor that takes no parameters is automatically provided.
2. An enum is implicitly final, which means you cannot extend it.
3. You cannot extend an enum from another enum or class because an enum implicitly extends java.lang.Enum. But an enum can implement interfaces.
4. Since enum maintains exactly one instance of its constants, you cannot clone it. You cannot even override the clone method in an enum because java.lang.Enum makes it final.
5. Compiler provides an enum with two public static methods automatically - values() and valueOf(String). The values() method returns an array of its constants and valueOf() method tries to match the String argument exactly (i.e. case sensitive) with an enum constant and returns that constant if successful otherwise it throws java.lang.IllegalArgumentException.
6. By default, an enum's toString() prints the enum name but you can override it to print anything you want.

The following are a few more important facts about java.lang.Enum which you should know:

1. It implements java.lang.Comparable (thus, an enum can be added to sorted collections such as SortedSet, TreeSet, and TreeMap).
2. It has a method ordinal(), which returns the index (starting with 0) of that constant i.e. the position of that constant in its enum declaration.
3. It has a method name(), which returns the name of this enum constant, exactly as declared in its enum declaration.

---

#### 7. AutoCloseable points  

You need to know the following points regarding try-with-resources statement for the exam:  

1. The resource class must implement java.lang.AutoCloseable interface. Many standard JDK classes such as implement java.io.Closeable interface, which extends java.lang.AutoCloseable.  
2. AutoCloseable has only one method - public void close() throws Exception.  
3. Resources are closed at the end of the try block and before any catch or finally block.  
4. Resources are not even accessible in the catch or finally block. For example:  
```java
   try(Device d = new Device())
   {
      d.read();
   }finally{
      d.close(); //This will not compile because d is not accessible here.
   }
```
Note that the try-with-resource was enhanced in Java 9 and it now allows you to use a variable declared before the try statement in the try-with-resource block. In this case, of course, the variable is accessible after the try block but the object referred to by it has been closed. For example, the following is valid since Java 9:  
```java
   Device d = new Device();
   try(d){ //valid since Java 9
     ...
   }finally{
      d.close(); //this will compile but may not work correctly because the object referred to by d has already been closed.
   }
```
5. Resources are closed in the reverse order of their creation.  
6. Resources are closed even if the code in the try block throws an exception.  
7. java.lang.AutoCloseable's close() throws Exception but java.io.Closeable's close() throws IOException.  
8. If code in try block throws exception and an exception also thrown while closing is resource, the exception thrown while closing the resource is suppressed. The caller gets the exception thrown in the try block.  

---

#### 8. JDBC URL  

The format of a JDBC URL is : `jdbc:<subprotocol>:<subname>`  
where subprotocol defines the kind of database connectivity mechanism that may be supported by one or more drivers. The contents and syntax of the subname will depend on the subprotocol.  
Here are a few examples of commonly used urls for connecting to derby db (the Java database that comes bundled with various IDEs such as NetBeans) and MySQL:  

> jdbc:derby:sample  
> jdbc:derby://localhost:1527/sample  
> jdbc:mysql://localhost:1527/sample  
> jdbc:mysql://192.168.0.100:3306/testdb  

Observe that a JDBC url always starts with jdbc: and has at least three components separated by a two colons.  
It also usually includes the hostname or address and the port number on which the database is listening for the requests but that is not necessary.  
Most drivers allow adding more options to the URL in the subname part, for example the following JDBC url for Oracle DB specifies the type of the jdbc driver :  
`jdbc:oracle:thin:@localhost:1521:testdb`  

Userid and password are usually supplied separately from the URL but some drivers allow them to be specified in the URL itself. For example:  
`jdbc:oracle:thin:scott/mypassword@//myhost:1521/orcl`  

---

#### 9. Command Line Switches for Assertions  

Although not explicitly mentioned in the exam objectives, OCP Java 11 Part 2 Exam requires you to know about the switches used to enable and disable assertions. Here are a few important points that you should know:  
Assertions can be enabled or disabled for specific classes and/or packages. To specify a class, use the class name. To specify a package, use the package name followed by "..." (three dots also known as ellipses):  
`java -ea:<class> myPackage.myProgram`  
`java -da:<package>... myPackage.myProgram`  

You can have multiple -ea/-da flags on the command line. For example, multiple flags allow you to enable assertions in general, but disable them in a particular package.  
`java -ea -da:com.xyz... myPackage.myProgram`  

The above command enables assertions for all classes in all packages, but then the subsequent -da switch disables them for the com.xyz package and its subpackages.  
To enable assertion for one package and disable for other you can use:  
`java -ea:<package1>... -da:<package2>... myPackage.myProgram`  

You can enable or disable assertions in the unnamed root package (i.e. the default package) using the following commands:  
`java -ea:... myPackage.myProgram`  
`java -da:... myPackage.myProgram`  

Note that when you use a package name in the ea or da flag, the flag applies to that package as well as its subpackages. For example,  
`java -ea:com... -da:com.enthuware... com.enthuware.Main`  
The above command first enables assertions for all the classes in com as well as for the classes in the subpackages of com. It then disables assertions for classes in package com.enthuware and its subpackages.  

Another thing is that `-ea/-da` do not apply to system classes. For system classes (i.e. the classes that come bundled with the JDK/JRE), you need to use `-enablesystemassertions/-esa` or `-disablesystemassertions/-dsa`  

Note that ** and * are not valid wildcards for including subpackages.  