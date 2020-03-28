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

**WTF**  
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

---

**3.**

---

**5.**

---

**6.**

---

**7.**

---

**10.**

---

**11.**

---

**12.**

---

**14.**

---

**15.**

---

**19.**

---

**21.**

---

**22.**

---

**23.**

---

**24.**

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


