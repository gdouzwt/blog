---
typora-root-url: ../
layout:     post
title:      816 基准测试回顾
date:       '2020-02-15T22:10'
subtitle:   OCP 816
author:     招文桃
catalog:    false
tags:
    - Java 11
    - OCP 11
---

**1.** Which of the following annotations are retained for run time?  

- [ ] @SuppressWarnings  
  > It is defined with @Retention(SOURCE)  
- [ ] @Override  
  > It is defined with @Retention(SOURCE)  
- [x] @SafeVarargs  
  > It is defined with @Retention(RUNTIME)  
- [x] @FunctionalInterface  
  > It is defined with @Retention(RUNTIME)  
- [x] @Deprecated  
  > It is defined with @Retention(RUNTIME)  

---

**2.** Your application needs to load a set of key value pairs from a database table which never changes. Multiple threads need to access this information but none of them changes it.  
Which class would be the most appropriate to store such data if the values need not be kept in a sorted fashion?  

- [ ] Hashtable  
- [x] HaspMap  
- [ ] Set  
- [ ] TreeMap  
- [ ] List  

**Explanation**  
You should know that all `Hashtable` methods are synchronized and this compromises its performance for simultaneous reads.  
Since not thread modifies the data, it is not efficient to use a `Hashtable`.  
A `HashMap` is a perfect choice because its methods are not synchronized and so it allows efficient multiple reads. TreeMap is used to keep the keys sorted which makes it a little bit slower than `HashMap`.  
`Set` and `List` can't be used since we need to store Key-value pairs.  <!--more-->

---

**3.** A programmer has written the following code to ensure that the phone number is not null and is of 10 characters:  

```java
public void processPhoneNumber(String number) {
  assert number != null && number.length() == 10 : "Invalid phone number";
  ...
}
```

Which of the given statements regarding the above code are correct?  

- [ ] This is an appropriate use of assertions.  
- [x] This code will not work in all situations.  
  > It will not work if assertions are disabled.  
- [x] The given code is syntactically correct.  
- [ ] Constrains on input parameters should be enforced using assertions.  

**Explanation**  
As a rule, assertions should not be used to assert the validity of the input public method. Since assertions may be disabled at wish of the user of the program, input validation will not occur when assertions are disabled. A public method should ensure in all situations(whether assertions are enabled or disabled) that the input parameters are valid before proceeding with the rest of the code. For this reason, input validation should always be done using the standard exception mechanism:  

`if(number == null || number.length() != 10) throw new RuntimeException("Invalid phone number");`

However, assertions may be used to validate the input parameters of a private method. This is because private methods are called only by the developer of the class. Therefore, if a private method is called with an invalid parameter, this problem should be rectified at the development stage itself. It cannot occur in the production stage, so there is no need to throw an explicit exception.  

---

**8.** Which is/are the root interface(s) for all collection related interfaces?  

- [ ] BaseCollection  
- [x] Collection  
- [ ] List  
- [ ] Set  
- [x] Map  

**Explanation**  
All name-value maps such as `java.util.HashMap` and `java.util.TreeMap` implement `java.util.Map` and all collections such as `java.util.ArrayList`, and `java.util.LinkedList` implement `java.util.Collection`.  

---

**9.** You have a collection (say, an ArrayList) which is read by multiple reader threads and which is modified by a single writer thread. The collection allows multiple concurrent reads but does not tolerate concurrent read and write. Which of the following strategies will you use to obtain best performance?  

- [ ] synchronize all access to the collection.  
  > While this is a valid approach, if you do this then even the reader threads will not be able to read concurrently. This will drastically reduce performance.  
- [ ] make the collection variable final.  
- [ ] make the collection variable final and volatile.  
  > Making it final and volatile will only ensure that all threads access the same collection object but it will not prevent simultaneous access by reader and writer threads.  
- [ ] Wrap the collection into its synchronized version using Collections.synchronizedCollection().  
  > This is same as option 1 and has the same issue.  
- [x] Encapsulate the collection into another class and use ReadWriteLock to manage read and write access.  

**Explanation**  
Since the collection allows multiple simultaneous reads, it is ok for multiple threads to access the collection simultaneously if they are not modifying the collection. On the other hand, a writer thread must get sole custody of the collection before modifying. This can be easily achieved by using a ReadWriteLock. For example:  

```java
public class MultipleReadersSingleWriter {
    private final ArrayList<String> theList = new ArrayList<String>();
    //Note that ReadWriteLock is an interface.
    private final ReadWriteLock rwl = new ReentrantReadWriteLock();
    private final Lock r = rwl.readLock();
    private final Lock w = rwl.writeLock();
    public String read(){
        r.lock();
        try{
            System.out.println("reading");
            if(theList.isEmpty()) return null;
            else return theList.get(0);
        }finally{
            r.unlock();
        }
    }
    public void write(String data){
        w.lock();
        try{
            System.out.println("Written "+data);
            theList.add(data);
        }finally{
            w.unlock();
        }
    }
}
```

