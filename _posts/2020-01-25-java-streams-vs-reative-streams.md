---
typora-root-url: ../
layout:     post
title:      Java Streams vs. Reactive Streams
date:       '2020-01-25T23:52'
subtitle:   Which, When, How, and Why? 学习记录
author:     招文桃
catalog:    true
tags:
    - Java
---

### Java: imperative + object-oriented

Michael Feather:

​	"In OPP we encapsulate the moving parts; in FP we eliminate the moving parts."

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

//double of even numbers
List<Integer> doubled = new ArrayList<>();

for (int i = 0; i < numbers.size(); i++) {
	if (numbers.get(i) % 2 == 0) {
		doubled.add(numbers.get(i) * 2);
	}
}
System.out.println(doubled);

System.out.println(
	numbers.stream()	
		.filter( e -> e % 2 == 0)
		.map( e -> e * 2)
		.collect(toList()));
```



#### functional programming == functional composition + lazy evaluation





Collection Pipeline Pattern

Stream is not a data structure it is an abstraction of functions



bucket   vs  pipeline

List/Set	    Stream



dataflow computing

Serverless



![image-20200126043305570](/img/image-20200126043305570.png)

