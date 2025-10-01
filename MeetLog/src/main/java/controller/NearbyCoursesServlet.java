package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dao.CourseDAO;
import model.CommunityCourse;

@WebServlet("/search/nearby-courses")
public class NearbyCoursesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int PAGE_SIZE = 15;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            double lat = Double.parseDouble(request.getParameter("lat"));
            double lng = Double.parseDouble(request.getParameter("lng"));
            int level = Integer.parseInt(request.getParameter("level"));

            String pageParam = request.getParameter("page");
            int page = (pageParam == null || pageParam.isEmpty()) ? 1 : Integer.parseInt(pageParam);

            double radiusKm = getRadiusByZoomLevel(level);
            int offset = (page - 1) * PAGE_SIZE;

            CourseDAO dao = new CourseDAO();
            List<CommunityCourse> courses = dao.findNearbyCoursesByPage(lat, lng, radiusKm, offset, PAGE_SIZE);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();

            Gson gson = new GsonBuilder()
                .registerTypeAdapter(java.time.LocalDateTime.class, new com.google.gson.JsonSerializer<java.time.LocalDateTime>() {
                    @Override
                    public com.google.gson.JsonElement serialize(java.time.LocalDateTime src, java.lang.reflect.Type typeOfSrc, com.google.gson.JsonSerializationContext context) {
                        return new com.google.gson.JsonPrimitive(src.toString());
                    }
                })
                .create();

            out.print(gson.toJson(courses));
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
        }
    }

    private double getRadiusByZoomLevel(int level) {
        if (level <= 3) return 10;
        if (level <= 5) return 5;
        if (level <= 7) return 2;
        if (level <= 9) return 1;
        return 0.5;
    }
}
