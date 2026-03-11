package com.family.dao;

import com.family.model.Family;
import com.family.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FamilyDAO {

    public int createFamily(String familyName) throws SQLException {
        String sql = "INSERT INTO Family (family_name) VALUES (?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, familyName);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    public boolean updateUserFamily(int userId, int familyId) throws SQLException {
        String sql = "UPDATE User SET family_id = ?, role = 'FAMILY_ADMIN' WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, familyId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean joinFamily(int userId, int familyId) throws SQLException {
        String sql = "UPDATE User SET family_id = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, familyId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public Family getFamilyById(int familyId) throws SQLException {
        String sql = "SELECT * FROM Family WHERE family_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, familyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Family(rs.getInt("family_id"), rs.getString("family_name"));
                }
            }
        }
        return null;
    }

    public List<Family> getAllFamilies() throws SQLException {
        List<Family> families = new ArrayList<>();
        String sql = "SELECT * FROM Family";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                families.add(new Family(rs.getInt("family_id"), rs.getString("family_name")));
            }
        }
        return families;
    }
}
