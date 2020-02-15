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
The schedule     methods create tasks with various delays and return a task object that can     be used to cancel or check execution. The `scheduleAtFixedRate` and  `scheduleWithFixedDelay` methods create and execute tasks that run periodically until cancelled.

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

##### Which of the following statements are correct?

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

##### How many methods have to be provided by a class that is not abstract and that implements Serializable interface?

- [x] 0

  > Serializable interface does not declare any methods. That is why is also called as a "marker" interface.

- [ ] 1

- [ ] 2

- [ ] 3



---

Simple rule to determine sorting order: spaces < numbers < uppercase < lowercase

---

##### Given that a code fragment has just created a JDBC Connection and has executed an update statement, which of the following statements is correct?

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

##### Which statements concerning the relation between a non-static inner class and its outer class instances are true?

- [ ] Member variables of the outer instance are always accessible to inner instances, regardless of their accessibility modifiers.

- [x] Member variables of the outer instance can always be referred to using only the variable name within the inner instance.

  > This is possible only if that variable is not shadowed by another variable in inner class.

- [x] More than one inner instance can be associated with the same outer instance.

- [x] An inner class can extend its outer classes.

- [ ] A final outer class cannot have any inner classes.

  > There is no such rule.

