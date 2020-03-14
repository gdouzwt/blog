---
typora-root-url: ../
layout:     post
title:        Java 并发
date:       '2019-11-15T14:03'
subtitle:   基础内容
author:     招文桃
catalog:    true
tags:
    - Java
    - OCP
---

## Concurrency 并发

### Synchronized 语句块

```java
package synchronizing;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class SheepManager {
	
	private int sheepCount = 0;
	
	// private void incrementAndReport() {
	private void incrementAndReport() {
		synchronized(this) {
        System.out.print((++sheepCount)+" ");
        }
	}

	public static void main(String[] args) {

		ExecutorService service = null;
		try {
			service = Executors.newFixedThreadPool(20);
			
			SheepManager manager = new SheepManager();
			for(int i = 0; i < 10; i++) 
				service.submit(()-> manager.incrementAndReport());
			} finally {
				if (service != null) service.shutdown();
			}
	}
}
```

使用 Monitor 或称为 Lock，使用 synchronized 的时候，注意🔒的对象是那个。保证同步，就要去要锁同一个对象。<!--more-->

并发集合类

| 类名称                | 接口                                   | 元素有序？ | 可排序？ | 阻塞？ |
| --------------------- | -------------------------------------- | ---------- | -------- | ------ |
| ConcurrentHashMap     | ConcurrentMap                          | No         | No       | No     |
| ConcurrentLinkedDeque | Deque                                  | Yes        | No       | No     |
| ConcurrentLinkedQueue | Queue                                  | Yes        | No       | No     |
| ConcurrentSkipListMap | ConcurrentMap, SortedMap, NavigableMap | Yes        | Yes      | No     |
| ConcurrentSkipListSet | SortedSet, NavigableSet                | Yes        | Yes      | No     |
| CopyOnWriteArrayList  | List                                   | Yes        | No       | No     |
| CopyOnWriteArraySet   | Set                                    | Yes        | No       | No     |
| LinkedBlockingDeque   | BlockingQueue, BlockingDeque           | Yes        | No       | Yes    |
| LinkedBlockingQueue   | BlockingQueue                          | Yes        | No       | Yes    |

### Understanding CopyOnWrite Collections

```java
List<Integer> list = new CopyOnWriteArrayList<>(Arrays.asList(4,3,52));
for (Integer item: list) {
	System.out.print(item+" ");
	list.add(9);
}
System.out.println();
System.out.println("Size: "+list.size());
```
