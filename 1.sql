SELECT 
    u.username, 
    r.roles, 
    COALESCE(a.activity_count, 0) AS activity_count
FROM 
    users u
LEFT JOIN (
    SELECT user_id, GROUP_CONCAT(DISTINCT role) AS roles
    FROM user_roles
    GROUP BY user_id
) r ON u.id = r.user_id
LEFT JOIN (
    SELECT user_id, COUNT(id) AS activity_count
    FROM user_activity
    WHERE activity_date >= '2024-09-20'
    GROUP BY user_id
) a ON u.id = a.user_id
ORDER BY 
    activity_count DESC;