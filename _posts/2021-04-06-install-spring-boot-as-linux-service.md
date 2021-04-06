---
typora-root-url: ../
layout:     post
title:      安装Spring Boot应用(作为系统服务)
date:       '2021-04-06T15:54'
subtitle:   
keywords:   Spring Boot, Linux, Serive
author:     招文桃
catalog:    true
tags:
    - Spring Boot
    - Linux
    - systemd
    - init.d
---

> 本文介绍将 Spring Boot 应用打包为可执行 jar 文件,并将其安装到 Linux 系统作为 `init.d` 服务或 `systemd` 服务。

### 安装 Spring Boot 应用(作为系统服务)

以 jar 形式打包的 Spring  Boot 应用可以使用命令 `java -jar` 运行，但也可以将它作为 Unix 环境的完全可执行文件的形式。一个完全可执行的 jar 可以像其它任何二进制可执行文件那样被执行，或者也可以注册到 `init.d` 或 `systemd`。这样的方式有助于在常见的生产环境中安装和管理 Spring Boot 应用。

要在 Maven 创建一个完全可执行的 jar， 使用以下插件配置：

```xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
    <configuration>
        <executable>true</executable>
    </configuration>
</plugin>
```

如果使用 Gradle 就用下面的配置：

```groovy
bootJar {
	launchScript()
}
```

生成的可执行 jar 可以通过命令 `./my-application.jar` (其中 `my-application` 是你的应用 artifact 名称)。包含这个 jar 的目录会用作应用程序的工作目录。

#### 1. 支持的操作系统

默认的脚本支持大部分 Linux 发行版而且已在 CentOS 和 Ubuntu 上测试过。 其它系统，例如 OS X 和 FreeBSD，需要使用自定义的 `embeddedLaunchScript`。

#### 2. Unix/Linux 服务

Spring Boot 应用可以容易地作为 Unix/Linux service 让 `init.d` 或 `systemd` 去启动。

##### 2.1 安装为 init.d 服务 (System V)

前面步骤生成的可执行 jar 可以用于 `init.d` service。 只需要符号连接到 `init.d` 就可以支持标准的 `start`，`stop`，`restart`，以及 `status` 命令。

其中的脚本支持下列特性：

- 以 jar 文件拥有者的用户去启动服务
- 通过使用 `/var/run/<appname>/<appname>.pid` 追踪应用程序的 PID
- 将控制台输出的日志写到 `/var/log/<appname>.log`

假设你有个 Spring Boot 应用安装在 `/var/myapp` ，那么要将它安装为一个 `init.d` 服务，可以按以下命令创建一个符号连接：

```bash
$ sudo ln -s /var/myapp/myapp.jar /etc/init.d/myapp
```

一旦安装完成，你就可以按照常规方式去启动和停止服务了。例如，在基于 Debian 的系统，你可以用以下命令启动：

```bash
$ service myapp start
```

> **注意**❗  如果应用程序启动失败，请检查写到 `var/log/<appname>.log` 的日志。

你也可以用操作系统的标准工具去将应用设为自动启动。例如，在基于 Debian 的系统，可以使用以下命令：

```bash
$ update-rc.d myapp defaults <priority>
```

###### 保护 init.d 服务

> ❕ 以下是一些关于以 init.d service 方式运行 Spring Boot 应用需要注意的一些安全问题。

当以 root 执行，即用 root 用户去启动 init.d 的 service，默认的可执行脚本会以环境变量 `RUN_AS_USER` 所指定的用户去运行应用。当环境变量没有设置，就会以 jar 文件的拥有者用户去执行。你绝不应该以 root 用户运行 Spring Boot 应用，即 `RUN_AS_USER` 绝不应该设为 root，且你的应用的 jar 文件的拥有者不应该是 root。适当的做法是创建一个专门的用户用于运行应用，并设置 `RUN_AS_USER` 环境变量的值为该用户，或者使用 `chown` 去将其设为 jar 文件的拥有者，如以下命令所示：

```bash
$ chown bootapp:bootapp your-app.jar
```

在这情况下，默认的可执行脚本会以 `bootapp` 用户去运行应用。

> 💡 为降低应用程序的用户被黑，应该考虑禁用它的登录shell，例如，将那个帐户的shell为 `/usr/sbin/nologin`

应该对应用程序的 jar 文件设置适当的权限，防止被修改。首先，权限设为不可写，只允许它的拥有者读或执行，如：

```bash
$ chmod 500 your-app.jar
```

接下来，限制当帐户被黑了的破坏范围。如果被黑了，黑客可以将 jar 文件设为可写的并修改它的内容。其中一种防护方式是将它设置为不可修改的，通过使用 `chattr` 命令，命令如下：

```
$ sudo chattr +i your-app.jar
```

