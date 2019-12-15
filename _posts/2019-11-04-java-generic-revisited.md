---
typora-root-url: ../
layout:     post
title:      Java 泛型回顾
date:       '2019-11-04T23:40'
subtitle:   深入理解泛型
author:     招文桃
catalog:    true
tags:
    - Java
    - Generics
---

# Generics

JDK 1.5 版本开始引入，加强了**类型安全（Type safety）**，强化了语言本身，更加强化了集合框架（Collections Framework）。Java 8 开始加入 Lambda、Stream 更加进一步增强了语言的表达能力。

### 什么是泛型？

泛型（Generics）意思是参数化类型（Parameterized types）。泛型允许在创建类、接口和方法的时候，以提供参数的形式指定其能操作的数据类型。它的对象是类、接口、方法。这三者都可以泛型化。

在没有泛型特性之前，可以通过 Object 类实现泛型编程，但是不能保证类型安全。<!--more-->

### 简单的泛型例子

```java
// 一个简单的泛型例子
// T 是类型参数
// 在创建Gen对象的时候 T 会被实际类型代替。
class Gen<T> { 
  T ob; // 声明一个类型为 T 的对象
   
  // 给构造器传递一个对类型为 T 的引用  
  Gen(T o) { 
    ob = o; 
  } 
 
  // 返回 ob
  T getob() { 
    return ob; 
  } 
 
  // 显示 T 的类型 
  void showType() { 
    System.out.println("Type of T is " + 
                       ob.getClass().getName()); 
  } 
} 
```

演示操作泛型

```java
// 演示使用泛型
class GenDemo { 
  public static void main(String args[]) { 
    // 创建一个实际类型为 Integer 的 Gen 引用
    Gen<Integer> iOb;  
 
    // 创建一个 Gen<Integer> 对象并将其引用赋值给 iOb
    // 注意 88 自动装箱成一个 Integer 对象。
    iOb = new Gen<Integer>(88); 
 
    // 显示 iOb 的数据类型
    iOb.showType(); 
 
    // 获取 iOb 的值。
    // 注意不需要类型转换。
    int v = iOb.getob(); 
    System.out.println("value: " + v); 
 
    System.out.println(); 
 
    // 创建一个实际类型为 String 的 Gen 对象
    Gen<String> strOb = new Gen<String>("Generics Test"); 
 
    // 显示 strOb 使用的数据类型
    strOb.showType(); 
 
    // 获取 strOb 的值。
    // 注意不需要类型转换。
    String str = strOb.getob(); 
    System.out.println("value: " + str); 
  } 
}
```

#### 泛型只适用于引用类型

泛型不能用于基本数据类型 ，只能用于引用类型，因此以下声明是错误的：

`Gen<int> intOb = new Gen<int>(53);  // 错误，不能使用基本数据类型。`

可以使用基本数据类型对应的封装类型，如 `Integer`。

#### 泛型因类型参数不同而异

不同类型参数的同一个泛型是不兼容的类型，例如，就上面展示的代码而言，以下这行代码是错误的，不能通过编译：

`iOb = strOb;   // 错误，不能编译，类型不兼容。`

虽然 `iOb` 和 `strOb` 都是 `Gen<T>` 类型，但两者的实际引用类型因为它们的类型参数不同而不同。`iOb` 实际引用的类型为 `Integer` ，`strOb` 实际引用的类型为 `String`。所以泛型增加了类型安全，防止错误。

#### 泛型如何增强类型安全

泛型为什么能增强类型安全？上面的代码实际上不使用泛型也可以实现同样的效果，只需要将引用类型声明为 `Object` 类型，并添加相应的类型转换操作即可。那么使用泛型究竟有什么好处？答案是泛型机制会自动保证与 `Gen` 相关的所有操作都是类型安全的，无需手动进行类型转换和类型检查。可以看以下没有使用泛型的，实现了同样功能的代码：

```java
// NonGen 功能上等价于 Gen 
// 但是没有使用泛型 
class NonGen {  
  Object ob; // ob 现在是 Object 类型
    
  //  给构造器传递一个对类型为 Object 的引用   
  NonGen(Object o) {  
    ob = o;  
  }  
  
  // 返回类型为 Object
  Object getob() {  
    return ob;  
  }  
 
  // 显示 ob 的类型
  void showType() {  
    System.out.println("Type of ob is " +  
                       ob.getClass().getName());  
  }  
}  
```

