---
typora-root-url: ../
layout:     post
title:      RSocket与Spring Security简单整合
date:       '2020-03-10T21:00'
subtitle:   Spring Tips 学习记录
keywords:   RSocket, Spring Security
author:     招文桃
catalog:    true
tags:
    - RSocket
    - Spring Security
    - Authentication
---

### 创建工程

- greetings-service

  > 在 start.spring.io 选择 2.3.0 M2 版本 Spring Boot，依赖项如下
  >
  > Lombok
  >
  > RSocket
  >
  > Spring Security

- greetings-client

  > 客户端的依赖项也是
  >
  > Lombok
  >
  > RSocket
  >
  > Spring Security

#### 服务端应用

GreetingsServiceApplication.java

```java
// 省略导入
// 一个简单的，基于用户名和密码的“问候”应用
// 简单起见，所有类都写在一个文件里
@SpringBootApplication
public class GreetingsServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(GreetingsServiceApplication.class, args);
    }
}

@Configuration
@EnableRSocketSecurity
class RSocketSecurityConfiguration {

    @Bean
    RSocketMessageHandler messageHandler(RSocketStrategies strategies) {
        RSocketMessageHandler mh = new RSocketMessageHandler();
        mh.getArgumentResolverConfigurer().addCustomResolver(new AuthenticationPrincipalArgumentResolver());
        mh.setRSocketStrategies(strategies);
        return mh;
    }

    // 授权
    @Bean
    PayloadSocketAcceptorInterceptor authorization(RSocketSecurity security) {
        return security
                .authorizePayload(spec -> spec
                        .route("greetings")
                        .authenticated()
                        .anyExchange()
                        .permitAll())
                .simpleAuthentication(Customizer.withDefaults())
                .build();
    }

    // 用户认证 Authentication
    @Bean
    MapReactiveUserDetailsService authentication() {
        UserDetails jlong = User.withDefaultPasswordEncoder().username("jlong")
            .password("pw").roles("USER").build();
        UserDetails rwinch = User.withDefaultPasswordEncoder().username("rwinch")
            .password("pw").roles("ADMIN", "USER").build();
        return new MapReactiveUserDetailsService(jlong, rwinch);
    }
}

// DTO
@Data
@AllArgsConstructor
@NoArgsConstructor
class GreetingResponse {
    private String message;
}

@Controller
class GreetingController {

    @MessageMapping("greetings")
    Flux<GreetingResponse> greet(@AuthenticationPrincipal Mono<UserDetails> user) {
        return user
                .map(UserDetails::getUsername)
                .flatMapMany(GreetingController::greet);
    }

    private static Flux<GreetingResponse> greet(String name) {
        return Flux.fromStream(
                Stream.generate(() -> 
                new GreetingResponse("Hello " + name + " @ " + 
                Instant.now().toString())))
                .delayElements(Duration.ofSeconds(1));
    }
}
```

**服务端的配置文件**：application.properties

```properties
spring.rsocket.server.port=8888
```

---

#### 客户端应用

GreetingsClientApplication.java

```java
@SpringBootApplication
@Log4j2
public class GreetingsClientApplication {

    @SneakyThrows
    public static void main(String[] args) {
        SpringApplication.run(GreetingsClientApplication.class, args);
        System.in.read(); // 让程序不要结束
    }

    private final MimeType mimeType =
            MimeTypeUtils.parseMimeType(WellKnownMimeType.MESSAGE_RSOCKET_AUTHENTICATION.getString());
    private final UsernamePasswordMetadata credentials = new UsernamePasswordMetadata("jlong", "pw");

    // 配置所用编码器
    @Bean
    RSocketStrategiesCustomizer rSocketStrategiesCustomizer() {
        return strategies -> strategies.encoder(new SimpleAuthenticationEncoder());
    }

    // 相当于客户端
    @Bean
    RSocketRequester rSocketRequester(RSocketRequester.Builder builder) {
        return builder
                //.setupMetadata(this.credentials, this.mimeType)
                .connectTcp("localhost", 8888)
                .block();
    }

    // 应用就绪时通过RSocket向localhost:8888/greetings发起请求
    // 并将响应消息通过日志输出到控制台
    @Bean
    ApplicationListener<ApplicationReadyEvent> ready(RSocketRequester greetings) {
        return event -> greetings
                .route("greetings")
                .metadata(this.credentials, this.mimeType)
                .data(Mono.empty())
                .retrieveFlux(GreetingResponse.class)
                .subscribe(gr -> log.info("secured response: " + gr.toString()));
    }
}

// DTO
@Data
@AllArgsConstructor
@NoArgsConstructor
class GreetingResponse {
    private String message;
}
```

### 结束

感觉直接看代码也挺好理解的，就不勉强添加太多文字说明了。有什么不明白的，可以看视频讲解。





