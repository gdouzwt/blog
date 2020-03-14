---
typora-root-url: ../
layout:     post
title:      816 基准测试回顾
date:       '2020-02-15T22:10'
subtitle:   OCP 816
author:     招文桃
catalog:    true
tags:
    - Java 11
    - OCP 11
---

The following are the details of the interface `ScheduledExecutorService`:
All Superinterfaces:
 `Executor`, `ExecutorService`
All Known Implementing Classes:
 `ScheduledThreadPoolExecutor`

An `ExecutorService` that can schedule commands to run after a given delay, or to execute periodically.
The schedule     methods create tasks with various delays and return a task object that can     be used to cancel or check execution. The `scheduleAtFixedRate` and  `scheduleWithFixedDelay` methods create and execute tasks that run periodically until cancelled.<!--more-->

Commands submitted using the `Executor.execute(java.lang.Runnable)` and `ExecutorService.submit` methods are scheduled with a requested delay of zero. Zero and negative delays (but not periods) are also allowed in schedule methods, and are treated as     requests for immediate execution.

All schedule methods accept relative delays and periods as arguments, not absolute times or dates. It is a simple matter to transform an absolute time represented as a Date to the required form. For example, to schedule at a certain future date, you can use: `schedule(task, date.getTime() - System.currentTimeMillis(), TimeUnit.MILLISECONDS)`. Beware however that expiration of a relative delay need not coincide with the current Date at which the task is enabled due to network time synchronization protocols, clock drift, or other factors. The Executors class provides convenient factory methods for the `ScheduledExecutorService` implementations provided in this package.   

Following is a usage example that sets up a `ScheduledExecutorService` to beep every ten seconds for an hour:  

```java
import java.util.concurrent.*;
import static java.util.concurrent.TimeUnit.SECONDS;

public class BeeperControl {
    private final ScheduledExecutorService scheduler =
            Executors.newScheduledThreadPool(1);

    public void beepForAnHour() {
        final ScheduledFuture<?> beeperHandle =
                scheduler.scheduleAtFixedRate(() ->
                        System.out.println("beep"), 0, 3, SECONDS);
    }

    public static void main(String[] args) {
        new BeeperControl().beepForAnHour();
    }
}
```

---

**Which of the following statements are correct?**

- [ ] A List stores elements in a Sorted Order.

  > List just keeps elements in the order in which they are added. For sorting, you'll need some other interface such as a SortedSet.

- [ ] A Set keeps the elements sorted and a List keeps the elements in the order they were added.

  > A Set keeps unique objects without any order or sorting.
  >
  > A List keeps the elements in the order they were added. A List may have non-unique elements.

- [ ] A SortedSet keeps the elements in the order they were added.

  > A SortedSet keeps unique elements in their natural order.

- [ ] An OrderedSet keeps the elements sorted.

  > There is no interface like OrderedSet

- [ ] An OrderedList keeps the elements ordered.

  > There is no such interface. The List interface itself is meant for keeping the elements in the order they were added.

- [x] A NavigableSet keeps the elements sorted.

  > A NavigableSet is a Sorted extended with navigation methods reporting closest matches for given search targets. Methods lower, floor, ceiling, and higher return elements respectively less than, or equal, greater than or equal, and greater than a given element, returning null if there is no such element.
  >
  > Since NavigableSet is a SortedSet, it keeps the elements sorted.

---

**How many methods have to be provided by a class that is not abstract and that implements Serializable interface?**

- [x] 0

  > Serializable interface does not declare any methods. That is why is also called as a "marker" interface.

- [ ] 1

- [ ] 2

- [ ] 3

---

Simple rule to determine sorting order: spaces < numbers < uppercase < lowercase

---

**Given that a code fragment has just created a JDBC Connection and has executed an update statement, which of the following statements is correct?**

- [ ] Changes to the database are pending a commit call on the connection.

- [ ] Changes to the database will be rolled back if another update is executed without committing the previous update.