演示没用使用泛型的情况：

```java
// 演示没有使用泛型的情况
class NonGenDemo {  
  public static void main(String args[]) {  
    NonGen iOb;   
  
    // 创建一个 NonGen 对象引用并存放一个 Integer 对象
    // 自动装箱
    iOb = new NonGen(88);  
  
    // 显示 iOb 的数据类型
    iOb.showType(); 
 
    // 获取 iOb 的值
    // 这次类型转换是必要的。
    int v = (Integer) iOb.getob();  
    System.out.println("value: " + v);  
  
    System.out.println();  
  
    // 创建另一个 NonGen 引用并存放一个 String 对象
    NonGen strOb = new NonGen("Non-Generics Test");  
  
    // 显示 strOb 的数据类型
    strOb.showType(); 
 
    // 获取 strOb 的值
    // 再次注意到，类型转换是必要的。
    String str = (String) strOb.getob();  
    System.out.println("value: " + str);  
 
    // 可以通过编译，但是概念上来说是错误的！
    iOb = strOb; 
    v = (Integer) iOb.getob(); // 运行时错误！ 
  }  
}
```

不使用泛型的情况，Java 编译器无法知道 `NonGen` 引用的实际类型，这是很糟糕的，因为：

1. 必须要显示地进行类型转换才能获取到存储的数据。
2. 很多类型不兼容的错误只能在运行时才能被发现。

总的来说，通过使用泛型，运行时错误被转化成了编译时错误。

### 含两个参数的泛型

```java
// A simple generic class with two type 
// parameters: T and V. 
class TwoGen<T, V> { 
  T ob1; 
  V ob2; 
   
  // Pass the constructor a reference to  
  // an object of type T. 
  TwoGen(T o1, V o2) { 
    ob1 = o1; 
    ob2 = o2; 
  } 
 
  // Show types of T and V. 
  void showTypes() { 
    System.out.println("Type of T is " + 
                       ob1.getClass().getName()); 
 
    System.out.println("Type of V is " + 
                       ob2.getClass().getName()); 
  } 
 
  T getob1() { 
    return ob1; 
  } 
 
  V getob2() { 
    return ob2; 
  } 
}
```

演示两个类型参数的泛型

```java
// Demonstrate TwoGen. 
class SimpGen { 
  public static void main(String args[]) { 
 
    TwoGen<Integer, String> tgObj = 
      new TwoGen<Integer, String>(88, "Generics"); 
 
    // Show the types. 
    tgObj.showTypes(); 
 
    // Obtain and show values. 
    int v = tgObj.getob1(); 
    System.out.println("value: " + v); 
 
    String str = tgObj.getob2(); 
    System.out.println("value: " + str); 
  } 
}
```

### 泛型类的一般形式

`class class-name<type-param-list>{ //...}`

`class-name<type-arg-list> var-name = new class-name<type-arg-list>(cons-arg-list)`

### 范围受限类型

```java
// Stats attempts (unsuccessfully) to  
// create a generic class that can compute 
// the average of an array of numbers of 
// any given type. 
// 
// The class contains an error! 
class Stats<T> {  
  T[] nums; // nums is an array of type T 
    
  // Pass the constructor a reference to   
  // an array of type T. 
  Stats(T[] o) {  
    nums = o;  
  }  
  
  // Return type double in all cases. 
  double average() {  
    double sum = 0.0; 
 
    for(int i=0; i < nums.length; i++)  
      sum += nums[i].doubleValue(); // Error!!! 
 
    return sum / nums.length; 
  }  
}
```

numeric types 才有 doubleValue() 方法。解决上面的问题，可以使用 bounded types，范围受限的类型。语法： `<T extends superclass>` 

修改为：

