---
typora-root-url: ../
layout:     post
title:      OCA Study Guide 练习回顾
date:       '2019-10-22'
subtitle:   全部章节的错题
author:     招文桃
catalog:    true
tags:
    - Java
    - OCA
---

> 这文章讲OCA准备过程，读过的书籍。 这本书叫 OCA Oracle Certified Associate Java SE 8 Programmer I Study Guide 以下按章节整理错题：  

#### Chapter 1 Java Building Blocks (2/23😄)

**18.**Which represent the order in which the following statements can be assembled into a program that will compile successfully? (Choose all that apply)  
`A: class Rabbit {}`  
`B: import java.util.*;`  
`C: package animals;`  

> **A.** A, B, C  
> **B.** B, C, A  
> **C.** C, B, A  
> **D.** B, A  
> **E.** C, A  
> **F.** A, C  
> **G.** A, B  

**22.**Which of the following are true statements? (Choose all that apply)  

> **A.** Java allows operator overloading.  
> **B.** Java code compiled on Windows can run on Linux.  
> **C.** Java has pointers to specific locations in memory.  
> **D.** Java is a procedural language.  
> **E.** Java is an object-oriented language.  
> **F.** Java is a functional programming language.  

#### Chapter 2 Operators and Statements (3/20😊)

**9.**How many times will the following code print "Hello World"?  
```java
3: for(int i=0; i<10 ; ) {
4: i = i++;
5: System.out.println("Hello World");
6: }
```
> **A.** 9  
> **B.** 10  
> **C.** 11  
> **D.** The code will not compile because of line 3.  
> **E.** The code will not compile because of line 5.  
> **F.** The code contains an infinite loop and does not terminate.  

**16.**What is the output of the following code snippet?  
```java
3: do {
4: int y = 1;
5: System.out.print(y++ + " ");
6: } while(y <= 10);
```
> **A.** 1 2 3 4 5 6 7 8 9  
> **B.** 1 2 3 4 5 6 7 8 9 10  
> **C.** 1 2 3 4 5 6 7 8 9 10 11  
> **D.** The code will not compile because of line 6.  
> **E.** The code contains an infinite loop and does not terminate.  

**17.**What is the output of the following code snippet?  
```java
3:  boolean keepGoing = true;
4:  int result = 15, i = 10;
5:  do {
6:  i--;
7:  if(i==8) keepGoing = false;
8:  result -= 2;
9:  } while(keepGoing);
10: System.out.println(result);
```
> **A.** 7  
> **B.** 9  
> **C.** 10  
> **D.** 11  
> **E.** 15  
> **F.** The code will not compile because of line 8.  

#### Chapter 3 Core Java APIs (13/33😂)

**4.**What is the result of the following code?  
```java
7: StringBuilder sb = new StringBuilder();
8: sb.append("aaa").insert(1, "bb").insert(4, "ccc");
9: System.out.println(sb);
```
> **A.** abbaaccc  
> **B.** abbaccca  
> **C.** bbaaaccc  
> **D.** bbaaccca  
> **E.** An exception is thrown.  
> **F.** The code does not compile.  

**5.**What is the result of the following code?  

```java
2: String s1 = "java";
3: StringBuilder s2 = new StringBuilder("java");
4: if (s1 == s2)
5: System.out.print("1");
6: if (s1.equals(s2))
7: System.out.print("2");
```
> **A.** 1  
> **B.** 2  
> **C.** 12  
> **D.** No output is printed.  
> **E.** An exception is thrown.  
> **F.** The code does not compile.  

**15.**Which of these array declarations is not legal? (Choose all that apply)  
> **A.** `int[][] scores = new int[5][];`  
> **B.** `Object[][][] cubbies = new Object[3][0][5];`  
> **C.** `String beans[] = new beans[6];`  
> **D.** `java.util.Date[] dates[] = new java.util.Date[2][];`  
> **E.** `int[][] types = new int[];`  
> **F.** `int[][] java = new int[][];`  

**16.**Which of these compile when replacing line 8? (Choose all that apply)  
```java
7: char[]c = new char[2];
8: // INSERT CODE HERE
```
> **A.** `int length = c.capacity;`  
> **B.** `int length = c.capacity();`  
> **C.** `int length = c.length;`  
> **D.** `int length = c.length();`  
> **E.** `int length = c.size;`  
> **F.** `int length = c.size();`  
> **G.** None of the above.  

