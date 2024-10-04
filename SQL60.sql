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

-- 診察記録テーブルデータ作成
INSERT INTO consultation_records (consultation_id, patient_id, doctor_id, consultation_date, consultation_details, del_flag, created_at, updated_at)
VALUES 
(1, 1, 1, '2024-01-01', '風邪の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 田中一郎
(2, 1, 2, '2024-01-10', '定期健診', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),   -- 田中一郎
(3, 1, 1, '2024-02-15', 'フォローアップ', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- 田中一郎
(4, 2, 2, '2024-03-01', '胃痛の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);  -- 鈴木二郎


-- 手術テーブルデータ作成
INSERT INTO surgeries (surgery_id, surgery_name, surgery_date, doctor_id, patient_id, del_flag, created_at, updated_at)
VALUES 
(1, '胃切除手術', '2024-03-15', 1, 1, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 田中一郎
(2, '胆嚢摘出術', '2024-03-20', 2, 2, '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP); -- 鈴木二郎


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


--SQLD058:特定部門の医師による診察件数と手術件数の比較
SELECT
    d.name AS 医師名
    , COALESCE(COUNT(DISTINCT cr.consultation_id), 0) AS 診察件数
    , COALESCE(COUNT(DISTINCT s.surgery_id), 0) AS 手術件数 
FROM
    doctor d 
    LEFT JOIN consultation_records cr 
        ON d.doctor_id = cr.doctor_id 
        AND cr.del_flag = '0' 
    LEFT JOIN surgeries s 
        ON d.doctor_id = s.doctor_id 
        AND s.del_flag = '0' 
WHERE
    d.department_id = ( 
        SELECT
            department_id 
        FROM
            departments 
        WHERE
            department_name = '外科'
    ) 
GROUP BY
    d.name;


--SQLD059:医師の勤務日と勤務時間に基づく診察予約の分析
SELECT
    d.name AS 医師名
    , TO_CHAR(r.reservation_date, 'Days') AS 予約曜日
    , COUNT(r.reservation_id) AS 予約件数 
FROM
    doctor d JOIN reservations r 
        ON d.doctor_id = r.doctor_id 
WHERE
    r.del_flag = '0' 
GROUP BY
    d.name
    , TO_CHAR(r.reservation_date, 'Days') 
ORDER BY
    d.name
    , TO_CHAR(r.reservation_date, 'Days');


--SQLD060:複数の条件を満たす患者の治療パスの分析
WITH consultation_dates AS ( 
    SELECT
        patient_id
        , MIN(consultation_date) AS first_consultation_date
        , MAX(consultation_date) AS last_consultation_date 
    FROM
        consultation_records 
    WHERE
        del_flag = '0' 
    GROUP BY
        patient_id 
    HAVING
        COUNT(consultation_id) >= 2
) 
SELECT
    p.name AS 患者名
    , cd.first_consultation_date AS 最初の診察日
    , cd.last_consultation_date AS 最後の診察日
    , s.surgery_date AS 手術日
    , STRING_AGG( 
        DISTINCT m.medicine_name
        , ', ' 
        ORDER BY
            m.medicine_name ASC
    ) AS 処方薬品リスト 
FROM
    patients p JOIN consultation_dates cd 
        ON p.patient_id = cd.patient_id JOIN surgeries s 
            ON p.patient_id = s.patient_id 
            AND s.surgery_date BETWEEN cd.last_consultation_date AND (cd.last_consultation_date + INTERVAL '30 DAY')
             JOIN prescription_medicines pm 
                ON p.patient_id = pm.patient_id 
                AND pm.created_at BETWEEN cd.first_consultation_date AND s.surgery_date JOIN medicines m 
                    ON pm.medicine_id = m.medicine_id 
WHERE
    p.del_flag = '0' 
    AND s.del_flag = '0' 
    AND pm.del_flag = '0' 
GROUP BY
    p.name
    , cd.first_consultation_date
    , cd.last_consultation_date
    , s.surgery_date;


--SQLD060:複数の条件を満たす患者の治療パスの分析
SELECT
    p.name AS 患者名
    , first_consultation_date AS 最初の診察日
    , last_consultation_date AS 最後の診察日
    , s.surgery_date AS 手術日
    , pr.prescribed_medicines AS 処方された薬品リスト 
FROM
    ( 
        SELECT
            c.patient_id
            , MIN(c.consultation_date) AS first_consultation_date
            , MAX(c.consultation_date) AS last_consultation_date
            , COUNT(c.consultation_id) AS consultation_count 
        FROM                                                                 --FROM 子句：使用一个子查询（命名为 c）来聚合诊察记录。                                                             
            consultation_records c 
        WHERE
            c.del_flag = '0' 
        GROUP BY
            c.patient_id 
        HAVING
            COUNT(c.consultation_id) >= 2
    ) AS c JOIN patients p 
        ON c.patient_id = p.patient_id JOIN ( 
            SELECT
                s.patient_id
                , s.surgery_date
                , s.surgery_name 
            FROM
                surgeries s 
            WHERE
                s.del_flag = '0'
        ) AS s 
        ON c.patient_id = s.patient_id 
        AND s.surgery_date BETWEEN c.last_consultation_date AND c.last_consultation_date + INTERVAL '30 days'
         JOIN ( 
            SELECT
                p.patient_id
                , STRING_AGG(m.medicine_name, ', ') AS prescribed_medicines 
            FROM
                prescription_medicines p JOIN medicines m 
                    ON p.medicine_id = m.medicine_id 
            WHERE
                p.del_flag = '0' 
            GROUP BY
                p.patient_id
        ) AS pr 
        ON c.patient_id = pr.patient_id 
WHERE
    p.del_flag = '0';
