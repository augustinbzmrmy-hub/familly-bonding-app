package com.family.api.service;

import com.family.api.model.Question;
import com.family.api.model.Answer;
import com.family.api.model.User;
import com.family.api.repository.QuestionRepository;
import com.family.api.repository.AnswerRepository;
import com.family.api.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EducationService {

    @Autowired
    private QuestionRepository questionRepository;

    @Autowired
    private AnswerRepository answerRepository;

    @Autowired
    private UserRepository userRepository;

    public Question askQuestion(Integer userId, String content) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        Question question = new Question();
        question.setUser(user);
        question.setContent(content);
        return questionRepository.save(question);
    }

    public List<Question> getAllQuestions() {
        return questionRepository.findAllByOrderByCreatedAtDesc();
    }

    public Answer answerQuestion(Integer questionId, Integer userId, String content) {
        Question question = questionRepository.findById(questionId)
                .orElseThrow(() -> new RuntimeException("Question not found"));

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Answer answer = new Answer();
        answer.setQuestion(question);
        answer.setUser(user);
        answer.setContent(content);
        return answerRepository.save(answer);
    }

    public void deleteQuestion(Integer questionId, Integer userId) {
        Question question = questionRepository.findById(questionId)
                .orElseThrow(() -> new RuntimeException("Question not found"));
        
        if (!question.getUser().getUserId().equals(userId)) {
             throw new RuntimeException("You can only delete your own questions");
        }
        
        questionRepository.delete(question);
    }
}
