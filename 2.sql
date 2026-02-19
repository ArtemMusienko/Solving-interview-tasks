SELECT 
    tr.inn AS tranche_inn, 
    tr.credit_num, 
    tr.account, 
    tr.operation_datetime AS tranche_datetime, 
    tr.operation_sum AS tranche_sum, 
    tr.doc_id AS tranche_doc_id,
    ts.inn AS trans_inn, 
    ts.account AS trans_account, 
    ts.operation_datetime AS trans_datetime, 
    ts.operation_sum AS trans_sum, 
    ts.ctrg_inn, 
    ts.ctrg_account, 
    ts.doc_id AS trans_doc_id
FROM tranches tr
LEFT JOIN transactions ts 
    ON tr.inn = ts.inn 
    AND tr.account = ts.account 
    AND ts.operation_datetime >= tr.operation_datetime
    AND ts.operation_datetime <= datetime(tr.operation_datetime, '+10 days')
WHERE strftime('%Y', tr.operation_datetime) = '2024'
AND (
    ts.operation_sum = tr.operation_sum
    OR 
    (ts.operation_sum > tr.operation_sum 
     AND NOT EXISTS (
        SELECT 1 
        FROM transactions ts2 
        WHERE tr.inn = ts2.inn 
          AND tr.account = ts2.account 
          AND ts2.operation_datetime >= tr.operation_datetime
          AND ts2.operation_datetime <= datetime(tr.operation_datetime, '+10 days')
          AND ts2.operation_sum = tr.operation_sum
     ))
)
ORDER BY tr.doc_id, ts.doc_id;