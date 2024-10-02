--データ全件削除--
delete from patients;
delete from examination_results;
delete from doctor;


--データ登録
INSERT INTO patients (patient_id, name, gender, date_of_birth, address, contact_number, emergency_contact, del_flag, created_at, updated_at) VALUES
(1, '山田太郎', '男性', '1985-04-23', '東京都渋谷区', '080-1234-5678', '080-8765-4321', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, '鈴木花子', '女性', '1990-11-30', '大阪府大阪市', '080-5678-1234', '080-4321-8765', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, '田中一郎', '男性', '1980-06-15', '北海道札幌市', '080-8765-4321', '080-1234-5678', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, '佐藤真一', '男性', '1975-08-25', '福岡県福岡市', '080-1122-3344', '080-2233-4455', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, '伊藤園子', '女性', '1988-03-05', '千葉県千葉市', '080-3344-5566', '080-4455-6677', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(6, '小林幸子', NULL, '1982-07-20', '愛知県名古屋市', '080-5566-7788', '080-6677-8899', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(7, '高橋健太', NULL, '1992-12-11', '神奈川県横浜市', '080-7788-9900', '080-8899-0011', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


--データ登録
-- 経験年数が10年以上の医師（5名）
INSERT INTO doctor (doctor_id, name, specialty, qualification, years_of_experience, contact_number, email, work_days, office_hours, department_id, joining_date, salary, status, del_flag, created_at, updated_at) VALUES
(1, '山田太郎', '内科', '医学博士', 15, '080-1234-5678', 'yamada@example.com', '月曜日から金曜日', '9:00-17:00', 1, '2010-04-01', 700000.00, '在籍', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, '鈴木一郎', '内科', '医学修士', 12, '080-5678-1234', 'suzuki@example.com', '火曜日から土曜日', '10:00-18:00', 2, '2008-05-15', 750000.00, '在籍', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, '田中恵美', '内科', '医学博士', 20, '080-8765-4321', 'tanaka@example.com', '水曜日から日曜日', '8:00-16:00', 3, '2003-09-10', 680000.00, '在籍', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, '伊藤浩司', '外科', '医学博士', 18, '080-2345-6789', 'ito@example.com', '月曜日から金曜日', '9:00-15:00', 4, '2002-03-20', 710000.00, '在籍', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, '佐藤絵里', '外科', '医学博士', 22, '080-5432-1987', 'sato@example.com', '火曜日から土曜日', '10:00-19:00', 5, '2000-07-30', 890000.00, '在籍', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 経験年数が10年未満の医師（3名）
INSERT INTO doctor (doctor_id, name, specialty, qualification, years_of_experience, contact_number, email, work_days, office_hours, department_id, joining_date, salary, status, del_flag, created_at, updated_at) VALUES
(6, '加藤次郎', '神経科', '医学修士', 8, '080-1122-3344', 'kato@example.com', '水曜日から日曜日', '11:00-20:00', 6, '2015-11-01', 660000.00, '在籍', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(7, '中村典子', '産婦人科', '医学博士', 5, '080-4455-6677', 'nakamura@example.com', '月曜日から金曜日', '9:00-17:00', 7, '2018-08-25', 640000.00, '在籍', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(8, '森本健', '眼科', '医学修士', 3, '080-5566-7788', 'morimoto@example.com', '火曜日から土曜日', '8:00-14:00', 8, '2020-04-15', 530000.00, '在籍', '0', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


SELECT p.name AS "患者名",e.examination_date AS "検査日",e.examination_type AS "検査種類",e.examination_result AS "検査結果"
FROM patients p
INNER JOIN examination_results e ON p.patient_id = e.patient_id
WHERE e.examination_result = '正常';

SELECT p.name AS "患者名", e.examination_date AS "検査日",e.examination_type AS "検査種類",e.examination_result AS "検査結果"
FROM patients p
LEFT JOIN examination_results e ON p.patient_id = e.patient_id;

SELECT p.name AS "患者名",e.examination_date AS "検査日",e.examination_type AS "検査種類",e.examination_result AS "検査結果"
FROM examination_results e
RIGHT JOIN patients p ON e.patient_id = p.patient_id;


SELECT name FROM patients WHERE date_of_birth BETWEEN '1985-01-01' AND '1985-12-31'
UNION
SELECT name FROM patients WHERE date_of_birth BETWEEN '1990-01-01' AND '1990-12-31';


SELECT name, contact_number FROM patients
WHERE contact_number IS NOT NULL;


SELECT name, contact_number FROM patients
WHERE contact_number IS NULL;


DELETE FROM patients
WHERE date_of_birth <= '1990-01-01';


SELECT gender,COUNT(*) AS patient_count
FROM patients
WHERE gender IS NOT NULL
GROUP BY gender;


SELECT specialty, COUNT(*) AS "経験年数"
FROM doctor
WHERE years_of_experience >= 10
GROUP BY specialty
HAVING COUNT(*) >= 3;
