---
typora-root-url: ../
layout:     post
title:      OCP-1Z0-816 模拟测试1回顾
date:       '2020-02-26T15:15'
subtitle:   记录部分
keywords:   Oracle Certified, OCP 11, Java 11, 1Z0-816
author:     招文桃
catalog:    false
tags:
    - Java
    - 1Z0-816
    - 认证考试
---

**How many methods have to be provided by a class that is not abstract and that implements Serializable interface?**  

- [x] 0  
  > Serializable interface does not declare any methods. That is why is also called as a "marker" interface.  
- [ ] 1  
- [ ] 2  
- [ ] 3  

**Given that a code fragment has just created a JDBC Connection and has executed an update statement, which of the following statements is correct?**  

- [ ] Changes to the database are pending a commit call on the connection.  
- [ ] Changes to the database will be rolled back if another update is executed without committing the previous update.  
- [x] Changes to the database will be committed right after the update statement has completed execution.  
  > A Connection is always in auto-commit mode when it is created. As per the problem statement, an update was fired without explicitly disabling the auto-commit mode, the changes will be committed right after the update statement has finished execution.  
- [ ] Changes to the database will be committed when another query (update or select) is fired using the connection.  

**Explanation**  
When a connection is created, it is in auto-commit mode. i.e. auto-commit is enabled. This means that each individual SQL statement is treated as a transaction and is automatically committed right after it is completed. (A statement is completed when all of its result sets and update counts have been retrieved. In almost all cases, however, a statement is completed, and therefore committed, right after it is executed.)  

The way to allow two or more statements to be grouped into a transaction is to disable the auto-commit mode. Since it is enabled by default, you have to explicitly disable it after creating a connection by calling `con.setAutoCommit(false);`  <!--more-->


**Which interfaces does java.util.NavigableMap extend directly or indirectly?**  

- [ ] `java.util.SortedSet`  
- [x] `java.util.Map`  
- [x] `java.util.SortedMap`  
- [ ] `java.util.TreeMap`  
  > `TreeMap` is a class that implements `NavigableMap` interface. `ConcurrentSkipListMap` is the other such class.  
- [ ] `java.util.List`  

**Explanation**  
A `NavigableMap` is a `SortedMap` (which in turn extends Map) extended with navigation methods returning the closest matches for given search targets. Methods `lowerEntry`, `floorEntry`, `ceilingEntry`, and `higherEntry` return Map. Entry objects associated with keys respectively less than, less than or equal, greater than or equal, and greater than a give key, returning null if there is no such key. Similarly, methods `lowerKey`, `ceilingKey`, and `higherKey` return only the associated keys.  

All of these methods are designed for locating, not traversing entries.  

A `NavigableMap` may be accessed and traversed in either ascending or descending key order. The `descendingMap` method returns a view of the map with the senses of all relational and directional methods inverted. The performance of ascending operations and views is likely to be faster than that of descending ones. Methods `subMap`, `headMap`, and `tailMap` differ from the like-named `SortedMap` methods in accepting additional arguments describing whether lower and upper bounds are inclusive versus exclusive. Submaps of any NavigableMap must implement the NavigableMap interface.  

This interface additionally defines methods `firstEntry`, `pollFirstEntry`, `lastEntry`, and `pollLastEntry` that return and/or remove the least and greatest mapping, if any exist, else returning null.  

Implementations of entry-returning methods are expected to return `Map.Entry` pairs representing snapshots of mappings at the time they were produced, and thus generally do not support the optional `Entry.setValue` method. Note however that it is possible to change mappings in the associated map using method put.  

Methods `subMap(K, K)`, `headMap(K)`, and `tailMap(K)` are specified to return `SortedMap` to allow existing implementations of `SortedMap` to be compatibly retrofitted to implement `NavigableMap`, but extensions and implementations of this interface are encouraged to override these methods to return `NavigableMap`. Similarly, `SortedMap.keySet()` can be overridden to return `NavigableSet`.  

---

**In which of the following cases can the Console object be acquired?**  

- [ ] When the JVM is started from an interactive command line with explicitly redirecting the standard input and output streams to Console.  
- [x] When the JVM is started from an interactive command line without redirecting the standard input and output streams.  
- [ ] When the JVM is started in the background with the standard input and output streams directed to Console.  
- [ ] When the JVM is started in the background without redirecting the standard input and output streams.  