**17.**Which of these compile when replacing line 8? (Choose all that apply)  
```java
7: ArrayList l = new ArrayList();
8: // INSERT CODE HERE
```
> **A.** `int length = l.capacity;`  
> **B.** `int length = l.capacity();`  
> **C.** `int length = l.length;`  
> **D.** `int length = l.length();`  
> **E.** `int length = l.size;`  
> **F.** `int length = l.size();`  
> **G.** None of the above.  

**18.**Which of the following are true? (Choose all that apply)  
> **A.** An array has a fixed size.  
> **B.** An `ArrayList` has a fixed size.  
> **C.** An array allows multiple dimensions.  
> **D.** An array is ordered.  
> **E.** An `ArrayList` is ordered.  
> **F.** An array is immutable.  
> **G.** An `ArrayList` is immutable.  

**19.**Which of the following are true? (Choose all that apply)  
> **A.** Two arrays with the same content are equal.  
> **B.** Two ArrayLists with the same content are equal.  
> **C.** If you call `remove(0)` using an empty `ArrayList` object, it will compile successfully.  
> **D.** If you call `remove(0)` using an empty `ArrayList` object, it will run successfully.  
> **E.** None of the above.  

**20.**What is the result of the following statements?  
```java
6:  List<String> list = new ArrayList<String>();
7:  list.add("one");
8:  list.add("two");
9:  list.add(7);
10: for(String s : list) System.out.print(s);
```
> **A.** onetwo  
> **B.** onetwo7  
> **C.** onetwo followed by an exception  
> **D.** Compiler error on line 9.  
> **E.** Compiler error on line 10.  

**24.**What is the result of the following?  
```java
6: String [] names = {"Tom", "Dick", "Harry"};
7: List<String> list = names.asList();
8: list.set(0, "Sue");
9: System.out.println(names[0]);
```
> **A.** Sue  
> **B.** Tom  
> **C.** Compiler error on line 7.  
> **D.** Compiler error on line 8.  
> **E.** An exception is thrown.  

**25.**What is the result of the following?  
```java
List<String> hex = Arrays.asList("30", "8", "3A", "FF");
Collections.sort(hex);
int x = Collections.binarySearch(hex, "8");
int y = Collections.binarySearch(hex, "3A");
int z = Collections.binarySearch(hex, "4F");
System.out.println(x + " " + y + " " + z);
```
> **A.** 0 1 –2  
> **B.** 0 1 –3  
> **C.** 2 1 –2  
> **D.** 2 1 –3  
> **E.** None of the above.  
> **F.** The code doesn’t compile.  

**26.**Which of the following are true statements about the following code? (Choose all that apply)  
```java
4: List<Integer> ages = new ArrayList<>();
5: ages.add(Integer.parseInt("5"));
6: ages.add(Integer.valueOf("6"));
7: ages.add(7);
8: ages.add(null);
9: for (int age : ages) System.out.print(age);
```
> **A.** The code compiles.  
> **B.** The code throws a runtime exception.  
> **C.** Exactly one of the add statements uses autoboxing.  
> **D.** Exactly two of the add statements use autoboxing.  
> **E.** Exactly three of the add statements use autoboxing.  

**29.**Which of the following can be inserted into the blank to create a date of June 21, 2014? (Choose all that apply)  
```java
import java.time.*;
public class StartOfSummer {
    public static void main(String[] args) {
    LocalDate date = _________
    }
}
```
> **A.** `new LocalDate(2014, 5, 21);`  
> **B.** `new LocalDate(2014, 6, 21);`  
> **C.** `LocalDate.of(2014, 5, 21);`  
> **D.** `LocalDate.of(2014, 6, 21);`  
> **E.** `LocalDate.of(2014, Calendar.JUNE, 21);`  
> **F.** `LocalDate.of(2014, Month.JUNE, 21);`  

**30.**What is the output of the following code?  
```java
LocalDate date = LocalDate.of(2018, Month.APRIL, 40);
System.out.println(date.getYear() + " " + date.getMonth() + " "
+ date.getDayOfMonth());
```
> **A.** 2018 APRIL 4  
> **B.** 2018 APRIL 30  
> **C.** 2018 MAY 10  
> **D.** Another date.  
> **E.** The code does not compile.  
> **F.** A runtime exception is thrown.  

