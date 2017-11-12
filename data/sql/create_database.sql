CREATE DATABASE IF NOT EXISTS rootham;

USE rootham;

-- list of unique NOC codes with primary job title
CREATE TABLE IF NOT EXISTS noc_uniques (
  noc_code CHAR(4) PRIMARY KEY,
  base_description_en VARCHAR(500),
  base_description_fr VARCHAR(500)
);

-- Basic info for job coding in Canada
CREATE TABLE IF NOT EXISTS noc_codes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  noc_code CHAR(4),
  description_en VARCHAR(500),
  description_fr VARCHAR(500),
  element_type CHAR(4),
  element_type_label_en VARCHAR(500),
  element_type_label_fr VARCHAR(500),
  FOREIGN KEY (noc_code)
    REFERENCES noc_uniques (noc_code)
    ON DELETE CASCADE
);

-- Task descriptions from dataset 17
CREATE TABLE IF NOT EXISTS noc_tasks(
  task_code CHAR(5) PRIMARY KEY,
  description_en VARCHAR(500),
  description_fr VARCHAR(500)
);

-- Skill descriptions from dataset 17
CREATE TABLE IF NOT EXISTS noc_skills(
  skill_code CHAR(3) PRIMARY KEY,
  description_en VARCHAR(500),
  description_fr VARCHAR(500)
);

-- Skill levels from dataset 17
CREATE TABLE IF NOT EXISTS noc_skills_levels(
  skill_code CHAR(3),
  level_code CHAR(2),
  description_en VARCHAR(500),
  description_fr VARCHAR(500),
  FOREIGN KEY (skill_code)
    REFERENCES noc_skills(skill_code)
    ON DELETE CASCADE,
  CONSTRAINT skill_level_pk PRIMARY KEY (skill_code, level_code)
);

-- Education Codes from dataset 17
CREATE TABLE IF NOT EXISTS noc_skills_education(
  education_training_code CHAR(3) PRIMARY KEY,
  description_en VARCHAR(500),
  description_fr VARCHAR(500)
);

-- Table linking skills & tasks to NOC codes from dataset 17
CREATE TABLE IF NOT EXISTS noc_skills_tasks(
  id INT PRIMARY KEY AUTO_INCREMENT,
  task_code CHAR(5),
  noc_code CHAR(4),
  skill_code CHAR(3),
  skill_level CHAR(3),
  education_training CHAR(3),
  FOREIGN KEY (task_code)
    REFERENCES noc_tasks (task_code)
    ON DELETE CASCADE,
  FOREIGN KEY (noc_code)
    REFERENCES noc_uniques (noc_code)
    ON DELETE CASCADE,
  FOREIGN KEY (skill_code)
    REFERENCES noc_skills (skill_code)
    ON DELETE CASCADE,
  FOREIGN KEY (education_training)
    REFERENCES noc_skills_education (education_training_code)
    ON DELETE CASCADE
);

-- University programs and faculty to allow us to link NOC codes & University
-- Lookup of program codes & descriptions
CREATE TABLE IF NOT EXISTS univ_programs(
  program_code CHAR(3) PRIMARY KEY,
  description_en VARCHAR(500),
  description_fr VARCHAR(500)
);

-- Table linking program areas, NOC and employment levels per year
CREATE TABLE IF NOT EXISTS univ_noc_employment(
  id INT PRIMARY KEY AUTO_INCREMENT,
  year YEAR(4),
  program_code CHAR(3),
  noc_code CHAR(4),
  employed INT,
  self_employed INT,
  FOREIGN KEY (program_code) REFERENCES univ_programs(program_code),
  FOREIGN KEY (noc_code) references noc_uniques(noc_code)
);

-- Lookup table with meanings of creditial codes found throughout files
CREATE TABLE IF NOT EXISTS credentials (
  credential_code CHAR(3) PRIMARY KEY,
  description_en VARCHAR(500),
  description_fr VARCHAR(500)
);

-- Table 21 has details on specific programs (very detailed).
-- These ARE NOT currently linked to univ_programs (though they should be)
CREATE TABLE IF NOT EXISTS univ_programs_specific(
  specific_program_code CHAR(5) PRIMARY KEY,
  program_code CHAR(3),
  description_en VARCHAR(500),
  description_fr VARCHAR(500),
  FOREIGN KEY (program_code)
    REFERENCES univ_programs (program_code)
    ON DELETE SET NULL
);

-- Table with details on area of study, credential level, job category & # of job_desc_fr
CREATE TABLE IF NOT EXISTS noc_specific_program(
  id INT PRIMARY KEY,
  noc_code CHAR(4),
  credential_code CHAR(3),
  specific_program_code CHAR(5),
  job_count INT,
  FOREIGN KEY (noc_code)
    REFERENCES noc_uniques (noc_code)
    ON DELETE CASCADE,
  FOREIGN KEY (credential_code)
    REFERENCES credentials (credential_code)
    ON DELETE CASCADE,
  FOREIGN KEY (specific_program_code)
    REFERENCES univ_programs_specific (specific_program_code)
    ON DELETE CASCADE
);

-- Table 23 - Automation Risks
CREATE TABLE IF NOT EXISTS automation_risk(
  noc_code CHAR(4),
  automation_risk DECIMAL(4,3),
  FOREIGN KEY (noc_code)
    REFERENCES noc_uniques (noc_code)
    ON DELETE CASCADE
);

-- Table 24 - Wages & opening for apprenticeships by NOC
CREATE TABLE IF NOT EXISTS apprentice_noc_wages_openings(
  id INT PRIMARY KEY AUTO_INCREMENT,
  noc_code CHAR(4),
  year YEAR(4),
  avg_hourly_wage DECIMAL(6,3),
  vacancies DECIMAL(10,3),
  FOREIGN KEY (noc_code)
    REFERENCES noc_uniques (noc_code)
    ON DELETE CASCADE
);


-- Trades have different classification codes from NOC; need to detail & link
-- table needs to be created from OCTAA data subset
CREATE TABLE IF NOT EXISTS trades_primary (
  trade_code CHAR(4) PRIMARY KEY,
  noc_code CHAR(4),
  trade_name_en CHAR(100),
  trade_name_fr CHAR(100),
  sector CHAR(25),
  classification CHAR(1),
  exam_reqd TINYINT
);

-- One of the provided tables; in group 7
-- CREATE TABLE octaa (
--   trade_code CHAR(4) PRIMARY KEY,
--
-- );