package com.github.fantasy0v0.ip;

import io.helidon.logging.common.LogConfig;
import io.helidon.config.Config;
import io.helidon.service.registry.Services;
import io.helidon.webserver.WebServer;
import io.helidon.webserver.http.HttpRouting;

import java.io.IOException;
import java.util.logging.Logger;

/**
 * The application main class.
 */
public class Main {

  /**
   * Cannot be instantiated.
   */
  private Main() {
  }

  /**
   * Application main entry point.
   *
   * @param args command line arguments.
   */
  static void main(String[] args) {
    // load logging configuration
    LogConfig.configureRuntime();
    final Logger logger = Logger.getLogger(Main.class.getName());

    // initialize global config from default configuration
    Config config = Config.create();
    Services.set(Config.class, config);

    WebServer server = WebServer.builder()
      .config(config.get("server"))
      .routing(Main::routing)
      .build()
      .start();

    logger.info(() -> "WEB server is up! http://localhost:" + server.port() + "/");
  }

  /**
   * Updates HTTP Routing.
   */
  static void routing(HttpRouting.Builder routing) {
    try {
      routing.register("/", new HomePage());
    } catch (IOException e) {
      throw new RuntimeException("初始化失败", e);
    }
  }
}