**Explanation**  
Whether a virtual machine has a console is dependent upon the underlying platform and also upon the manner in which the virtual machine is invoked. If the virtual machine is started from an interactive command line without redirecting the standard input and output streams then its console will exist and will typically be connected to the keyboard and display from which the virtual machine was launched. If the virtual machine is started automatically, for example by a background job scheduler, then it will typically not have a console.  

If this virtual machine has a console then it is represented by a unique instance of this class which can be obtained by invoking the `System.console()` method. If no console device is available then an invocation of that method will return null.  

---

Which of the following are wrapper classes for primitive types?  

- [ ] `java.lang.String`  
- [ ] `java.lang.Void`  
  > There is Void class but it does not wrap any primitive type.  
- [ ] `java.lang.Null`  
  > There is no Null class in java.  
- [ ] `java.lang.Object`  
- [ ] None of the above  

**Explanation**  
Frequently it is necessary to represent a value of primitive type as if it were an object. There are following wrapper classes for this purpose:  

`Byte`, `Char`, `Character`, `Short`, `Integer`, `Long`, `Float`, and `Double`.  

Note that Byte, Short, Integer, Long, Float and Double extend from Number which is an abstract class. An object of type Double, for example, contains a field whose type is double, representing that value in such a way that a reference to it can be stored in a variable of reference type. These classes also provide a number of methods for converting among primitive values, as well as supporting such standard methods as `equals` and `hasCode`.  

**It is important to understand that objects of wrapper classes are immutable.**

---

**Which of the following standard functional interface returns void?**  

- [ ] `Supplier`  
  > It takes no argument and returns an object.  
  > `T get()`  
- [ ] `Function`  
  > Represents a function that accepts one argument and produces a result.  
  > `R apply(T t)`  
  > Applies this function to the given argument.  
- [ ] `Predicate`  
  > It takes and argument and returns a boolean:  
  > `boolean test(T t)`  
  > Evaluates this predicate on the given argument.  
- [x] `Consumer`  
  > Its functional method is:  
  > `void accept(T t)`  
  > Performs this operation on the given argument.  
  > It also has the following default method:  
  > `default Consumer<T> andThen(Consumer<? super T> after)`  
  > Returns a composed `Consumer` that performs, in sequence, this operation followed by the after operation.  
- [ ] `UnaryOperator`  
  > Represents an operation on a single operand that produces a result of the same type as its operand. This is a specialization of `Function` for the case where the operand and result are of the same type.  

