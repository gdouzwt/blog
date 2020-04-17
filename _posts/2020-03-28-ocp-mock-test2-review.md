---
typora-root-url: ../
layout:     post
title:      OCP-1Z0-816模拟测试2回顾
date:       '2020-03-28T12:20'
last-modified: '2020-04-17T23:43'
subtitle:   
keywords:   Oracle Certified, OCP 11, Java 11, 1Z0-816
author:     招文桃
catalog:    false
tags:
    - Java
    - 1Z0-816
    - 认证考试
---

**1.** Given  

```java
class Booby {
}
class Dooby extends Booby {
}
class Tooby extends Dooby {
}

public class TestClass {
  Booby b = new Booby();
  Tooby t = new Tooby();
  public void do1(List<? super Dooby> dataList) {
    //1 INSERT CODE HERE
  }
  public void do2(List<? extends Dooby> dataList) {
    //2 INSERT CODE HERE
  }
}
```

and the following four statements:  

1. b = dataList.get(0);  
2. t = dataList.get(0);  
3. dataList.add(b);  
4. dataList.add(t);  

What can be inserted in the above code?  

- [ ] Statements 1 and 3 can inserted at //1 and Statements 2 and 4 can be inserted at //2.  
- [x] Statement 4 can inserted at //1 and Statement 1 can be inserted at //2.  
- [ ] Statements 3 and 4 can inserted at //1 and Statements 1 and 2 can be inserted at //2.  
- [ ] Statements 1 and 2 can inserted at //1 and Statements 3 and 4 can be inserted at //2.  
- [ ] Statement 1 can inserted at //1 and Statement 4 can be inserted at //2.  

**Explanation**  

1. `addData1(List<? super Dooby> dataList)`  
This means that dataList is a List whose elements are of a class that is either Dooby or a super class of Dooby. We don't know which super class of Dooby. Thus, if you try to add any object to dataList, it has to be a assignable to Dooby.  
Thus, `dataList.add(b);` will be invalid because b is not assignable to Dooby.  
Further, if you try to take some object out of dataList, that object will be of a class that is either Dooby or a Superclass of Dooby. Only way you can declare a variable that can be assigned the object retrieved from dataList is Object obj. Thus, `t = dataList.get(0);` and `b = dataList.get(0);` are both invalid.  

2. `addData2(List<? extends Dooby> dataList)`  
This means that dataList is a List whose elements are of a class that is either Dooby or a subclass of Dooby. Since we don't know which subclass of Dooby is the list composed of, there is no way you can add any object to this list.  
If you try to take some object out of dataList, that object will be of a class that is either Dooby or a subclass of Dooby and thus it can be assigned to a variable of class Dooby or its superclass.. Thus, `t = dataList.get(0);` is invalid.  

**泛型规则（JLS）**  
A type argument $T_1$ is said to contain another type argument $T_2$, written $T_2 <= T_1$, is the set of types denoted by $T_2$ is provably a subset of the set of types denoted by $T_1$ under the reflexive and transitive closure of the following rules(where $<:$ denotes subtyping($\S4.10$)):  

- $?\space extends\space T<=\space ?\space extends \space S$ if $T <: S$  
- $?\space extends \space T<=\space ?$  
- $?\space super \space T<=\space ?\space super \space S$  if $T <: S$  
- $?\space super \space T<=\space ?$  
- $?\space super \space T<=\space ? \space extends \space Object$  
- $ T<=\space T$  
- $T <= \space ? \space extends \space T$  
- $T <= \space ? \space super \space T$  
<!--more-->

---

**2.**
Given the following RDBMS table information :  
STUDENT Table  
SID INT Primary Key NAME VARCHAR(50)  
GPA INT  
and the following code:  

```java
Statement stmt = connection.createStatement();  
ResultSet rs = stmt.executeQuery("select SID, NAME,  GPA from STUDENT");  
while(rs.next()){  
  System.out.println( INSERT CODE HERE );  
}  
connection.close();  
```

What can be inserted in the above code so that it will print the GPA value for each student?  (Assume that items not specified such as import statements and try/catch block are all valid.)  

- [ ] rs.getString(2)  
  > The numbering of columns in a ResultSet stars with 1. Therefore, it should be rs.getString(3).  
- [x] rs.getString(3)  
  > Although the value of the GPA field is int, it can still be retrieved using getString().  
  > Note that if a field is of type VARCHAR and if you try to retrieve the value using say getInt(), it may throw an exception at runtime if the value cannot be parsed into an Integer.  
- [ ] rs.getInt(2)  
  > The numbering of columns in a ResultSet starts with 1. Therefore, it should be rs.getInt(3).  
- [ ] rs.getInteger(2)  
- [x] rs.getInt("GPA")  

---

**3.**

Given:  

```java
class Item {
  private int id;
  private String name;
  public Item(int id, String name) {
    this.id = id;
    this.name = name;
  }
  public Integer getId() {
    return id;
  }
  public void setId(int id) {
    this.id = id;
  }
  public String getName() {
    return name;
  }
  public void setName(String name) {
    this.name = name;
  }
  public String toString() {
    return name;
  }
}

public class Test {
  public static void main(String[] args) {
    List<Item> l = Arrays.asList(
          new Item(1, "Screw"),
          new Item(2, "Nail"),
          new Item(3, "Bolt")
    );
    l.stream()
    // INSERT CODE HERE
    .forEach(System.out::print);
  }
}
```

Which of the following options can be inserted in the above code independent of each other, so that the code will print BoltNailScrew?  

- [ ] .sorted((a, b)->a.getId().compareTo(b.getId()))  
  > This option creates a Comparator using a lambda expression that compares two Item objects for their id attribute. Syntactically, this option is correct but we need to sort by name instead of id.  
- [x] .sorted(Comparator.comparing(a->a.getName())).map((i)->i.getName())  
  > 1. This option uses Comparator's comparing method that accepts a function that extracts a Comparable sort key, and returns a Comparator that compares by that sort key. Note that this is helpful only if the type of the object returned by the function implements Comparable. Here, it returns a String, which does implement Comparable and so it is ok.  
  > 2. Although the map part is not required because Item class overrides the toString method to print the name anyway, it is valid.  
- [ ] .map((i)->i.getName())  
  > Just mapping the Items to their names will not help because we need to sort the elements as well.  
- [x] .map((i)->i.getName()).sorted()  
  > 1. The call to map converts the stream of Items to a stream of Strings.  
  > 2. The call to sorted() sorts the stream of String by their natural order, which is what we want here.  

---

**5.**
Given:  

```java
List<Integer> ls = Arrays.asList(3,4,6,9,2,5,7);
System.out.println(ls.stream().reduce(Integer.MIN_VALUE, (a, b)->a>b?a:b)) //1
System.out.println(ls.stream().max(Integer::max).get()); //2
System.out.println(ls.stream().max(Integer::compare).get()); //3
System.out.println(ls.stream().max((a, b)->a>b?a:b)); //4
```  

Which of the above statements will print 9?  

- [ ] 1 and 4  
- [ ] 2 and 3  
- [x] 1 and 3  
- [ ] 2,3, and 4  
- [ ] All of them.  
- [ ] None of them.  

**Explanation**  
The code will print:  

9  
3  
9  
Optional[3]  

You need to understand the following points to answer this question:  

