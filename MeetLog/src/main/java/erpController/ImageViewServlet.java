package erpController;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/imageView")
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