---

**11.** Which variables of the encapsulating class can an inner class access, if the inner class is defined in a instance method of the encapsulating class?  

- [x] All static variables.  
- [x] All final instance variables.  
- [x] All instance variables.  
- [ ] All automatic variables.  
- [x] All final and effectively final automatic variables.  

**Explanation**   
Consider the following code:  

```java
public class TestClass
{
  static int si = 10; int ii = 20;
  public void inner() {
    int ai = 30; // automatic variable
    ai = 31; // ai is not effectively final anymore
    final int fai = 40; // automatic final variable
    class Inner {
      public Inner() { System.out.println(si" "+ii+" "+fai); }
    }
    new Inner();
  }
  public static void main(String[] args) { ne TestClass().inner(); }
}
```

As method `inner()` is an instance method(i.e. non-static method), `si`, `ii`, and `fai` are accessible in class `Inner`. Note that `ai` is not accessible because it is not effectively final. If the line `ai = 31;` did not exist, `ai` would have been accessible. If method `inner()` were a static method, `ii` would have been inaccessible. Prior to Java 8, only final local variables were accessible to the inner class but in Java 8, event effectively final local variables of the method are accessible to the inner defined in that method as well.  

**12.** Which interface would you use to represent a collection having non-unique objects in the order of insertion?  
> List  
> java.util.List  

**Explanation**  
`java.util.List` interface is implemented by collections that maintain sequences of possibly non-unique elements. Elements retain their ordering in the sequence. Collection classes implementing `SortedSet` maintain their elements sorted in the set.  

---

**14.** Identify the correct statement about i18n.  

- [ ] I18N class allows you to port your code from multiple regions and/or languages.  
  > There is no class named I18N.  