```java
// In this version of Stats, the type argument for 
// T must be either Number, or a class derived 
// from Number. 
class Stats<T extends Number> {  
  T[] nums; // array of Number or subclass 
    
  // Pass the constructor a reference to   
  // an array of type Number or subclass. 
  Stats(T[] o) {  
    nums = o;  
  }  
  
  // Return type double in all cases. 
  double average() {  
    double sum = 0.0; 
 
    for(int i=0; i < nums.length; i++)  
      sum += nums[i].doubleValue(); 
 
    return sum / nums.length; 
  }  
}  
```

演示使用受限类型：

```java
// Demonstrate Stats.  
class BoundsDemo {  
  public static void main(String args[]) {  
 
    Integer inums[] = { 1, 2, 3, 4, 5 }; 
    Stats<Integer> iob = new Stats<Integer>(inums);   
    double v = iob.average(); 
    System.out.println("iob average is " + v); 
 
    Double dnums[] = { 1.1, 2.2, 3.3, 4.4, 5.5 }; 
    Stats<Double> dob = new Stats<Double>(dnums);   
    double w = dob.average(); 
    System.out.println("dob average is " + w); 
 
    // This won't compile because String is not a 
    // subclass of Number. 
//    String strs[] = { "1", "2", "3", "4", "5" }; 
//    Stats<String> strob = new Stats<String>(strs);   
  
//    double x = strob.average(); 
//    System.out.println("strob average is " + v); 
 
  }  
}
```

涉及到类或接口，或多个接口的时候，使用 & 操作符将它们连接起来，例如：

`class Gen<T extends MyClass & MyInterface> { //... }`

### 使用通配符参数

```java
// Use a wildcard.  
class Stats<T extends Number> {   
  T[] nums; // array of Number or subclass  
     
  // Pass the constructor a reference to    
  // an array of type Number or subclass.  
  Stats(T[] o) {   
    nums = o;   
  }   
   
  // Return type double in all cases.  
  double average() {   
    double sum = 0.0;  
  
    for(int i=0; i < nums.length; i++)   
      sum += nums[i].doubleValue();  
  
    return sum / nums.length;  
  } 
 
  // Determine if two averages are the same. 
  // Notice the use of the wildcard. 
  boolean sameAvg(Stats<?> ob) { 
    if(average() == ob.average())  
      return true; 
 
    return false; 
  } 
}
```

演示使用通配符

```java
// Demonstrate wildcard. 
class WildcardDemo {   
  public static void main(String args[]) {   
    Integer inums[] = { 1, 2, 3, 4, 5 };  
    Stats<Integer> iob = new Stats<Integer>(inums);    
    double v = iob.average();  
    System.out.println("iob average is " + v);  
  
    Double dnums[] = { 1.1, 2.2, 3.3, 4.4, 5.5 };  
    Stats<Double> dob = new Stats<Double>(dnums);    
    double w = dob.average();  
    System.out.println("dob average is " + w);  
  
    Float fnums[] = { 1.0F, 2.0F, 3.0F, 4.0F, 5.0F };  
    Stats<Float> fob = new Stats<Float>(fnums);    
    double x = fob.average();  
    System.out.println("fob average is " + x);  
  
    // See which arrays have same average. 
    System.out.print("Averages of iob and dob "); 
    if(iob.sameAvg(dob)) 
      System.out.println("are the same.");  
    else 
      System.out.println("differ.");  
 
    System.out.print("Averages of iob and fob "); 
    if(iob.sameAvg(fob)) 
      System.out.println("are the same.");  
    else 
      System.out.println("differ.");  
  }   
}
```

#### 范围受限通配符

```java
// Bounded Wildcard arguments. 
 
// Two-dimensional coordinates. 
class TwoD { 
  int x, y; 
 
  TwoD(int a, int b) { 
    x = a; 
    y = b; 
  } 
} 
 
// Three-dimensional coordinates. 
class ThreeD extends TwoD { 
  int z; 
   
  ThreeD(int a, int b, int c) { 
    super(a, b); 
    z = c; 
  } 
} 
 
// Four-dimensional coordinates. 
class FourD extends ThreeD { 
  int t; 
 
  FourD(int a, int b, int c, int d) { 
    super(a, b, c); 
    t = d;  
  } 
} 
 
// This class holds an array of coordinate objects. 
class Coords<T extends TwoD> { 
  T[] coords; 
 
  Coords(T[] o) { coords = o; } 
} 
```