- [x] Changes to the database will be committed right after the update statement has completed execution.

  > A Connection is always in auto-commit mode when it is created. As per the problem statement, an update was fired without explicitly disabling the auto-commit mode, the changes will be committed right after the update statement has finished execution.

- [ ] Changes to the database will be committed when another query (update or select) is fired using the connection.

**Explanation**

When a connection is created, it is in auto-commit mode. i.e. auto-commit is enabled. This means that each individual SQL statement is treated as a transaction and is automatically committed right after it is completed. (A statement is completed when all of its result sets and update counts have been retrieved. In almost all cases, however, a statement is completed, and therefore committed, right after it is executed.)

The way to allow two or more statements to be grouped into a transaction is to disable the auto-commit mode. Since it is enabled by default, you have to explicitly disable it after creating a connection by calling `con.setAutoCommit(false);`

JDBC 默认开启了自动提交。

---

**Which statements concerning the relation between a non-static inner class and its outer class instances are true?**

- [ ] Member variables of the outer instance are always accessible to inner instances, regardless of their accessibility modifiers.

- [x] Member variables of the outer instance can always be referred to using only the variable name within the inner instance.

  > This is possible only if that variable is not shadowed by another variable in inner class.

- [x] More than one inner instance can be associated with the same outer instance.

- [x] An inner class can extend its outer classes.

- [ ] A final outer class cannot have any inner classes.

  > There is no such rule.

---

**Which interfaces does java.util.NavigableMap extend directly or indirectly?**

- [ ] `java.util.SortedSet`

- [x] `java.util.Map`

- [x] `java.util.SortedMap`

- [ ] `java.util.TreeMap`

  `TreeMap` is a class that implements `NavigableMap` interface. `ConcurrentSkipListMap` is the other such class.

- [ ] `java.util.List`

**Explanation**

A `NavigableMap` is a `SortedMap` (which in turn extends Map) extended with navigation methods returning the closest matches for given search targets. Methods `lowerEntry`, `floorEntry`, `ceilingEntry`, and `higherEntry` return Map. Entry objects associated with keys respectively less than, less than or equal, greater than or equal, and greater than a give key, returning null if there is no such key. Similarly, methods `lowerKey`, `ceilingKey`, and `higherKey` return only the associated keys.

All of these methods are designed for locating, not traversing entries.

A `NavigableMap` may be accessed and traversed in either ascending or descending key order. The `descendingMap` method returns a view of the map with the senses of all relational and directional methods inverted. The performance of ascending operations and views is likely to be faster than that of descending ones. Methods `subMap`, `headMap`, and `tailMap` differ from the like-named `SortedMap` methods in accepting additional arguments describing whether lower and upper bounds are inclusive versus exclusive. Submaps of any NavigableMap must implement the NavigableMap interface.

This interface additionally defines methods `firstEntry`, `pollFirstEntry`, `lastEntry`, and `pollLastEntry` that return and/or remove the least and greatest mapping, if any exist, else returning null.

Implementations of entry-returning methods are expected to return `Map.Entry` pairs representing snapshots of mappings at the time they were produced, and thus generally do not support the optional `Entry.setValue` method. Note however that it is possible to change mappings in the associated map using method put.

Methods `subMap(K, K)`, `headMap(K)`, and `tailMap(K)` are specified to return `SortedMap` to allow existing implementations of `SortedMap` to be compatibly retrofitted to implement `NavigableMap`, but extensions and implementations of this interface are encouraged to override these methods to return `NavigableMap`. Similarly, `SortedMap.keySet()` can be overridden to return `NavigableSet`.

---

**Which of the following standard functional interfaces is most suitable to process a large collection of int primitives and return processed data for each of them?**

- [ ] `Function<Integer>`
- [x] `IntFunction`
- [ ] `Consumer<Integer>`
- [ ] `IntConsumer`
- [ ] `Predicate<Integer>`

