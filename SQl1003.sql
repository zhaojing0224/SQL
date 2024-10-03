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


-- 予約テーブル（reservations）
CREATE TABLE reservations (
    -- 予約ID
    reservation_id SERIAL PRIMARY KEY,
    -- 患者ID
    patient_id INT NOT NULL,
    -- 医師ID
    doctor_id INT NOT NULL,
    -- 予約日
    reservation_date DATE NOT NULL,
    -- 予約時間
    reservation_time TIME NOT NULL,
    -- 削除フラグ
    del_flag CHAR(1) DEFAULT '0',
    -- 作成日時
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- 更新日時
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE reservations IS '予約テーブル';
COMMENT ON COLUMN reservations.reservation_id IS '予約の一意の識別子';
COMMENT ON COLUMN reservations.patient_id IS '予約をした患者のID';
COMMENT ON COLUMN reservations.doctor_id IS '予約された医師のID';
COMMENT ON COLUMN reservations.reservation_date IS '予約の日付';
COMMENT ON COLUMN reservations.reservation_time IS '予約の時間';
COMMENT ON COLUMN reservations.del_flag IS '削除フラグ（0：未削除、1：削除済み）';
COMMENT ON COLUMN reservations.created_at IS 'レコードの作成日時';
COMMENT ON COLUMN reservations.updated_at IS 'レコードの更新日時';




-- 患者テーブルデータ作成
INSERT INTO patients (patient_id, name, gender, date_of_birth, address, contact_number, emergency_contact, del_flag, created_at, updated_at)
VALUES 
(1, '田中一郎', '男性', '1985-04-12', '東京都', '987-6543', '987-6544', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, '鈴木二郎', '男性', '1990-07-20', '神奈川県', '987-1111', '987-2222', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 診察記録テーブルデータ作成
INSERT INTO consultation_records (consultation_id, patient_id, doctor_id, consultation_date, consultation_details, del_flag, created_at, updated_at)
VALUES 
(1, 1, 1, '2024-05-01', '風邪の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 山田太郎
(2, 2, 2, '2024-05-10', '高血圧の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- 佐藤花子
(3, 3, 1, '2024-05-20', '胃痛の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), -- 山田太郎
(4, 4, 3, '2024-06-01', '腰痛の診察', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP); -- 鈴木一郎


-- 部門テーブルデータ作成
INSERT INTO departments (department_id, department_name, description)
VALUES 
(1, '外科', '手術を担当する部門'),
(2, '内科', '内科治療を担当する部門');


-- 医師テーブルデータ作成
INSERT INTO doctor (doctor_id, name, specialty, qualification, years_of_experience, contact_number, email, work_days, office_hours, department_id, joining_date, salary, status, del_flag, created_at, updated_at)
VALUES 
(1, '山田太郎', '外科', 'MD', 15, '123-4567', 'yamada@example.com', '月-金', '09:00-17:00', 1, '2020-01-15', 1200000, 'active', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, '佐藤花子', '内科', 'MD', 10, '123-8901', 'sato@example.com', '月-金', '09:00-18:00', 2, '2018-03-20', 1000000, 'active', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, '鈴木一郎', '外科', 'PhD', 20, '123-9999', 'suzuki@example.com', '月-金', '09:00-17:00', 1, '2015-02-25', 1300000, 'active', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


-- 予約テーブルデータ作成
INSERT INTO reservations (reservation_id, patient_id, doctor_id, reservation_date, reservation_time, del_flag, created_at, updated_at)
VALUES 
(1, 1, 1, '2024-08-19', '10:00:00', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 月曜日
(2, 2, 1, '2024-08-20', '11:00:00', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 火曜日
(3, 3, 1, '2024-08-21', '09:30:00', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 水曜日
(4, 4, 2, '2024-08-21', '14:00:00', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),  -- 水曜日
(5, 1, 2, '2024-08-22', '16:00:00', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);  -- 木曜日


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


--SQLD052:診察と手術の間隔日数の計算
SELECT
    p.name AS "患者名"
    , cr.consultation_date AS "診察日"
    , s.surgery_date AS "手術日"
    , (s.surgery_date - cr.consultation_date) AS "間隔日数" 
FROM
    consultation_records cr JOIN patients p 
        ON cr.patient_id = p.patient_id JOIN surgeries s 
        ON cr.patient_id = s.patient_id 
WHERE
    cr.del_flag = '0' 
    AND s.del_flag = '0';


--SQLD053:医師ごとの手術の成功率
SELECT
    d.name AS 医師名
    , COUNT(s.surgery_id) AS 総手術件数
    , SUM( 
        CASE 
            WHEN s.success_flag = '1' 
                THEN 1 
            ELSE 0 
            END
    ) AS 成功手術件数
    , ROUND(                                             --ROUND() 是一个 SQL 函数，用于将数字四舍五入到指定的小数位数。
        ( 
            SUM( 
                CASE 
                    WHEN s.success_flag = '1' 
                        THEN 1 
                    ELSE 0 
                    END
            ) * 100.0 / COUNT(s.surgery_id)
        ) 
        , 2                                              --ROUND(..., 2) 表示将计算结果（成功率百分比）保留到 小数点后两位。
    ) AS 成功率 
FROM
    doctor d JOIN surgeries s 
        ON d.doctor_id = s.doctor_id 
WHERE
    s.del_flag = '0' 
GROUP BY
    d.name;



--SQLD054:部門ごとの医師の平均年収
SELECT
    dep.department_name AS 部門名
    , AVG(d.salary) AS 平均年収 
FROM
    doctor d JOIN departments dep 
        ON d.department_id = dep.department_id 
WHERE
    d.del_flag = '0' 
GROUP BY
    dep.department_name;


--SQLD055:特定薬品の処方回数の分析
SELECT
    m.medicine_name AS 薬品名
    , COUNT(pm.prescription_id) AS 処方回数 
FROM
    medicines m JOIN prescription_medicines pm 
        ON m.medicine_id = pm.medicine_id 
WHERE
    pm.created_at BETWEEN '2023-08-01' AND '2024-07-31' 
    AND pm.del_flag = '0' 
    AND m.medicine_name = 'リシノプリル' 
GROUP BY
    m.medicine_name;


--SQLD056:予約のキャンセル率分析
SELECT
    d.name AS 医師名
    , COUNT(r.reservation_id) AS 総予約件数
    , SUM( 
        CASE 
            WHEN r.status = 'cancelled' 
                THEN 1 
            ELSE 0 
            END
    ) AS キャンセルされた予約件数
    , ROUND( 
        ( 
            SUM( 
                CASE 
                    WHEN r.status = 'cancelled' 
                        THEN 1 
                    ELSE 0 
                    END
            ) * 100.0 / COUNT(r.reservation_id)
        ) 
        , 2
    ) AS キャンセル率 
FROM
    doctor d JOIN reservations r 
        ON d.doctor_id = r.doctor_id 
WHERE
    r.del_flag = '0' 
GROUP BY
    d.name;



--SQLD057:患者の治療期間の分析
SELECT
    p.name AS 患者名
    , MIN(cr.consultation_date) AS 最初の診察日
    , MAX(cr.consultation_date) AS 最後の診察日
    , ( 
        MAX(cr.consultation_date) - MIN(cr.consultation_date)
    ) AS 治療期間 
FROM
    patients p JOIN consultation_records cr 
        ON p.patient_id = cr.patient_id 
WHERE
    cr.del_flag = '0' 
GROUP BY
    p.name 
HAVING                                                                     --用于在数据分组之后，过滤基于聚合结果的条件。
     (MAX(cr.consultation_date) - MIN(cr.consultation_date)) >= 30;


--SQLD058:特定部門の医師による診察件数と手術件数の比較
SELECT
    d.name AS 医師名
    , COALESCE(COUNT(DISTINCT cr.consultation_id), 0) AS 診察件数          --COALESCE 是 SQL 中的一个函数，用于返回第一个非 NULL 的值。如果为 NULL，那么使用 COALESCE 将其替换为 0
    , COALESCE(COUNT(DISTINCT s.surgery_id), 0) AS 手術件数 
FROM
    doctor d 
    LEFT JOIN consultation_records cr 
        ON d.doctor_id = cr.doctor_id 
    LEFT JOIN surgeries s 
        ON d.doctor_id = s.doctor_id 
WHERE
    cr.del_flag = '0' 
    AND s.del_flag = '0' 
    AND d.del_flag = '0' 
    AND d.department_id = ( 
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
    , TO_CHAR(r.reservation_date, 'Day') AS 予約曜日                        --TO_CHAR(r.reservation_date, 'Day') AS 予約が行われた曜日：将预约日期转换为星期几的名称。
    , COUNT(r.reservation_id) AS 予約件数 
FROM
    doctor d JOIN reservations r 
        ON d.doctor_id = r.doctor_id 
WHERE
    r.del_flag = '0' 
GROUP BY
    d.name, TO_CHAR(r.reservation_date, 'Day')
ORDER BY
    d.name
    , TO_CHAR(r.reservation_date, 'Day');

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


--SQLD061:医師の診察と手術のパフォーマンス分析
WITH doctor_performance AS (                                     --WITH doctor_performance AS (...):用来计算每个医生的诊察件数和手術件数。是公用表表达式也叫CTE,是为了将查询中的某些子查询部分提取出来，使得主查询更易读、更模块化。
    SELECT
        d.name AS 医師名
        , COUNT(DISTINCT cr.consultation_id) AS 診察件数
        , COUNT(DISTINCT s.surgery_id) AS 手術件数
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
    , dp.診察件数
    , dp.手術件数
    , ROUND(dp.手術件数 / dp.診察件数, 2) AS 診察1件あたりの手術件数 
FROM
    doctor_performance dp 
WHERE
    dp.診察件数 > 0 
    AND dp.手術件数 > 0;  --过滤掉没有诊察记录或手术记录的医生，只保留至少有一件诊察和手术记录的医生。


--SQLD062:患者の転院前後の診察と手術の比較分析