这会防止任何用户，包括 root 修改 jar 的内容。

如果 root 用于控制应用程序的 service，而且你使用 `.conf` 文件去自定义应用的启动，然后 `.conf` 文件被 root 用户读取并生效的。那么那文件也应该相应地做保护。使用 `chmod` 设置那文件只允许它的拥有者读取，并将 root 设为拥有者，如以下命令所示：

```bash
$ chmod 400 your-app.conf
$ sudo chown root:root your-app.conf
```

##### **2.2. 安装为一个 systemd Service**

`systemd` 是 System V init system 的继任者，并已被很多现代 Linux 发行版采用。尽管你可以继续在 `systemd` 使用 `init.d` 脚本，它也可以使用 `systemd` 'service' 脚本去启动 Spring Boot 应用程序的。

假设你有个 Spring Boot 应用安装在 `/var/myapp`，要将 Spring Boot 应用程序安装为 `systemd` 服务，你需要创建一个名为 `myapp.service` 的脚本，并放到 `/etc/systemd/system` 目录。以下脚本提供作为例子：

```bash
[Unit]
Description=myapp
After=syslog.target

[Service]
User=myapp
ExecStart=/var/myapp/myapp.jar
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
```

> ❗ 记得修改 `Description`, `User` 和 `ExecStart` 字段为自己的应用程序。

> ❕ 那个 `ExecStart` 字段没有声明脚本的动作命令，这意味着默认使用 `run` 命令

