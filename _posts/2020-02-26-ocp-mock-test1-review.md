---
typora-root-url: ../
layout:     post
title:      OCP-1Z0-816 模拟测试1回顾
date:       '2020-02-26T15:15'
subtitle:   记录部分
keywords:   Oracle Certified, OCP 11, Java 11, 1Z0-816
author:     招文桃
catalog:    true
tags:
    - Java
    - 1Z0-816
    - 认证考试
---

### NIO 2 Files class

文件操作， `Files.copy`方法

However, `Files.isSameFile` method doesn't check the contents of the file. It is meant to check if the two path objects resolve to the same file or not. In this case, they are not, and so, it will return false.  

```java
public static Path copy(Path source, Path target, CopyOption... options) throws IOException
```

选项参数（options parameter)可以包括以下：

**REPLACE_EXISTING**

​      If the target file exists, then the target file is replaced if it is not a non-empty directory. If the target file exists and is a symbolic link, then the symbolic link itself, not the target of the link, is replaced.  

**COPY_ATTRIBUTES**

​      Attempts to copy the file attributes associated with this file to the target file. The exact file attributes that are copied is platform and file system dependent and therefore unspecified. Minimally, the last-modified-time is copied to the target file if supported by both the source and target file store. Copying of file timestamps may result in precision loss.  

**NOFOLLOW_LINKS**

​      Symbolic links are not followed. If the file is a symbolic link, then the symbolic link itself, not the target of the link, is copied. It is implementation specific if file attributes can be copied to the new link.  In other words, the COPY_ATTRIBUTES option may be ignored when copying a symbolic link.  
An implementation of this interface may support additional implementation specific options.
Coping a file is not an atomic operation. If an `IOException` is thrown then it's possible that the target file is incomplete or some of its file attributes have not been copied from the source file. When the REPLACE_EXISTING option is specified and the target file exists, then the target file is replaced. The check for the existence of the creation of the new file may not be atomic with respect to other file system activities. <!--more-->

```java
public static Path move(Path source, Path target, CopyOption... options) throws IOException
```

Move or rename a file to a target file.
By default, this method attempts to move the file to the target file, failing if the target file exists except if the source and target are the same file, in which case this method has no effect. If the file is a symbolic link then the symbolic link itself, not the target of the link, is moved. This method may be invoked to move an empty directory. In some implementations a directory has entries for special files or links that are created when the directory is created. In such implementations a directory is considered empty when only the special entries exist. When invoked to move a directory that is not empty then the directory is moved if it does not require moving the entries in the directory. For example, renaming a directory on the same FileStore will usually not required moving the entries in the directory. When moving a directory requires that its entries be moved then this method fails (by throwing an `IOException`). To move a file tree may involve copying rather than moving directories and this can be done using the copy method in conjunction with the `Files.walkFileTree` utility method.

The options parameter may include any of the following:

**REPLACE_EXISTING** If the target file exists, then the target file is replaced if it is not a non-empty directory. If the target file exists and is a symbolic link, then the symbolic link itself, not the target of the link, is replaced.

**ATOMIC_MOVE** The move is performed as an atomic file system operation and all other options are ignored. If the target file exists then it is implementation specific if the existing file is replaced or this method fails by throwing an `IOException`. If the move cannot be performed as an atomic file system operation then `AtomicMoveNotSupportedException` is thrown. This can arise, for example, when the target location is on a different FileStore and would require that the file be copied, or target location is associated with a different provider to this object. An implementation of this interface may support additional implementation specific options.

Where the move requires that the file be copied then the last-modified-time is copied to the new file. An implementation may also attempt to copy other file attributes but is not required to fail if the file attributes cannot be copied. When the move is performed as a non-atomic operation, and an `IOException` is thrown, then the state of the files is not defined. The original file and the target file may both exist, the target file may be incomplete or some of its file attributes may not been copied from the original file.

---

Consider the following code:

```java
class LowBalanceException extends ____ {  // 1
    public LowBalanceException(String msg) { super(msg); }
}

class WithdrawalException extends ____ { // 2 
    public WithdrawalException(String msg) { super(msg); }
}

class Account {
    double balance;
    public void withdraw(double amount) throws WithdrawalException {
        try {
            throw new RuntimeException("Not Implemented");
        } catch (Exception e) {
            throw new LowBalanceException( e.getMessage());
        }
    }
    public static void main(String[] args) {
        try {
            Account a = new Account();
            a.withdraw(100.0);
        } catch(Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
```

What can be inserted at // 1 and // 2 so that the above code will prints Not Implemented?

- [ ] Exception
  Exception
- [ ] Exception
  LowBalanceException
- [x] WithdrawalException
  Exception
- [ ] WithdrawalException
  RuntimeException

**Explanation**

1. The withdraw method declares that it throws WithdrawalException. This means that the only exceptions that can come out of this method are WithdrawalExceptions  (which means WithdrawalException or its subclasses) or RuntimeExceptions.
2. The try block in withdraw method throws a RuntimeException. It will be caught by the catch(Exception) block because RuntimeException is-a Exception. The code in the catch block throws a LowBalanceException, which is not caught. Thus, it will be thrown out of this method, which means LowBalanceException must either be a RuntimeException or be a WithdrawalException (i.e. must extend WithdrawalException) to satisfy the throws clause of the withdraw method.
3. The main() method does not have a throws clause but the call to withdraw() is enclosed within a try block with catch(Exception). Thus, WithdrawalException can extend either Exception or RuntimeException.

[To be continued!]