#### Chapter 4 Methods and Encapsulation (14/29😂)

**2.**Which of the following compile? (Choose all that apply)  
> **A.** `final static void method4() { }`  
> **B.** `public final int void method() { }`  
> **C.** `private void int method() { }`  
> **D.** `static final void method3() { }`  
> **E.** `void final method() {}`  
> **F.** `void public method() { }`  

**5.**Given the following method, which of the method calls return 2? (Choose all that apply)  
```java
public int howMany(boolean b, boolean... b2) {
return b2.length;
}
```
> **A.** `howMany();`  
> **B.** `howMany(true);`  
> **C.** `howMany(true, true);`  
> **D.** `howMany(true, true, true);`  
> **E.** `howMany(true, {true});`  
> **F.** `howMany(true, {true, true});`  
> **G.** `howMany(true, new boolean[2]);`  

**6.**Which of the following are true? (Choose all that apply)  
> **A.** Package private access is more lenient than protected access.  
> **B.** A public class that has private fields and package private methods is not visible to classes outside the package.  
> **C.** You can use access modifiers so only some of the classes in a package see a particular package private class.  
> **D.** You can use access modifiers to allow read access to all methods, but not any instance variables.  
> **E.** You can use access modifiers to restrict read access to all classes that begin with the word Test.  

**9.**Which are methods using JavaBeans naming conventions for accessors and mutators? (Choose all that apply)  
> **A.** `public boolean getCanSwim() { return canSwim;}`  
> **B.** `public boolean canSwim() { return numberWings;}`  
> **C.** `public int getNumWings() { return numberWings;}`  
> **D.** `public int numWings() { return numberWings;}`  
> **E.** `public void setCanSwim(boolean b) { canSwim = b;}`  

**11.**Which are true of the following code? (Choose all that apply)  
```java
1:  public class Rope {
2:    public static void swing() {
3:        System.out.print("swing ");
4:    }
5:    public void climb() {
6:        System.out.println("climb ");
7:    }
8:    public static void play() {
9:        swing();
10:       climb();
11:   }
12:   public static void main(String[] args) {
13:       Rope rope = new Rope();
14:       rope.play();
15:       Rope rope2 = null;
16:       rope2.play();
17:   }
18: }
```
> **A.** The code compiles as is.  
> **B.** There is exactly one compiler error in the code.  
> **C.** There are exactly two compiler errors in the code.  
> **D.** If the lines with compiler errors are removed, the output is climb climb .  
> **E.** If the lines with compiler errors are removed, the output is swing swing .  
> **F.** If the lines with compile errors are removed, the code throws a NullPointerException.  

**12.**What is the output of the following code?  
```java
import rope.*;
import static rope.Rope.*;
public class RopeSwing {
    private static Rope rope1 = new Rope();
    private static Rope rope2 = new Rope();
    {
        System.out.println(rope1.length);
    }
    public static void main(String[] args) {
        rope1.length = 2;
        rope2.length = 8;
        System.out.println(rope1.length);
    }
}
package rope;
public class Rope {
    public static int length = 0;
}
```
> **A.** 02  
> **B.** 08  
> **C.** 2  
> **D.** 8  
> **E.** The code does not compile.  
> **F.** An exception is thrown.  

**15.**What is the result of the following statements?  
```java
1:  public class Test {
2:    public void print(byte x) {
3:      System.out.print("byte");
4:    }
5:    public void print(int x) {
6:      System.out.print("int");
7:    }
8:    public void print(float x) {
9:      System.out.print("float");
10:   }
11:   public void print(Object x) {
12:     System.out.print("Object");
13:   }
14:   public static void main(String[] args) {
15:     Test t = new Test();
16:     short s = 123;
17:     t.print(s);
18:     t.print(true);
19:     t.print(6.789);
20:   }
21: }
```
> **A.** bytefloatObject  
> **B.** intfloatObject  
> **C.** byteObjectfloat  
> **D.** intObjectfloat  
> **E.** intObjectObject  
> **F.** byteObjectObject  