演示范围受限通配符

```java
// Demonstrate a bounded wildcard. 
class BoundedWildcard { 
  static void showXY(Coords<?> c) { 
    System.out.println("X Y Coordinates:"); 
    for(int i=0; i < c.coords.length; i++) 
      System.out.println(c.coords[i].x + " " + 
                         c.coords[i].y); 
    System.out.println(); 
  } 
 
  static void showXYZ(Coords<? extends ThreeD> c) { 
    System.out.println("X Y Z Coordinates:"); 
    for(int i=0; i < c.coords.length; i++) 
      System.out.println(c.coords[i].x + " " + 
                         c.coords[i].y + " " + 
                         c.coords[i].z); 
    System.out.println(); 
  } 
 
  static void showAll(Coords<? extends FourD> c) { 
    System.out.println("X Y Z T Coordinates:"); 
    for(int i=0; i < c.coords.length; i++) 
      System.out.println(c.coords[i].x + " " + 
                         c.coords[i].y + " " + 
                         c.coords[i].z + " " + 
                         c.coords[i].t); 
    System.out.println(); 
  } 
 
  public static void main(String args[]) { 
    TwoD td[] = { 
      new TwoD(0, 0), 
      new TwoD(7, 9), 
      new TwoD(18, 4), 
      new TwoD(-1, -23) 
    }; 
 
    Coords<TwoD> tdlocs = new Coords<TwoD>(td);     
 
    System.out.println("Contents of tdlocs."); 
    showXY(tdlocs); // OK, is a TwoD 
//  showXYZ(tdlocs); // Error, not a ThreeD 
//  showAll(tdlocs); // Error, not a FourD 
 
    // Now, create some FourD objects. 
    FourD fd[] = { 
      new FourD(1, 2, 3, 4), 
      new FourD(6, 8, 14, 8), 
      new FourD(22, 9, 4, 9), 
      new FourD(3, -2, -23, 17) 
    }; 
 
    Coords<FourD> fdlocs = new Coords<FourD>(fd);     
 
    System.out.println("Contents of fdlocs."); 
    // These are all OK. 
    showXY(fdlocs);  
    showXYZ(fdlocs); 
    showAll(fdlocs); 
  } 
}
```

创建上限使用以下语法：`<? extends superclass>` ，创建下限使用这样的语法：`<? super subclass>`

### 创建泛型方法

创建一个简单的泛型方法：

```java
// Demonstrate a simple generic method. 
class GenMethDemo {  
 
  // Determine if an object is in an array. 
  static <T extends Comparable<T>, V extends T> boolean isIn(T x, V[] y) { 
 
    for(int i=0; i < y.length; i++) 
      if(x.equals(y[i])) return true; 
 
    return false; 
  } 
 
  public static void main(String args[]) {  
 
    // Use isIn() on Integers. 
    Integer nums[] = { 1, 2, 3, 4, 5 }; 
 
    if(isIn(2, nums)) 
      System.out.println("2 is in nums"); 
 
    if(!isIn(7, nums)) 
      System.out.println("7 is not in nums"); 
 
    System.out.println(); 
 
    // Use isIn() on Strings. 
    String strs[] = { "one", "two", "three", 
                      "four", "five" }; 
 
    if(isIn("two", strs)) 
      System.out.println("two is in strs"); 
 
    if(!isIn("seven", strs)) 
      System.out.println("seven is not in strs"); 
 
    // Opps! Won't compile! Types must be compatible. 
//    if(isIn("two", nums)) 
//      System.out.println("two is in strs"); 
  }  
}
```

泛型方法的类型参数声明放在返回值类型的前面。泛型方法可以是静态的也可以是非静态的。方法可以类型推断，但是仍然可以显式地指明类型参数。

泛型方法的一般形式为： `<type-param-list> ret-type meth-name(param-list) { //... }`， type-param-list 为逗号分隔的类型参数。

#### 泛型构造器

构造器可以是泛型，即使它的类不是泛型也可以。例如：

