---
typora-root-url: ../
layout:     post
title:      JDK 的 jpackage 早期预览版
date:       '2019-11-11T14:27'
subtitle:   Java 应用新的打包方式
author:     招文桃
catalog:    true
tags:
    - Java
    - JDK 14
---

### 在 Windows 测试

```
jpackage --type exe --name javafx-library --description "Demo of jpackage" --vendor "Zhao Wentao" --app-version 0.0.1 --input input --dest output --main-jar app.jar --win-shortcut --win-menu
```

需要 Wix Toolsets
