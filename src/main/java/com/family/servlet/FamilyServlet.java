package com.family.servlet;

import com.family.dao.FamilyDAO;
import com.family.model.Family;
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

@WebServlet("/family")
public class FamilyServlet extends HttpServlet {
    private FamilyDAO familyDAO = new FamilyDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            List<Family> families = familyDAO.getAllFamilies();
            request.setAttribute("families", families);
            request.getRequestDispatcher("family.jsp").forward(request, response);
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
            if ("create".equals(action)) {
                String familyName = request.getParameter("familyName");
                int familyId = familyDAO.createFamily(familyName);
                if (familyId != -1) {
                    familyDAO.updateUserFamily(user.getUserId(), familyId);
                    user.setFamilyId(familyId);
                    user.setRole("FAMILY_ADMIN");
                    session.setAttribute("user", user);
                }
            } else if ("join".equals(action)) {
                int familyId = Integer.parseInt(request.getParameter("familyId"));
                if (familyDAO.joinFamily(user.getUserId(), familyId)) {
                    user.setFamilyId(familyId);
                    session.setAttribute("user", user);
                }
            }
            response.sendRedirect("dashboard");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
