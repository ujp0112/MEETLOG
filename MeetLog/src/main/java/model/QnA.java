package model;

public class QnA {
    private String question;
    private String answer;
    private boolean isOwner;

    public QnA() {}

    public QnA(String question, String answer, boolean isOwner) {
        this.question = question;
        this.answer = answer;
        this.isOwner = isOwner;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public boolean isOwner() {
        return isOwner;
    }

    public void setOwner(boolean owner) {
        isOwner = owner;
    }
}
