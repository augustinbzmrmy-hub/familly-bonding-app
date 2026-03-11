package com.family.dao;

import com.family.model.Challenge;
import com.family.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChallengeDAO {

    public List<Challenge> getAllChallenges(int userId) throws SQLException {
        List<Challenge> challenges = new ArrayList<>();
        String sql = "SELECT c.*, uc.status FROM Challenge c " +
                     "LEFT JOIN User_Challenge uc ON c.challenge_id = uc.challenge_id AND uc.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Challenge c = new Challenge();
                    c.setChallengeId(rs.getInt("challenge_id"));
                    c.setTitle(rs.getString("title"));
                    c.setDescription(rs.getString("description"));
                    c.setStatus(rs.getString("status") == null ? "NOT_JOINED" : rs.getString("status"));
                    challenges.add(c);
                }
            }
        }
        return challenges;
    }

    public boolean joinChallenge(int userId, int challengeId) throws SQLException {
        String sql = "INSERT INTO User_Challenge (user_id, challenge_id, status) VALUES (?, ?, 'IN_PROGRESS') " +
                     "ON DUPLICATE KEY UPDATE status = 'IN_PROGRESS'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, challengeId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean completeChallenge(int userId, int challengeId) throws SQLException {
        String sql = "UPDATE User_Challenge SET status = 'COMPLETED' WHERE user_id = ? AND challenge_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, challengeId);
            return ps.executeUpdate() > 0;
        }
    }
}
