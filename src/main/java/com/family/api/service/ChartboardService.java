package com.family.api.service;

import com.family.api.model.ChartboardPost;
import com.family.api.model.Comment;
import com.family.api.model.User;
import com.family.api.repository.ChartboardPostRepository;
import com.family.api.repository.CommentRepository;
import com.family.api.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ChartboardService {

    @Autowired
    private ChartboardPostRepository postRepository;

    @Autowired
    private CommentRepository commentRepository;

    @Autowired
    private UserRepository userRepository;

    public ChartboardPost createPost(Integer userId, String content) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        if (user.getFamily() == null) {
            throw new RuntimeException("User must belong to a family to post");
        }

        ChartboardPost post = new ChartboardPost();
        post.setUser(user);
        post.setContent(content);
        return postRepository.save(post);
    }

    public List<ChartboardPost> getFamilyPosts(Integer familyId) {
        return postRepository.findByFamilyIdOrderByCreatedAtDesc(familyId);
    }

    public List<ChartboardPost> searchPosts(Integer familyId, String keyword) {
        if (keyword == null || keyword.isBlank()) {
            return getFamilyPosts(familyId);
        }
        return postRepository.searchByFamilyIdAndKeyword(familyId, keyword);
    }

    public void deletePost(Integer postId, Integer userId) {
        ChartboardPost post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post not found"));
        
        if (!post.getUser().getUserId().equals(userId)) {
             throw new RuntimeException("You can only delete your own posts");
        }
        
        postRepository.delete(post);
    }

    public Comment addComment(Integer postId, Integer userId, String content) {
        ChartboardPost post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post not found"));

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Comment comment = new Comment();
        comment.setPost(post);
        comment.setUser(user);
        comment.setContent(content);
        return commentRepository.save(comment);
    }
}