注意，不像使用 `init.d` service 运行的那样，运行应用的用户，PID 文件，还有控制台输出日志文件都是由 `systemd` 本身管理的，因此，**必须**在 'service' 脚本中使用适当的字段进行配置。详细配置方式可以参考 [service unit configuration man page](https://www.freedesktop.org/software/systemd/man/systemd.service.html)

要将应用设置为开机启动，可以使用以下命令：

```bash
$ systemctl enable myapp.service
```

详情可参考 `man systemctl` 。

##### 2.3. 自定义启动脚本

由 Maven 或 Gradle 插件写的内置启动脚本有好几种自定义的方式。对于大多数人而言，使用默认脚本和添加一些新的自定义配置通常就够了。如果发现没法自定义某些需要的东西，那使用 `embeddedLaunchScript` 选项去写你自己的版本。

###### 在写入过程自定义启动脚本

通常在启动脚本被写入到 jar 文件的过程时去自定义脚本的元素是合理的。例如, init.d 脚本可以提供一个 "description". 因为你提前就知道了 description (而且不需要变更),你可能也会在 jar 生成时候提供它。

要自定义写入的元素,使用Spring Boot Maven 插件的 `embeddedLaunchScriptProperties` 选项, [或 Spring Boot Gradle 插件的 `launchScript` 的 `properpies` 属性.](https://docs.spring.io/spring-boot/docs/2.4.4/gradle-plugin/reference/htmlsingle/#packaging-executable-configuring-launch-script)

默认脚本支持替换的属性如下:

| 名称                       | 描述                                                         | Gradle 默认值                                                | Maven 默认值                                                 |
| :------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| `mode`                     | The script mode.                                             | `auto`                                                       | `auto`                                                       |
| `initInfoProvides`         | The `Provides` section of “INIT INFO”                        | `${task.baseName}`                                           | `${project.artifactId}`                                      |
| `initInfoRequiredStart`    | `Required-Start` section of “INIT INFO”.                     | `$remote_fs $syslog $network`                                | `$remote_fs $syslog $network`                                |
| `initInfoRequiredStop`     | `Required-Stop` section of “INIT INFO”.                      | `$remote_fs $syslog $network`                                | `$remote_fs $syslog $network`                                |
| `initInfoDefaultStart`     | `Default-Start` section of “INIT INFO”.                      | `2 3 4 5`                                                    | `2 3 4 5`                                                    |
| `initInfoDefaultStop`      | `Default-Stop` section of “INIT INFO”.                       | `0 1 6`                                                      | `0 1 6`                                                      |
| `initInfoShortDescription` | `Short-Description` section of “INIT INFO”.                  | Single-line version of `${project.description}` (falling back to `${task.baseName}`) | `${project.name}`                                            |
| `initInfoDescription`      | `Description` section of “INIT INFO”.                        | `${project.description}` (falling back to `${task.baseName}`) | `${project.description}` (falling back to `${project.name}`) |
| `initInfoChkconfig`        | `chkconfig` section of “INIT INFO”                           | `2345 99 01`                                                 | `2345 99 01`                                                 |
| `confFolder`               | The default value for `CONF_FOLDER`                          | Folder containing the jar                                    | Folder containing the jar                                    |
| `inlinedConfScript`        | Reference to a file script that should be inlined in the default launch script. This can be used to set environmental variables such as `JAVA_OPTS` before any external config files are loaded |                                                              |                                                              |
| `logFolder`                | Default value for `LOG_FOLDER`. Only valid for an `init.d` service |                                                              |                                                              |
| `logFilename`              | Default value for `LOG_FILENAME`. Only valid for an `init.d` service |                                                              |                                                              |
| `pidFolder`                | Default value for `PID_FOLDER`. Only valid for an `init.d` service |                                                              |                                                              |
| `pidFilename`              | Default value for the name of the PID file in `PID_FOLDER`. Only valid for an `init.d` service |                                                              |                                                              |
| `useStartStopDaemon`       | Whether the `start-stop-daemon` command, when it’s available, should be used to control the process | `true`                                                       | `true`                                                       |
| `stopWaitTime`             | Default value for `STOP_WAIT_TIME` in seconds. Only valid for an `init.d` service | 60                                                           | 60                                                           |

###### 运行时自定义脚本

对于 jar 写入后还需要自定义的脚本内容,你可以使用环境变量,或一个 [config 文件](https://docs.spring.io/spring-boot/docs/current/reference/html/deployment.html#deployment-script-customization-conf-file)

默认脚本支持下来环境变量属性:

| 变量                    | 描述                                                         |
| :---------------------- | :----------------------------------------------------------- |
| `MODE`                  | The “mode” of operation. The default depends on the way the jar was built but is usually `auto` (meaning it tries to guess if it is an init script by checking if it is a symlink in a directory called `init.d`). You can explicitly set it to `service` so that the `stop|start|status|restart` commands work or to `run` if you want to run the script in the foreground. |
| `RUN_AS_USER`           | The user that will be used to run the application. When not set, the user that owns the jar file will be used. |
| `USE_START_STOP_DAEMON` | Whether the `start-stop-daemon` command, when it’s available, should be used to control the process. Defaults to `true`. |
| `PID_FOLDER`            | The root name of the pid folder (`/var/run` by default).     |
| `LOG_FOLDER`            | The name of the folder in which to put log files (`/var/log` by default). |
| `CONF_FOLDER`           | The name of the folder from which to read .conf files (same folder as jar-file by default). |
| `LOG_FILENAME`          | The name of the log file in the `LOG_FOLDER` (`<appname>.log` by default). |
| `APP_NAME`              | The name of the app. If the jar is run from a symlink, the script guesses the app name. If it is not a symlink or you want to explicitly set the app name, this can be useful. |
| `RUN_ARGS`              | The arguments to pass to the program (the Spring Boot app).  |
| `JAVA_HOME`             | The location of the `java` executable is discovered by using the `PATH` by default, but you can set it explicitly if there is an executable file at `$JAVA_HOME/bin/java`. |
| `JAVA_OPTS`             | Options that are passed to the JVM when it is launched.      |
| `JARFILE`               | The explicit location of the jar file, in case the script is being used to launch a jar that it is not actually embedded. |
| `DEBUG`                 | If not empty, sets the `-x` flag on the shell process, allowing you to see the logic in the script. |
| `STOP_WAIT_TIME`        | The time in seconds to wait when stopping the application before forcing a shutdown (`60` by default). |

>  ❕ 其中 `PID_FOLDER`, `LOG_FOLDER`, 和`LOG_FILENAME` 变量仅适用于 `init.d` service. 对于`systemd`, 等价的自定义设置通过 ‘service’ script 实现. 详情请查看 [service unit configuration man page](https://www.freedesktop.org/software/systemd/man/systemd.service.html).

除了 `JARFILE` 和 `APP_NAME` , 上面所列出的设置都可以通过一个 `.conf` 文件去配置. 该文件应该与 jar 文件放在一起,并使用相同的文件名,但扩展名为 `.conf` 例如, 一个 jar 文件名为 `/var/myapp/myapp.jar` 使用的配置文件名称是 `/var/myapp/myapp.conf` , 入下面所示:

**myapp.conf**

```ini
JAVA_OPTS=-Xmx1024M
LOG_FOLDER=/custom/log/folder
```

> 💡  如果你不喜欢将config 文件跟 jar 文件放到一起, 你可以设置一个 `CONF_FOLDER` 环境变量以自定义配置文件的位置.

了解更多对配置文件的安全保护措施, 可参考 [the guidelines for securing an init.d service](https://docs.spring.io/spring-boot/docs/current/reference/html/deployment.html#deployment-initd-service-securing).

#### 3.Microsoft Windows Services

一个 Spring Boot 应用程序可以通过使用[`winsw`](https://github.com/kohsuke/winsw)作为 Windows 服务启动

详情可参考: A ([separately maintained sample](https://github.com/snicoll-scratches/spring-boot-daemon)) describes step-by-step how you can create a Windows service for your Spring Boot application.