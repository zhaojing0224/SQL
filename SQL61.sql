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

drop table reservations;
drop table surgeries;
drop table consultation_records;


-- 手術テーブル（surgeries）
CREATE TABLE surgeries (
    -- 手術ID
    surgery_id SERIAL PRIMARY KEY,
    -- 手術名
    surgery_name VARCHAR(255) NOT NULL,
    -- 手術日
    surgery_date DATE NOT NULL,
    -- 医師ID
    doctor_id INT NOT NULL,
    -- 患者ID
    patient_id INT NOT NULL,
    -- 削除フラグ
    del_flag CHAR(1) DEFAULT '0',
    -- 作成日時
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- 更新日時
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE surgeries IS '手術テーブル';
COMMENT ON COLUMN surgeries.surgery_id IS '手術の一意の識別子';
COMMENT ON COLUMN surgeries.surgery_name IS '手術の名称';
COMMENT ON COLUMN surgeries.surgery_date IS '手術の日付';
COMMENT ON COLUMN surgeries.doctor_id IS '手術を行った医師のID';
COMMENT ON COLUMN surgeries.patient_id IS '手術を受けた患者のID';
COMMENT ON COLUMN surgeries.del_flag IS '削除フラグ（0：未削除、1：削除済み）';
COMMENT ON COLUMN surgeries.created_at IS 'レコードの作成日時';
COMMENT ON COLUMN surgeries.updated_at IS 'レコードの更新日時';



-- 患者テーブルデータ作成
INSERT INTO patients (patient_id, name, gender, date_of_birth, address, contact_number, emergency_contact, del_flag, created_at, updated_at)
VALUES 
(1, '田中一郎', '男性', '1985-04-12', '東京都', '987-6543', '987-6544', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, '鈴木二郎', '男性', '1990-07-20', '神奈川県', '987-1111', '987-2222', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


-- 転院履歴テーブル（新規作成）
CREATE TABLE department_transfer_history (
    transfer_id SERIAL PRIMARY KEY,
    patient_id INT,
    old_department_id INT,
    new_department_id INT,
    transfer_date DATE,
    del_flag VARCHAR(1) DEFAULT '0',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 転院履歴データ作成
INSERT INTO department_transfer_history (patient_id, old_department_id, new_department_id, transfer_date)
VALUES 
(1, 1, 2, '2024-03-01'),
(2, 2, 1, '2024-05-15');


-- 医師テーブルデータ作成
INSERT INTO doctor (doctor_id, name, specialty, qualification, years_of_experience, contact_number, email, work_days, office_hours, department_id, joining_date, salary, status, del_flag, created_at, updated_at)
VALUES 
(1, '山田太郎', '外科', 'MD', 15, '123-4567', 'yamada@example.com', '月-金', '09:00-17:00', 1, '2020-01-15', 1200000, 'active', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, '佐藤花子', '内科', 'MD', 10, '123-8901', 'sato@example.com', '月-金', '09:00-18:00', 2, '2018-03-20', 1000000, 'active', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, '鈴木一郎', '外科', 'PhD', 20, '123-9999', 'suzuki@example.com', '月-金', '09:00-17:00', 1, '2015-02-25', 1300000, 'active', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


-- 診察記録テーブルデータ作成
INSERT INTO consultation_records (consultation_id, patient_id, doctor_id, consultation_date, consultation_details, del_flag, created_at, updated_at)
VALUES 
(1, 1, 1, '2024-05-01', '風邪の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 山田太郎
(2, 2, 2, '2024-05-10', '高血圧の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- 佐藤花子
(3, 3, 1, '2024-05-20', '胃痛の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- 山田太郎
(4, 4, 3, '2024-06-01', '腰痛の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP); -- 鈴木一郎

-- 手術テーブルデータ作成
INSERT INTO surgeries (surgery_id, surgery_name, surgery_date, doctor_id, patient_id, del_flag, created_at, updated_at)
VALUES 
(1, '胃切除手術', '2024-06-15', 1, 1, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 山田太郎
(2, '心臓バイパス手術', '2024-07-10', 1, 2, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- 山田太郎
(3, '盲腸手術', '2024-07-25', 3, 3, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- 鈴木一郎
(4, '胆嚢摘出術', '2024-08-01', 3, 4, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP); -- 鈴木一郎


-- 薬品テーブルデータ作成
INSERT INTO medicines (medicine_id, medicine_name, description, price)
VALUES 
(1, 'アスピリン', '痛みを軽減する', 100.00),
(2, 'メトホルミン', '糖尿病の治療薬', 200.00),
(3, 'リシノプリル', '高血圧の治療薬', 150.00);

-- 薬品処方テーブルデータ作成
INSERT INTO prescription_medicines (prescription_id, patient_id, medicine_id, dosage, frequency, del_flag, created_at, updated_at)
VALUES 
(1, 1, 3, '10mg', '1日1回', '0', '2024-02-16', CURRENT_TIMESTAMP),  -- 田中一郎
(2, 2, 2, '500mg', '1日2回', '0', '2024-03-02', CURRENT_TIMESTAMP);  -- 鈴木二郎


--SQLD061:医師の診察と手術のパフォーマンス分析
WITH doctor_performance AS ( 
    SELECT
        d.name AS 医師名
        , COUNT(DISTINCT cr.consultation_id) AS 総診察件数
        , COUNT(DISTINCT s.surgery_id) AS 総手術件数 
    FROM
        doctor d 
        LEFT JOIN consultation_records cr 
            ON d.doctor_id = cr.doctor_id 
            AND cr.del_flag = '0' 
        LEFT JOIN surgeries s 
            ON d.doctor_id = s.doctor_id 
            AND s.del_flag = '0' 
    WHERE
        d.del_flag = '0' 
    GROUP BY
        d.name
) 
SELECT
    dp.医師名
    , dp.総診察件数
    , dp.総手術件数
    , ROUND(dp.総手術件数 / dp.総診察件数, 2) AS 診察1件あたりの手術件数 
FROM
    doctor_performance dp 
WHERE
    dp.総診察件数 > 0 
    AND dp.総手術件数 > 0;