**17.**Which of the following are output by the following code? (Choose all that apply)  
```java
public class StringBuilders {
    public static StringBuilder work(StringBuilder a,
    StringBuilder b) {
        a = new StringBuilder("a");
        b.append("b");
        return a;
    }
    public static void main(String[] args) {
        StringBuilder s1 = new StringBuilder("s1");
        StringBuilder s2 = new StringBuilder("s2");
        StringBuilder s3 = work(s1, s2);
        System.out.println("s1 = " + s1);
        System.out.println("s2 = " + s2);
        System.out.println("s3 = " + s3);
    }
}
```
> **A.** s1 = a  
> **B.** s1 = s1  
> **C.** s2 = s2  
> **D.** s2 = s2b  
> **E.** s3 = a  
> **F.** s3 = null  
> **G.** The code does not compile.  

**18.**Which of the following are true? (Choose 2)  
> **A.** `this()` can be called from anywhere in a constructor.  
> **B.** `this()` can be called from any instance method in the class.  
> **C.** `this.variableName` can be called from any instance method in the class.  
> **D.** `this.variableName` can be called from any static method in the class.  
> **E.** You must include a default constructor in the code if the compiler does not include one.  
> **F.** You can call the default constructor written by the compiler using `this()`.  
> **G.** You can access a private constructor with the `main()` method.  

**20.**Which code can be inserted to have the code print 2?  
```java
public class BirdSeed {
    private int numberBags;
    boolean call;

    public BirdSeed() {
        // LINE 1
        call = false;
        // LINE 2
    }
    public BirdSeed(int numberBags) {
        this.numberBags = numberBags;
    }
    public static void main(String[] args) {
        BirdSeed seed = new BirdSeed();
        System.out.println(seed.numberBags);
} }
```
> **A.** Replace line 1 with `BirdSeed(2)`;  
> **B.** Replace line 2 with `BirdSeed(2)`;  
> **C.** Replace line 1 with `new BirdSeed(2)`;  
> **D.** Replace line 2 with `new BirdSeed(2)`;  
> **E.** Replace line 1 with `this(2)`;  
> **F.** Replace line 2 with `this(2)`;  

**22.**What is the result of the following?  
```java
1: public class Order {
2:   static String result = "";
3:   { result += "c"; }
4:   static
5:   { result += "u"; }
6:   { result += "r"; }
7: }

1: public class OrderDriver {
2:   public static void main(String[] args) {
3:     System.out.print(Order.result + " ");
4:     System.out.print(Order.result + " ");
5:     new Order();
6:     new Order();
7:     System.out.print(Order.result + " ");
8:   }
9: }
```
> **A.** curur  
> **B.** ucrcr  
> **C.** u ucrcr  
> **D.** u u curcur  
> **E.** u u ucrcr  
> **F.** ur ur urc  
> **G.** The code does not compile.  

**26.**What is the result of the following class?  
```java
1: import java.util.function.*;
2: 
3: public class Panda {
4:   int age;
5:   public static void main(String[] args) {
6:     Panda p1 = new Panda();
7:     p1.age = 1;
8:     check(p1, p -> p.age < 5);
9:   }
10:  private static void check(Panda panda, Predicate<Panda> pred) {
11:    String result = pred.test(panda) ? "match" : "not match";
12:    System.out.print(result);
13: } }
```
> **A.** match  
> **B.** not match  
> **C.** Compiler error on line 8.  
> **D.** Compiler error on line 10.  
> **E.** Compiler error on line 11.  
> **F.** A runtime excep  

**27.**What is the result of the following code?  
```java
1:  interface Climb {
2:    boolean isTooHigh(int height, int limit);
3:  }
4:  
5:  public class Climber {
6:    public static void main(String[] args) {
7:      check((h, l) -> h.append(l).isEmpty(), 5);
8:    }
9:    private static void check(Climb climb, int height) {
10:     if (climb.isTooHigh(height, 10))
11:       System.out.println("too high");
12:     else
13:       System.out.println("ok");
14:   }
15: }
```
> **A.** ok  
> **B.** too high  
> **C.** Compiler error on line 7.  
> **D.** Compiler error on line 10.  
> **E.** Compiler error on a different line.  
> **F.** A runtime exception is thrown.  

