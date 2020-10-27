package com.ftpix.sss.services;


import com.ftpix.sss.Constants;
import com.ftpix.sss.db.DB;
import com.ftpix.sss.models.User;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;


@Service
public class UserService {
    public final static String EMAIL_REGEX = "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    private final static Logger logger = LogManager.getLogger();
    private final ExpenseService recurringExpenseService;
    private final ExpenseService expenseService;
    private final ExpenseService categoryService;

    @Autowired
    public UserService(ExpenseService recurringExpenseService, ExpenseService expenseService, ExpenseService categoryService) {
        this.recurringExpenseService = recurringExpenseService;
        this.expenseService = expenseService;
        this.categoryService = categoryService;
    }

    /**
     * String hash for passowrds
     *
     * @param str the string to hash
     * @return the new string
     * @throws NoSuchAlgorithmException
     */
    public String hashString(String str) throws NoSuchAlgorithmException {
        MessageDigest md5;
        md5 = MessageDigest.getInstance("MD5");
        str += Constants.SALT;

        md5.update(str.getBytes());

        byte[] byteData = md5.digest();
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < byteData.length; i++) {
            sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
        }

        return sb.toString();
    }

    public String hashUserCredentials(String email, String password) throws NoSuchAlgorithmException {
        return hashString(email + password);
    }

    public User getByEmail(String email) throws SQLException {
        return DB.USER_DAO.queryBuilder().where().eq("email", email).queryForFirst();
    }

    public User getCurrentUser() throws SQLException {
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        org.springframework.security.core.userdetails.User user = (org.springframework.security.core.userdetails.User) authentication.getPrincipal();

        return getByEmail(user.getUsername());
    }

    public List<User> getAll() throws SQLException {
        return DB.USER_DAO.queryForAll();
    }

    public User getById(UUID id) throws SQLException {
        return DB.USER_DAO.queryForId(id);
    }

    public User createUser(User user) throws Exception {
        if (user.getFirstName() == null || user.getFirstName().length() == 0
                || user.getLastName() == null || user.getLastName().length() == 0
                || user.getEmail() == null || user.getEmail().length() == 0
                || user.getPassword() == null || user.getPassword().length() == 0
        ) {
            throw new Exception("All fields must be filled.");
        }

        final long count = DB.USER_DAO.countOf();

        if (count == 0) {
            user.setAdmin(true);
        }

        if (!user.getEmail().matches(EMAIL_REGEX)) {
            throw new Exception("Invalid email");
        }

        if (Constants.HAS_SUBSCRIPTIONS && !user.isAdmin()) {
            // give one month subscription to new users
            final LocalDateTime expiry = LocalDateTime.now().plusMonths(1);
            user.setSubscriptionExpiryDate(Timestamp.valueOf(expiry).getTime());
        } else {
            user.setSubscriptionExpiryDate(User.NEVER);
        }

        // checking if user already exists
        final long emailCheck = DB.USER_DAO.queryBuilder()
                .where()
                .eq("email", user.getEmail())
                .countOf();

        if (emailCheck > 0) {
            throw new Exception("Email already in use");
        }

        user.setPassword(hashUserCredentials(user.getEmail(), user.getPassword()));
        DB.USER_DAO.create(user);

        // Migration code
        // migrating all existing categories to new user as it's the first one
        if (count == 0) {
            DB.CATEGORY_DAO.queryForAll().forEach(c -> {
                try {
                    c.setUser(user);
                    c.update();
                } catch (SQLException e) {
                    logger.error("Couldn't migrate categories", e);
                    throw new RuntimeException(e);
                }
            });
        }

        return user;
    }

    public boolean deleteUser(String userId, User currentUser) throws Exception {
        if (currentUser.getId().toString().equalsIgnoreCase(userId)) {
            throw new Exception("You can't delete yourself");
        }

        return Optional.ofNullable(getById(UUID.fromString(userId)))
                .map(user -> {
                    try {
                        // deleting recurring expenses
                        recurringExpenseService.getAll(user)
                                .forEach(e -> {
                                    try {
                                        recurringExpenseService.delete(e.getId(), user);
                                    } catch (Exception throwables) {
                                        throw new RuntimeException(throwables);
                                    }
                                });

                        // all expenses
                        expenseService.getAll(user)
                                .forEach(e -> {
                                    try {
                                        expenseService.delete(e.getId(), user);
                                    } catch (Exception throwables) {
                                        throw new RuntimeException(throwables);
                                    }
                                });
                        // all categories
                        categoryService.getAll(user)
                                .forEach(c -> {
                                    try {
                                        categoryService.delete(c.getId(), user);
                                    } catch (Exception throwables) {
                                        throw new RuntimeException(throwables);
                                    }
                                });

                        user.delete();
                        return true;
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                })
                .orElse(false);
    }
}