**Explanation**

Using the regular functional interfaces by parameterizing them to Integer is inefficient as compared to using specially designed interfaces for primitives because they avoid the cost of boxing and unboxing the primitives.

Now, since the problem statement requires something to be returned after processing each int, you need to use a Function instead of a Consumer or a Predicate.

Therefor, **`IntFunction`** is most appropriate in this case.

---

**In which of the following cases can the Console object be acquired?**

You had to select 1 option

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

Byte, Char, Character, Short, Integer, Long, Float, and Double.

Note that Byte, Short, Integer, Long, Float and Double extend from Number which is an abstract class. An object of type Double, for example, contains a field whose type is double, representing that value in such a way that a reference to it can be stored in a variable of reference type. These classes also provide a number of methods for converting among primitive values, as well as supporting such standard methods as `equals` and `hasCode`.

**It is important to understand that objects of wrapper classes are immutable.**

---

Complete the following code so that it will print dick, harry, and tom in that order.

```java
public class TestClass {
    public static void main(String[] args) {
        
        Set<String> holder = new TreeSet<>();
        holder.add("tom");
        holder.add("dick");
        holder.add("harry");
        holder.add("tom");
        printIt(holder);
    }
    public static void printIt(Collection<String> list) {
        for(String s : list) System.out.println(s);
    }
}
```

**Explanation**

The output is expected to contain unique items. This implies that you need to use a `Set`. The output is also expected to be sorted. Thus, `TreeSet` is the only option.

The `printIt()` method expects a Collection of Strings. Therefore, the reference type of holder can be `Collection<String>` or any subclass of `Collection<String>` such as `Set<String>`. It cannot be `List` or `ArrayList` because the object on the right hand side is `TreeSet`.

---

**Which of the following standard functional interface returns void?**

- [ ] `Supplier`

  It takes no argument and returns an object. 

  `T get()`

- [ ] `Function`

  Represents a function that accepts one argument and produces a result.

  `R apply(T t)`

  Applies this function to the given argument.

- [ ] `Predicate`

  It takes and argument and returns a boolean:

  `boolean test(T t)`

  Evaluates this predicate on the given argument.

- [x] `Consumer`

  Its functional method is:

  `void accept(T t)`

  Performs this operation on the given argument.

  It also has the following default method:

  `default Consumer<T> andThen(Consumer<? super T> after)`

  Returns a composed `Consumer` that performs, in sequence, this operation followed by the after operation.

- [ ] `UnaryOperator`

  Represents an operation on a single operand that produces a result of the same type as its operand. This is a specialization of `Function` for the case where the operand and result are of the same type.

**Explanation**

You should go through the description of all the functional interfaces given here:

https://docs.oracle.com/javase/8/docs/api/java/util/function/package-summary.html

---

Which of the following switches is/are used for controlling the execution of assertions at run time?

- [ ] `-ua`

- [x] `-da`

  It is a short form for 'disable assertions'.

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

  List is meant for ordering of elements. Duplicates are allowed.

- [ ] ArrayList can only accommodate a fixed number of elements.

  It grows as more elements are added.

- [x] Some operations may throw an UnsupportedOperationException.

**Explanation**

Some operations may throw an UnsupportedOperationException. This exception type is unchecked, and code calling these operations is not required to explicitly handle exceptions of this type.

---

Identify correct statements about the Java module system.

- [ ] If a request is made to load a type whose package is not defined in any known module system will attempt to load it from the class path.

- [ ] The unnamed module can only access types present in the unnamed module.

  The unnamed module reads every other module. In other words, a class in an unnamed module can access all exported types of all modules.

- [ ] Code from a named module can access classes that are on the classpath.

  A named module cannot access any random class from the classpath. If your named module requires access to a non-modular class, you must put the non-modular class/jar on module-path and load it as an automatic module. Further, you must also put an appropriate "requires" clause in your module-info.

- [ ] If a package is defined in both a named module and the unnamed module then the package in the unnamed module is ignored.