**29.**Which lambda can replace the MySecret class to return the same value? (Choose all that apply)  
```java
interface Secret {
  String magic(double d);
}
class MySecret implements Secret {
  public String magic(double d) {
    return "Poof";
  }
}
```
> **A.** `caller((e) -> "Poof");`  
> **B.** `caller((e) -> {"Poof"});`  
> **C.** `caller((e) -> { String e = ""; "Poof" });`  
> **D.** `caller((e) -> { String e = ""; return "Poof"; });`  
> **E.** `caller((e) -> { String e = ""; return "Poof" });`  
> **F.** `caller((e) -> { String f = ""; return "Poof"; });`  

#### Chapter 5 Class Design (12/20😭)

**1.**What modifiers are implicitly applied to all interface methods? (Choose all that apply)  
> **A.** `protected`  
> **B.** `public`  
> **C.** `static`  
> **D.** `void`  
> **E.** `abstract`  
> **F.** `default`  

**2.**What is the output of the following code?  
```java
1:  class Mammal {
2:    public Mammal(int age) {
3:      System.out.print("Mammal");
4:    }
5:  }
6:  public class Platypus extends Mammal {
7:    public Platypus() {
8:      System.out.print("Platypus");
9:    }
10:   public static void main(String[] args) {
11:     new Mammal(5);
12:   }
13: }
```
> **A.** Platypus  
> **B.** Mammal  
> **C.** PlatypusMammal  
> **D.** MammalPlatypus  
> **E.** The code will not compile because of line 7.  
> **F.** The code will not compile because of line 11.  

**3.**Which of the following statements can be inserted in the blank line so that the code will
compile successfully? (Choose all that apply)  
```java
public interface CanHop {}
public class Frog implements CanHop {
  public static void main(String[] args) {
    ____________frog = new TurtleFrog();
  }
}
public class BrazilianHornedFrog extends Frog {}
public class TurtleFrog extends Frog {}
```
> **A.** Frog  
> **B.** TurtleFrog  
> **C.** BrazilianHornedFrog  
> **D.** CanHop  
> **E.** Object  
> **F.** Long  

**4.**Which statement(s) are correct about the following code? (Choose all that apply)  
```java
public class Rodent {
  protected static Integer chew() throws Exception {
    System.out.println("Rodent is chewing");
    return 1;
  }
}
public class Beaver extends Rodent {
  public Number chew() throws RuntimeException {
    System.out.println("Beaver is chewing on wood");
    return 2;
  }
}
```
> **A.** It will compile without issue.  
> **B.** It fails to compile because the type of the exception the method throws is a subclass of the type of exception the parent method throws.  
> **C.** It fails to compile because the return types are not covariant.  
> **D.** It fails to compile because the method is protected in the parent class and public in the subclass.  
> **E.** It fails to compile because of a static modifier mismatch between the two methods.  

**5.**Which of the following may only be hidden and not overridden? (Choose all that apply)  
> **A.** private instance methods  
> **B.** protected instance methods  
> **C.** public instance methods  
> **D.** static methods  
> **E.** public variables  
> **F.** private variables  

**8.**Choose the correct statement about the following code:  
```java
1: public interface Herbivore {
2:   int amount = 10;
3:   public static void eatGrass();
4:   public int chew() {
5:     return 13;
6:   }
7: }
```
> **A.** It compiles and runs without issue.  
> **B.** The code will not compile because of line 2.  
> **C.** The code will not compile because of line 3.  
> **D.** The code will not compile because of line 4.  
> **E.** The code will not compile because of lines 2 and 3.  
> **F.** The code will not compile because of lines 3 and 4.  

**10.**Which statements are true for both abstract classes and interfaces? (Choose all that apply)  
> **A.** All methods within them are assumed to be `abstract`.  
> **B.** Both can contain `public static final` variables.  
> **C.** Both can be extended using the `extends` keyword.  
> **D.** Both can contain default methods.  
> **E.** Both can contain `static` methods.  
> **F.** Neither can be instantiated directly.  
> **G.** Both inherit `java.lang.Object`.  

**11.**What modifiers are assumed for all interface variables? (Choose all that apply)  
> **A.** `public`  
> **B.** `protected`  
> **C.** `private`  
> **D.** `static`  
> **E.** `final`  
> **F.** `abstract`  

