---
typora-root-url: ../
layout:     post
title:      第11章练习回顾
date:       '2020-03-22T18:42'
subtitle:   OCP 11-1 Book
keywords:   OCP 11
author:     招文桃
catalog:    false
tags:
    - Java
    - OCP
---

**1.** Which of the following is an advantage of the Java Platform Module System? **B**  

**A.** A central repository of all modules  
**B.** Encapsulating packages  
**C.** Encapsulating objects  
**D.** No defined types  
**E.** Platform independence  

**2.** Which statement is true of the following module? **F -> D**

zoo.staff
|---zoo
|-- staff
|-- Vet.java

**A.** The directory structure shown is a valid module.
**B.** The directory structure would be a valid module if module.java were added directly underneath zoo.staff.
**C.** The directory structure would be a valid module if module.java were added directly underneath zoo.
**D.** The directory structure would be a valid module if module-info.java were added directly underneath zoo.staff.
**E.** The directory structure would be a valid module if module-info.java were added directly underneath zoo.
**F.** None of these changes would make this directory structure a valid module.

**解释：**  Modules are required to have a module-info.java file at the root directory of the module. Option D matches this requirement.

**3.** B

**4.** D -> G The -m or --module option is used to specify the module and class name. The -p or -module-path option is used to specify the location of the modules. Option D would be correct if the rest of the command were correct. However, running a program requires specifying the package name with periods (.) instead of slashes. Since the command is incorrect, option G is correct.

**5.** AF -> AFG Options C and D are incorrect because there is no use keyword. Options A and F are correct because opens is for reflection and uses declares an API that consumes a service. Option G is also correct as the file can be completely empty. This is just something you have to memorize.

**6.** BDF -> BC Packages inside a module are not exported by default, making option B correct and option A incorrect. Exporting is necessary for other code to use the packages; it is not necessary to call the main() method at the command line, making option C correct and option D incorrect. The module-info.java file has the correct name and compiles, making options E and F incorrect.

**7.** EF -> DG Options A, B, E, and F are incorrect because they refer to keywords that don't exist. The requires transitive keyword is used when specifying a module to be used by the requesting module and any other modules that use the requesting module. Therefore, dog needs to specify the transitive relationship, and option G is correct. The module puppy just needs to require dog, and it gets the transitive dependencies, making option D correct.<!--more-->

**8.** ABCD -> ABD Options A and B are correct because the -p (--module-path) option can be passed when compiling or running a program. Option D is also correct because jdeps can use the --module-path option when listing dependency information.

**9.** AEF -> AB The -p specifies the module path. This is just a directory, so all of the options have a legal module path. The -m specifies the module, which has two parts separated by a slash. Options E and F are incorrect since there is no slash. The first part is the module name. It is separated by periods (.) rather than dashes (-), making option C incorrect. The second part is the package and class name, again separated by periods. The package and class names must be legal Java identifiers. Dashes (-) are not allowed, ruling out option D. This leaves options A and B as the correct answers.  

**10.** B

**11.** ABD -> BDEF This is another question you just have to memorize. The jmod command has five modes you need to be able to list: create, extract, describe, list, and hash. The hash operation is not an answer choice. The other four are making options B, D, E, and F correct.

**12.** A -> B The java command uses this option to print information when the program loads. You might think jar does the same thing since it runs a program too. Alas, this parameter does not exist on jar.

**13.** AD -> E There is a trick here. A module definition uses the keyword module rather than class. Since the code does not compile, option E is correct. If the code did compile, options A and D would be correct.

**14.** A

**15.** AD -> BD The java command has an --add-exports option that allows exporting a package at runtime. However, it is not encouraged to use it, making options B and D the answer.

**16.** BC

**17.** D -> E

**18.** AC

**19.** BC

**20.** BE

**21.** G
