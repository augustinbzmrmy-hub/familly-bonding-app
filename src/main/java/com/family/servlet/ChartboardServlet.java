package com.family.servlet;

import com.family.dao.ChartboardDAO;
import com.family.model.ChartboardPost;
import com.family.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/chartboard")
public class ChartboardServlet extends HttpServlet {
    private ChartboardDAO chartboardDAO = new ChartboardDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getFamilyId() == null) {
            response.sendRedirect("family?message=joinfirst");
            return;
        }

        try {
            List<ChartboardPost> posts = chartboardDAO.getFamilyPosts(user.getFamilyId());
            request.setAttribute("posts", posts);
            request.getRequestDispatcher("chartboard.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                String content = request.getParameter("content");
                chartboardDAO.createPost(user.getUserId(), content);
            } else if ("delete".equals(action)) {
                int postId = Integer.parseInt(request.getParameter("postId"));
                chartboardDAO.deletePost(postId, user.getUserId());
            }
            response.sendRedirect("chartboard");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