- [ ] An automatic module cannot access classes from the unnamed module.

  Remember that named modules cannot access classes from the unnamed module because it is not possible for named module to declare dependency on the unnamed module.

  But what if a named module needs to access a class from a non-modular jar? Well, you can put the non-modular jar on the module-path, thereby making it an automatic module. A named module can declare dependency on an automatic module using the requires clause.

  Now, what if that jar in turn requires access to some other class from another third party non-modular jar? Here, the original modular jar doesn't directly access the non-modular jar, so it may not be wise to create an automatic module out of all such third party jars. This is where the -classpath options is helpful.

  In addition to reading every other named module, an automatic module is also made to read the unnamed module. Thus, while running a modular application, the classpath option can be used to enable automatic modules to access third party non-modular jars.

**Explanation**

**Bottom Up Approach for modularizing an application**

While modularizing an app using the bottom-up approach, you basically need to convert lower level libraries into modular jars before you can convert the higher level libraries. For example, if a class in **A.jar** directly uses a class from **B.jar**, and a class in **B.jar** directly uses a class from **C.jar**, you need to first modularize **C.jar** and then **B.jar** before you can modularize **A.jar**.

Thus, bottom up approach is possible only when the dependent libraries are modularized already.

**Top Down Approach for modularzing an application**

While modularizing an app in a top-down approach, you need to remember the following points - 

1. Any jar file can be converted into an automatic module by simply putting that jar on the *module-path* instead of the *classpath*. Java automatically derives the name of this module from the jar file.

2. Any jar that is put on classpath(instead of *module-path*) is loaded as part of the "unnamed" module.

3. An explicitly named module (which means, a module that has an explicitly defined name in its *module-info.java* file) can specify dependency on an automatic module just like it does for any other module i.e. by adding a `requires <module-name>;` clause in its module info but it cannot do so for the unnamed module because there is no way to write a `requires` clause without a name. In other words, named module can access classes present in an automatic module but not in the unnamed module.

4. Automatic modules are given access to classes in the unnamed module (even though there is no explicitly defined module-info and requires clause in an automatic module). In other words, a class from an automatic module will be able to read a class in the unnamed module without doing anything special.

5. An automatic module exports all its packages and is allowed to read all packages exported by other modules. Thus, an automatic module can access: all packages of all other automatic modules + all packages exported by all explicitly named modules + all packages of the unnamed module (i.e. classes loaded from the classpath).

   Thus, if your application jar **A** directly uses a class from another jar **B**, then you would have to convert **B** into a module (either named or automatic). If **B** uses another jar **C**, then you can leave **C** on the class path if **B** hasn't yet been migrated into a named module. Otherwise, you would have to convert **C** into an automatic module as well.

   **Note:**

   There are two possible ways for an automatic module to get its name:

   1. When an Automatic-Module-Name entry is available in the manifest, its value is the name of the automatic module.
   2. Otherwise, a name is derived from the JAR filename (see the ModuleFinder JavaDoc for the derivation algorithm) - Basically, hyphens are converted into dots and the version number part is ignored. So, for example, if you put `mysql-connector-java-8.0.11.jar` on module path, its module name would be `mysql.connector.java`

---

Using a `Callable` would be more appropriate than using a `Runnable` in which of the following situations?

- [ ] When you want to execute a task directly in a separate thread.

  A Callable cannot be passed to Thread for Thread creation but a Runnable can be. i.e. `new Thread(aRunnable);` is valid. But `new Thread(aCallable);` is not. Therefore, if you want to execute a task directly in a Thread, a `Callable` is not suitable. You will need to use a `Runnable`. You can achieve the same by using an `ExecutorService.submit(aCallable)` , but in this case, you are not controlling the Thread directly.

- [ ] When your task might throw a checked exception and you want to execute it in a separate Thread.

  `Callable.call()` allows you to declare checked exceptions while `Runnable.run()` does not. So if your task throws a checked exception, it would be more appropriate to use a `Callable`.

