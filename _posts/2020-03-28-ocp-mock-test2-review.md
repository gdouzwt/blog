---
typora-root-url: ../
layout:     post
title:      OCP-1Z0-816模拟测试2回顾
date:       '2020-03-28T12:20'
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

---

**27.**

---

**28.**

---

**29.**

---

**30.**

---

**31.**

---

**33.**

---

**38.**

---

**44.**

---

**45.**

---

**46.**

---

**48.**

---

**50.**

---

**54.**

---

**55.**

---

**57.**

---

**58.**

---

**59.**

---

**60.**

---

**62.**

---

**63.**

---

**65.**

---

**66.**

---

**69.**

---

**70.**

---

**73.**

---

**74.**

---

**75.**

---

**76.**

---

**77.**

---

**79.**

---

**80.**

---

**81.**

---


