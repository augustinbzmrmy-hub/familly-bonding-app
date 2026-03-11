package com.family.servlet;

import com.family.dao.ChallengeDAO;
import com.family.model.Challenge;
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

@WebServlet("/challenges")
public class ChallengeServlet extends HttpServlet {
    private ChallengeDAO challengeDAO = new ChallengeDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        try {
            List<Challenge> challenges = challengeDAO.getAllChallenges(user.getUserId());
            request.setAttribute("challenges", challenges);
            request.getRequestDispatcher("challenges.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        int challengeId = Integer.parseInt(request.getParameter("challengeId"));

        try {
            if ("join".equals(action)) {
                challengeDAO.joinChallenge(user.getUserId(), challengeId);
            } else if ("complete".equals(action)) {
                challengeDAO.completeChallenge(user.getUserId(), challengeId);
            }
            response.sendRedirect("challenges");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
