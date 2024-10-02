--データ全件削除--
delete from patients;
delete from examination_results;
delete from doctor;
delete from consultation_records;
delete from surgeries;
delete from departments;
delete from medicines;
delete from prescription_medicines;
delete from reservations;


-- 部門テーブルデータ作成
INSERT INTO departments (department_id, department_name, description)
VALUES 
(1, '外科', '手術を担当する部門'),
(2, '内科', '内科治療を担当する部門'),
(3, '小児科', '子供の診察を担当する部門');


-- 医師テーブルデータ作成
INSERT INTO doctor (doctor_id, name, specialty, qualification, years_of_experience, contact_number, email, work_days, office_hours, department_id, joining_date, salary, status, del_flag, created_at, updated_at)
VALUES 
(1, '山田太郎', '外科', 'MD', 15, '123-4567', 'yamada@example.com', '月-金', '09:00-17:00', 1, '2015-01-15', 1200000, 'active', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- 9年以上
(2, '佐藤花子', '内科', 'MD', 10, '123-8901', 'sato@example.com', '月-金', '09:00-18:00', 2, '2018-03-20', 1000000, 'active', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- 6年以上
(3, '鈴木一郎', '外科', 'PhD', 20, '123-9999', 'suzuki@example.com', '月-金', '09:00-17:00', 1, '2021-04-01', 1300000, 'active', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- 3年以下
(4, '田中三郎', '小児科', 'MD', 8, '123-8888', 'tanaka@example.com', '月-金', '09:00-17:00', 3, '2017-05-10', 1100000, 'active', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP); -- 7年以上


-- 患者テーブルデータ作成
INSERT INTO patients (patient_id, name, gender, date_of_birth, address, contact_number, emergency_contact, del_flag, created_at, updated_at)
VALUES 
(1, '田中一郎', '男性', '1985-04-12', '東京都', '987-6543', '987-6544', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, '鈴木二郎', '男性', '1990-07-20', '神奈川県', '987-1111', '987-2222', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, '佐藤花子', '女性', '1988-02-14', '大阪府', '987-3333', '987-4444', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 診察記録テーブルデータ作成
INSERT INTO consultation_records (consultation_id, patient_id, doctor_id, consultation_date, consultation_details, del_flag, created_at, updated_at)
VALUES 
(1, 1, 1, '2023-09-15', '高血圧の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 田中一郎
(2, 2, 2, '2024-01-20', '糖尿病の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- 鈴木二郎
(3, 3, 1, '2024-03-10', '高血圧の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP); -- 佐藤花子


-- 手術テーブルデータ作成
INSERT INTO surgeries (surgery_id, surgery_name, surgery_date, doctor_id, patient_id, del_flag, created_at, updated_at)
VALUES 
(1, '心臓バイパス手術', '2024-05-15', 1, 1, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 山田太郎
(2, '胃切除手術', '2024-06-10', 1, 2, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),        -- 山田太郎
(3, '緊急開腹手術', '2024-07-20', 2, 3, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);       -- 佐藤花子

-- 薬品テーブルデータ作成
INSERT INTO medicines (medicine_id, medicine_name, description, price)
VALUES 
(1, 'アスピリン', '痛みを軽減する', 100.00),
(2, 'メトホルミン', '糖尿病の治療薬', 200.00),
(3, 'リシノプリル', '高血圧の治療薬', 150.00);

-- 薬品処方テーブルデータ作成
INSERT INTO prescription_medicines (prescription_id, patient_id, medicine_id, dosage, frequency, del_flag, created_at, updated_at)
VALUES 
(1, 1, 3, '10mg', '1日1回', '0', '2023-09-16', CURRENT_TIMESTAMP),  -- 田中一郎 (高血圧の治療)
(2, 2, 2, '500mg', '1日2回', '0', '2024-01-21', CURRENT_TIMESTAMP),  -- 鈴木二郎 (糖尿病の治療)
(3, 3, 3, '20mg', '1日1回', '0', '2024-03-11', CURRENT_TIMESTAMP);   -- 佐藤花子 (高血圧の治療)


-- 予約テーブルデータ作成
INSERT INTO reservations (reservation_id, patient_id, doctor_id, reservation_date, reservation_time, del_flag, created_at, updated_at)
VALUES 
(1, 1, 1, '2024-08-20', '09:30:00', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 山田太郎の予約
(2, 2, 1, '2024-08-20', '10:00:00', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 山田太郎の予約
(3, 1, 2, '2024-08-20', '11:00:00', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);  -- 佐藤花子の予約


--SQLD039:患者の性別別の診察件数と手術件数    
SELECT
    p.gender AS 性別
    , COUNT(DISTINCT c.consultation_id) AS 検査件数
    , COUNT(DISTINCT s.surgery_id) AS 手術件数 
FROM
    patients p 
    LEFT JOIN consultation_records c 
        ON p.patient_id = c.patient_id 
        AND c.del_flag = '0' 
    LEFT JOIN surgeries s 
        ON p.patient_id = s.patient_id 
        AND s.del_flag = '0' 
WHERE
    p.del_flag = '0' 
GROUP BY
    p.gender;
    
    
--SQLD040:削除フラグが立てられたレコードを除外した全データの取得
SELECT
    'patients' AS テーブル名
    , COUNT(*) AS 有効レコード数 
FROM
    patients p 
WHERE
    p.del_flag = '0' 
UNION ALL 
SELECT
    'doctor' AS テーブル名
    , COUNT(*) AS 有効レコード数 
FROM
    doctor d 
WHERE
    d.del_flag = '0' 
UNION ALL 
SELECT
    'consultation_records' AS テーブル名
    , COUNT(*) AS 有効レコード数 
FROM
    consultation_records c 
WHERE
    c.del_flag = '0' 
UNION ALL 
SELECT
    'surgeries' AS テーブル名
    , COUNT(*) AS 有効レコード数 
FROM
    surgeries s 
WHERE
    s.del_flag = '0' 
UNION ALL 
SELECT
    'medicines' AS テーブル名
    , COUNT(*) AS 有効レコード数 
FROM
    medicines m 
UNION ALL 
SELECT
    'prescription_medicines' AS テーブル名
    , COUNT(*) AS 有効レコード数 
FROM
    prescription_medicines pm 
WHERE
    pm.del_flag = '0';
    

--SQLD041:特定の専門分野を持つ医師による特定期間の診察と手術の統合情報
SELECT
    p.name AS "患者名"
    , c.consultation_date AS "診察日"
    , c.consultation_details AS "診察内容"
    , s.surgery_date AS "手術日"
    , s.surgery_name AS "手術名"
    , d.name AS "医師名" 
FROM
    patients p 
    LEFT JOIN consultation_records c 
        ON p.patient_id = c.patient_id 
        AND c.del_flag = '0' 
    LEFT JOIN doctor d 
        ON c.doctor_id = d.doctor_id 
        AND d.del_flag = '0' 
    LEFT JOIN surgeries s 
        ON p.patient_id = s.patient_id 
        AND d.doctor_id = s.doctor_id 
        AND s.surgery_date BETWEEN '2024-01-01' AND '2024-06-30' --ここに書くのは、WHEREに書くより良い
        AND s.del_flag = '0' 
WHERE
    c.consultation_date BETWEEN '2024-01-01' AND '2024-06-30' 
    AND d.specialty = '内科' 
    AND p.del_flag = '0';


--SQLD042:部門ごとの総給与と医師数
SELECT
    dep.department_name AS "部門名"
    , SUM(d.salary) AS "総給与"
    , COUNT(d.doctor_id) AS "医師数" 
FROM
    departments dep JOIN doctor d 
        ON dep.department_id = d.department_id
WHERE
    d.del_flag = '0' 
GROUP BY
    dep.department_name;
    

--SQLD043:患者の住所情報に基づく診察記録の統計
SELECT
    p.address AS "地域名"
    , COUNT(c.consultation_id) AS "診察記録の件数" 
FROM
    patients p JOIN consultation_records c 
        ON p.patient_id = c.patient_id 
WHERE
    p.del_flag = '0' 
    AND c.del_flag = '0' 
GROUP BY
    p.address;


--SQLD044:手術名に「緊急」文字を含む手術のリスト
SELECT
    p.name AS "患者名"
    , s.surgery_name AS "手術名"
    , s.surgery_date AS "手術日"
    , d.name AS "医師名" 
FROM
    surgeries s 
    LEFT JOIN patients p 
        ON s.patient_id = p.patient_id 
    LEFT JOIN doctor d 
        ON s.doctor_id = d.doctor_id 
WHERE
    s.surgery_name LIKE '%緊急%' 
    AND s.del_flag = '0';


--SQLD045:患者が過去1年間に処方された薬品のリスト
SELECT
    p.name AS "患者名"
    , m.medicine_name AS "薬品名"
    , pm.dosage AS "用量"
    , pm.frequency AS "服用頻度"
    , pm.created_at AS "処方日" 
FROM
    prescription_medicines pm 
    LEFT JOIN patients p 
        ON pm.patient_id = p.patient_id 
    LEFT JOIN medicines m 
        ON pm.medicine_id = m.medicine_id 
WHERE
    pm.created_at BETWEEN '2023-08-01' AND '2024-07-31' 
    AND p.del_flag = '0' 
    AND pm.del_flag = '0';
    
    
--SQLD046:特定の医師による診察の予約情報
SELECT
    p.name AS "患者名"
    , r.reservation_date AS "予約日"
    , r.reservation_time AS "予約時間"
    , d.name AS "担当医師" 
FROM
    reservations r JOIN patients p 
        ON r.patient_id = p.patient_id JOIN doctor d 
        ON r.doctor_id = d.doctor_id 
WHERE
    d.doctor_id = 1 
    AND r.reservation_date <= CURRENT_DATE+ cast( '30 days' as INTERVAL )
    AND r.del_flag = '0';


--SQLD047:患者の年齢別診察件数
SELECT
    CASE 
        WHEN EXTRACT(YEAR FROM AGE(p.date_of_birth)) BETWEEN 0 AND 19 
            THEN '0-19歳' 
        WHEN EXTRACT(YEAR FROM AGE(p.date_of_birth)) BETWEEN 20 AND 39 
            THEN '20-39歳' 
        WHEN EXTRACT(YEAR FROM AGE(p.date_of_birth)) BETWEEN 40 AND 59 
            THEN '40-59歳' 
        ELSE '60歳以上' 
        END AS 年齢層
    , COUNT(consultation_id) AS 診査件数 
FROM
    patients p JOIN consultation_records cr 
        ON p.patient_id = cr.patient_id 
WHERE
    p.del_flag = '0' 
    AND cr.del_flag = '0' 
GROUP BY
    年齢層;


--SQLD048:医師の勤務時間に基づく予約可能時間の取得

--SQLD049:全医師の給与に対する分析


--SQLD050:患者ごとの診察内容に基づく薬品処方パターンの分析
SELECT
    p.name AS "患者名"
    , cr.consultation_date AS "診察日"
    , cr.consultation_details AS "診察内容"
    , m.medicine_name AS "薬品名"
    , pm.dosage AS "用量"
    , pm.frequency AS "服用頻度" 
FROM
    consultation_records cr JOIN patients p 
        ON cr.patient_id = p.patient_id JOIN prescription_medicines pm 
        ON cr.patient_id = pm.patient_id JOIN medicines m 
        ON pm.medicine_id = m.medicine_id 
WHERE
    cr.consultation_details = '高血圧の診察' 
    AND cr.del_flag = '0'


--SQLD051:医師の入職日を基準とした勤続年数の計算
SELECT
    d.name AS "医師名"
    , d.specialty AS "専門分野"
    , d.joining_date AS "入職日"
    , EXTRACT(YEAR FROM AGE(CURRENT_DATE, joining_date)) AS 勤続年数 
FROM
    doctor d 
WHERE
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, joining_date)) >= 5 
    AND d.del_flag = '0';

