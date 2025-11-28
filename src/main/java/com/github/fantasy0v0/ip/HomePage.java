package com.github.fantasy0v0.ip;

import com.ip2location.IP2Location;
import com.ip2location.IPResult;
import gg.jte.CodeResolver;
import gg.jte.ContentType;
import gg.jte.TemplateEngine;
import gg.jte.TemplateOutput;
import gg.jte.output.StringOutput;
import gg.jte.resolve.DirectoryCodeResolver;
import io.helidon.common.media.type.MediaTypes;
import io.helidon.http.Status;
import io.helidon.webserver.http.HttpRules;
import io.helidon.webserver.http.HttpService;
import io.helidon.webserver.http.ServerRequest;
import io.helidon.webserver.http.ServerResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

public class HomePage implements HttpService {

  private final Logger logger = Logger.getLogger(HomePage.class.getName());

  private final IP2Location location;

  private final TemplateEngine templateEngine;

  private final String indexJteName = "index.jte";

  public HomePage() throws IOException {
    String binFile = "IP2LOCATION-LITE-DB11.IPV6.BIN";
    if (!Files.exists(Path.of(binFile))) {
      throw new IllegalStateException("缺少IP2Location Bin File");
    }
    location = new IP2Location();
    location.Open(binFile);
    Path templatePath = Path.of("template");
    CodeResolver codeResolver = new DirectoryCodeResolver(templatePath);
    this.templateEngine = TemplateEngine.create(codeResolver, ContentType.Html);

    Path indexJte = Path.of(templatePath.toString(), indexJteName);
    if (!Files.exists(indexJte)) {
      throw new IllegalStateException("缺少index.jte");
    }
  }

  @Override
  public void routing(HttpRules rules) {
    rules
    .get("/", this::index)
    .get("/index.html", this::index);
  }

  private void index(ServerRequest request, ServerResponse response) {
    long start = System.currentTimeMillis();
    try {
      TemplateOutput output = new StringOutput();
      Map<String, Object> params = new HashMap<>();
      String ip = null;
      if (request.query().contains("ip")) {
        ip = request.query().get("ip");
      }
      if (null == ip || ip.isBlank()) {
        ip = request.remotePeer().host();
      }
      // TODO 测试
      ip = "183.213.185.141";
      params.put("ip", ip);
      IPResult result = location.IPQuery(ip);
      params.put("result", result);
      params.put("cost", System.currentTimeMillis() - start);
      templateEngine.render(indexJteName, params, output);
      response.headers().contentType(MediaTypes.TEXT_HTML);
      response.send(output.toString());
    } catch (Exception e) {
      var sw = new java.io.StringWriter();
      e.printStackTrace(new PrintWriter(sw));
      String stackTrace = sw.toString();
      logger.severe(stackTrace);
      response.status(Status.INTERNAL_SERVER_ERROR_500);
    }
  }
}