```java
// Use a generic constructor. 
class GenCons { 
  private double val; 
 
  <T extends Number> GenCons(T arg) { 
    val = arg.doubleValue(); 
  } 
 
  void showval() { 
    System.out.println("val: " + val); 
  } 
} 
 
class GenConsDemo { 
  public static void main(String args[]) { 
 
    GenCons test = new GenCons(100); 
    GenCons test2 = new GenCons(123.5F); 
 
    test.showval(); 
    test2.showval(); 
  } 
}
```

### 泛型接口

泛型接口的例子：

```java
// A generic interface example. 
 
// A Min/Max interface. 
interface MinMax<T extends Comparable<T>> { 
  T min(); 
  T max(); 
} 
```

实现泛型接口：

```java
// Now, implement MinMax 
class MyClass<T extends Comparable<T>> implements MinMax<T> { 
  T[] vals; 
 
  MyClass(T[] o) { vals = o; } 
 
  // Return the minimum value in vals. 
  public T min() { 
    T v = vals[0]; 
 
    for(int i=1; i < vals.length; i++) 
      if(vals[i].compareTo(v) < 0) v = vals[i]; 
 
    return v; 
  } 
 
  // Return the maximum value in vals. 
  public T max() { 
    T v = vals[0]; 
 
    for(int i=1; i < vals.length; i++) 
      if(vals[i].compareTo(v) > 0) v = vals[i]; 
 
    return v; 
  } 
}
```

演示使用泛型接口：

```java
class GenIFDemo { 
  public static void main(String args[]) { 
    Integer inums[] = {3, 6, 2, 8, 6 }; 
    Character chs[] = {'b', 'r', 'p', 'w' }; 
 
    MyClass<Integer> iob = new MyClass<Integer>(inums); 
    MyClass<Character> cob = new MyClass<Character>(chs); 
 
    System.out.println("Max value in inums: " + iob.max()); 
    System.out.println("Min value in inums: " + iob.min()); 
 
    System.out.println("Max value in chs: " + cob.max()); 
    System.out.println("Min value in chs: " + cob.min()); 
  } 
}
```

泛型接口的一般形式：

`interface interface-name<type-param-list> { //... }`

实现一个泛型接口的情况：

`class class-name<type-param-list> implements interface-name<type-arg-list> { //... }` 

### 原始类型和老代码

演示原始类型（raw type）

```java
// Demonstrate a raw type. 
class Gen<T> {  
  T ob; // declare an object of type T  
    
  // Pass the constructor a reference to   
  // an object of type T.  
  Gen(T o) {  
    ob = o;  
  }  
  
  // Return ob.  
  T getob() {  
    return ob;  
  }  
}
```

演示使用原始类型：

```java
// Demonstrate raw type. 
class RawDemo {  
  public static void main(String args[]) {  
 
    // Create a Gen object for Integers. 
    Gen<Integer> iOb = new Gen<Integer>(88);  
   
    // Create a Gen object for Strings. 
    Gen<String> strOb = new Gen<String>("Generics Test");  
  
    // Create a raw-type Gen object and give it 
    // a Double value. 
    Gen raw = new Gen(new Double(98.6)); 
 
    // Cast here is necessary because type is unknown. 
    double d = (Double) raw.getob(); 
    System.out.println("value: " + d); 
 
    // The use of a raw type can lead to run-time. 
    // exceptions.  Here are some examples. 
 
    // The following cast causes a run-time error! 
//    int i = (Integer) raw.getob(); // run-time error 
 
    // This assigment overrides type safety. 
    strOb = raw; // OK, but potentially wrong 
//    String str = strOb.getob(); // run-time error  
     
    // This assingment also overrides type safety. 
    raw = iOb; // OK, but potentially wrong 
//    d = (Double) raw.getob(); // run-time error 
  }  
}
```

原始类型不是类型安全的，因为绕过了泛型提供的类型安全机制。会提示 *unchecked warning*

### 泛型类体系结构

泛型与非泛型的继承体系结构之间的区别在于，在泛型继承体系里面，任何类型参数都需要向上传递到超类。这跟构造器参数在继承体系结构中必须向上传递的情况类似。

#### 使用泛型超类

一个简单的泛型继承体系结构

```java
// A simple generic class hierarchy. 
class Gen<T> {  
  T ob; 
    
  Gen(T o) {  
    ob = o;  
  }  
  
  // Return ob.  
  T getob() {  
    return ob;  
  }  
}
```