- [ ] When your task does not return any result but you want to execute the task asynchronously.

  Both `Callable` and `Runnable` can be used to execute a task asynchronously. If the task does not return any result, neither is more appropriate than the other. However, if the task returns a result, which you want to collect asynchronously later, `Callable` is more appropriate.

- [ ] When you want to use `ExecutorService` to submit multiple instance of a task.

  Both can be used with an `ExecutorService` because has overloaded submit methods:

  `<T> Future<T> submit(Callable<T> task)`

  and

  `Future<?> submit(Runnable task)` Observe that even though a Runnable's `run()` method cannot return a value, the `ExecutorService.submit(Runnable)` returns a `Future`. The Future's get method will return `null` upon successful completion.

**Explanation**

`public interface Callable<V>`

  A task that returns a result and may throw an exception. Implementers define a single method with no arguments called call - 

V call() throws Exception

The `Callable` interface is similar to `Runnable`, in that both are designed for classes whose instances are potentially executed by another thread. A `Runnable`, however, does not return a result and cannot throw a checked exception.

---

**65 Which of the following collection implementations are thread-safe?**

- [ ] ArrayList
- [ ] HashSet
- [ ] HashMap
- [ ] TreeSet
- [ ] None of the above

**Explanation**

Of all the collection classes of the `java.util` package, only `Vector` and `Hashtable` are Thread-safe. `java.util.Collection` class contains a `synchronizedCollection` method that creates thread-safe instances based on collections which are not.

For example:

`Set s = Collections.synchronizedSet(new HashSet());`

From Java 1.5 onwards, you can also use a new Concurrent library available in `java.util.concurrent` package, which contains interfaces/classes such as ConcurrentMap/ConcurrentHashMap. Classes in this package offer better performance than objects returned from `Collections.synchronizedXXX` methods.

---

**Complete the code so that a Portfolio object can be serialized and deserialized properly.**

这题主要考察序列化与反序列化，正确答案如下：

```java
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

public class Bond {
    String ticker = "bac";
    double coupon = 8.3;
}
class Portfolio implements Serializable {
    String accountName;
    transient Bond bond = new Bond();

    private void writeObject(ObjectOutputStream os) throws Exception {
        os.defaultWriteObject();
        os.writeObject(bond.ticker);
        os.writeDouble(bond.coupon);
    }
    private void readObject(ObjectInputStream os) throws Exception {
        os.defaultReadObject();
        this.bond = new Bond();
        bond.ticker = (String) os.readObject();
        bond.coupon = os.readDouble();
    }
}
```

**Explanation**

1. Bond class does not implement Serializable. Therefore, for Portfolio to be serialized, 'bond' must be transient.
2. `writeObject` method takes `ObjectOutputStream` as the only parameter, while `readObject` method takes `ObjectInputStream`.
3. To serialize the object using the default behavior, you must call `objectOutputStream.defaultWriteObject();` or `objectOutputStream.writeFields();`. This will ensure that instance field of Portfolio object are serialized.
4. To deserialize the object using the default behavior, you must call `objectInputStream.defaultReadObject();` or `objectInputStream.readFields();`. This will ensure that instance fields of Portfolio object are deserialized.
5. The order of values to be read explicitly in `readObject` must be exactly the same as the order they were written in `writeObject`. Here, ticker was written before coupon and so ticker must be read before coupon.

---

**Which of the following are standard annotations used to suppress various warnings generated by the compiler?**

- [ ] `@SuppressWarning("rawtypes")`

- [ ] `@SupressWarning( {"deprecation", "unchecked"} )`

- [ ] `@SupressWarning("deprecation", "unchecked")`

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

This annotation is not repeatable. Therefore, you cannot use it twice on the same type. However, you can specify multiple values like this: `@SupressWarning({ "deprecation", "unchecked"} )`

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

