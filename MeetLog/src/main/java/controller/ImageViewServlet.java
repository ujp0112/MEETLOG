package controller;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.*;

public class ImageViewServlet extends HttpServlet {
  @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    String path = req.getParameter("path");
    if (path == null || path.contains("..")) { resp.sendError(400); return; }
    Path p = Paths.get(req.getServletContext().getRealPath("/"), path);
    if (!Files.exists(p)) { resp.sendError(404); return; }
    String mime = req.getServletContext().getMimeType(p.toString());
    resp.setContentType(mime==null? "application/octet-stream": mime);
    try (OutputStream os = resp.getOutputStream()) {
      Files.copy(p, os);
    }
  }
}
