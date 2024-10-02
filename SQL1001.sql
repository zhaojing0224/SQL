-- 薬品テーブル（medicines）
CREATE TABLE medicines (
    -- 薬品ID
    medicine_id SERIAL PRIMARY KEY,
    -- 薬品名
    medicine_name VARCHAR(100) NOT NULL,
    -- 説明
    description TEXT,
    -- 価格
    price DECIMAL(10,2) NOT NULL
);

COMMENT ON TABLE medicines IS '薬品テーブル';
COMMENT ON COLUMN medicines.medicine_id IS '薬品の一意の識別子';
COMMENT ON COLUMN medicines.medicine_name IS '薬品の名前';
COMMENT ON COLUMN medicines.description IS '薬品の説明';
COMMENT ON COLUMN medicines.price IS '薬品の価格';

drop table medicines;

--データ全件削除--
delete from patients;
delete from examination_results;
delete from doctor;
delete from consultation_records;
delete from surgeries ;
delete from departments;

-- 患者テーブルデータ作成
INSERT INTO patients (patient_id, name, gender, date_of_birth, address, contact_number, emergency_contact, del_flag, created_at, updated_at)
VALUES 
(1, '田中一郎', '男性', '1985-04-12', '東京都', '987-6543', '987-6544', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, '鈴木二郎', '男性', '1990-07-20', '神奈川県', '987-1111', '987-2222', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 医師テーブルデータ作成
INSERT INTO doctor (doctor_id, name, specialty, qualification, years_of_experience, contact_number, email, work_days, office_hours, department_id, joining_date, salary, status, del_flag, created_at, updated_at)
VALUES 
(1, '山田太郎', '外科', 'MD', 15, '123-4567', 'yamada@example.com', '月-金', '9:00-17:00', 1, '2020-01-15', 1200000, 'active', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, '佐藤花子', '内科', 'MD', 10, '123-8901', 'sato@example.com', '月-金', '9:00-18:00', 2, '2018-03-20', 1000000, 'active', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, '鈴木一郎', '外科', 'PhD', 20, '123-9999', 'suzuki@example.com', '月-金', '9:00-17:00', 1, '2015-02-25', 1300000, 'active', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


-- 薬品テーブルデータ作成
INSERT INTO medicines (medicine_id, medicine_name, description, price)
VALUES 
(1, 'アスピリン', '痛みを軽減する', 100.00),
(2, 'メトホルミン', '糖尿病の治療薬', 200.00),
(3, 'リシノプリル', '高血圧の治療薬', 150.00);

-- 薬品処方テーブルデータ作成
INSERT INTO prescription_medicines (prescription_id, patient_id, medicine_id, dosage, frequency, del_flag, created_at, updated_at)
VALUES 
(1, 1, 1, '100mg', '1日1回', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 田中一郎への処方
(2, 1, 2, '500mg', '1日2回', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 田中一郎への処方
(3, 2, 3, '10mg', '1日1回', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),   -- 鈴木二郎への処方
(4, 1, 3, '20mg', '1日1回', '1', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);   -- 削除された処方（田中一郎）


-- 診察記録テーブルデータ作成
INSERT INTO consultation_records (consultation_id, patient_id, doctor_id, consultation_date, consultation_details, del_flag, created_at, updated_at)
VALUES 
(1, 1, 1, '2024-03-15', '風邪の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 山田太郎
(2, 1, 2, '2024-04-20', '高血圧の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- 佐藤花子
(3, 2, 3, '2024-05-10', '胃痛の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);   -- 鈴木一郎


-- 部門テーブルデータ作成
INSERT INTO departments (department_id, department_name, description)
VALUES 
(1, '外科', '手術を担当する部門'),
(2, '内科', '内科治療を担当する部門'),
(3, '小児科', '子供の診察を担当する部門');


-- 手術テーブルデータ作成
INSERT INTO surgeries (surgery_id, surgery_name, surgery_date, doctor_id, patient_id, del_flag, created_at, updated_at)
VALUES 
(1, '心臓バイパス手術', '2024-05-15', 1, 1, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 山田太郎
(2, '胃切除手術', '2024-06-10', 1, 2, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),        -- 山田太郎
(3, '脳腫瘍摘出手術', '2024-07-20', 3, 3, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);   -- 鈴木一郎


--SQLD030:特定期間内に行われた手術の一覧
SELECT
    p.name AS "患者名"
    , s.surgery_name AS "手術名"
    , s.surgery_date AS "手術日"
    , doc.name AS "医者名"
    , dep.department_name AS "手術部門" 
FROM
    surgeries s JOIN patients p 
        ON s.patient_id = p.patient_id JOIN doctor doc 
        ON s.doctor_id = doc.doctor_id JOIN departments dep 
        ON doc.department_id = dep.department_id 
WHERE
    s.surgery_date BETWEEN '2023-01-01' AND '2023-12-31' 
    AND p.del_flag = '0' 
    AND s.doctor_id = 1;


--SQLD031:患者ごとの最新診察記録を取得
SELECT
    p.name AS "患者名"
    , c.consultation_date AS "診察日"
    , c.consultation_details AS "診察内容"
    , d.name AS "担当医" 
FROM
    consultation_records c JOIN patients p 
        ON c.patient_id = p.patient_id JOIN doctor d 
        ON c.doctor_id = d.doctor_id 
WHERE
    p.del_flag = '0' 
    AND c.consultation_date = ( 
        SELECT
            MAX(c2.consultation_date) 
        FROM
            consultation_records c2 
        WHERE
            c2.patient_id = c.patient_id 
            and c2.del_flag = '0'
    )


--SQLD032:特定の専門分野の医師が担当したすべての患者
SELECT
    p.name AS "患者名"
    , c.consultation_date AS "診察日"
    , c.consultation_details AS "診察内容"
    , d.name AS "担当医" 
FROM
    consultation_records c JOIN patients p 
        ON c.patient_id = p.patient_id JOIN doctor d 
        ON c.doctor_id = d.doctor_id 
WHERE
    d.specialty = '内科' 
    AND p.del_flag = '0';


--SQLD033:特定患者に対する薬品処方の履歴
SELECT
    p.name AS 患者名
    , m.medicine_name AS 薬品名
    , pm.dosage AS 用量
    , pm.frequency AS 服用頻度
    , pm.created_at AS 処方日 
FROM
    prescription_medicines pm JOIN patients p 
        ON pm.patient_id = p.patient_id JOIN medicines m 
        ON pm.medicine_id = m.medicine_id 
WHERE
    pm.patient_id = 1
    AND pm.del_flag = '0';


--SQLD034:診察記録と手術記録の統合情報を取得
SELECT
    p.name AS 患者名
    , c.consultation_date AS 診察日
    , c.consultation_details AS 診察内容
    , s.surgery_date AS 手術日
    , s.surgery_name AS 手術名
    , dc.name AS 診察担当医師名
    , ds.name AS 手術担当医師名 
FROM
    patients p 
    LEFT JOIN consultation_records c 
        ON p.patient_id = c.patient_id 
        AND c.del_flag = '0' 
    LEFT JOIN surgeries s 
        ON p.patient_id = s.patient_id 
        AND s.del_flag = '0' 
    LEFT JOIN doctor dc 
        ON c.doctor_id = dc.doctor_id 
        AND dc.del_flag = '0' 
    LEFT JOIN doctor ds 
        ON s.doctor_id = ds.doctor_id 
        AND ds.del_flag = '0' 
WHERE
    p.del_flag = '0';


--SQLD035:経験年数が10年以上の医師の詳細情報
SELECT
    d.name AS 医師名
    , d.specialty AS 専門分野
    , d.qualification AS 資格
    , d.years_of_experience AS 経験年数
    , d.work_days AS 勤務日
    , d.office_hours AS 勤務時間
    , dep.department_name AS 部門名 
FROM
    doctor d JOIN departments dep 
        ON d.department_id = dep.department_id 
WHERE
    d.years_of_experience >= 10 
    AND d.del_flag = '0';


--SQLD036:医師ごとの手術回数と総収入を計算
SELECT
    d.name AS 医師名
    , d.specialty AS 専門分野
    , COUNT(s.surgery_id) AS 手術回数
    , SUM(d.salary) AS 総収入 
FROM
    doctor d JOIN surgeries s 
        ON d.doctor_id = s.doctor_id 
WHERE
    d.del_flag = '0' 
    AND s.del_flag = '0' 
GROUP BY
    d.name
    , d.specialty;


--SQLD037:部門ごとの医師の数と平均経験年数を計算
SELECT
    dep.department_name AS 部門名
    , COUNT(d.doctor_id) AS 医師の人数
    , AVG(d.years_of_experience) AS 平均経験年数 
FROM
    departments dep JOIN doctor d 
        ON dep.department_id = d.department_id 
WHERE
    d.del_flag = '0' 
GROUP BY
    dep.department_name;


--SQLD038:特定の資格を持つ医師による診察記録
SELECT
    p.name AS 患者名
    , c.consultation_date AS 診察日
    , c.consultation_details AS 診察内容
    , d.name AS 医師名
    , d.specialty AS 専門分野 
FROM
    consultation_records c JOIN patients p 
        ON c.patient_id = p.patient_id JOIN doctor d 
        ON c.doctor_id = d.doctor_id 
WHERE
    d.qualification = 'MD' 
    AND c.del_flag = '0';


--SQLD039:患者の性別別の診察件数と手術件数