1. The reduce method needs a BinaryOperator. This interface is meant to consume two arguments and produce one output. It is applied repeatedly on the elements in the stream until only one element is left. The first argument is used to provide an initial value to start the process. (If you don't pass this argument, a different reduce method will be invoked and that returns an Optional object. )  

2. The Stream.max method requires a Comparator. All you need to implement this interface using a lambda expression is a reference to any method that takes two arguments and returns an int. The name of the method doesn't matter. That is why it is possible to pass the reference of Integer's max method as an argument to Stream's max method. However, Integer.max works very differently from Integer.compare. The max method returns the maximum of two numbers while the compare method returns a difference between two numbers. Therefore, when you pass Integer::max to Stream's max, you will not get the correct maximum element from the stream. That is why //2 will compile but will not work correctly.  

//4 is basically same as //2. It will not work correctly for the same reason.  

---

**6.**
Given:  

```java
@Retention(RetentionPolicy.RUNTIME)
public @interface DebugInfo {
    String[] params() default {""};
    String date() default "";
    int depth() default 10;
    String value() ;
}
```  

Which of the following options correctly uses the above annotation?  

- [ ] `List<Integer> al = new ArrayList<Integer>(); al.forEach((@DebugInfo("lambda") x) ->{ System.out.println(x);});`  
  > It is possible to annotate lambda parameters but to do that the type of the lambda parameter must be specified.  
- [x] `List<Integer> al = new ArrayList<Integer>(); al.forEach((@DebugInfo("lambda") var x) ->{ System.out.println(x);});`  
  > Normally, when a lambda express requires only a single parameter, you don't need to specify its type because it can be inferred by the compiler. However, in that case, you cannot apply an annotation to it. To be able to apply an annotation and to get the benefit of type inferencing, you can specify the type of the variable as var.  
- [x] `List<Integer> al = new ArrayList<Integer>(); al.forEach((@DebugInfo("lambda") Integer x) ->System.out.println(x));`  
- [x] `@DebugInfo( "01/01/2019") void applyLogic(int index){ }`
  > Since there is only one element in the @DebugInfo annotation that does not have a default value and since its name is value, you can pass a value for this element directly without specifying the name.  
- [ ] `BinaryOperator<Integer> bin = @DebugInfo("lambda")( a, b)-> a+b;`  
  > The annotation is not placed correctly. You can do something like this: `BinaryOperator<Integer> bin = ( @DebugInfo("lambda") Integer a, Integer b)-> a+b;` or `BinaryOperator<Integer> bin = ( @DebugInfo("lambda1") Integer a, @DebugInfo("lambda1") Integer b)-> a+b;` or even this: `BinaryOperator<Integer> bin = ( @DebugInfo("lambda") var a, var b)-> a+b;`  But you cannot do: `BinaryOperator<Integer> bin = ( @DebugInfo("lambda") var a, Integer b)-> a+b;` because you cannot mix var and explicit types in lambda.  
- [ ] `@DebugInfo( date=new Date(), value="01/01/2019") void applyLogic(int index){ }`  
  > Value of an element must be a constant expression. So, new Date() is not a valid value for date element.  

---

**7.**  
Which of the following method implementations will write a boolean value to the underlying stream?  

- [ ] `public void usePrintWriter(PrintWriter pw){ boolean bval = true;     pw.writeBoolean(bval); }`  
  > PrintWriter does not have write  methods such as writeInt, writeBoolean, WriteLong. It has overloaded print methods for writing various primitives.  
- [ ] `public void usePrintWriter(PrintWriter pw) throws IOException{     boolean bval = true; pw.write(bval); }`  
  > PrintWriter does not have write(boolean ) method. It does have write(String), write(int ), write(char[] ) methods. It also has write(char[] buf, int off, int len) and write(String buf, int off, int len) methods that let you write a portion of the input buf.  
- [x] `public void usePrintWriter(PrintWriter pw) throws IOException{     boolean bval = true;  pw.print(bval); }`  
  > Although the throws IOException clause is not required here, it is not invalid.  
- [x] `public void usePrintWriter(PrintWriter pw) { boolean bval = true;     pw.print(bval); }`  
- [x] `public void usePrintWriter(PrintWriter pw) { boolean bval = true;     pw.println(bval); }`  

Explanation  
Remember that none of PrintWriter's print or write methods throw I/O exceptions (although some of its constructors may). This is unlike other streams, where you need to include exception handling (i.e. a try/catch or throws clause) when you use the stream.  

---

**10.**  
Consider the following code fragment:  

```java
public static void myMethod(int x)  //Specify throws clause here
{
    try{
        if(x == 0){
            throw new ClassNotFoundException();
        }
        else throw new NoSuchFieldException();
    }catch(RuntimeException e){
        throw e;
    }
}
```

Which of the following is a valid throws clause for the above method?  

- [ ] No throws clause is necessary.  
- [x] throws ClassNotFoundException, NoSuchFieldException  
- [ ] throws ClassNotFoundException  
- [ ] throws NoSuchFieldException  
- [x] throws Exception  

**Explanation**  
`ClassNotFoundException` and `NoSuchFieldException` are checked exceptions and are thrown when you use Java reflection mechanism to load a class and access its fields. For example:  
`Class c = Class.forName("test.MyClass");` //may throw ClassNotFoundException  
`java.lang.reflect.Field f = c.getField("someField");` //may throw NoSuchFieldException  

---

**11.**  
Which of the following are correct definitions of a repeatable annotation?  

- [ ] `public @interface Meal{ String value(); }`  
  > For an annotation to be repeatable it must be defined with @Repeatable meta-annotation.  
  > @Repeatable requires the name of the container annotation class. It cannot be empty. For example, @Repeatable(Meals.class)  
- [ ] `@Repeatable(Meals.class) public @interface Meal { int id() default 0; } public @interface Meals{ Meal[] meals(); }`  
  > The name of the Meal[] array should be value, not meals.  
- [x] `public @interface Meals{ Meal[] value(); String course() default "maincourse"; } @Repeatable(Meals.class) public @interface Meal{ int id() default 0; String name(); }`  
  > The value of the `@Repeatable` meta-annotation, in parentheses, is the type of the container annotation that the Java compiler generates to store repeating annotations. Containing annotation type must have a value element with an array type. The component type of the array type must be the repeatable annotation type. It is possible to use other elements in the container annotation but they must have default values.
  
- [ ] `public @interface Meals{ Meal[] value(); String course(); } @Repeatable(Meals.class) public @interface Meal{ int id() default 0; String value(); }`  
  > It is possible to use other elements in the container annotation but they must have default values. So, String course(); should be changed to something like String course() default "maincourse";  
  > The reason for this restriction is simple. Java allows you to use the contained annotation and omit the container annotation. But internally, the container does create the container annotation and if there is no default value for any element of the container annotation, the compiler will not be able to supply its value.  

**Explanation**
To make it easy to repeat annotations, Java does not require you to use the container annotation. You can just write `@Meal(name="sandwich")` but, internally, Java converts it to `@Meals(@Meal(name="sandwich"))`. If you apply two such annotations, for example:  
`@Meal(name="sandwich")`  
`@Meal(name="fries")`  

the compiler will convert them to: `@Meals({@Meal(name="sandwich"), @Meal(name="fries") })`  

A container annotation is also an annotation and just like any other annotation, it can be used independently. It can have other elements as well. For example, you can use the `@Meals` annotation like this:  
`@Meals(value={@Meal(name="sandwich"), @Meal(name="fries") }, course="starter")`  

Remember that values of a repeated annotations are not additive. So, for example, you cannot expect `@Meal(id=1)` and `@Meal(name="fries")` to combine automatically to `@Meal(id=1, name="fries")`. Since id is defined using a default value but name is not, `@Meal(name="fries")` is valid but `@Meal(id=1)` is not valid.  

---

**12.**
Your application is packaged in myapp.jar and depends on a jar named datalayer.jar, which in turn depends on mysql-connector-java-8.0.11.jar. The following packages exist in these jars:  

myapp.jar:   com.abc.myapp  
datalayer.jar: com.abc.datalayer  
mysql-connector-java-8.0.11.jar:  com.mysql.jdbc  

You want to use bottom up approach for migrating your app to a modular app. Which of the following is required before you can do this?  

- [x] Mysql driver jar and datalayer.jar must first be converted into modular jars.  
  > In this case, mysql-connector-java-8.0.11.jar would have to become modular first, then datalayer.jar.  
  > In the top down approach, on the other hand, you would directly make myapp.jar modular by including a module-info and adding requires datalayer; clause. You would create an automatic module for datalayer.jar by simply placing it on module-path (instead of classpath). You would leave mysql jar on the classpath so that datalayer could access it.  
- [ ] datalayer.jar must first be converted into modular jar. The mysql jar need not be converted.  
- [ ] The mysql jar must first be converted into modular jar. The datalayer.jar need not be converted.  
- [ ] Neither datalayer nor mysql driver need to be converted into modular jars.  
**Explanation**  
**Bottom Up Approach for modularzing an application**  
While modularizing an app using the bottom-up approach, you basically need to convert lower level libraries into modular jars before you can convert the higher level libraries. For example, if a class in A.jar directly uses a class from B.jar, and a class in B.jar directly uses a class from C.jar, you need to first modularize C.jar and then B.jar before you can modularize A.jar.  
Thus, bottom up approach is possible only when the dependent libraries are modularized already.  

---

**14.**
Given:  
`List<Integer> ls = Arrays.asList(1, 2, 3);`  
Which of the following options will compute the sum of all Integers in the list correctly?  

- [ ] double sum = ls.stream().sum();  
  > There no sum method in Stream. There is one in IntStream and DoubleStream.  
- [x] double sum = ls.stream().reduce(0, (a,b)-> a+b);
  > The reduce method performs a reduction on the elements of this stream, using the provided identity value and an associative accumulation function, and returns the reduced value.  
- [x] double sum = ls.stream().mapToInt(x->x).sum();
- [ ] double sum = 0; ls.stream().forEach(a->{sum=sum+a;});
  > This code is almost correct but for the fact that only final local variables can be used in a lambda expression. Here, the code is trying to use sum and sum is not final. Effectively final means that even though it is not declared as final, it is not assigned any value anywhere else after the first assignment. That compiler determines that this variable never changes and consider it as final.  
- [ ] double sum = 0; ls.stream().peek(x->{sum=sum+x;}).forEach(y->{});
  > This has the same problem as above. sum is not final or effectively final.  

**Explanation**  
It is important that you go through the JavaDoc API description of the three flavors of reduce method given here: You should read about the three flavors of reduce method given here: [https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html](https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html)  

---

**15.**
Given:  

```java
public class Book{
    private String title;
    private Double price;
    public Book(String title, Double price){
        this.title = title;
        this.price = price;
    }
    //accessor methods not shown
```  

What will the following code print when compiled and run?  

`Book b1 = new Book("Java in 24 hrs", null);`  
`DoubleSupplier ds1 = b1::getPrice;`  
`System.out.println(b1.getTitle()+" "+ds1.getAsDouble());`  

- [ ] Java in 24 hrs null  
- [ ] Java in 24 hrs 0.0  
- [ ] Java in 24 hrs  
- [x] It will throw a NullPointerException.  
- [ ] It will not compile.  
  > There is no problem with the code.  

**Explanation**  
`java.util.function.DoubleSupplier`(and other similar Suppliers such as IntSupplier and LongSupplier) is a functional interface with the functional method named `getAsDouble`. The return type of this method is a primitive double (not `Double`). Therefore, if your lambda expression for this function returns a `Double`, it will automatically be converted into a double because of auto-unboxing. However, if your expression returns a null, a `NullPointerException` will be thrown.  

---

**19.**
What will the following code print?  

```java
import java.util.Optional;
public class NewClass {
    public static Optional<String> getGrade(int marks){
        Optional<String> grade = Optional.empty();
        if(marks>50){
            grade = Optional.of("PASS");
        }
        else {
            grade.of("FAIL");
        }
        return grade;
    }
    public static void main(String[] args) {
        Optional<String> grade1 = getGrade(50);
        Optional<String> grade2 = getGrade(55);
        System.out.println(grade1.orElse("UNKNOWN"));
        if(grade2.isPresent()){
            grade2.ifPresent(x->System.out.println(x));
        }else{
            System.out.println(grade2.orElse("Empty"));
        }
    }
}
```  

- [x] UNKNOWN PASS  
- [ ] Optional[UNKNOWN] PASS  
- [ ] Optional[UNKNOWN] Optional[PASS]  
- [ ] FAIL PASS  
- [ ] Optional[FAIL] OPTIONAL[PASS]  

**Explanation**  
You should go through the following article about java.util.Optional:  
[http://www.oracle.com/technetwork/articles/java/java8-optional-2175753.html](http://www.oracle.com/technetwork/articles/java/java8-optional-2175753.html)  

Here are a few important things you need to know about Optional class:  

1. Optional has a static method named `of(T t)` that returns an Optional object containing the value passed as argument. It will throw `NullPointerException` if you pass `null`. If you want to avoid `NullPointerException`, you should use `Optional.ofNullable(T t)` method. This will return `Optional.empty` if you pass `null`.  
2. You cannot change the contents of Optional object after creation. Optional does not have a set method. Therefore, `grade.of`, although technically correct, will not actually change the Optional object referred to by grade. It will return a new Optional object containing the passed argument.  
3. The `orElse` method returns the actual object contained inside the Optional or the argument passed to this method if the Optional is empty. It does not return an Optional object. Therefore, `print(grade1.orElse("UNKNOWN"))` will print UNKNOWN and not Optional[UNKNOWN].  
4. `isPresent()` returns true if the Optional contains a value, false otherwise.  
5. `ifPresent(Consumer)` executes the `Consumer` object with the value if the Optional contains a value. Not that it is the value contained in the Optional that is passed to the `Consumer` and not the Optional itself.  

---

**21.**
Consider the following method exposed by a utility class:  

```java
public static String getOptions(final String propName) {
                return AccessController.doPrivileged(
                    new PrivilegedAction<String>() {
                        public String run() {
                            return System.getProperty(propName);
                        }
                    }
                );
            }
```  

It has been decided to give appropriate permission in the security file for this code. Identify correct statements.  

- [x] It violates secure coding guidelines for invoking privileged actions.  
  > As per Guideline 9-3 / ACCESS-3: "Safely invoke java.security.AccessController.doPrivileged", the given code should retrieve a system property using a hardcoded value instead of passing user input directly to the OS. In the given code, the user can potentially wreck the application by requesting illformated or mischievous property name. Since the code is privileged, the call may cause unwanted impact directly on the OS.  
- [ ] It violates secure coding guidelines for exposing static methods.  
- [x] It violates secure coding guidelines for validating inputs.  
  > Ideally, it should validate whether the property name for which the value is requested is valid or not.  
- [ ] It violates secure coding guidelines for protecting confidential information.  

---

**22.**
Which of the following statements are true regarding the try-with-resources statement?  

- [ ] Resources are closed in the same order of their creation.  
- [ ] Resources may not be closed properly if the code in the try block throws an exception for which there is no catch block.  
- [ ] Resources may not be closed properly if the code in the catch block throws an exception.  
- [x] catch and finally blocks are executed after the resources opened in the try blocks are closed.  

**Explanation**  
You need to know the following points regarding try-with-resources statement for the exam:  

**1.** The resource class must implement java.lang.AutoCloseable interface. Many standard JDK classes such as implement java.io.Closeable interface, which extends java.lang.AutoCloseable.  
**2.** AutoCloseable has only one method - public void close() throws Exception.  
**3.** Resources are closed at the end of the try block and before any catch or finally block.  
**4.** Resources are not even accessible in the catch or finally block. For example:  

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

**5.** Resources are closed in the reverse order of their creation.  
**6.** Resources are closed even if the code in the try block throws an exception.  
**7.** java.lang.AutoCloseable's `close()` throws `Exception` but java.io.Closeable's `close()` throws `IOException`.  
**8.** If code in try block throws exception and an exception also thrown while closing is resource, the exception thrown while closing the resource is suppressed. The caller gets the exception thrown in the try block.  

---

**23.**
What will the following code print when run?  

```java
import java.nio.file.Path;
import java.nio.file.Paths;

public class PathTest {
    static Path p1 = Paths.get("c:\\finance\\data\\reports\\daily\\pnl.txt");  
    public static void main(String[] args) {
        System.out.println(p1.subpath(0, 2));
    }
}
```  

- [x] finance\data  
- [ ] finance\data\  
- [ ] \finance\data\reports  
- [ ] c:\finance\data  
- [ ] c:\finance  

**Explanation**  
Remember the following points about `Path.subpath(int beginIndex, int endIndex)`  

1. Indexing starts from 0.  
2. Root (i.e. c:\) is not considered as the beginning.  
3. name at beginIndex is included but name at endIndex is not.  
4. paths do not start or end with \.  

Thus, in case of "c:\\finance\\data\\reports\\daily\\pnl.txt", name at 0 is *finance* and name at 2 is *reports*. However, since the name at endIndex is excluded, `subpath(0, 2)` will correspond to finance\data.  

The following is the API description for this method:  

`public Path subpath(int beginIndex, int endIndex)`  
Returns a relative Path that is a subsequence of the name elements of this path.  
The beginIndex and endIndex parameters specify the subsequence of name elements. The name that is closest to the root in the directory hierarchy has index 0. The name that is farthest from the root has index count-1. The returned Path object has the name elements that begin at beginIndex and extend to the element at index endIndex-1.  

Parameters:  
beginIndex - the index of the first element, inclusive  
endIndex - the index of the last element, exclusive  
Returns:  
a new Path object that is a subsequence of the name elements in this Path  
Throws:  
IllegalArgumentException - if beginIndex is negative, or greater than or equal to the number of elements. If endIndex is less than or equal to beginIndex, or larger than the number of elements.  

---

**24.**
Consider the following code:  

```java
public class AssertErrorTest
{
   public void robustMethod(int[] intArray) throws AssertionError
   {
      int[] newIA = //get new array by processing intArray
      assert newIA != intArray;
   }
}
```  

Which of the following declarations of robustMethod(int[] intArray) are valid in a subclass of the above class?  

- [x] public void robustMethod(int[] intArray)  
- [ ] public void robustMethod(int[] intArray) throws Exception  
  > Exception is in a different branch of Exceptions than AssertionError.  
- [ ] public void robustMethod(int[] intArray) throws Throwable  
  > Throwable is a super class of AssertionError so it cannot be thrown from the subclass's overriding method.  
- [x] public void robustMethod(int[] intArray) throws Error  
  > Error is also a superclass of AssertionError but any Error or any RuntimeException can be thrown without having to declare them in the throws clause.  
- [x] public void robustMethod(int[] intArray) throws RuntimeException  

**Explanation**  
This questions tests two concepts:  

1. An overriding method must not throw any new or broader checked exceptions than the ones declared in the overridden method. This means, the overriding method can only throw the exceptions or the subclasses of the exceptions declared in the overridden method. It can throw any subclass of Error or RuntimeException as well because it is not mandatory to declare Errors and RuntimeExceptions in the throws clause. An overriding method may also choose not to throw any exception at all.  
2. AssertionError is a subclass of Error.  
Therefore, option 1, 4, and 5 are valid.

---

**25.**
Given:  

```java
String sentence = "Life is a box of chocolates, Forrest. You never know what you're gonna get."; //1
Optional<String> theword = Stream.of(sentence.split("[ ,.]")).anyMatch(w->w.startsWith("g")); //2
System.out.println(theword.get()); //3
```  

Which of the following statements are correct?  

- [ ] It may print either gonna or get  
- [ ] It will print gonna.  
- [ ] It may print either gonna or get if lines //2 and //3 are changed to: `String theword = Stream.of(sentence.split("[,.]")).anyMatch(w->w.startsWith("g"));` //2 `System.out.println(theword.get());` //3  
- [ ] It may print either gonna or get if lines //2 and //3 are changed to: `Optional<String> theword = Stream.of(sentence.split("[,.]")).parallel().anyMatch(w->w.startsWith("g"));` //2 `System.out.println(theword.get());` //3  
- [x] It will fail to compile.  
  > anyMatch returns a boolean and not an Optional. Therefore, //2 will not compile.  
  > The expression Stream.of(sentence.split("[,.]")).anyMatch(w->w.startsWith("g")); will actually just return true.  

**Explanation**  
`anyMatch` returns a boolean and not an Optional. Therefore, //2 will not compile.  

---

**27.**
Given:  

```java
  Connection con = DriverManager.getConnection(dbURL);
  con.setAutoCommit(false);
  String updateString =
        "update SALES " +
        "set T_AMOUNT = 100 where T_NAME = 'BOB'";
  Statement stmt = con.createStatement();
  stmt.executeUpdate(updateString);
  //INSERT CODE HERE
```  

What statement can be added to the above code so that the update is committed to the database?  

- [x] con.setAutoCommit(true);  
- [ ] con.commit(true);  
  > commit() does not take any parameter.  
  > FYI, there are two flavors of rollback() - one does not take any argument and another one takes a java.sql.Savepoint as an argument.  
- [ ] stmt.commit();  
- [ ] con.setRollbackOnly(false)  
  > There is no such method in Connection.  
- [ ] Node code is necessary  

**Explanation**  
This is a trick question. Since auto-commit has been disabled in the given code (by calling `c.setAutoCommit(false)`), you have to explicitly commit the transaction to commit the changes to the database. The regular way to do this is to call `con.commit()`. Notice that commit method does not take any arguments.  

Another way is to utilize the side effect of changing the auto-commit mode of the connection. If the `setAutoCommit` method is called during a transaction and the auto-commit mode is changed, the transaction is committed. If `setAutoCommit` is called and the auto-commit mode is not changed, the call is a no-op. In this question, `con.setAutoCommit(true)` changes the auto-commit mode of the connection from `false` to `true` and therefore this call commits the changes.  

---

**28.**
What will the following code print when run?  

```java
import java.nio.file.Path;
import java.nio.file.Paths;

public class PathTest {
    static Path p1 = Paths.get("c:\\a\\b\\c");
    public static String getValue(){
        String x = p1.getName(1).toString();
        String y = p1.subpath(1,2).toString();
        return x+" : "+y;
    }
    public static void main(String[] args) {
        System.out.println(getValue());
    }
}
```  

- [x] \b:\b  
- [ ] b:b  
- [ ] b:b\c\  
- [ ] a:a\b  
- [ ] b:b\c  

**Explanation**  
Remember the following points about `Path.subpath(int beginIndex, int endIndex)`  

1. Indexing starts from 0.  
2. Root (i.e. c:\) is not considered as the beginning.  
3. name at beginIndex is included but name at endIndex is not.  
4. paths do not start or end with \.  
Thus, if your path is "c:\\a\\b\\c",  

subpath(1,1) will cause IllegalArgumentException to be thrown.  
subpath(1,2) will correspond to b.  
subpath(1,3) will correspond to b/c.  

Remember the following 4 points about Path.getName() method :  

1. Indices for path names start from 0.  
2. Root (i.e. c:\) is not included in path names.  
3. \ is NOT a part of a path name.  
4. If you pass a negative index or a value greater than or equal to the number of elements, or this path has zero name elements, java.lang.IllegalArgumentException is thrown. It DOES NOT return null.  

Thus, for example, If your Path is "c:\\code\\java\\PathTest.java",  
p1.getRoot()  is c:\  ((For Unix based environments, the root is usually / ).  
p1.getName(0) is code  
p1.getName(1) is java  
p1.getName(2) is PathTest.java  
p1.getName(3) will cause IllegalArgumentException to be thrown.  

---

**29.**
Given:  

```java
@Retention(RetentionPolicy.RUNTIME)
public @interface DebugInfo {
    String value() default "";
    String[] params();
    String date();
    int depth() default 10;
}
```  

Which of the following options correctly uses the above annotation?  

- [x] `@DebugInfo(date = "2019", params = "index") void applyLogic(int index){ }`  
  > The date element is defined as String. So, it doesn't really have to be a date. Any string value will be valid.  
  > params is defined as a String[]. So, you can either use a single string such as used in this option or a String array such as params={"index"} or params={"index1", "whatever"} or even params={}.  
  > value and depth elements have default values so, the value for these elements can be omitted.  
- [ ] `@DebugInfo(date = "2019-1-1", params = { null }) void applyLogic(int index){ }`  
  > You cannot set an annotation element (or its values, if it is an array) to null.  
- [x] `@DebugInfo(depth = 10, date = "01/01/2019", params = {"index"}, value="applyLogic") static final String s = null;`  
  > 1. The order of values for the elements is not important.  
  > 2. Since @Target annotation is not specified in the definition of @DebugInfo, it will be assumed that @DebugInfo is applicable to all place where annotations can be used.  
- [ ] `@DebugInfo({"index"}, "01/01/2019") void applyLogic(int index){ }`  
  > Names of the elements cannot be omitted when there are more than one values. Even when there is only one value, the name of the element can be omitted only if the name of the element is value.  
- [ ] `@DebugInfo("value", params={"index"}, date="01/01/2019") void applyLogic(int index){ }`  
  > You cannot omit the name of any element, if you are specifying values for more than one element. So, you must write value="value" instead of just "value".  

---

**30.**
Given:  

```java
String qr = "insert into STOCK ( ID, TICKER, LTP, EXCHANGE ) values( ?, ?, ?, ?)";
String[] tickers = {"AA", "BB", "CC", "DD" };
```

You are trying to initialize the STOCK table and for that you need to insert one row for each of the ticker value in the tickers array. Each row has to be initialized with the same values except the ID and TICKER columns, which are different for each row. The ID column is defined as AUTO_INCREMENT and so you need to pass only 0 for this column.  

Which of the following code snippets would you use?  

- [ ] option 1

```java
for(String ticker: tickers)
try(PreparedStatement ps = c.preparedStatement(qr);) {
  ps.setInt(1,0);
  ps.setString(2, ticker);
  ps.setDouble(3, 0.0);
  ps.setString(4, "NYSE");
  ps.executeUpdate();
}
```  

  > This will close the PreparedStatement after each insert. This is very inefficient.  

- [ ] option 2

```java
try(PreparedStatement ps = c.prepareStatement(qr);)
{
  for(String ticker: tickers) {
    ps.setInt(1, 0);
    ps.setString(2, ticker);
    ps.setDouble(3, 0.0);
    ps.setString(4, "NYSE");
    ps.executeUpdate()；
  }
}
```  

  > This is better than option 1 but there is no need to set the values for ID, LTP, and EXCHANGE columns in every iteration.  

- [x] option 3

```java
try(PreparedStatement ps = c.prepareStatement(qr);)
{
    ps.setInt(1, 0);
    ps.setDouble(3, 0.0);
    ps.setString(4, "NYSE");
    for(String ticker: tickers) {
      ps.setString(2, ticker);
      ps.executeUpdate()；
    }
}
```  

  > All of the options will insert the required rows in the table, however, this option is most suitable because it is the most efficient of all. A PreparedStatement remembers the values once you set them until you close it. So, there is no need to reset the values for ID, LTP, and EXCHANGE columns if they are not changing.  

- [ ] option 4  

```java
for(String ticker: tickers)
try(Statement s = c.createStatement(qr);)
{
  s.executeUpdate("insert into STOCK (ID, TICKER, LTP, EXCHANGE ) values (0, '"+ticker+"', 0.0, 'NYSE')");
}
```

  > This option is as bad as option 1 in terms of performance. Further, it does not offer protection from SQL injection either.  

---

**31.**
Given that Book is a valid class with appropriate constructor and getTitle and getPrice methods that return a String and a Double respectively, what can be inserted at //1 and //2 so that it will print the price of all the books having a title that starts with "A"?  

```java
List<Book> books = Arrays.asList(
        new Book("Atlas Shrugged", 10.0),
        new Book("Freedom at Midnight", 5.0),
        new Book("Gone with the wind", 5.0)
);

Map<String, Double> bookMap = //1 INSERT CODE HERE
//2 INSERT CODE HERE
bookMap.forEach(func);
```  

- [x] option 1

```java
books.steam().collect(Collectors.toMap((b->b.getTitle()), b->b.getPrice()));
// and
BiConsumer<String, Double> func = (a, b) -> {
  if(a.startsWith("A")) {
    System.out.println(b);
  }
};
```

  > 1. The first line generates a `Map<String, Double>` from the List using Stream's collect method. The `Collectors.toMap` method uses two functions to get two values from each element of the stream.  The value returned by the first function is used as a key and the value returned by the second function is used as a value to build the resulting `Map`.  
  > 2. The `forEach` method of a `Map` requires a `BiConsumer`. This function is invoked for each entry, that is each key-value pair, in the map. The first argument of this function is the key and the second is the value.  

- [ ] option 2

```java
books.stream().toMap((b->b.getTitle()), b->b.getPrice()));
// and
BiConsumer<String, Double> func = (a, b) -> {
  if(a.startsWith("A")) {
    System.out.println(b);
  }
};
```

  > toMap is not a valid method in Stream.  

- [ ] option 3

```java
books.stream().toMap((b->b.getTitle()), b->b.getPrice()));
// and
BiConsumer<Map.Entry> func = (b)-> {
  if(b.getKey().startsWith("A")) {
    System.out.println(b.getValue());
  }
};
```

  > 1. toMap is not a valid method in Stream.  
  > 2. BiConsumer requires two generic types and two arguments.  

- [ ] option 4

```java
books.stream().collect(Collectors.toMap((b->b.getTitle()), b->b.getPrice()));
// and
Consumer<Map.Entry<String, Double>> func = (e)-> {
  if(e.getKey().startsWith("A")) {
    System.out.println(e.getValue());
  }
};
```

  > The implementation of Consumer is technically correct. However, the forEach method requires a BiConsumer.  

---

**33.**
NOTE: If you are not from a Computer Science background, this question will seem very complicated and almost unanswerable. Further, this has more to do with understanding of an algorithm than assertions. Unfortunately, we have seen similar question in the real exam. If you get such a question in your exam, our suggestion is to just mark it and move on. Attempt it only at the end if you have time.  

Given the following code that implements a sorting algorithm:  

```java
public static void mysort(int[] values){
    int n = values.length;
    for(int i = 1; i<n; i++){  

        //1
        int temp = values[i];
        int j = i-1;
        while( (j>-1) && values[j]>temp){
            values[j+1] = values[j];
            j--;

            //2
        }
        //3
        values[j+1] = temp;

        //4
    }
    //5
}
```

To test the working of this code, you want to assert that the elements are partially sorted in the middle of the sorting process using this statement:  
`assert j<0 || values[j]<=values[j+1];`

Where can this statement be put?  

- [ ] At //1.
- [ ] At //2.
- [ ] At //3.
- [x] At //4.
- [ ] At //5.

**Explanation**  
The basic idea behind this algorithm is to determine the right place of an element of among the elements that appear before it in the input array. If a list contains only 1 element, then the list is always already sorted. So, the first top level iteration starts with the second element. In this iteration, the second element is put in the correct position considering just the first two elements. Thus, at the end of the first iteration, first two elements will be sorted. The process is continued till the last element is put in its right place.  

Try to run the above code Step by Step in an editor. Observe the values of the variables.  

---

**38.**
What will the following code print when run?  

```java
  LocalDate d = LocalDate.now();
  DateFormat df = new DateFormat(DateFormat.LONG);
  System.out.println(df.format(d));
```  

- [ ] It will print current date in LONG format.  
- [ ] It will print the number of milliseconds since 1 Jan 1970.  
- [x] It will not compile.  
- [ ] It will throw an exception at runtime.  

**Explanation**  
`java.text.DateFormat` class provides several static getXXXInstance methods. The following are the important methods that you need to know for the exam:  

`static DateFormat getDateInstance()`  
          Get a default date/time formatter that uses the SHORT style for both the date and the time.  
`static DateFormat getDateInstance(int style)`  
          Gets the date formatter with the given formatting style for the default locale.  
`static DateFormat getDateInstance(int style, Locale aLocale)`  
          Gets the date formatter with the given formatting style for the given locale.  
`static DateFormat getInstance()`  
          Get a default date/time formatter that uses the default style for both the date and the time.  

Note that valid styles values are : `DateFormat.DEFAULT`, `DateFormat.FULL`, `DateFormat.LONG`, `DateFormat.MEDIUM`, and `DateFormat.SHORT`  

---

**44.**
Assuming that STOCK table exists and is empty, what will the following code snippet print?  

```java
String qr = "insert into STOCK ( ID, TICKER, LTP, EXCHANGE ) values( ?, ?, ?, ?)";
try(PreparedStatement ps =  c.prepareStatement(qr);)
{
    ps.setInt(1, 111);
    ps.setString(2, "APPL");
    ps.setDouble(3, 0.0);
    ps.setString(4, "NYSE");
    int i = ps.executeUpdate();  //1
    System.out.println(i);
}
```

- [ ] It will not compile due to error at //1.  
- [ ] It will print 0.  
- [x] It will print 1.  
  > executeUpdate returns the number of rows that have been affected by the query. If you execute a query that, for example, causes updates to 10 existing rows, executeUpdate would return 10. Here, 1 row has been inserted and so it will return 1.  
- [ ] It will print 4.  
- [ ] It will print -1.  

---

**45.**
Given that a method named Double getPrice(String id) exists and may potentially return null, about which of the following options can you be certain that a run time exception will not be thrown?  

- [ ] option 1  

```java
Optional<Double> price = Optional.of(getPrice("1111"));
```

  > Optional.of method throws NullPointerException if you try to create an Optional with a null value. If you expect the argument to be null, you should use Optional.ofNullable method, which returns an empty Optional if the argument is null.  

- [x] option 2  

```java
Optional<Double> price = Optional.ofNullable(getPrice("1111"));  
Double x = price.orElse(getPrice("2222"));  
```

- [x] option 3  

```java
Optional<Double> price = Optional.ofNullable(getPrice("1111"));  
Double y = price.orElseGet(()->getPrice("333"));  
```  

  > Optional's `orElseGet` method takes a `java.util.function.Supplier` function as an argument and invokes that function to get a value if the Optional itself is empty. Just like the orElse method, this method does not throw any exception even if the Supplier returns null. It does, however, throw a NullPointerException if the `Optional` is empty and the supplier function itself is null.  

- [ ] option 4  

```java
Optional<Double> price = Optional.of(getPrice("1111"), 10.0);  
```  

  > This will not compile because Optional.of takes only one argument.  

- [ ] option 5  

```java
Optional<Double> price = Optional.of(getPrice("1111"));  
Double z = price.orElseThrow(()->new RuntimeException("Bad Code"));  
```  

  > The `orElseThrow` method takes a `Supplier` function that returns an `Exception`. This method is useful when you want to throw a custom exception in case the Optional is empty.  

---

**46.**
Whi of the following are correct definitions of a repeatable annotation?  

- [ ] option 1

```java
@Repeatable
public @interface Author {
  int id() default 0;
  String name;
}
```
  
  > @Repeatable requires the name of the container class. It cannot be empty. For example, @Repeatable(Authors.class)  

- [ ] option 2

```java
@Repeatable(List.class)
public @interface Author {
  int id() default 0;
  String name();
}
```

- [ ] option 3

```java
@Repeatable(List<Author>)
public @interface Author {
  int id() default 0;
  String name();
}
```

- [x] option 4

```java
public @interface Authors {
  Author[] value();
}
@Repeatable(Authors.class)
public @interface Author {
  int id() default 0;
  String name();
}
```

  > The value of the @Repeatable meta-annotation, in parentheses, is the type of the container annotation that the Java compiler generates to store repeating annotations. Containing annotation type must have a value element with an array type. The component type of the array type must be the repeatable annotation type.  

- [ ] option 5

```java
public class Authors {
  Author[] values;
}
@Repeatable(Authors.class)
public @interface Author {
  int id() default 0;
  String name();
}
```

- [ ] option 6

```java
public class Authors {
  List<Author> authors;
}
@Repeatable(Authors.class)
public @interface Author {
  int id() default 0;
  String name();
}
```

---

**48.**
Which of the following is correct regarding a HashSet?  

- [ ] Elements are stored in a sorted order.  
  > TreeSet does that.  
- [ ] It is immutable.  
  > No, you can add/remove elements to/from it.  
- [x] It only keeps unique elements.  
- [ ] Elements can be accessed using a unique key.  
  > HashSet is a Set not a Map.  

**Explanation**  
public class HashSet extends AbstractSet implements Set, Cloneable, Serializable  

This class implements the Set interface, backed by a hash table (actually a HashMap instance). It makes no guarantees as to the iteration order of the set; in particular, it does not guarantee that the order will remain constant over time. This class permits the null element.  

---

**50.**
Given:  

```java
public @interface Authors{
   Author[] value();
}
@Repeatable(Authors.class)
public @interface Author {
    int id() default 0;
    String value();
}
```  

Identify correct usages of the above annotations.  
**You had to select 2 options**  

- [ ] option 1  

```java
@Author(1, "bob")
@Author(2, "alice")
public class Sample {
}
```

  > Must use name=value format for element values because more than one values are being specified.  

- [x] option 2  

```java
@Authors(@Author("bob"))
void someMethod(int index) {
}
```

  > To make it easy to repeat annotations, Java does not require you to use the container annotation. You can just write @Author("bob") but, internally, Java converts it to @Authors(@Author("bob")).  

- [ ] option 3  

```java
@Authors(@Author("bob"))
@Authors(@Author("alice"))
void someMethod(int index) {
}
```

  > The @Author annotation is repeatable, @Authors is not!  

- [x] option 4  

```java
@Author("bob")
@Authors(@Author("alice"))
void someMethod(int index) {
}
```

- [ ] option 5  

```java
@Author("bob")
@Author(1)
void someMethod(int index) {
}
```

  > The two annotations are different. Their values are not additive. So, while @Author("bob") is valid @Author(1) is not because it does not include a value for the value element.  

- [ ] option 6  

```java
@Author("bob")
@Author(id=1, value=null)
void someMethod(int index) {
}
```

  > @Author(id=1, value=null) is invalid because you cannot set an element value to null. The value must be a constant non-null value.  

---

**54.**
Given the following code:  

```java
RandomAccessFile raf = new RandomAccessFile("c:\\temp\\test.txt", "rwd");
raf.writeChars("hello");
raf.close();
```

Which of the following statements are correct?  
(Assuming that the code has appropriate security permissions.)  

- [x] If the file test.txt does not exist, an attempt will be made to create it.  
- [ ] If the file test.txt does not exist, an exception will be thrown.  
- [ ] If the file test.txt exists, an exception will be thrown.  
- [ ] If the file test.txt, it will be overwritten and all the existing data will be lost.  
  > Only the initial 5 characters (i.e. 10 bytes) of the file will be overwritten. Any existing data beyond 10 bytes will be left untouched.  
- [ ] If the file test.txt exists, the given characters will be appended to the end of the existing data.  
  > When you open the file, the pointer is at the first position. So the given characters will be written at the beginning of the file.  

**Explanation**  
The permitted values for the access mode and their meanings are:  

"r": Open for reading only. Invoking any of the write methods of the resulting object will cause an IOException to be thrown.  
"rw": Open for reading and writing. If the file does not already exist then an attempt will be made to create it.  
"rws": Open for reading and writing, as with "rw", and also require that every update to the file's content or metadata be written synchronously to the underlying storage device.  
"rwd": Open for reading and writing, as with "rw", and also require that every update to the file's content be written synchronously to the underlying storage device.  

---

**55.**
Given the following code:  

```java
enum Title
{
    MR("Mr. "), MRS("Mrs. "), MS("Ms. ");
    private String title;
    private Title(String s){
    title = s;
    }
    public String format(String first, String last){
    return title+" "+first+" "+last;
    }
}

//INSERT CODE HERE
```  

Identify valid code snippets ..  

(Assume that Title is accessible wherever required.)  
**You had to select 4 options**  

- [ ] option 1  

```java
class TestClass {
  void someMethod()
  {
    System.out.println(Title.format("Rob", "Miller"));
  }
}
```

  > You cannot call format method directly on Title because format is not a static method. You must call it on Title instances. For example, Title.MR.format().  

- [x] option 2  

```java
class TestClass {
  void someMethod()
  {
    System.out.println
  }
}
```

- [ ] option 3  

```java
class TestClass {
  void someMethod()
  {
    System.out.println(MR.format("Rob", "Miller"));
  }
}
```

  > It must be Title.MR.format("Rob", "Miller").

- [ ] option 4  

```java
enum Title2 extends Ttile
{
  DR("Dr. ");
}
```

  > An enum cannot extend another enum or class. It may implement an interface though.  

- [ ] option 5  

```java
class TestClass {
  void someMethod()
  {
    Title.DR dr = new Title.DR("Dr. ");
  }
}
```

  > Enum constants cannot be instantiated/created using the new keyword.  

- [x] option 6  

```java
enum Title2
{
  DR;
  private Title t;
}
```

- [x] option 7  

```java
enum Title2
{
  DR;
  private Title t = Title.MR;
}
```

- [x] option 8  

```java
enum Title2
{
  DR;
  private Title t = Title.MR;
  public String format(String s) { return t.format(s, s); };
}
```

**Explanation**  
You need to know the following facts about enums:  

1. Enum constructor is always private. You cannot make it public or protected. If an enum type has no constructor declarations, then a private constructor that takes no parameters is automatically provided.  
2. An enum is implicitly final, which means you cannot extend it.  
3. You cannot extend an enum from another enum or class because an enum implicitly extends `java.lang.Enum`. But an enum can implements interfaces.  
4. Since enum maintains exactly one instance of its constants, you cannot clone it. You cannot even override the clone method in an enum because `java.lang.Enum` makes it final.  
5. Compiler provides an enum with two public static methods automatically - `values()` and `valueOf(String)`. The `values()` method returns an array of its constants and `valueOf()` method tries to match the String argument exactly (i.e. case sensitive) with an enum constant and returns that constant if successful otherwise it throws `java.lang.IllegalArgumentException`.  
6. By default, an enum's toString() prints the enum name but you can override it to print anything you want.  

The following are a few more important facts about java.lang.Enum which you should know:  

1. It implements `java.lang.Comparable` (thus, an enum can be added to sorted collections such as `SortedSet`, `TreeSet`, and `TreeMap`).  
2. It has a method `ordinal()`, which returns the index (starting with 0) of that constant i.e. the position of that constant in its enum declaration.  
3. It has a method name(), which returns the name of this enum constant, exactly as declared in its enum declaration.  

---

**57.**
Given:  

```java
module abc.print{
   requires org.pdf;
   provides org.pdf.Print with com.abc.print.PrintImpl;
}
```  

Identify correct statements about the above module.  

- [ ] org.pdf.Print must be an interface.  
- [ ] org.pdf.Print must be an interface or an abstract class.  
  > Ideally, Print should be an interface or an abstract class but there is no such technical restriction. As per JLS Section 7.7.4: The service must be a class type, an interface type, or an annotation type. It is a compile-time error if a provides directive specifies an enum type as the service.  
- [ ] com.abc.print.PrintImpl must have a no-args constructor.  
  > This is not necessary. It could also have a provider method.  
- [ ] com.abc.print.PrintImpl must implement(or extend) org.pdf.Print.  
  > This is not necessary. If PrintImpl has a provider method, then that method could return any sub-type of Print. PrintImpl does not have to be a sub-type of Print.  
- [x] None of the above are correct.  

**Explanation**  
Here are the rules for a service provider:  

1. If a service provider explicitly declares a public constructor with no formal parameters, or implicitly declares a public default constructor, then that constructor is called the provider constructor.  
2. If a service provider explicitly declares a public static method called provider with no formal parameters, then that method is called the provider method.  
3. If a service provider has a provider method, then its return type must (i) either be declared in the current module, or be declared in another module and be accessible to code in the current module; and (ii) be a subtype of the service specified in the provides directive; or a compile-time error occurs.  
4. While a service provider that is specified by a provides directive must be declared in the current module, its provider method may have a return type that is declared in another module. Also, note that when a service provider declares a provider method, the service provider itself need not be a subtype of the service.  
5. If a service provider does not have a provider method, then that service provider must have a provider constructor and must be a subtype of the service specified in the provides directive, or a compile-time error occurs.  

---

**58.**
Which of the following statements are correct regarding synchronization and locks?  

- [ ] A thread shares the intrinsic lock of an object with other threads between the time the threads enter a synchronized method and exit the method.  
  > Just the opposite is true. An intrinsic lock is never shared. Once a thread acquires an intrinsic lock, it owns the lock exclusively until it releases the lock.  
- [x] When a synchronized method ends with a checked exception, the intrinsic lock held by the thread is released automatically.  
- [ ] A thread will retain the intrinsic lock if the return from a synchronized method is caused due to an uncaught unchecked exception.  
  > The intrinsic lock is released when the method ends. Irrespective of how it ends.  
- [ ] Every object has an intrinsic lock associated with it and that lock is automatically acquired by a thread when it executes a method on that object.  
  > A thread acquires the intrinsic lock of an object when it enters synchronized method on that object or when it enter a synchronized block that uses that object. The lock is not acquired when a thread enters a non-synchronized method.  

**Explanation**  
Please go through this link that explains synchronization and intrinsic locks. You will find questions in the exam that use statements given in this trail: [https://docs.oracle.com/javase/tutorial/essential/concurrency/locksync.html](https://docs.oracle.com/javase/tutorial/essential/concurrency/locksync.html)  

---

**59.**
What will the following code print when compiled and run?  

```java
import java.io.Serializable;
class Booby{
    int i; public Booby(){ i = 10; System.out.print("Booby"); }
}
class Dooby extends Booby implements Serializable {
    int j; public Dooby(){ j = 20; System.out.print("Dooby"); }
}
class Tooby extends Dooby{
    int k; public Tooby(){ k = 30; System.out.print("Tooby"); }
}
public class TestClass {
  public static void main(String[] args) throws Exception{
    Tooby t = new Tooby();
    t.i = 100;
    ObjectOutputStream oos  = new ObjectOutputStream(new FileOutputStream("c:\\temp\\test.ser"));
    oos.writeObject(t); oos.close();
    ObjectInputStream ois = new ObjectInputStream(new FileInputStream("c:\\temp\\test.ser"));
    t = (Tooby) ois.readObject();ois.close();
    System.out.println(t.i+" "+t.j+" "+t.k);
  }
}
```  

- [ ] Booby Dooby Tooby 100 20 30  
- [ ] Booby Dooby Tooby Booby Dooby Tooby 10 20 30  
- [x] Booby Dooby Tooby Booby 10 20 30  
- [ ] Booby Dooby Tooby Booby 0 20 30  
- [ ] Booby Dooby Tooby Booby 100 20 30  
- [ ] Booby Dooby Tooby Booby Dooby Tooby 100 20 30  

**Explanation**  
Objects of a class that is not marked Serializable cannot be serialized. In this question, class Booby does not implement Serializable and so, its objects cannot be serialized. Class Dooby implements Serializable and since Tooby extends Dooby, it is Serializable as well.  

Now, when you serialize an object of class Tooby, only the data members of Dooby and Tooby will be serialized. Data members of Booby will not be serialized. Thus, the value of i (which is 100) at the time of serialization will not be saved in the file.  

When reading the object back (i.e. deserializing), the constructors of serializable classes are not called. Their data members are set directly from the values present in serialized data. Constructor for unserializable classes is called. Thus, in this case, constructors of Tooby and Dooby are not called but the constructor of Booby is called. Therefore, i is set in the constructor to 10 and j and k are set using the data from the file to 20 and 30 respectively.  

---

**60.**
Given:  

```java
@Target(ElementType.TYPE)
public @interface DBTable {
  public String value();
  public String[] primarykey();
  public String surrogateKey() default "id";
}
```

Identify correct usages of the above annotation.  
**You had to select 2 options**  

- [ ] option 1

```java
@DBTable("person", primarykey={"name"})
interface Person {
}
```

  > Must use value="person" because you are specifying values for more than one elements.  

- [x] option 2

```java
@DBTable(value="person" primarykey={"name"})
interface Person {
}
```

- [ ] option 3

```java
@DBTable("person", {"name"}, "pid")
class Person {
}
```

  > Must use elementName=elementValue format for specifying element values because you are specifying values for more than one element.  

- [x] option 4

```java
@DBTable(value="DAYS", primarykey="name")
enum DAYS {
  MON, TUE, WED, THU, FRI, SAT, SUN;
}
```

  > Since the target of @DBTable annotation is specified as ElementType.TYPE, this annotation can be used on a class, an interface, or an enum.  

- [ ] option 5

```java
@DBTable("DAYS", {"name"})
enum DAYS {
  MON, TUE, WED, THU, FRI, SAT, SUN;
}
```

**Explanation**  
There are two rules that you need to remember while specifying values for annotation elements:  

1. You can omit the element name while specifying a value only when the name of the element is value and only when you are specifying just one value. In other words, if you are specifying values for more than one elements, you need to use the elementName=elementValue format for each element. The order of the elements is not important.  
2. If an element expects an array, you can specify the values by enclosing them in { }. But if you want to specify an array of length 1, you may omit the { }.  

---

**62.**
What will the following code fragment print?  

```java
Path p1 = Paths.get("x\\y");
Path p2 = Paths.get("z");
Path p3 = p1.relativize(p2);
System.out.println(p3);

```

- [ ] x\y\z  
  > Observe what happens when you append this path to p1:  
  > x\y + \x\y\z => x\y\x\y\z  
  > This is not same as z  
- [ ] \z  
  > Observe what happens when you append this path to p1:  
  > x\y + \z => x\y\z  
  > This is not same as z  
- [ ] ..\z  
  > Observe what happens when you append this path to p1:  
  > x\y + ..\z => x\z  
  > This is not same as z  
- [x] ..\\..\z  
  > Observe what happens when you append this path to p1:  
  x\y + ..\\..\z => x + ..\z => z  
  > This is what we want. So this is the correct answer.  

  A ".." implies parent folder, therefore imagine that you are taking off one ".." from the right side of the plus sign and removing the last name of the path on the left side of the plus sign.  
  For example, .. appended to y makes it y\\.., which cancels out.  

**Explanation**  
You need to understand how relativize works for the purpose of the exam. The basic idea of relativize is to determine a path, which, when applied to the original path will give you the path that was passed. For example, "a/c" relativize "a/b"  is "../b" because "/a/c/../b" is "/a/b" Notice that  "c/.." cancel out.  

Please go through the following description of relativize() method, which explains how it works in more detail.  

Note that in Java 11, the paths are first normalized before relativizing.  

`public Path relativize(Path other)`  
Constructs a relative path between this path and a given path. Relativization is the inverse of resolution. This method attempts to construct a relative path that when resolved against this path, yields a path that locates the same file as the given path. For example, on UNIX, if this path is "/a/b" and the given path is "/a/b/c/d" then the resulting relative path would be "c/d".  

Where this path and the given path do not have a root component, then a relative path can be constructed.  

A relative path cannot be constructed if only one of the paths have a root component.  

Where both paths have a root component then it is implementation dependent if a relative path can be constructed.  

If this path and the given path are equal then an empty path is returned.  

For any two normalized paths p and q, where q does not have a root component,
p.relativize(p.resolve(q)).equals(q)  

When symbolic links are supported, then whether the resulting path, when resolved against this path, yields a path that can be used to locate the same file as other is implementation dependent. For example, if this path is "/a/b" and the given path is "/a/x" then the resulting relative path may be "../x". If "b" is a symbolic link then is implementation dependent if "a/b/../x" would locate the same file as "/a/x".  

---

**63.**
What will the following code fragment print?  

```java
Path p1 = Paths.get("\\personal\\readme.txt");
Path p2 = Paths.get("\\index.html");
Path p3 = p1.relativize(p2);
System.out.println(p3);
```

- [ ] \index.html  
  > Observe what happens when you append this path to p1:  
  > \personal\readme.txt + \index.html =>\personal\readme.txt\index.html  
  > This is not same as \index.html  
- [ ] \personal\index.html  
  > Observe what happens when you append this path to p1:  
  > \personal\readme.txt + \personal\index.html =>\personal\readme.txt\\personal\index.html  
  > This is not same as \index.html  
- [ ] personal\index.html  
  > Observe what happens when you append this path to p1:  
  > \personal\readme.txt + personal\index.html =>\personal\readme.txt\personal\index.html  
  > This is not same as \index.html  
- [x] ..\\..\index.html  
  > Observe that if you append this path to p1, you will get p2. Therefore, this is the right answer.  
  > p1 + ..\..\index.html  
  > =>\personal\readme.txt + ..\..\index.html  
  > =>\personal + ..\index.html  
  > =>\index.html  
  
  A ".." implies parent folder, therefore imagine that you are taking off one ".." from the right side of the plus sign and removing the last name of the path on the left side of the plus sign.  
  For example, .. appended to personal makes it personal\.., which cancels out.  

**Explanation**  
You need to understand how relativize works for the purpose of the exam. The basic idea of relativize is to determine a path, which, when applied to the original path will give you the path that was passed. For example, "a/c" relativize "a/b"  is "../b" because "/a/c/../b" is "/a/b" Notice that  "c/.." cancel out.  

Note that in Java 11, the paths are first normalized before computing relativizing.  

Please go through the following description of relativize() method, which explains how it works in more detail.  

`public Path relativize(Path other)`  
Constructs a relative path between this path and a given path. Relativization is the inverse of resolution. This method attempts to construct a relative path that when resolved against this path, yields a path that locates the same file as the given path. For example, on UNIX, if this path is "/a/b" and the given path is "/a/b/c/d" then the resulting relative path would be "c/d".  

Where this path and the given path do not have a root component, then a relative path can be constructed.  

A relative path cannot be constructed if only one of the paths have a root component.  

Where both paths have a root component then it is implementation dependent if a relative path can be constructed.  

If this path and the given path are equal then an empty path is returned.  

For any two normalized paths p and q, where q does not have a root component,
p.relativize(p.resolve(q)).equals(q)

When symbolic links are supported, then whether the resulting path, when resolved against this path, yields a path that can be used to locate the same file as other is implementation dependent. For example, if this path is "/a/b" and the given path is "/a/x" then the resulting relative path may be "../x". If "b" is a symbolic link then is implementation dependent if "a/b/../x" would locate the same file as "/a/x".  

---

**65.**
What will the following code print when compiled and run?  

```java
interface Boiler{
    public void boil();
    private static void log(String msg){ //1
       System.out.println(msg);
    }
    public static void shutdown(){
        log("shutting down");
    }
}
interface Vaporizer extends Boiler{  
    public default void vaporize(){
        boil();
        System.out.println("Vaporized!");
    }
}
public class Reactor implements Vaporizer{
    public void boil() {
        System.out.println("Boiling...");
    }

    public static void main(String[] args) {
        Vaporizer v =  new Reactor(); //2
        v.vaporize(); //3
        v.shutdown(); //4
    }
}
```

- [ ]  option 1  

```none
Boiling...
Vaporized!
shutting down
```

- [ ] Compilation failure at //1.  
  > Since Java 9, an interface is allowed to have private (but not protected) static as well as instance methods. Fields of an interface are still always implicitly public, static, and final.  
- [ ] Compilation failure at //2.  
- [x] Compilation failure at //4.  
- [ ] option 5

```none
If code at //4 is changed to Vaporizer.shutdown();, it will print  Boiling...
Vaporized!
shutting down
```

- [ ] Definition of interface Vaporizer will cause compilation to fail.  
  > Definition of interface Vaporizer is fine.  

**Explanation**  
Remember that static method of an interface can only be accessed by using the name of that interface. i.e. `Boiler.shutdown()` in this case. This is unlike a static method of a class, which can be accessed using a subclass name or a variable name as well.  

---

**66.**
Given:  

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface DebugInfo {
    String value();
    String[] params();
    String date();
    int depth();
}
```  

Which of the following options correctly uses the above annotation?  

- [x] option 1  

```java
@DebugInfo(value="applyLogic", date = "2019", depth = 10, params = "index")
void applyLogic(int index) {
}
```

The date element is defined as String. So, it doesn't really have to be a date. Any string value will be valid. params is defined as a `String[]`. So, you can either use a single string such as used in this option or a String array such as `params={"index"}` or `params={"index1", "whatever"}`.  

- [ ] option 2  

```java
@DebugInfo(value="applyLogic", date = "01/01/2019", depth = "10", params = "index" )
void applyLogic(int index) {
}
```

Since *depth* is defined as `int`, you can't pass "10", You must pass 10 (i.e. without double quotes.)  

- [ ] option 3  

```java
@DebugInfo(value="applyLogic", date="01/01/2019", depth="10", params = {"index"})
void applyLogic(int index) {
}
```

Since *depth* is defined as `int`, you can't pass "10", You must pass 10 (i.e. without double quotes.)  

- [ ] option 4  

```java
@DebugInfo(value="applyLogic", date="01/01/2019")
@DebugInfo(depth = 10, params = {"index"})
void applyLogic(int index) {
}
```

Since @DebugInfo is not annotated with @Repeatable, you can use this annotation only once at any place.  

---

**69.**
Identify the correct statements about the following code:  

```java
import java.util.*;
class Person {
    private static int count = 0;
    private String id = "0"; private String interest;
    public Person(String interest){ this.interest = interest; this.id = "" + ++count; }
    public String getInterest(){ return interest;     }
    public void setInterest(String interest){ this.interest = interest; }
    public String toString(){ return id; }
}

public class StudyGroup
{
    String name = "MATH";
    TreeSet<Person> set = new TreeSet<Person>();
    public void add(Person p) {
      if(name.equals(p.getInterest())) set.add(p);
    }

    public static void main(String[] args) {
      StudyGroup mathGroup = new StudyGroup();
      mathGroup.add(new Person("MATH"));
      System.out.println("A");
      mathGroup.add(new Person("MATH"));
      System.out.println("B");
      System.out.println(mathGroup.set);
    }
}
```  

- [ ] It will print : A, B, and then the contents of mathGroup.set.  
- [ ] It will compile with a warning.  
- [ ] It will NOT throw an exception at runtime.  
- [x] It will compile without warning but will throw an exception at runtime.  
- [ ] It will only print : A  
- [ ] It will print : A and B.  

**Explanation**  
Note that `TreeSet` is an ordered set that keeps its elements in a sorted fashion. When you call the `add()` method, it immediately compares the element to be added to the existing elements and puts the new element in its appropriate place. Thus, the foremost requirement of a `TreeSet` is that the elements must either implement `Comparable` interface (which has the `compareTo(Object) method)` and they must also be mutually comparable or the `TreeSet` must be created with by passing a `Comparator` (which has a `compare(Object, Object)` method). For example, you might have two classes \\\\\A\\\\\ and \\\\\B\\\\\ both implementing `Comparable` interface. But if their `compareTo()` method does not work with both the types, you cannot add both type of elements in the same `TreeSet`.  

In this question, `Person` class does not implement `Comparable` interface. Ideally, when you add the first element, since there is nothing to compare this element to, there should be no exception. But when you add the second element, `TreeSet` tries to compare it with the existing element, thereby throwing `ClassCastException` because they don't implement `Comparable` interface. However, this behavior was changed in the `TreeSet` implementation recently and it throws a `ClassCastException` when you add the first element itself.  

The compiler knows nothing about this requirement of `TreeSet` since it is an application level requirement and not a language level requirement. So the program compiles fine without any warning.  

---

**70.**
java.util.Locale allows you to do which of the following?  
**You had to select 2 options**  

- [ ] Provide country specific formatting for fonts.  
- [ ] Provide country and language specific for HTML pages.  
- [x] Provide country and language specific formatting for Dates.  
- [x] Provide country specific formatting for Currencies.  
- [ ] Provide country and language specific formatting for properties files.  
  > The objective of Localization is not to format properties files but to format the data that is displayed to the user in country/language specific manner. Resource Bundles, which are nothing but appropriately named properties files, are used along with the `Locale` (i.e. country and language) information to format `Date`, `Currencies`, and text messages in Locale specific manner.  

---

**73.**
Identify valid statements.  

- [ ] Locale myLocal = System.getDefaultLocale();  
  > There is no such method in System class.  
- [ ] Locale myLocale = Locale.getDefaultLocale();  
- [x] Locale myLocale = Locale.getDefault();  
- [x] Locale myLocale = Locale.US;  
  > Locale class has several static constants for standard country locales.  
- [ ] Locale myLocale = Locale.getInstance();  
  > There is no getInstance() method in Locale.  
- [x] Locale myLocale = new Locale("ru", "RU");  
  > You don't have to worry about the actual values of the language and country codes. Just remember that both are two lettered codes and country codes are always upper case.  

---

**74.**
Consider the following classes:  

```java
class Boo {
    public Boo(){ System.out.println("In Boo"); }
}
class BooBoo extends Boo {
    public BooBoo(){ System.out.println("In BooBoo"); }
}

class Moo extends BooBoo implements Serializable {
    int moo = 10; { System.out.println("moo set to 10"); }
    public Moo(){ System.out.println("In Moo"); }
}
```

First, the following code was executed and the file moo1.ser was created successfully:  

```java
  Moo moo = new Moo();
  moo.moo = 20;
  FileOutputStream fos = new FileOutputStream("c:\\temp\\moo1.ser");
  ObjectOutputStream os = new ObjectOutputStream(fos);
  os.writeObject(moo);
  os.close();
```  

Next, the following code was executed.  

```java
  FileInputStream fis = new FileInputStream("c:\\temp\\moo1.ser");
  ObjectInputStream is = new ObjectInputStream(fis);
  Moo moo = (Moo) is.readObject();
  is.close();
  System.out.println(moo.moo);
```

Which of the following will be a part of the output of the second piece of code?  

- [x] In Boo  
- [x] In BooBoo  
- [ ] In Moo  
- [ ] 10  
- [x] 20  
- [ ] moo set to 10  

**Explanation**  
During deserialization, the constructor of the class (or any static or instance blocks) is not executed. However, if the super class does not implement Serializable, its constructor is called. So here, `BooBoo` and `Boo` are not Serializable. So, their constructor is invoked.  

---

**75.**
What will the following code print when compiled and run?  

```java
import java.util.*;

interface Birdie {
    void fly();
}

class Dino implements Birdie {
    public void fly(){ System.out.println("Dino flies"); }
    public void eat(){ System.out.println("Dino eats");}
}

class Bino extends Dino {
    public void fly(){ System.out.println("Bino flies"); }
    public void eat(){ System.out.println("Bino eats");}
}

public class TestClass {
    public static void main(String[] args)    {
       List<Birdie> m = new ArrayList<>();
       m.add(new Dino());
       m.add(new Bino());
       for(Birdie b : m) {
    b.fly();
    b.eat();
       }
    }
}
```

- [ ] option 1

```java
Dino flies
Dino eats
Bino flies
Bino eats
```

- [ ] option 2

```java
Bino flies
Bino eats
```

- [ ] option 3

```java
Dino flies
Bino eats
```

- [x] The code will not compile.  
  > Note that in the for loop b has been declared to be of type Birdie. But Birdie doesn't define the method eat(), so the compiler will not allow b.eat() even though the actual class of the object referred to by b does have an eat() method.  

- [ ] Exception at run time.  

---

**76.**
Consider the following program:  

```java
import java.io.FileReader;
import java.io.FileWriter;

public class ClosingTest {
    public static void main(String[] args) throws Exception {
        try(FileReader fr = new FileReader("c:\\temp\\license.txt");
            FileWriter fw = new FileWriter("c:\\temp\\license2.txt") )
        {
            int x = -1;
            while( (x = fr.read()) != -1){
                fw.write(x);
            }
        }
    }
}
```

Identify the correct statements.  

- [ ] The FileWriter object will always be closed before the FileReader object.  
  > Resources are closed automatically at the end of the try block in reverse order of their creation.  
- [ ] The order of the closure of the FileWriter and FileReader objects is platform dependent and should not be relied upon.  
  > The order is defined. They are always closed in the reverse order.  
- [ ] The FileWriter object will not be closed if an exception is thrown while closing the FileReader object.  
  > The close method is called on all the resources one by one even if any resource throws an exception in its close method.  
- [ ] This is not a fail safe approach to managing resources because in certain situations one or both of the resources may be left open after the end of the try block.  
  > This is the right approach. The close method will be called automatically on all the resources that were opened even if any exception is thrown any where.  

---

**77.**
Given:  

```java
class Book{
    private String title;
    private double price;
    public Book(String title, double price){
        this.title = title;
        this.price = price;
    }
    //getters/setters not shown
}
```

What will the following code print?  

```java
List<Book> books = Arrays.asList(new Book("Thinking in Java", 30.0),
                                 new Book("Java in 24 hrs", 20.0),
                                 new Book("Java Recipies", 10.0));
double averagePrice = books.stream().filter(b->b.getPrice()>10)
        .mapToDouble(b->b.getPrice())
        .average().getAsDouble();
System.out.println(averagePrice);
```

- [ ] It will not compile.  
- [ ] It will thrown an exception at runtime.  
- [ ] 0.0  
- [x] 25.0  
- [ ] 10.0  

**Explanation**  
This is a straight forward code that chains three operations to a stream. First, it filters out all the element that do not satisfy the condition `b.getPrice()>10`, which means only two elements are left in the stream, second, it maps each `Book` element to a double using the mapping function `b.getPrice()`, which means, the stream now contains two doubles - *20.0* and *30.0*. Finally, the `average()` method computes the average of all the elements. Therefore, the code will print *25.0*.

This is a straight forward code that chains three operations to a stream. First, it filters out all the element that do not satisfy the condition `b.getPrice()>10`, which means only two elements are left in the stream, second, it maps each `Book` element to a double using the mapping function `b.getPrice()`, which means, the stream now contains two doubles - *20.0* and *30.0*. Finally, the `average()` method computes the average of all the elements. Therefore, the code will print *25.0*.

---

**79.**
Your group has an existing application (reports.jar) that uses a library (analytics.jar) from another group in your company. Both - the application and the library - use a JDBC driver packaged in ojdbc8.jar.  

Which of the following options describes the steps that will be required to modularize your application?  

- [x] option 1  

```none
1. Convert analytics.jar and ojdbc8.jar into automatic modules  
2. Convert reports.jar into a named module.  
3. Add requires clauses for analytics and ojdbc8 in reports.jar in its module-info.java.
```

- [ ] option 2  

```none
1. Modularize analytics.jar and ojdbc8.jar into modules by adding module-info.java to these jars. 2. Convert reports.jar into a named module. 3. Add requires clauses for all packages contained in analytics.jar and ojdbc8.jar that are directly referred to by classes in reports.jar in its module-info.java.
```

- [ ] option 3  

```none
1. Convert reports.jar into a named module. 2. Add requires clauses for analytics and ojdbc8 modules in reports.jar in its module-info.java. 3. Use analytics.jar and ojdbc8.jar as unnamed modules.
```

- [ ] option 4  

```none
1. Convert ojdbc8.jar into automatic module. 2. Convert analytics.jar into a named module by adding module-info.java to it. In this module-info, export all packages that are used by reports.jar and add requires clauses for all packages of ojdbc.jar that are used by analytics.jar. 3. Convert reports.jar into a named module. Add requires clause for analytics module in reports's module-info.java.
```

**Explanation**  
If a module directly uses classes from another jar, then that jar has to be converted into a module (either named or automatic).  

So, if you want to modularize reports.jar, then analytics.jar and ojdbc8.jar must also be converted into a module. Since these two jars are not controlled by you, they can be converted into automatic modules.  

module-info for reports.jar must have requires clauses for the two automatic modules (whose names will be analytics and ojdbc8).  

Since an automatic module is allowed to access classes from all other modules, nothing special needs to be done for analytics.jar. It will be able to access all classes from ojdbc.jar.  

---

**80.**
Which of the given options if put at //1 will correctly instantiate objects of various classes defined in the following code?  

```java
public class TestClass
{
   public class A{
   }
   public static class B {
   }
   public static void main(String args[]){
      class C{
      }
      //1
   }
}
```

- [x] new TestClass().new A();  
- [ ] new TestClass().new B();  
- [ ] new TestClass.A();  
  > A is not static. So on outer instance of TestClass is necessary.  
- [x] new C();  
- [ ] new TestClass.C();  

**Explanation**  
class A is not static inner class of `TestClass`. So it cannot exist without an outer instance of `TestClass`. So, option 1 is the right way to instantiate it. class B is static inner class and can be instantiated like this: `new TestClass.B()`. But `new TestClass().new B()` is not correct.  
Although not related to this question, unlike popular belief, anonymous class can never be static. Even if created in a static method.  

---

**81.**
Consider the following code:  

```java
Statement stmt = null;
try(Connection c = DriverManager.getConnection("jdbc:derby://localhost:1527/sample", "app", "app"))
{
    stmt = c.createStatement();
    ResultSet rs = stmt.executeQuery("select * from STUDENT");
    while(rs.next()){
        System.out.println(rs.getString(1));
    }

}
catch(SQLException e){
    System.out.println("Exception "+e);
}
```

Which objects can be successfully used to query the database after the try block ends without any exception?  

- [ ] stmt  
- [ ] c  
- [ ] rs  
- [ ] stmt as well c  
- [x] None of them.  

**Explanation**  
There are a few things to note in the question:  

1. Once a `Connection` object is closed, you cannot access any of the subsequent objects such as `Statement` and `ResultSet` that are retrieved from that `Connection`.  
2. The references declared in the try block (in this case, `c` and `ResultSet`) are not visible outside the try block. Not even in the catch block.  
3. When a resource is created in the try-with-resources block ( in this case, c), it is closed at the end of the try block irrespective of whether there is an exception in the try block or not.  

Based on the above, it is easy to see that only stmt is visible after the try block but it cannot be successfully used because the `Connection` object from which it was retrieved has already been closed.
