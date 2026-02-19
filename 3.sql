SELECT 
    c.client_id, 
    c.name, 
    c.age,
    COALESCE(acc.total_accounts, 0) AS total_accounts,
    COALESCE(acc.total_balance, 0) AS total_balance,
    COALESCE(dep.cnt, 0) AS total_deposits,
    COALESCE(wit.cnt, 0) AS total_withdrawals
FROM clients c
LEFT JOIN (
    SELECT client_id, COUNT(*) AS total_accounts, SUM(balance) AS total_balance
    FROM accounts
    GROUP BY client_id
) acc ON c.client_id = acc.client_id
LEFT JOIN (
    SELECT a.client_id, COUNT(*) AS cnt
    FROM transactions t
    JOIN accounts a ON t.account_id = a.account_id
    WHERE t.transaction_type = 'deposit'
    GROUP BY a.client_id
) dep ON c.client_id = dep.client_id
LEFT JOIN (
    SELECT a.client_id, COUNT(*) AS cnt
    FROM transactions t
    JOIN accounts a ON t.account_id = a.account_id
    WHERE t.transaction_type = 'withdrawal'
    GROUP BY a.client_id
) wit ON c.client_id = wit.client_id
WHERE c.registration_date >= '2020-01-01'
ORDER BY total_balance DESC;