**Which of the following statements are true?**

- [x] A nested class may be declared static.

  > FYI, JLS defines the following terminology in Chapter 8:
  >
  > A top level class is a class that is not a nested class.
  >
  > A nested class is any class whose declaration occurs within the body of another class or interface.
  >
  > An inner class is a class that is not explicitly or implicitly declared static.

- [ ] Anonymous inner class may be declared public.

- [ ] Anonymous inner class may be declared private.

- [ ] Anonymous inner class may be declared protected.

- [x] Anonymous inner class may extend an abstract class.

**Explanation**

```java
abstract class SomeClass { public abstract void ml(); }
public class TestClass
{
    public static class StaticInnetClass { } //option1
    public SomeClass getSomeClass()
    {
        return new SomeClass()
        {
            public void ml() {}
        };
	}
}
//Here, the anonymous class created inside the method extends the abstract class SomeClass.
```

---

Which of the following options can be a part of a correct inner class declaration or a combined declaration and instance initialization? (Assume that `SimpleInterface` and `ComplexInterface` are interfaces.)

- [x] ```java
  private class C { }
  ```

- [x] ```java
  new SimpleInterface() {
      // valid code
  }
  ```

- [ ] ```java
  new ComplexInterface(x) {
      // valid code
  }
  ```

  > You cannot pass parameters when you implement an interface by anonymous class.

- [ ] ```java
  private final abstract class C { }
  ```

  > A final class can never be abstract.

- [ ] ```java
  new ComplexClass() implements SimpleInterface { }
  ```

  > 'implements' part comes only in class definition not in instantiation.

---

**Which of the following statements are true?**

- [ ] Package member classes can be declared static.
- [x] Classes declared as members of top-level classes can be declared static.
- [ ] Local classes can be declared static.
- [x] Anonymous classes cannot be declared static.
- [ ] No type of class can be declared static.

**Explanation**

The modifier static pertains only to member classes, not to top level or local or anonymous classes. That is, only classes declared as member of top-level classes can be declared static. Package member classes, local classes (i.e. classes declared in methods) and anonymous classes cannot be declared static.

---

**How will you initialize a `SimpleDateFormat` object to that the following code will print the full name of the month of the given date?**

- [ ] `SimpleDateFormat sdf = new SimpleDateFormat("MMMM", Locale.FRANCE);`

  > Upper case M is for Month. For example, for February and December, the following will be printed:
>M => 2, 12  
  > MM => 02, 12  
  > MMM => févr., déc.  
  > MMMM => février, décembre  

- [ ] `SimpleDateFormat sdf = new SimpleDateFormat("M*", Locale.FRANCE);`

  > M* will print the month number (i.e. 2 for Feb and 12 for Dec), followed by \*. For example, 2* or 12*

- [ ] `SimpleDateFormat sdf = new SimpleDateFormat("mmmm", Locale.FRANCE);`

  > Lower case m is for minutes. So mmmm will print the current minute, where the first two digits will always be zero. For example, 0032 or 0002.

- [ ] `SimpleDateFormat sdf = new SimpleDateFormat("mmm", Locale.FRANCE);`

- [ ] `SimpleDateFormat sdf = new SimpleDateFormat("MM", Locale.FRANCE);`

**Explanation**

For the purpose of the exam, you need to know the basic codes for printing out a date. The important ones are m, M, d, D, e, y, s, S, h, H, and z.  
You should check the complete details of these patterns here:  
https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/time/format/DateTimeFormatter.html

The important point to understand is how the length of the pattern determines the output of text and numbers.

Text: The text style is determined based on the number of pattern letters used. Less than 4 pattern letters will use the short form. Exactly 4 pattern letters will use the full form. Exactly 5 pattern letters will use the narrow form. Pattern letters 'L', 'c', and 'q' specify the stand-alone from of the text styles.