Gen 的一个子类

```java
// A subclass of Gen. 
class Gen2<T> extends Gen<T> { 
  Gen2(T o) { 
    super(o); 
  } 
}
```

一个子类可以添加它自己的类型参数

```java
// A subclass can add its own type parameters. 
class Gen<T> {  
  T ob; // declare an object of type T  
    
  // Pass the constructor a reference to   
  // an object of type T.  
  Gen(T o) {  
    ob = o;  
  }  
  
  // Return ob.  
  T getob() {  
    return ob;  
  }  
}
```

```java
// A subclass of Gen that defines a second 
// type parameter, called V. 
class Gen2<T, V> extends Gen<T> { 
  V ob2; 
 
  Gen2(T o, V o2) { 
    super(o); 
    ob2 = o2; 
  } 
 
  V getob2() { 
    return ob2; 
  } 
}
```

演示继承体系结构

```java
// Create an object of type Gen2. 
class HierDemo {  
  public static void main(String args[]) {  
    
    // Create a Gen2 object for String and Integer. 
    Gen2<String, Integer> x = 
      new Gen2<String, Integer>("Value is: ", 99);  
 
    System.out.print(x.getob()); 
    System.out.println(x.getob2()); 
  }  
}
```

#### 泛型子类

非泛型子类

```java
// A nongeneric class can be the superclass 
// of a generic subclass. 
 
// A nongeneric class. 
class NonGen { 
  int num; 
 
  NonGen(int i) { 
    num = i; 
  } 
 
  int getnum() { 
    return num; 
  } 
}
```

泛型子类

```java
// A generic subclass. 
class Gen<T> extends NonGen {  
  T ob; // declare an object of type T  
    
  // Pass the constructor a reference to   
  // an object of type T.  
  Gen(T o, int i) {  
    super(i); 
    ob = o;  
  }  
  
  // Return ob.  
  T getob() {  
    return ob;  
  }  
}
```

演示继承体系

```java
// Create a Gen object. 
class HierDemo2 {  
  public static void main(String args[]) {  
    
    // Create a Gen object for String. 
    Gen<String> w = new Gen<String>("Hello", 47); 
    
    System.out.print(w.getob() + " "); 
    System.out.println(w.getnum()); 
  }  
}
```

#### 泛型体系的运行时类型比较

```java
// Use the instanceof operator with a generic class hierarchy.  
class Gen<T> {   
  T ob;  
     
  Gen(T o) {   
    ob = o;   
  }   
   
  // Return ob.   
  T getob() {   
    return ob;   
  }   
}
```

Gen 的一个子类

```java
// A subclass of Gen.  
class Gen2<T> extends Gen<T> {  
  Gen2(T o) {  
    super(o);  
  }  
}
```

演示泛型运行时类型推断

```java
// Demonstrate run-time type ID implications of generic 
// class hierarchy. 
class HierDemo3 {   
  public static void main(String args[]) {   
     
    // Create a Gen object for Integers.  
    Gen<Integer> iOb = new Gen<Integer>(88);  
  
    // Create a Gen2 object for Integers.  
    Gen2<Integer> iOb2 = new Gen2<Integer>(99);   
    
    // Create a Gen2 object for Strings.  
    Gen2<String> strOb2 = new Gen2<String>("Generics Test");   
  
    // See if iOb2 is some form of Gen2. 
    if(iOb2 instanceof Gen2<?>)   
      System.out.println("iOb2 is instance of Gen2");  
 
    // See if iOb2 is some form of Gen. 
    if(iOb2 instanceof Gen<?>)   
      System.out.println("iOb2 is instance of Gen");  
  
    System.out.println();  
  
    // See if strOb2 is a Gen2. 
    if(strOb2 instanceof Gen2<?>)   
      System.out.println("strOb is instance of Gen2");  
  
    // See if strOb2 is a Gen. 
    if(strOb2 instanceof Gen<?>)   
      System.out.println("strOb is instance of Gen");  
 
    System.out.println();  
  
    // See if iOb is an instance of Gen2, which it is not. 
    if(iOb instanceof Gen2<?>)   
      System.out.println("iOb is instance of Gen2");  
  
    // See if iOb is an instance of Gen, which it is. 
    if(iOb instanceof Gen<?>)   
      System.out.println("iOb is instance of Gen");  
  
    // The following can't be compiled because  
    // generic type info does not exist at run-time. 
//    if(iOb2 instanceof Gen2<Integer>)   
//      System.out.println("iOb2 is instance of Gen2<Integer>");  
  }   
}
```