**16.**What is the output of the following code?  
```java
1:  abstract class Reptile {
2:    public final void layEggs() { System.out.println("Reptile laying eggs"); }
3:    public static void main(String[] args) {
4:      Reptile reptile = new Lizard();
5:      reptile.layEggs();
6:    }
7:  }
8:  public class Lizard extends Reptile {
9:    public void layEggs() { System.out.println("Lizard laying eggs"); }
10: }
```
> **A.** Reptile laying eggs  
> **B.** Lizard laying eggs  
> **C.** The code will not compile because of line 4.  
> **D.** The code will not compile because of line 5.  
> **E.** The code will not compile because of line 9.  

**18.**What is the output of the following code? (Choose all that apply)  
```java
1:  interface Aquatic {
2:    public default int getNumberOfGills(int input) { return 2; }
3:  }
4:  public class ClownFish implements Aquatic {
5:    public String getNumberOfGills() { return "4"; }
6:    public String getNumberOfGills(int input) { return "6"; }
7:    public static void main(String[] args) {
8:      System.out.println(new ClownFish().getNumberOfGills(-1));
9:    }
10: }
```
> **A.** 2  
> **B.** 4  
> **C.** 6  
> **D.** The code will not compile because of line 5.  
> **E.** The code will not compile because of line 6.  
> **F.** The code will not compile because of line 8.  

**19.**Which of the following statements can be inserted in the blank so that the code will compile successfully? (Choose all that apply)  
```java
public class Snake {}
public class Cobra extends Snake {}
public class GardenSnake {}
public class SnakeHandler {
  private Snake snake;
  public void setSnake(Snake snake) { this.snake = snake; }
  public static void main(String[] args) {
    new SnakeHandler().setSnake(__________);
  }
}
```
> **A.** `new Cobra()`  
> **B.** `new GardenSnake()`  
> **C.** `new Snake()`  
> **D.** `new Object()`  
> **E.** `new String("Snake")`  
> **F.** `null`  

**20.**What is the result of the following code?  
```java
1:  public abstract class Bird {
2:    private void fly() { System.out.println("Bird is flying"); }
3:    public static void main(String[] args) {
4:      Bird bird = new Pelican();
5:      bird.fly();
6:    }
7:  }
8:  class Pelican extends Bird {
9:    protected void fly() { System.out.println("Pelican is flying"); }
10: }
```
> **A.** Bird is flying  
> **B.** Pelican is flying  
> **C.** The code will not compile because of line 4.  
> **D.** The code will not compile because of line 5.  
> **E.** The code will not compile because of line 9.  

#### Chapter 6 Exceptions (12/20😭)

**1.**Which of the following statements are true? (Choose all that apply)  
> **A.** Runtime exceptions are the same thing as checked exceptions.  
> **B.** Runtime exceptions are the same thing as unchecked exceptions.  
> **C.** You can declare only checked exceptions.  
> **D.** You can declare only unchecked exceptions.  
> **E.** You can handle only Exception subclasses.  

**2.**Which of the following pairs fill in the blanks to make this code compile? (Choose all that apply)  
```java
7: public void ohNo() _____ Exception {
8: _____________ Exception();
9: }
```
> **A.** On line 7, fill in `throw`  
> **B.** On line 7, fill in `throws`  
> **C.** On line 8, fill in `throw`  
> **D.** On line 8, fill in `throw new`  
> **E.** On line 8, fill in `throws`  
> **F.** On line 8, fill in `throws new`  

**5.**Which of the following exceptions are thrown by the JVM? (Choose all that apply)  
> **A.** `ArrayIndexOutOfBoundsException`  
> **B.** `ExceptionInInitializerError`  
> **C.** `java.io.IOException`  
> **D.** `NullPointerException`  
> **E.** `NumberFormatException`  