Number: If the count of letters is one, then the value is output using the minimum number of digits and without padding. Otherwise, the count of digits is used as the width of the output field, with the value zero-padded as necessary. The following pattern letters have constrains on the count of letters. Only one letter of 'c' and 'F' can be specified. Up to two letters of 'd', 'H', 'h', 'K', 'k', 'm', and 's' can be specified. Up to three letters of 'D' can be specified.

Number/Text: If the count of pattern letters is 3 or greater, use the Text rules above. Otherwise use the Number rules above.

---

**Code that uses generic collection classes can interoperate with code that uses raw collections classes because of?**

- [x] type erasure

  > Type erasure means that a compiled java class does not contain any of the generic information that is present in the java file. In other words, the compiler removes the generic information from a java class when it compile it into byte code. For example, `List<String> list;` and `List list;` are compiled to the same byte code. Therefore, at run time, it does not matter whether you've used generic classes or not and this kinds of classes to interoperate because they are essentially the same class to the JVM.
  >
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

Which variables declared in the encapsulating class or in the method, can an inner class access if the inner class is defined in a static method of encapsulating class?

- [x]  All static variables

- [ ] All final instance variables

- [ ] All instance variables

- [ ] All automatic variables

- [x] All final or effectively final static or automatic variables

  > An effectively final variable means even though it is not declared final, it is never assigned a value again throughout the code after being assigned a value at the time of declaration.

**Explanation**

Consider the following code:

```java
public class TestClass
{
    static int si = 10; int ii = 20;
    public static void inner()
    {
        int ai = 30; // automatic variable
        ai = 31; // ai is not effectively final anymore.
        final int fai = 40; // automatic final variable
        class Inner
        {
            public Inner() { System.out.println(si+"    "+fai);  }
        }
        new Inner();
    }
    public static void main(String[] args) { TestClass.inner(); }
}
```

Since method `inner()` is a static method, only `si` and `fai` are accessible in class Inner. Note that `ai` and `ii` are not accessible. If method `inner()` were a non-static, `ii` would have been accessible. If the line `ai = 31;` did not exist, `ai` would have been accessible.

---

Which of the following command line switches is required for the assert statements to be executed while running a Java class?

- [ ] `ea`

- [ ] `ua`

- [ ] `a`

- [ ] No switch is needed, they are on by default.

  > No, assertions are turned off by default.

- [ ] `source`

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

Please see http://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html for learning Lambda expressions in Java.

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

Which of these statements concerning nested classes and interfaces are true?

- [ ] An instance of a static nested class has an inherent outer instance.

  > Because static nested class is a static class.

- [ ] A static nested class can contain non-static member variables.

  > It is like any other normal class.

- [ ] A static nested interface can contain static member variables.

  > Static nested interface is similar to top level interface.

- [ ] A static nested interface has an inherent outer instance associated with it.

  > A static nested interface is a static interface and so does not have an associated outer instance.

- [ ] For each instance of the outer class, there can exist many instances of a non-static inner class.

**Explanation**
Note the difference between an Inner class and a static nested class. Inner class means a NON STATIC class defined inside a class. Remember: A nested class is any class whose declaration occurs within the body of another class or interface. A top level class is a class that is not a nested class. An inner class is a nested class that is not explicitly or implicitly declared static. A class defined inside an interface is implicitly static. For example,

```java
public class A  // outer class
{
   static public class B //Static Nested class . It can be used in other places: A.B b = new A.B(); There is no outer instance.
   {
   }
   class C //Inner class. It can only be used like this: A.C c = new A().new C(); Outer instance is needed.
   {
   }
}
```
One can define a class as a static member of any top-level class. Now consider the following contents of a file named I1.java ...  

```java
public interface I1
{
    public void mA();
    public interface InnerI1
    {
        int k = 10;
        public void innerA();
    }
}
```
Here, interface `InnerI1` is implicitly **STATIC** and so is called as static nested interface. 'k' is a `static` (& `final`) member of this interface. If you do `'javap'` on I1 it prints: Compiled from I1.java  

