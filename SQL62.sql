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
delete from department_transfer_history;

drop table reservations;
drop table surgeries;
drop table consultation_records;
drop table department_transfer_history;


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

-- 診察記録テーブル作成
CREATE TABLE consultation_records (
    consultation_id SERIAL PRIMARY KEY,   -- 診察ID
    patient_id INT NOT NULL,              -- 患者ID
    doctor_id INT NOT NULL,               -- 医師ID
    consultation_date DATE NOT NULL,      -- 診察日
    consultation_details TEXT NOT NULL,   -- 診察内容
    department_id INT NOT NULL,           -- 部門ID
    del_flag CHAR(1) DEFAULT '0',         -- 削除フラグ（0: 未削除, 1: 削除済み）
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 作成日時
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- 更新日時
);


-- 手術テーブル作成
CREATE TABLE surgeries (
    surgery_id SERIAL PRIMARY KEY,         -- 手術ID
    surgery_name VARCHAR(255) NOT NULL,    -- 手術名
    surgery_date DATE NOT NULL,            -- 手術日
    doctor_id INT NOT NULL,                -- 医師ID
    patient_id INT NOT NULL,               -- 患者ID
    department_id INT NOT NULL,            -- 部門ID
    del_flag CHAR(1) DEFAULT '0',          -- 削除フラグ（0: 未削除, 1: 削除済み）
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 作成日時
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- 更新日時
);



-- 患者テーブルデータ作成
INSERT INTO patients (patient_id, name, gender, date_of_birth, address, contact_number, emergency_contact, del_flag, created_at, updated_at)
VALUES 
(1, '田中一郎', '男性', '1985-04-12', '東京都', '987-6543', '987-6544', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, '鈴木二郎', '男性', '1990-07-20', '神奈川県', '987-1111', '987-2222', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


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
INSERT INTO consultation_records (consultation_id, patient_id, doctor_id, consultation_date, consultation_details, department_id, del_flag, created_at, updated_at)
VALUES 
(1, 1, 1, '2024-01-15', '風邪の診察', 1, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 転院前
(2, 1, 2, '2024-02-10', '定期健診', 1, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),   -- 転院前
(3, 1, 3, '2024-03-10', 'フォローアップ', 2, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- 転院後
(4, 2, 1, '2024-04-01', '高血圧の診察', 2, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- 転院前
(5, 2, 3, '2024-06-01', '胃痛の診察', 1, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);  -- 転院後

-- 手術テーブルデータ作成
INSERT INTO surgeries (surgery_id, surgery_name, surgery_date, doctor_id, patient_id, department_id, del_flag, created_at, updated_at)
VALUES 
(1, '胃切除手術', '2024-01-20', 1, 1, 1, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 転院前
(2, '胆嚢摘出術', '2024-04-10', 2, 1, 2, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- 転院後
(3, '心臓バイパス手術', '2024-02-15', 2, 2, 2, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- 転院前
(4, '盲腸手術', '2024-07-05', 3, 2, 1, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP); -- 転院後


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




--SQLD062:患者の転院前後の診察と手術の比較分析
WITH before_transfer AS ( 
    SELECT
        p.patient_id
        , COUNT(DISTINCT cr.consultation_id) AS 転院前の診察件数
        , COUNT(DISTINCT s.surgery_id) AS 転院前の手術件数 
    FROM
        department_transfer_history dt JOIN patients p 
            ON dt.patient_id = p.patient_id 
        LEFT JOIN consultation_records cr 
            ON p.patient_id = cr.patient_id 
            AND cr.department_id = dt.old_department_id 
            AND cr.consultation_date < dt.transfer_date 
            AND cr.del_flag = '0' 
        LEFT JOIN surgeries s 
            ON p.patient_id = s.patient_id 
            AND s.department_id = dt.old_department_id 
            AND s.surgery_date < dt.transfer_date 
            AND S.del_flag = '0' 
    WHERE
        dt.del_flag = '0' 
    GROUP BY
        p.patient_id
) 
, after_transfer AS ( 
    SELECT
        p.patient_id
        , COUNT(DISTINCT cr.consultation_id) AS 転院後の診察件数
        , COUNT(DISTINCT s.surgery_id) AS 転院後の手術件数 
    FROM
        department_transfer_history dt JOIN patients p 
            ON dt.patient_id = p.patient_id 
        LEFT JOIN consultation_records cr 
            ON p.patient_id = cr.patient_id 
            AND cr.department_id = dt.new_department_id 
            AND cr.consultation_date >= dt.transfer_date 
            AND cr.del_flag = '0' 
        LEFT JOIN surgeries s 
            ON p.patient_id = s.patient_id 
            AND s.department_id = dt.new_department_id 
            AND s.surgery_date >= dt.transfer_date 
            AND S.del_flag = '0' 
    WHERE
        dt.del_flag = '0' 
    GROUP BY
        p.patient_id
) 
SELECT
    p.name AS 患者名
    , bt.転院前の診察件数
    , aft.転院後の診察件数
    , bt.転院前の手術件数
    , aft.転院後の手術件数
FROM
    patients p JOIN before_transfer bt 
        ON p.patient_id = bt.patient_id JOIN after_transfer aft 
            ON p.patient_id = aft.patient_id 
WHERE
    bt.転院前の診察件数 > aft.転院後の診察件数 
    OR bt.転院前の手術件数 > aft.転院後の手術件数;