**7.**What is printed besides the stack trace caused by the NullPointerException from line 16?  
```java
1:  public class DoSomething {
2:    public void go() {
3:      System.out.print("A");
4:      try {
5:        stop();
6:      } catch (ArithmeticException e) {
7:        System.out.print("B");
8:      } finally {
9:        System.out.print("C");
10:     }
11:     System.out.print("D");
12:   }
13:   public void stop() {
14:     System.out.print("E");
15:     Object x = null;
16:     x.toString();
17:     System.out.print("F");
18:   }
19:   public static void main(String[] args) {
20:     new DoSomething().go();
21:   }
22: }
```
> **A.** AE  
> **B.** AEBCD  
> **C.** AEC  
> **D.** AECD  
> **E.** No output appears other than the stack trace.  

**13.**Which of the following statements are true? (Choose all that apply)  
> **A.** You can declare a method with `Exception` as the return type.  
> **B.** You can declare any subclass of `Error` in the throws part of a method declaration.  
> **C.** You can declare any subclass of `Exception` in the throws part of a method declaration.  
> **D.** You can declare any subclass of `Object` in the throws part of a method declaration.  
> **E.** You can declare any subclass of `RuntimeException` in the throws part of a method declaration.  

**14.**Which of the following can be inserted on line 8 to make this code compile? (Choose all that apply)  
```java
7: public void ohNo() throws IOException {
8:   // INSERT CODE HERE
9: }
```
> **A.** `System.out.println("it's ok");`  
> **B.** `throw new Exception();`  
> **C.** `throw new IllegalArgumentException();`  
> **D.** `throw new java.io.IOException();`  
> **E.** `throw new RuntimeException();`  

**15.**Which of the following are unchecked exceptions? (Choose all that apply)  
> **A.** `ArrayIndexOutOfBoundsException`  
> **B.** `IllegalArgumentException`  
> **C.** `IOException`  
> **D.** `NumberFormatException`  
> **E.** `Any exception that extends RuntimeException`  
> **F.** `Any exception that extends Exception`  

**16.**Which scenario is the best use of an exception?  
> **A.** An element is not found when searching a list.  
> **B.** An unexpected parameter is passed into a method.  
> **C.** The computer caught fire.  
> **D.** You want to loop through a list.  
> **E.** You don’t know how to code a method.  

**17.**Which of the following can be inserted into Lion to make this code compile? (Choose all that apply)  
```java
class HasSoreThroatException extends Exception {}
class TiredException extends RuntimeException {}
interface Roar {
  void roar() throws HasSoreThroatException;
}
class Lion implements Roar {// INSERT CODE HERE
}
```
> **A.** `public void roar(){}`  
> **B.** `public void roar() throws Exception{}`  
> **C.** `public void roar() throws HasSoreThroatException{}`  
> **D.** `public void roar() throws IllegalArgumentException{}`  
> **E.** `public void roar() throws TiredException{}`  

**18.**Which of the following are true? (Choose all that apply)  
> **A.** Checked exceptions are allowed to be handled or declared.  
> **B.** Checked exceptions are required to be handled or declared.  
> **C.** Errors are allowed to be handled or declared.  
> **D.** Errors are required to be handled or declared.  
> **E.** Runtime exceptions are allowed to be handled or declared.  
> **F.** Runtime exceptions are required to be handled or declared.  

**19.**Which of the following can be inserted in the blank to make the code compile? (Choose all that apply)  
```java
public static void main(String[] args) {
  try {
    System.out.println("work real hard");
  } catch ( ______ e) {
  } catch (RuntimeException e) {
  }
}
```
> **A.** `Exception`  
> **B.** `IOException`  
> **C.** `IllegalArgumentException`  
> **D.** `RuntimeException`  
> **E.** `StackOverflowError`  
> **F.** None of the above.  

**20.**What does the output of the following contain? (Choose all that apply)  
```java
12: public static void main(String[] args) {
13:   System.out.print("a");
14:   try {
15:     System.out.print("b");
16:     throw new IllegalArgumentException();
17:   } catch (IllegalArgumentException e) {
18:     System.out.print("c");
19:     throw new RuntimeException("1");
20:   } catch (RuntimeException e) {
21:     System.out.print("d");
22:     throw new RuntimeException("2");
23:   } finally {
24:     System.out.print("e");
25:     throw new RuntimeException("3");
26:   }
27: }
```
> **A.** abce  
> **B.** abde  
> **C.** An exception with the message set to "1"  
> **D.** An exception with the message set to "2"  
> **E.** An exception with the message set to "3"  
> **F.** Nothing, the code does not compile.  
