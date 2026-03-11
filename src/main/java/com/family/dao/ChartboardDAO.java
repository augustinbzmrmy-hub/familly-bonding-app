package com.family.dao;

import com.family.model.ChartboardPost;
import com.family.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChartboardDAO {

    public boolean createPost(int userId, String content) throws SQLException {
        String sql = "INSERT INTO Chartboard_Post (user_id, content) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, content);
            return ps.executeUpdate() > 0;
        }
    }

    public List<ChartboardPost> getFamilyPosts(int familyId) throws SQLException {
        List<ChartboardPost> posts = new ArrayList<>();
        String sql = "SELECT p.*, u.full_name FROM Chartboard_Post p " +
                     "JOIN User u ON p.user_id = u.user_id " +
                     "WHERE u.family_id = ? ORDER BY p.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, familyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChartboardPost post = new ChartboardPost();
                    post.setPostId(rs.getInt("post_id"));
                    post.setContent(rs.getString("content"));
                    post.setCreatedAt(rs.getTimestamp("created_at"));
                    post.setUserId(rs.getInt("user_id"));
                    post.setUserName(rs.getString("full_name"));
                    posts.add(post);
                }
            }
        }
        return posts;
    }

    public boolean deletePost(int postId, int userId) throws SQLException {
        String sql = "DELETE FROM Chartboard_Post WHERE post_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }
}
