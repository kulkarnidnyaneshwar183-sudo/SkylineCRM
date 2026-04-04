public class User {
    private String userId;
    private String fullName;
    private String username;
    private String password;
    private String role;
    private String status;

    // Constructor
    public User(String userId, String fullName,
                String username, String password,
                String role, String status) {
        this.userId = userId;
        this.fullName = fullName;
        this.username = username;
        this.password = password;
        this.role = role;
        this.status = status;
    }

    // Getters
    public String getUserId() { return userId; }
    public String getFullName() { return fullName; }
    public String getUsername() { return username; }
    public String getPassword() { return password; }
    public String getRole() { return role; }
    public String getStatus() { return status; }

    // Setters
    public void setUserId(String userId) { this.userId = userId; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public void setUsername(String username) { this.username = username; }
    public void setPassword(String password) { this.password = password; }
    public void setRole(String role) { this.role = role; }
    public void setStatus(String status) { this.status = status; }
}