- [x] You should use Locale and formatter objects such as NumberFormat and DateFormat to generate locale specific output.  
- [ ] The i18n method of NumberFormat and DateFormat allows you to generate locale specific output.  
- [x] Using default locale for NumberFormat and DateFormat automatically ensures that the formatted text will be localized to the location - [ ] setting of the machine on which the code is run.(Assuming the default locale hasn't been explicitly changed by any means.)  
  > When not passed to the `getInstance()` method, the default `Locale` is used, which is same as the one set by the operating system. If you want to change it,(for example, if you want to generate French format on a US machine), you must create a new `Locale("fr", "FR")` object and use the following methods to get an appropriate NumberFormat or DateFormat instance -  
  > NumberFormat: `NumberFormat getInstance(Locale locale)`  
  > DateFormat: `DateFormat getDateInstance(int style, Locale locale)`  
  > Note that DateFormat does not have `getInstance(Locale locale)` method.  
- [ ] i18n stands for Internationalization and it is handled automatically by Java.  

---

**15.** Which of the following statements are correct regarding abstract classes and interfaces?  

- [ ] An abstract class can have private as well as static methods while an interface can not have static methods.  
  > Interfaces can have static methods(public as well as private). Interfaces cannot have protected methods. It cannot have non-public fields and instance fields.  
- [ ] An abstract class cannot implement multiple interfaces while an interface can extend multiple interfaces.  
  > An abstract class(or any class for that matter) can implement any number of interfaces.  
- [ ] Abstract classes can have abstract methods but interface cannot.  
  > Both abstract classes and interfaces can have abstract as well as non-abstract methods. The difference is that by default(i.e. when no modifier is specified), the methods of an abstract class have "default" access and are non-abstract(i.e. must have a body), while the methods of an interface are public and abstract.  
- [x] Abstract classes can have instance fields but interfaces can't  
  > Fields of an interface are always public, static, and final.  
- [x] An abstract class can have final methods but an interface cannot.  

**16.** Which of the following statements are correct?  

- [x] Assertions can be enabled or disabled on a class basis.  
  > Yes, it can be enabled/disabled for class as well as package basis using -ea or -da flags.  
- [ ] Assertions are appropriate to check whether method parameters are valid.  
  > Since it does not say which kind of methods (public or private), you should assume all methods.  
- [ ] Conditional compilation is used to allow an application that uses assertions to run with maximum performance.  
  > Assertion can be disabled without recompiling the code.  
- [ ] When an assertion fails, a programmer may either throw an exception or simply return from the method.  
  > When an assertion fails, a programmer should always throw the exception.  

**Explanation**  
An assertion signifies a basic assumption made by the programmer that he/she believes to be true at all times. It is never a wise idea to try to recover when an assertion fails because that is the whole purpose of assertions: that the program should fail if that assumption fails.  

---

**17.** Complete the code so that the user can enter a password on the command line.  

```java
import java.io.Console;
public class TestClass {
  public static void main(String[] args) throws Exception {
    Console c = System.console();
    char[] cha = c.readPassword("Please enter password:");
    String pwd = new String(cha);
    System.out.println("pwd = "+pwd);
  }
}
```

**Explanation**  
**1.** `Console` class is in `java.io` package.  
**2.** Correct way to retrieve the `Console` object is `System.console();` There is only one `Console` object so `new Console();` doesn't make sense. And therefore, Console's constructor is not public.  
**3.** You can read user's input using either `readLine()` or `readPassword()`. Here, since you are reading password, `readPassword()` should be used. `readPassword()` ensures that the keys typed by the user aren't echoed to the command prompt.  

---

**19.** What will the following code print?  

```java
ReentrantLock rlock = new ReentrantLock();
boolean f1 = rlock.lock();
System.out.println(f1);
boolean f2 = rlock.lock();
System.out.println(f2);
```

- [ ]
  > true  
  > true  
- [ ]
  > true  
  > false  
- [ ]
  > true  
- [x] It will not compile.  
  > `java.util.concurrent.locks.Lock` interface's `lock()` method returns `void`, while its `tryLock()` returns `boolean`.  
  Had the code been:  

```java
ReentrantLock rlock = new ReentrantLock();
boolean f1 = rlock.tryLock();
System.out.println(f1);
boolean f2 = rlock.tryLock();
System.out.println(f2);
```

It would have printed:  
> true  
> true  

Note that `java.util.concurrent.locks.ReentrantLock` class implements `java.util.concurrent.locks.Lock` interface.  

---

**21.** Anonymous inner classes always extend directly from the Object class.  

- [ ] True  
- [x] False  

**Explanation**  
When you create an anonymous class for an interface, it extends from Object. For example,  
button.addActionListener( new ActionListener() {  public void actionPerformed(ActionEvent ae) { } }  );  
But if you make an anonymous class from another class then it extends from that class. For example, consider the following class:  

```java
class MyListener implements ActionListener {
  public void actionPerformed(ActionEvent ae) {
    System.out.println("MyListener class");
  }
}

button.addActionListener(new MyListener() {
  public void actionPerformed(ActionEvent ea) {
    System.out.println("Anonymous Listener class");
  }
});
```

Here the anonymous class actually extends from MyListener class and successfully overrides the actionPerformed() method.  

---

**22.** Consider the following code:  

```java
Locale myLoc = new Locale("fr", "FR");
ResourceBundle rb = ResourceBundle.getBundle("appmessages", myLoc);
//INSERT CODE HERE
```

Which of the following lines of code will assign a ResourceBundle for a different Locale to rb than the one currently assigned?  
(Assume appropriate import statements)  

- [x] rb = ResourceBundle.getBundle("appmessages", new Locale("ch", "CH"));  
- [ ] rb = ResourceBundle.getBundle("appmessages", CHINA);  
  > In this question, the import statements are not specified. If appropriate imports are present (i.e. import static java.util.Locale.*; ), this will work fine. In the exam, you may see a couple of question that have such ambiguous options. In our opinion, it is best not to assume anything special or out of ordinary. Therefore, this option should not be selected.  
- [ ] myLoc.setLocale(Locale.CHINA);  
  > There is no setLocale() method in Locale.  
- [ ] myLoc.setLocale(new Locale("ch", "CH"));  
- [x] rb = ResourceBundle.getBundle("appmessages", Locale.CHINA);  
- [ ] rb.setLocale(Locale.CHINA);  
  > There is no setLocale() method in Locale.  

**Explanation**  
Note that once a `ResourceBundle` is retrieved, changing the Locale will not affect the `ResourceBundle`. You have to retrieve a new `ResourceBundle` by passing in the new `Locale` and then assign it to the variable.  

---

**23.** Which of these methods are defined in the Map interface?  

- [ ] contains(Object o)  
- [ ] addAll(Collection c)  
- [x] remove(Object o)  
- [x] values()  
- [ ] toArray()  

**Explanation**  
The Map interface defines the methods `remove(Object)` and `values()`. It does not define  methods `contains()`, `addAll()` and `toArray()`  
Methods with these names are defined in the Collection interface, but Map does not extend from Collection.  

---

**24.** Insert appropriate methods so that the following code will produce expected output.  

```java
import java.util.*;
public class TestClass {
  public static void main(String[] args) {
    NavigableSet<String> myset = new TreeSet<String>();
    myset.add("a"); myset.add("b"); myset.add("c");
    myset.add("aa"); myset.add("bb"); myset.add("c");
    System.out.println(myset.floor("a"));
    System.out.println(myset.ceiling("aaa"));
    System.out.println(myset.lower("a"));
    System.out.println(myset.higher("bb"));
  }
}
```

**Expected output.**  
> a  
> b  
> null  
> c  

**25.** Complete the following code so that it will print each line in the given file.  

```java
import java.io.*;
class Liner {
  public void dumper(File f) throws IOException {
    FileReader x1 = new FileReader(f);
    BufferedReader x2 = new BufferedReader(x1);
    String x3 = x2.readLine();
    while (x3 != null) {
      System.out.println(x3);
      x3 = x2.readLine();
    }
  }
}
```

**26.** Which of the following statements are correct?  

- [ ] Assertions are usually enabled in the production environment.  
- [ ] Assertions are usually disabled in the development and testing environment.  
  > Just the reverse is true.
- [ ] Assertions can be enabled selectively on per class basis but not on per package basis.  
- [x] Assertions can be enabled selectively on per class basis as well as on per package basis.  
  > Yes, it can be enabled/disabled on class as well as package basis -ea or -da flags.  
- [x] It is not a good practice to write code that recovers from an assertion failure.  

**Explanation**  
An assertion signifies a basic assumption made by the programmer that he/she believes to be true at all times. It is never a wise idea to try to recover when an assertion fails is the whole prupose of assertions: that the program should fail if that assumption fails.  

---

**27.** Which clause(s) are used by a module definition that implements a service?  

- [ ] exports  
  > A service provider module is not read directly by a service user module. So, *exports* clause is not required.  
- [ ] provides  
  > The provider module must specify the service interface and the implementing class that implements the service interface. For example,  
  > `provides org.printservice.api.Print with com.myprinter.PrintImpl`  
- [x] uses  
  > A uses clause is used by the module that uses a service. For example,  
  > `uses org.printservice.api.Print;`  
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

**31.** Which of the following statements regarding the assertion mechanism of Java is NOT correct?  

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

**32.** Identify correct statements about annotations.  

- [ ] @SuppressWarnings can be used only on a class, constructor, or a method.  
  > Actually, it can be used on several things. Its target can be a **TYPE**, **FIELD**, **METHOD**, **PARAMETER**, **CONSTRUCTOR**, **LOCAL_VARIABLE**, and **MODULE**.  
- [x] @Override can only be used on instance methods.  
- [ ] @SafeVarargs can only be used on methods.  
  > It can be used on constructors and methods.  
- [ ] @Deprecated can be used only on a class, constructor, or a method.  
  > Actually, it can be used on serval things, Its target can be a **CONSTRUCTOR**, **FIELD**, **LOCAL_VARIABLE**, **METHOD**, **PACKAGE**, **MODULE**,**PARAMETER**,**TYPE**.  
- [ ] @SuppressWarnings("all") can be used suppress all warnings from a method or a class.  
  > Although you can pass any string value to the SuppressWarnings annotation (unrecognized values are ignored), the Java specification mandates only three values - unchecked, deprecation, and removal. Different compilers and IDEs may support other values in addition to these three. There is no rule that says the value "all" has to suppress all warnings (although a compiler or an IDE may do that upon seeing this value.)  

---

**33.** Which of the following is thrown when an assertion fails?  

- [x] AssertionError  
- [ ] AssertionException  
- [ ] RuntimeException  
- [ ] AssertionFailedException  
- [ ] Exception  

**Explanation**  
A java.lang.AssertionError is thrown.  

```java
public class java.lang.AssertionError extends java.lang.Error {
  public java.lang.AssertionError();
  public java.lang.AssertionError(java.lang.Object);
  public java.lang.AssertionError(boolean);
  public java.lang.AssertionError(char);
  public java.lang.AssertionError(int);
  public java.lang.AssertionError(long);
  public java.lang.AssertionError(float);
  public java.lang.AssertionError(double);
}
```

---

**38.** Which of the following are required to construct a Locale?  

- [x] language  
- [ ] region  
- [ ] country  
  > country is the second parameter that may be passed while creating a Locale. It is not required though.  
- [ ] time zone  
- [ ] state  
- [ ] culture  

**Explanation**  
Locale needs at least a language to be constructed. It has three constructor -  
`Locale(String language)`  
Construct a locale from a language code.  
`Locale(String language, String country)`  
Construct a locale from language, country  
`Locale(String language, String country, String variant)`  
Construct a locale from language, country, variant  

For example:  
`new Locale("fr", "FR");` // language is French, Country is France.  
`new Locale("fr", "CA");` // language is French, Country is Canada, so this means, you are trying to use Canadian dialect of French.  
`new Locale("en", "IN");` // language is English, COuntry is India, so this means, you are trying to use Indian dialect of English.  

---

**40.** Which of the following are standard Java annotations?  

- [ ] @NonNull  
  > This is not a standard Java annotation.  
  > Although this annotation is officially not in scope for the OCP Java 11 exam, we have seen questions on the exam that require knowledge about this annotation. It exists in Spring framework as well as in **[Checker Framework](https://checkerframework.org/manual/)**, which is referred in an Oracle **[blog](https://blogs.oracle.com/java-platform-group/java-8s-new-type-annotations)**  
  > It can be applied to a field, method parameter, or method return type.  
  > org.springframework.lang  
  > Annotation Type NonNull  
  > @Target(value={METHOD,PARAMETER,FIELD})  
  > @Retention(value=RUNTIME)  
  > @Documented @Nonnull  
  > @TypeQualifierNickname  
  > public @interface NonNull  
  > A common Spring annotation to declare that annotated elements cannot be null.  
  > It can be used like this:  
  > **1.** @NonNull String getString(@NonNull String input){ return "adsf"; };  
  > **2.** @NonNull String name; //instance or class fields  
  > **3.** Function<Integer, Integer> fin =  (@NonNull var x) -> 2*x;//lambda expression  
  > You may see the details of the NonNull annotation of the checker framework **[here](https://checkerframework.org/api/org/checkerframework/checker/nullness/qual/NonNull.html)**  
- [ ] @Interned  
  > @Interned is not a standard Java annotation.  
  > Although this annotation is officially not in scope for the OCP Java 11 exam, we have seen questions on the exam that require knowledge about this annotation. It exists in Spring framework as well as in **[Checker Framework](https://checkerframework.org/manual/)**, which is referred in an Oracle **[blog](https://blogs.oracle.com/java-platform-group/java-8s-new-type-annotations)**  
  > 
- [x] @Repeatable  
- [x] @Retention  

---

**41.** A programmer wants to rename all the files in a directory (just the files and not directories) to `<existing filename>`.checked.  
Complete the given code so that it works as required.  

```java
import java.io.File;
import java.util.*;
public class ChangeFileNames {
  public static void main(String[] args) throws Exception {
    File dir = new File(args[0]);
    if(!dir.isDirectory()) {
      System.out.println(args[0]+" is not a directory.");
      return;
    }
    File[] files = dir.listFiles();
    for (File oldfile : files) {
      // process only if oldfile is a normal file and not a directory
      if(!oldfile.isDirectory()) {
        String oldfilename = oldfile.getName();
        File newfile = new File(args[0]+File.separator+oldfilename+".checked");
        boolean b = oldfile.renameTo(newfile);
        if(b)
            System.out.println("Changed: "+oldfilename+" To "+newfile.getName());
        else
            System.out.println("Not Changed: "+oldfilename);
      }
    }
  }
}
```

**Explanation**  
This programs illustrates the usage of many important File class methods.  
**1.** The `isDirectory()` method returns `true` if the file object represents a directory.  
**2 and 3.** File class has two methods for returning the contents of a directory (although it has more but for the exam, you need to know only these two):  
`String[] list()`  
Returns an array of strings naming the files and directories in the directory denoted by this abstract pathname.  
`File[] listFiles()`  
Returns an array of abstract pathnames denoting the files in the directory denoted by this abstract pathname.  
The for loop is expecting 'files' to be an array or a Collection of File objects. Thus, 2nd and 3rd blanks should be `File[]` and `listFiles` respectively.  
**4.** `isFile()` method returns `true` if the file object represents a normal file.  
**5.** `renameTo(File newfile)` renames the file to newfile.

---

**46.** What classes can a non-static nested class extend?  
(Provided that the class to be extended is visible and is not final.)  

- [ ] Only the encapsulating class.  
- [ ] Any top level class.  
- [x] Any class.  
- [ ] It depends on whether the inner class is defined in a method or not.  
- [ ] None of the above.  

**Explanation**  
In general, there is no restriction on what a nested class may or may not extend.  
FYI, a nested class is any class whose declaration occurs within the body of another class or interface. A top level class is a class that is not a nested class. An inner class is a nested class that is not explicitly or implicitly declared static.  

---

**47.** A JDBC driver implementation must provide implementation classes for which of the following interfaces?  

- [x] java.sql.Driver  
- [x] java.sql.Connection  
- [x] java.sql.Statement  
- [ ] java.sql.SQLException  
  > This is a class and not an interface. It is provided by the JDBC API.  
- [ ] java.sql.Date  
  > This is a class and not an interface. It is provided by the JDBC API.  

**Explanation**  
`java.sql.ResultSet` is another important interface that a driver must provide.  
Besides these, there are several interfaces and methods that a driver must provide but they are not relevant for the exam. If you want to learn more, please refer JDBC Specification.  

---

**49.** Identify the correct statement regarding a JDBC Connection：

- [x] When a JDBC Connection is created, it is in auto-commit mode.  
- [ ] When a JDBC Connection is created, its commit mode depends on the parameters used while creating the connection.  
- [ ] When a JDBC Connection is created, its auto-commit feature is disabled.  
- [ ] When a JDBC Connection is created, it is in commit mode undetermined.  

**Explanation**  
When a connection is created, it is in auto-commit mode. i.e. auto-commit is enabled. This means that each individual SQL statement is treated as a transaction and is automatically committed right after it is completed. (A statement is completed when all of its result sets and update counts have been retrieved. In almost all cases, however, a statement is completed, and therefore committed, right after it is executed.)  
The way to allow two or more statements to be grouped into a transaction is to disable the auto-commit mode. Since it is enabled by default, you have to explicitly disable it after creating a connection by calling `con.setAutoCommit(false);`  

---

**51.** Which of these statements are true?  

- [ ] Non-static inner class cannot have static members.  
  > They can have final fields but the static fields have to be final constants.  
- [x] Objects of static nested classes can be created without creating instances of their Outer classes.  
- [ ] Member variables in any nested class cannot be declared final.  
  > Nested classes can have final members (i.e. methods and fields)  
- [x] Anonymous classes cannot define constructors explicitly in Java code.  
- [x] Anonymous classes cannot be static.  

**Explanation**  
Non-static inner classes can contain final static fields (but not methods).  
Anonymous classes cannot have explicitly defined constructors, since they have no names.  
Remember: A nested class is any class whose declaration occurs within the body of another class or interface. A top level class is a class that is not a nested class. An inner class is a nested class that is not explicitly or implicitly declared `static`. A class defined inside an interface is implicitly `static`.  
Consider the following nested class `B` which is `static`:  

```java
public class A  //This is a standard Top Level class.  
{  
  class X
  {
    final int j = 10; //compiles fine!
  }  
  public static class B //This is a static nested class
  {
  }
}
```

You can create objects of `B` without having objects of `A`. For example: `A.B b = new A.B();` Members in outer instances are directly accessible using simple names. There is no restriction that member variables in inner classes must be `final`. Nested classes define distinct types from the enclosing class, and the `instanceof` operator does not take of the outer instance into consideration.

---

**52.** Which of these statements concerning nested classes and interfaces are true?  

- [ ] An instance of a static nested class has an inherent outer instance.  
  > Because static nested class is a static class.  
- [x] A static nested class can contain non-static member variables.  
  > It is like any other normal class.  
- [x] A static nested interface can contain static member variables.  
  > Static nested interface is similar to top level interface.  
- [ ] A static nested interface has an inherent outer instance associated with it.  
  > A static nested interface is a static interface and so does not have an associated outer instance.  
- [x] For each instance of the outer class, there can exist many instances of a non-static inner class.  

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

**55.** Which of the following command line switches is required for the assert statements to be executed while running a Java class?

- [x] `ea`  
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

**56.** Which variables declared in the encapsulating class or in the method, can an inner class access if the inner class is defined in a static method of encapsulating class?  

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

**58.** How will you initialize a `SimpleDateFormat` object to that the following code will print the full name of the month of the given date?  

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
You should check the complete details of these patterns **[here](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/time/format/DateTimeFormatter.html)**  
The important point to understand is how the length of the pattern determines the output of text and numbers.  
Text: The text style is determined based on the number of pattern letters used. Less than 4 pattern letters will use the short form. Exactly 4 pattern letters will use the full form. Exactly 5 pattern letters will use the narrow form. Pattern letters 'L', 'c', and 'q' specify the stand-alone from of the text styles.  
Number: If the count of letters is one, then the value is output using the minimum number of digits and without padding. Otherwise, the count of digits is used as the width of the output field, with the value zero-padded as necessary. The following pattern letters have constrains on the count of letters. Only one letter of 'c' and 'F' can be specified. Up to two letters of 'd', 'H', 'h', 'K', 'k', 'm', and 's' can be specified. Up to three letters of 'D' can be specified.  
Number/Text: If the count of pattern letters is 3 or greater, use the Text rules above. Otherwise use the Number rules above.  

---

**59.** Which of the following statements are true?  

- [ ] Package member classes can be declared static.  
- [x] Classes declared as members of top-level classes can be declared static.  
- [ ] Local classes can be declared static.  
- [x] Anonymous classes cannot be declared static.  
- [ ] No type of class can be declared static.  

**Explanation**  
The modifier static pertains only to member classes, not to top level or local or anonymous classes. That is, only classes declared as member of top-level classes can be declared static. Package member classes, local classes (i.e. classes declared in methods) and anonymous classes cannot be declared static.  

---

**60.** Which of the following options can be a part of a correct inner class declaration or a combined declaration and instance initialization? (Assume that `SimpleInterface` and `ComplexInterface` are interfaces.)  

- [x] `java private class C { }`  
- [x] `java new SimpleInterface() { // valid code }`  
- [ ] `java new ComplexInterface(x) { // valid code }`  
  > You cannot pass parameters when you implement an interface by anonymous class.  
- [ ] `java private final abstract class C { }`  
  > A final class can never be abstract.  
- [ ] `java new ComplexClass() implements SimpleInterface { }`  
  > 'implements' part comes only in class definition not in instantiation.  

---

**61.** Which of the following statements are true?

- [x] A nested class may be declared static.  
  > FYI, JLS defines the following terminology in Chapter 8:  
  > A top level class is a class that is not a nested class.  
  > A nested class is any class whose declaration occurs within the body of another class or interface.  
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

**64.** Complete the code so that a Portfolio object can be serialized and deserialized properly.

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
**1.** Bond class does not implement Serializable. Therefore, for Portfolio to be serialized, 'bond' must be transient.  
**2.** `writeObject` method takes `ObjectOutputStream` as the only parameter, while `readObject` method takes `ObjectInputStream`.  
**3.** To serialize the object using the default behavior, you must call `objectOutputStream.defaultWriteObject();` or `objectOutputStream.writeFields();`. This will ensure that instance field of Portfolio object are serialized.  
**4.** To deserialize the object using the default behavior, you must call `objectInputStream.defaultReadObject();` or `objectInputStream.readFields();`. This will ensure that instance fields of Portfolio object are deserialized.  
**5.** The order of values to be read explicitly in `readObject` must be exactly the same as the order they were written in `writeObject`. Here, ticker was written before coupon and so ticker must be read before coupon.  

---

**65.** Which of the following collection implementations are thread-safe?

- [ ] ArrayList  
- [ ] HashSet  
- [ ] HashMap  
- [ ] TreeSet  
- [x] None of the above  

**Explanation**  
Of all the collection classes of the `java.util` package, only `Vector` and `Hashtable` are Thread-safe. `java.util.Collection` class contains a `synchronizedCollection` method that creates thread-safe instances based on collections which are not.  
For example:  
`Set s = Collections.synchronizedSet(new HashSet());`  
From Java 1.5 onwards, you can also use a new Concurrent library available in `java.util.concurrent` package, which contains interfaces/classes such as ConcurrentMap/ConcurrentHashMap. Classes in this package offer better performance than objects returned from `Collections.synchronizedXXX` methods.  

---

**66.** Using a `Callable` would be more appropriate than using a `Runnable` in which of the following situations?  

- [ ] When you want to execute a task directly in a separate thread.  
  > A Callable cannot be passed to Thread for Thread creation but a Runnable can be. i.e. `new Thread(aRunnable);` is valid. But `new Thread(aCallable);` is not. Therefore, if you want to execute a task directly in a Thread, a `Callable` is not suitable. You will need to use a `Runnable`. You can achieve the same by using an `ExecutorService.submit(aCallable)` , but in this case, you are not controlling the Thread directly.  
- [ ] When your task might throw a checked exception and you want to execute it in a separate Thread.  
  > `Callable.call()` allows you to declare checked exceptions while `Runnable.run()` does not. So if your task throws a checked exception, it would be more appropriate to use a `Callable`.  
- [ ] When your task does not return any result but you want to execute the task asynchronously.  
  > Both `Callable` and `Runnable` can be used to execute a task asynchronously. If the task does not return any result, neither is more appropriate than the other. However, if the task returns a result, which you want to collect asynchronously later, `Callable` is more appropriate.  
- [ ] When you want to use `ExecutorService` to submit multiple instance of a task.  
  > Both can be used with an `ExecutorService` because has overloaded submit methods:  
  > `<T> Future<T> submit(Callable<T> task)`  
  > and  
  > `Future<?> submit(Runnable task)` Observe that even though a Runnable's `run()` method cannot return a value, the `ExecutorService.submit(Runnable)` returns a `Future`. The Future's get method will return `null` upon successful completion.  

**Explanation**  
`public interface Callable<V>`  
A task that returns a result and may throw an exception. Implementers define a single method with no arguments called call -  
`V call() throws Exception`  
The `Callable` interface is similar to `Runnable`, in that both are designed for classes whose instances are potentially executed by another thread. A `Runnable`, however, does not return a result and cannot throw a checked exception.  

---

**67.** Identify correct statements about the Java module system.

- [x] If a request is made to load a type whose package is not defined in any known module system will attempt to load it from the class path.  
- [ ] The unnamed module can only access types present in the unnamed module.  
  > The unnamed module reads every other module. In other words, a class in an unnamed module can access all exported types of all modules.  
- [ ] Code from a named module can access classes that are on the classpath.  
  > A named module cannot access any random class from the classpath. If your named module requires access to a non-modular class, you must put the non-modular class/jar on module-path and load it as an automatic module. Further, you must also put an appropriate "requires" clause in your module-info.  
- [x] If a package is defined in both a named module and the unnamed module then the package in the unnamed module is ignored.  
- [ ] An automatic module cannot access classes from the unnamed module.  
  > Remember that named modules cannot access classes from the unnamed module because it is not possible for named module to declare dependency on the unnamed module.  
  > But what if a named module needs to access a class from a non-modular jar? Well, you can put the non-modular jar on the module-path, thereby making it an automatic module. A named module can declare dependency on an automatic module using the requires clause.  
  > Now, what if that jar in turn requires access to some other class from another third party non-modular jar? Here, the original modular jar doesn't directly access the non-modular jar, so it may not be wise to create an automatic module out of all such third party jars. This is where the -classpath options is helpful.  
  > In addition to reading every other named module, an automatic module is also made to read the unnamed module. Thus, while running a modular application, the classpath option can be used to enable automatic modules to access third party non-modular jars.  

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

**70.** Which of the following switches is/are used for controlling the execution of assertions at run time?  

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

**72.** Complete the following code so that it will print dick, harry, and tom in that order.  

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

**75.** Which of the following standard functional interfaces is most suitable to process a large collection of int primitives and return processed data for each of them?

- [ ] `Function<Integer>`  
- [x] `IntFunction`  
- [ ] `Consumer<Integer>`  
- [ ] `IntConsumer`  
- [ ] `Predicate<Integer>`  

**Explanation**  
Using the regular functional interfaces by parameterizing them to Integer is inefficient as compared to using specially designed interfaces for primitives because they avoid the cost of boxing and unboxing the primitives.  
Now, since the problem statement requires something to be returned after processing each int, you need to use a Function instead of a Consumer or a Predicate.  

Therefore, **`IntFunction`** is most appropriate in this case.  

---

**77.** Which statements concerning the relation between a non-static inner class and its outer class instances are true?  

- [ ] Member variables of the outer instance are always accessible to inner instances, regardless of their accessibility modifiers.  
- [x] Member variables of the outer instance can always be referred to using only the variable name within the inner instance.  
  > This is possible only if that variable is not shadowed by another variable in inner class.  
- [x] More than one inner instance can be associated with the same outer instance.  
- [x] An inner class can extend its outer classes.  
- [ ] A final outer class cannot have any inner classes.  
  > There is no such rule.  

---

**80.** Simple rule to determine sorting order: **spaces** < **numbers** < **uppercase** < **lowercase**  

---

**82.** Which of the following statements are correct?

- [ ] A List stores elements in a Sorted Order.  
  > List just keeps elements in the order in which they are added. For sorting, you'll need some other interface such as a SortedSet.
- [ ] A Set keeps the elements sorted and a List keeps the elements in the order they were added.  
  > A Set keeps unique objects without any order or sorting.  
  > A List keeps the elements in the order they were added. A List may have non-unique elements.  
- [ ] A SortedSet keeps the elements in the order they were added.  
  > A SortedSet keeps unique elements in their natural order.  
- [ ] An OrderedSet keeps the elements sorted.  
  > There is no interface like OrderedSet  
- [ ] An OrderedList keeps the elements ordered.  
  > There is no such interface. The List interface itself is meant for keeping the elements in the order they were added.  
- [x] A NavigableSet keeps the elements sorted.  
  > A NavigableSet is a Sorted extended with navigation methods reporting closest matches for given search targets. Methods lower, floor, ceiling, and higher return elements respectively less than, or equal, greater than or equal, and greater than a given element, returning null if there is no such element.  
  > Since NavigableSet is a SortedSet, it keeps the elements sorted.  

---

**84.** You want to execute your tasks after a given delay. Which `ExecutorService` would you use?

- [ ] `FixedDelayExecutorService`
- [ ] `TimedExecutorService`
- [ ] `DelayedExecutorService`
- [x] `ScheduledExecutorService`

The following are the details of the interface `ScheduledExecutorService`:  
All Superinterfaces:  
`Executor`, `ExecutorService`  
All Known Implementing Classes:  
`ScheduledThreadPoolExecutor`  

An `ExecutorService` that can schedule commands to run after a given delay, or to execute periodically.  
The schedule methods create tasks with various delays and return a task object that can be used to cancel or check execution. The `scheduleAtFixedRate` and `scheduleWithFixedDelay` methods create and execute tasks that run periodically until cancelled.  

Commands submitted using the `Executor.execute(java.lang.Runnable)` and `ExecutorService.submit` methods are scheduled with a requested delay of zero. Zero and negative delays (but not periods) are also allowed in schedule methods, and are treated as requests for immediate execution.  

All schedule methods accept relative delays and periods as arguments, not absolute times or dates. It is a simple matter to transform an absolute time represented as a Date to the required form. For example, to schedule at a certain future date, you can use: `schedule(task, date.getTime() - System.currentTimeMillis(), TimeUnit.MILLISECONDS)`. Beware however that expiration of a relative delay need not coincide with the current Date at which the task is enabled due to network time synchronization protocols, clock drift, or other factors. The Executors class provides convenient factory methods for the `ScheduledExecutorService` implementations provided in this package.  

**Explanation**  
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