**Explanation**  
You should go through the description of all the functional interfaces given **[here](https://docs.oracle.com/javase/8/docs/api/java/util/function/package-summary.html)**  

---

Which of the following switches is/are used for controlling the execution of assertions at run time?

- [ ] `-ua`  
- [x] `-da`  
  > It is a short form for 'disable assertions'.  
- [x] `-enableassertions`  
- [ ] `-assert`  
- [ ] `-keepassertions`  

**Explanation**  
Although not explicitly mentioned in the exam objectives, OCP Java 11 Part 2 Exam requires you to know about the switches used to enable and disable assertions. Here are a few important points that you should know:  
Assertions can be enabled or disabled for specific classes and/or packages. To specify a class, use the class name. To specify a package, use the package name followed by "..."(three dots also known as ellipses):  
`java -ea:<class> myPackage.myProgram`  
`java -da:<package>... myPackage.myProgram`  
You can have multiple `-ea/-da` flags on the command line. For example, multiple flags allow you to enable assertions in general, but disable them in a particular package.  
`java -ea -da:com.xyz... myPackage.myProgram`  
The above command enables assertions for all classes  in all packages, but then the subsequent `-da` switch disables them for the `com.xyz` package and its subpackages.  
To enable assertion for one package and disable for other you can use:  
`java -ea:<package1>... -da:<package2>... myPackage.myProgram`  
You can enable or disable assertions in the unnamed root package (i.e. the default package) using the following commands:  
`java -ea:... myPackage.myProgram`  
`java -da:... myPackage.myProgram`  
Note that when you use a package name in the `ea` or `da` flag, the flag applies to that package as well as its subpackages. For example,  
`java -ea:com... -da:com.enthuware... com.enthuware.Main`  
The above command first enables assertions for all the classes in `com` as well as for the classes in the subpackages of `com`. It then disables assertions for classes in package `com.enthuware` and its subpackages.  
Another thing is that -ea/-da do not apply to system classes. For system classes (i.e. the classes that com bundled with the JDK/JRE), you need to use `-enablesystemassertions/-esa` or `-disablesystemassertions/-dsa`  
Note that * and ** are not valid wildcards for including subpackages.  

---

Which of these statements concerning the use of standard collection interfaces are true?  

- [ ] None of the standard collection classes are thread safe.  
  > Vector and Hashtable are.  
- [ ] class HashSet implements SortedSet.  
- [ ] Collection classes implementing List cannot have duplicate elements.  
  > List is meant for ordering of elements. Duplicates are allowed.  
- [ ] ArrayList can only accommodate a fixed number of elements.  
  > It grows as more elements are added.  
- [x] Some operations may throw an UnsupportedOperationException.  

**Explanation**  
Some operations may throw an UnsupportedOperationException. This exception type is unchecked, and code calling these operations is not required to explicitly handle exceptions of this type.

---

**Which of the following are standard annotations used to suppress various warnings generated by the compiler?**

- [ ] `@SuppressWarning("rawtypes")`  
- [ ] `@SuppressWarning( {"deprecation", "unchecked"} )`  
- [ ] `@SuppressWarning("deprecation", "unchecked")`  
  > Syntax is incorrect because this annotation takes only one value type String array. So, if you want to pass multiple string values, you must pass an array containing those values.  
- [ ] `@SafeVarargs`  
  > This can be used on a constructor or a method. If a constructor or a method tries to perform unsafe operations involving a var args parameter and a parameterized collection, a warning is generated. This annotation suppresses that warning. Example:  
  >
  > ```java
  > @SafeVarargs // Not actually safe but still suppresses the warning
  > static void m(List<String>... stringList) {
  >     Object[] array = stringLists;
  >     List<Integer> temList = Arrays.asList(42);
  >     array[0] = temList; // Semantically invalid, but compiles without warnings because of the annotation
  >     String s = stringLists[0].get(0);  // Oh no, ClassCastException at runtime!
  > }
  > ```  

- [ ] `@Override`  
  > This annotation is used only on methods. It causes a warning to be generated if a method does not actually override any method from the base class. It does not suppress any warning.  
- [ ] `@Deprecated`  
  > This annotation causes a warning to be generated. It does not suppress any warning.  

**Explanation**  
As per JLS 11 section 9.6.4.5, `@SuppressWarning` must support three values: `unchecked`, `deprecation`, and `removal`. However, it is not an error if you use a value that is not supported by the compiler. A compiler simply ignores it.

Different compilers may support more values. For example, Oracle's javac compiler supports a large number of values (https://docs.oracle.com/en/java/javase/11/tools/javac.html). The ones that you should be aware of for the exam are: `none`, `rawtypes`, `serial`, and `varargs`.

This annotation is not repeatable. Therefore, you cannot use it twice on the same type. However, you can specify multiple values like this: `@SuppressWarning({ "deprecation", "unchecked"} )`

---

**You are implementing a special sorting algorithm that can sort objects of different classes. Which of the following class declarations will you use?**

- [ ] ```java
  public class SpecialSorter<> {
      ...
  }
  ```

- [x] ```java
  public class SpecialSorter<K> {
      ...
  }
  ```

  > This is the correct way to define a generic class. Within the class, you can use K as a type, for example:
  >
  > ```java
  > public class SpecialSorter<K> {
  >     public void sort(ArrayList<K> items) {
  >         K item = items.get(0);
  >         // ...
  >     }
  > }
  > ```

- [ ] ```java
  public class <SpecialSorter> {
      ...
  }
  ```

- [ ] ```java
  public class SpecialSorter(K) {
      ...
  }
  ```

---

**Code that uses generic collection classes can interoperate with code that uses raw collections classes because of?**

- [x] type erasure  
  > Type erasure means that a compiled java class does not contain any of the generic information that is present in the java file. In other words, the compiler removes the generic information from a java class when it compile it into byte code. For example, `List<String> list;` and `List list;` are compiled to the same byte code. Therefore, at run time, it does not matter whether you've used generic classes or not and this kinds of classes to interoperate because they are essentially the same class to the JVM.  
  > Type erasure ensure that no new classes are created for parameterized types; consequently, generics incur no runtime overhead.  
- [ ] reification  
  > This is just the opposite of type erasure. Here, all the type information is preserved in the byte code. In Java, arrays are reified. For example,  
  >
  > ```java
  > ArrayList[] alArray = new ArrayList[1];
  > Collection[] cArray = alArray;
  > cArray[0] = new HashSet();
  > ```
  >
  > The above code will compile fine. But it will throw an `java.lang.ArrayStoreException` at run time because the byte code contains the information that `cArray` actually points to an array of `ArrayList`s and not of `HasSet`s.

- [ ] just in time compilation  
- [ ] byte code instrumentation  
字节码操作好像有点意思。

---



**Which of the following is/are valid functional interface?**

- [ ] ```java
  interface F {
      default void m() {}
  }
  ```

  It is not a valid functional interface because it does not have an abstract method.

- [ ] ```java
  interface F {
      default void m() {}
      static void n() {}
  }
  ```

  It is not a valid functional interface because it does not have an abstract method.

- [ ] ```java
  interface F {
      void m();
      void n();
  }
  ```

  It is not a valid functional interface because it has more than one abstract methods.

- [x] ```java
  interface F {
      default void m() { }
      abstract void n();
  }
  ```

  The use of abstract keyword is redundant here, but it legal.

- [ ] ```java
  interface F {
      void m() {}
  }
  ```  

This will not compile because the method has a body but it lacks the keyword default.  

**Explanation**  
A functional interface is an interface that contains exactly one abstract method. It may contain zero or more default methods and/or static methods in addition to the abstract method. Because a functional interface contains exactly one abstract method, you can omit the name of that method when you implement it using a lambda expression. For example, consider the following interface -  

```java
interface Predicate<T> {
    boolean test(T t);
}
```

The purpose of this interface is to provide a method that operates on an object of class T and return a boolean.  

You could have a method that takes an instance of class that  implements this interface defined like this -  

```java
public void printImportantData(ArrayList<Data> dataList, Predicate<Data> p) {
    for (Data d: dataList) {
        if (p.test(d)) System.out.println(d);
    }
}
```

where Data class could be as simple as `public class Data { public int value; }`  

Now, you can call the above method as follows:  

`printImportantData(al, (Data d) -> { return d.value > 1; } );`  

Notice the lack of method name here. This is possible because the interface has only one abstract method so the compiler can figure out the name. This can be shortened to:  

`printImportantData(al, d -> d.value > 1);`  

Notice that there is no declaration of d! The compiler can figure out all information it needs because the interface has only one abstract method and that method has only one parameter. So you don't need to write all those things in your code.  

Compare the above approach to the old style using an inner class that does the same thing -  

```java
printImportantData(al, new Predicate<Data>() {
    public boolean test(Data d) {
        return d.value > 1;
    }
});
```  

The `Predicate` interface described above can be used anywhere there is a need to "do something with an object and return a boolean" and is actually provided by the standard java library in `java.util.function` package. This package provides a few other useful functional interfaces.  

`Predicate<T>` Represents a predicate (boolean-valued function) of one argument of type T.  
`Consumer<T>` Represents an operation that accepts a single input argument of type T and returns no result.  
`Function<T, R>` Represents a function that accepts one argument of type T and produces a result of type R  
`Supplier<T>` Represents a supplier of results of type T.

Please see [http://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html](http://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html) for learning Lambda expressions in Java.

---

看段代码，判断输出：

```java
import java.util.HashSet;

enum SIZE {
    TALL, GRANDE, JUMBO;
}

public class CoffeeMug {
    public static void main(String[] args) {
        HashSet<SIZE> hs = new HashSet<>();
        hs.add(SIZE.TALL); hs.add(SIZE.JUMBO); hs.add(SIZE.GRANDE);
        hs.add(SIZE.TALL); hs.add(SIZE.TALL); hs.add(SIZE.JUMBO);
        for(SIZE s: hs) System.out.println(s);
    }
}
```  

There are two concepts involved in this question:

1. A `Set` (such as a `HashSet`) does not allow duplicate elements. If you add a duplicate element, it is ignored. Thus, only three unique `SIZE` elements are stored.

It is important to understand how the `add()` method of a Set works :  
`boolean add(E o)`
    Adds the specified element to this set if it is not already present (optional operation). More formally, adds the specified element, o, to this set if this set contains no element e such that `(o==null ? e==null : o.equals(e))`. If this set already contains the specified element, the call leaves this set unchanged and returns false. In combination with the restriction on constructors, this ensures that sets never contain duplicate elements.

2. The order of elements is not defined in `HashSet`. So while retrieving elements, it can return them in any order.  

Remember that, `TreeSet` does store elements in their **natural sorted order**.  

Also remember that the order of Enums is the order in which they are defined. It is not necessarily same as alphabetical order of their names.

---



**Which of the following annotations are retained for run time?**

- [ ] `@SuppressWarnings`  
  > It is defined with `@Retention(SOURCE)`  
- [ ] `@Override`  
  > It is defined with `@Retention(SOURCE)`  
- [x] `@SafeVarargs`  
  > It is defined with `@Retention(RUNTIME)`  
- [x] `@FunctionalInterface`  
  > It is defined with `@Retention(RUNTIME)`  
- [x] `@Deprecated`  
  > It is defined with `@Retention(RUNTIME)`  

---

**Your application needs to load a set of key value pairs from a database table which never changes. Multiple threads need to access this information but none of them changes it.  Which class would be the most appropriate to store such data if the values need not be keep in a sorted fashion?**

- [ ] `Hashtable`
- [x] `HashMap`
- [ ] `Set`
- [ ] `TreeMap`
- [ ] `List`

**Explanation**  
You should know that all `Hashtable` methods are synchronized and this compromises its performance for simultaneous reads.  
Since no thread modifies the data, it is not efficient to use a `Hashtable`.  
A `HashMap` is perfect choice because its methods are not synchronized and so it allows efficient multiple reads. `TreeMap` is used to keep the keys sorted which makes it a little bit slower than `HashMap`.  
`Set` and `List` can't be used since we need to store Key-value pairs.

---

**A programmer has written the following code to ensure that the phone number is not null and is of 10 characters:**

```java
public void processPhoneNumber(String number) {
    assert number != null && number.length() == 10 : "Invalid phone number";
    ...
}
```

Which of the given statements regarding the above code are correct?  

- [ ] This is an appropriate use of assertions.  
- [ ] This code will not work  in all situations.  
  > It will not work if assertions are disabled.  
- [ ] The given code is syntactically correct.  
- [ ] Constrains on input parameters should be enforced using assertions.  

**Explanation**  
As a rule, assertions should not be used to assert the validity of input parameters of a public method. Since assertions may be disabled at the wish of the user of the program, input validation will not occur when assertions are disabled. A public method should ensure in all situations(whether assertions are enabled or disabled) that the input parameters are valid before proceeding with the rest of the code. For this reason, input validation should always be done using the standard exception mechanism:

`if(number == null || number.length() != 10) throw new RuntimeException("Invalid phone number");`

However, assertions may be used to validate the input parameters of a private method. This is because private methods are called only by the developer of the class. Therefore, if a private method is called with an invalid parameter, this problem should be rectified at the development stage itself. It cannot occur in the production stage, so there is not need to throw an explicit exception.

---

### NIO 2 Files class

文件操作， `Files.copy`方法

However, `Files.isSameFile` method doesn't check the contents of the file. It is meant to check if the two path objects resolve to the same file or not. In this case, they are not, and so, it will return false.  

```java
public static Path copy(Path source, Path target, CopyOption... options) throws IOException
```

选项参数（options parameter)可以包括以下：

**REPLACE_EXISTING**

​      If the target file exists, then the target file is replaced if it is not a non-empty directory. If the target file exists and is a symbolic link, then the symbolic link itself, not the target of the link, is replaced.  

**COPY_ATTRIBUTES**

​      Attempts to copy the file attributes associated with this file to the target file. The exact file attributes that are copied is platform and file system dependent and therefore unspecified. Minimally, the last-modified-time is copied to the target file if supported by both the source and target file store. Copying of file timestamps may result in precision loss.  

**NOFOLLOW_LINKS**

​      Symbolic links are not followed. If the file is a symbolic link, then the symbolic link itself, not the target of the link, is copied. It is implementation specific if file attributes can be copied to the new link.  In other words, the COPY_ATTRIBUTES option may be ignored when copying a symbolic link.  
An implementation of this interface may support additional implementation specific options.
Coping a file is not an atomic operation. If an `IOException` is thrown then it's possible that the target file is incomplete or some of its file attributes have not been copied from the source file. When the REPLACE_EXISTING option is specified and the target file exists, then the target file is replaced. The check for the existence of the creation of the new file may not be atomic with respect to other file system activities.  

```java
public static Path move(Path source, Path target, CopyOption... options) throws IOException
```

Move or rename a file to a target file.
By default, this method attempts to move the file to the target file, failing if the target file exists except if the source and target are the same file, in which case this method has no effect. If the file is a symbolic link then the symbolic link itself, not the target of the link, is moved. This method may be invoked to move an empty directory. In some implementations a directory has entries for special files or links that are created when the directory is created. In such implementations a directory is considered empty when only the special entries exist. When invoked to move a directory that is not empty then the directory is moved if it does not require moving the entries in the directory. For example, renaming a directory on the same FileStore will usually not required moving the entries in the directory. When moving a directory requires that its entries be moved then this method fails (by throwing an `IOException`). To move a file tree may involve copying rather than moving directories and this can be done using the copy method in conjunction with the `Files.walkFileTree` utility method.

The options parameter may include any of the following:

**REPLACE_EXISTING** If the target file exists, then the target file is replaced if it is not a non-empty directory. If the target file exists and is a symbolic link, then the symbolic link itself, not the target of the link, is replaced.

**ATOMIC_MOVE** The move is performed as an atomic file system operation and all other options are ignored. If the target file exists then it is implementation specific if the existing file is replaced or this method fails by throwing an `IOException`. If the move cannot be performed as an atomic file system operation then `AtomicMoveNotSupportedException` is thrown. This can arise, for example, when the target location is on a different FileStore and would require that the file be copied, or target location is associated with a different provider to this object. An implementation of this interface may support additional implementation specific options.

Where the move requires that the file be copied then the last-modified-time is copied to the new file. An implementation may also attempt to copy other file attributes but is not required to fail if the file attributes cannot be copied. When the move is performed as a non-atomic operation, and an `IOException` is thrown, then the state of the files is not defined. The original file and the target file may both exist, the target file may be incomplete or some of its file attributes may not been copied from the original file.

---

Consider the following code:

```java
class LowBalanceException extends ____ {  // 1
    public LowBalanceException(String msg) { super(msg); }
}

class WithdrawalException extends ____ { // 2 
    public WithdrawalException(String msg) { super(msg); }
}

class Account {
    double balance;
    public void withdraw(double amount) throws WithdrawalException {
        try {
            throw new RuntimeException("Not Implemented");
        } catch (Exception e) {
            throw new LowBalanceException( e.getMessage());
        }
    }
    public static void main(String[] args) {
        try {
            Account a = new Account();
            a.withdraw(100.0);
        } catch(Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
```

What can be inserted at // 1 and // 2 so that the above code will prints Not Implemented?

- [ ] Exception
  Exception
- [ ] Exception
  LowBalanceException
- [x] WithdrawalException
  Exception
- [ ] WithdrawalException
  RuntimeException

**Explanation**

1. The withdraw method declares that it throws WithdrawalException. This means that the only exceptions that can come out of this method are WithdrawalExceptions  (which means WithdrawalException or its subclasses) or RuntimeExceptions.
2. The try block in withdraw method throws a RuntimeException. It will be caught by the catch(Exception) block because RuntimeException is-a Exception. The code in the catch block throws a LowBalanceException, which is not caught. Thus, it will be thrown out of this method, which means LowBalanceException must either be a RuntimeException or be a WithdrawalException (i.e. must extend WithdrawalException) to satisfy the throws clause of the withdraw method.
3. The main() method does not have a throws clause but the call to withdraw() is enclosed within a try block with catch(Exception). Thus, WithdrawalException can extend either Exception or RuntimeException.

[To be continued!]