```java
public interface I1
    /* ACC_SUPER bit NOT set */
{
    public abstract void mA();
    public static interface I1. InnerI1
    /* ACC_SUPER bit NOT set */
    {
        public static final int k;
        public abstract void innerA();
    }
}
```
This interface can be referred to in other places like:  

```java
class MyClass implements I1.InnerI1
{
...
}
```
This is similar to referring a Top Level class.  

---

**Which of the following annotations are retained for run time?**

- [ ] `@SuppressWarnings`

  > It is defined with @Retention(SOURCE)

- [ ] `@Override`

  > It is defined with @Retention(SOURCE)

- [x] `@SafeVarargs`

  > It is defined with @Retention(RUNTIME)

- [x] `@FunctionalInterface`

  > It is defined with @Retention(RUNTIME)

- [x] `@Deprecated`

  > It is defined with @Retention(RUNTIME)

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

**Which clause(s) are used by a module definition that implements a service?**

- [ ] exports

  > A service provider module is not read directly by a service user module. So, *exports* clause is not required.

- [ ] provides

  > The provider module must specify the service interface and the implementing class that implements the service interface. For example, 
  >
  > provides org.printservice.api.Print with com.myprinter.PrintImpl

- [x] uses

  > A uses clause is used by the module that uses a service. For example,
  >
  > uses org.printservice.api.Print;

- [ ] implements

  > This is not a valid clause in module-info.

- [x] requires

  > The implementing module must require the module that defines the service interface.

**Explanation**

For example, if an `abc.print` module implements an `org.printing.Print` service interface defined in `PrintServiceAPI` module using `com.abc.PrintImpl` class, then this is how its module-info should look:

```java
module abc.print {
    requires PrintServiceAPI; //required because this module defines the service interface org.printing.Print
    uses org.printing.Print; //specifies that this module uses this service
    
    //observe that abc.print module is not required.
}
```

---

**Which of the following statements regarding the assertion mechanism of Java is NOT correct?**

- [x] Assertions require changes at the JVM level.

  > No change is required in the JVM for supporting assertions.

- [ ] Assertions require changes at the API level.

  > Besides the 'assert' keyword, new methods are added in `java.lang.Class` and `java.lang.ClassLoader` classes.

- [ ] Assertions can be enabled or disabled through the command line at the time of execution of (i.e. starting) the program.

  > By using the switches, -ea and -da or -enableassertions or -disableassertions

- [ ] Code that uses Assertions cannot be run on version below 1.4

  > Because of the 'assert' keyword.

- [x] Code written for JDK version 1.3 cannot be compiled under JDK version 1.4

  > It can be compiled by using -source flag: javac -source 1.3 classname.java

---

**Identify correct statements about annotations.**

- [ ] @SuppressWarnings can be used only on a class, constructor, or a method.

  > Actually, it can be used on several things. Its target can be a **TYPE**, **FIELD**, **METHOD**, **PARAMETER**, **CONSTRUCTOR**, **LOCAL_VARABLE**, and **MODULE**.

- [x] @Override can only be used on instance methods.

- [ ] @SafeVarargs can only be used on methods.

  > It can be used on constructors and methods.

- [ ] @Deprecated can be used only on a class, constructor, or a method.

  > Actually, it can be used on serval things, Its target can be a **CONSTRUCTOR**, **FIELD**, **LOCAL_VARIABLE**, **METHOD**, **PACKAGE**, **MODULE**,**PARAMETER**,**TYPE**.

- [ ] @SuppressWarnings("all") can be used suppress all warnings from a method or a class.

  > Although you can pass any string value to the SuppressWarnings annotation (unrecognized values are ignored), the Java specification mandates only three values - unchecked, deprecation, and removal. Different compilers and IDEs may support other values in addition to these three. There is no rule that says the value "all" has to suppress all warnings (although a compiler or an IDE may do that upon seeing this value.)

---





















