#### 类型转换

只能是兼容的类型之间转换

#### 重写泛型类的方法

重写一个泛型类中的泛型方法

```java
// Overriding a generic method in a generic class. 
class Gen<T> {  
  T ob; // declare an object of type T  
    
  // Pass the constructor a reference to   
  // an object of type T.  
  Gen(T o) {  
    ob = o;  
  }  
  
  // Return ob.  
  T getob() {  
    System.out.print("Gen's getob(): " ); 
    return ob;  
  }  
}
```

重写了 getob() 的一个 Gen 的子类

```java
// A subclass of Gen that overrides getob(). 
class Gen2<T> extends Gen<T> { 
 
  Gen2(T o) { 
    super(o); 
  } 
   
  // Override getob(). 
  T getob() {  
    System.out.print("Gen2's getob(): "); 
    return ob;  
  }  
}
```

演示如何重写泛型方法：

```java
// Demonstrate generic method override. 
class OverrideDemo {  
  public static void main(String args[]) {  
    
    // Create a Gen object for Integers. 
    Gen<Integer> iOb = new Gen<Integer>(88); 
 
    // Create a Gen2 object for Integers. 
    Gen2<Integer> iOb2 = new Gen2<Integer>(99);  
   
    // Create a Gen2 object for Strings. 
    Gen2<String> strOb2 = new Gen2<String>("Generics Test");  
 
    System.out.println(iOb.getob()); 
    System.out.println(iOb2.getob()); 
    System.out.println(strOb2.getob()); 
  }  
}
```

### 泛型的类型推断

即钻石操作符 diamond operator `<>`

### 类型擦除

泛型只是源代码机制，编译后不存在类型参数信息。

#### 桥接方法

有时候编译器需要一个桥接方法，确保子类重写的方法的类型擦除效果与父类方法不同。

### 模糊错误

常出现在方法重载的时候。

### 泛型的一些限制

#### 类型参数不可实例化

例如以下代码：

```java
// 不能创建一个类型为 T 的示例
class Gen<T> {
    T ob;
    
    Gen() {
        ob = new T();  // 非法操作!
    }
}
```

原因编译器不知道应该创建声明类型的对象，T 只是一个占位符。

#### 静态方法的限制

No static member can use a type parameter declared by the enclosing class. For example, both of the static members of this class are illeagal:

```java
class Wrong<T> {
	// Wrong, no static variables of type T.
    static T ob;
    
    // Wrong, no static method can use T.
    static T getob() {
        return ob;
    }
}
```

Although you can't declare static memebers that use a type parameter declared by the enclosing class, you can declare static generic methods, which define their own type parameters, as was done earlier in this chapter.

#### 泛型在数组的限制

主要包含两方面的限制：不可以实例化元素类型为类型参数的数组。

不可以创建某个特定的泛型的数组引用。以下代码展示这两种情况：

```java
// Generics and arrays.
class Gen<T extends Number> {
	T ob;
	T vals[];	// OK
	Gen(T o, T[] nums) {
		ob = o;
		
		// This statement is illegal.
		// vals = new T[10]; 	// can't create an array of T
		
		// But, this statement is OK.
		vals = nums;	// OK to assign reference to existent array
	}
}

class GenArrays {
    public static void main(String args[]) {
        Integer n[] = { 1, 2, 3, 4, 5 };
        
        Gen<Integer> iOb = new Gen<Integer>(50, n);
        
        // Can't create an array of type-specific generic references.
        // Gen<Integer> gens[] = new Gen<Integer>[10];	// Wrong!
        
        // This is OK.
        Gen<?> gens[] = new Gen<?>[10];	// OK
    }
}
```



#### 泛型在异常方面的限制

泛型类不可以继承 `Throwable` 意味着你不可以创建泛型异常类型。