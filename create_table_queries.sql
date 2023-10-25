CREATE TABLE Insurance ( 
  id RAW(16) PRIMARY KEY, 
  policy_type VARCHAR2(100) NOT NULL, 
  provider VARCHAR2(100) NOT NULL, 
  claim_percentage INTEGER NOT NULL 
  CONSTRAINT invalid_claim_percentage CHECK  (claim_percentage BETWEEN 0 AND 100) 
);

CREATE TABLE Address ( 
  id RAW(16) PRIMARY KEY, 
  building_name VARCHAR2(100) NOT NULL, 
  street VARCHAR2(100) NOT NULL, 
  city VARCHAR2(100) NOT NULL, 
  state CHAR(2) NOT NULL, 
  country VARCHAR2(50) NOT NULL, 
  zip CHAR(5) NOT NULL 
);

CREATE TABLE Allergy ( 
    id RAW(16) PRIMARY KEY, 
    description VARCHAR2(255) NOT NULL 
);

CREATE TABLE Vaccination ( 
    id RAW(16) PRIMARY KEY, 
    name VARCHAR2(100) NOT NULL, 
    number_of_doses INTEGER NOT NULL, 
    strength_of_dose VARCHAR2(10) NOT NULL, 
    prescription_needed CHAR(1) NOT NULL CONSTRAINT invalid_prescription_needed CHECK (prescription_needed IN ('Y', 'N')) 
);

CREATE TABLE Drug_Inventory ( 
  ndc_code RAW(16) PRIMARY KEY, 
  name VARCHAR2(100) NOT NULL, 
  manufacturer VARCHAR2(100) NOT NULL, 
  strength VARCHAR2(10) NOT NULL, 
  expiry_date TIMESTAMP NOT NULL, 
  cost NUMBER(8,2) NOT NULL, 
  category VARCHAR2(11) NOT NULL CONSTRAINT invalid_category CHECK (category IN ('Medication', 'Vaccination')), 
  location_aisle VARCHAR2(10) NOT NULL, 
  drug_type VARCHAR2(20) NOT NULL CONSTRAINT invalid_drug_inventory_drug_type CHECK (drug_type IN ('Tablet', 'Syrup', 'Injection')), 
  number_of_available_units INTEGER NOT NULL, 
  address_id RAW(16) NOT NULL UNIQUE, 
  FOREIGN KEY (address_id) REFERENCES Address (id) 
);

CREATE TABLE Patient ( 
  id RAW(16) PRIMARY KEY, 
  first_name VARCHAR2(100) NOT NULL, 
  last_name VARCHAR2(100) NOT NULL, 
  age NUMBER NOT NULL constraint invalid_age CHECK (age > 0), 
  phone_number VARCHAR2(20) NOT NULL UNIQUE  constraint invalid_patient_phone_number CHECK (REGEXP_LIKE(phone_number, '^\(\d{3}\) \d{3}-\d{4}$')), 
  email VARCHAR2(255) NOT NULL constraint invalid_patient_email CHECK  (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')), 
  gender CHAR(1) NOT NULL constraint invalid_patient_gender CHECK  (gender IN ('M', 'F', 'O')), 
  national_identification_number VARCHAR2(9) NOT NULL UNIQUE, 
  address_id RAW(16) NOT NULL, 
  FOREIGN KEY (address_id) REFERENCES Address(id) 
);

CREATE TABLE Clinic ( 
  id RAW(16) PRIMARY KEY, 
  name Varchar2(100) NOT NULL,
  phone_number VARCHAR2(20) NOT NULL UNIQUE CONSTRAINT invalid_clinic_phone_number CHECK (REGEXP_LIKE(phone_number, '^\(\d{3}\) \d{3}-\d{4}$')), 
  email VARCHAR2(255) NOT NULL UNIQUE CONSTRAINT invalid_clinic_email CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')), 
  website VARCHAR2(255) NOT NULL UNIQUE, 
  address_id RAW(16) NOT NULL UNIQUE, 
  FOREIGN KEY (address_id) REFERENCES Address(id) 
);

CREATE TABLE Doctor ( 
  id RAW(16) PRIMARY KEY, 
  first_name VARCHAR2(100) NOT NULL, 
  last_name VARCHAR2(100) NOT NULL, 
  age NUMBER NOT NULL constraint invalid_doctor_age check (age > 21), 
  phone_number VARCHAR2(20) NOT NULL UNIQUE constraint invalid_doctor_phone_number check (REGEXP_LIKE(phone_number, '^\(\d{3}\) \d{3}-\d{4}$')), 
  email VARCHAR2(255) NOT NULL UNIQUE constraint invalid_doctor_email check  (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')), 
  gender CHAR(1) NOT NULL constraint invalid_doctor_gender check (gender IN ('M', 'F', 'O')), 
  ssn CHAR(9) NOT NULL, 
  profession_start_date TIMESTAMP NOT NULL, 
  speciality VARCHAR2(100) NOT NULL, 
  address_id RAW(16) NOT NULL, 
  FOREIGN KEY (address_id) REFERENCES Address(id) 
);

CREATE TABLE Patient_Health_History ( 
  id RAW(16) PRIMARY KEY, 
  description VARCHAR2(255) NOT NULL, 
  patient_id RAW(16) NOT NULL, 
  FOREIGN KEY (patient_id) REFERENCES Patient(id) 
);

CREATE TABLE Pharmacy ( 
  id RAW(16) PRIMARY KEY, 
  business_hours VARCHAR2(20) NOT NULL, 
  phone_number VARCHAR2(20) NOT NULL UNIQUE constraint invalid_pharmacy_phone_number CHECK (REGEXP_LIKE(phone_number, '^\(\d{3}\) \d{3}-\d{4}$')) , 
  website VARCHAR2(255) NOT NULL UNIQUE, 
  email VARCHAR2(255) NOT NULL UNIQUE Constraint invalid_pharmacy_email CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')) , 
  address_id RAW(16) NOT NULL UNIQUE, 
  manager_id RAW(16) UNIQUE, 
  FOREIGN KEY (address_id) REFERENCES Address(id)  
);

CREATE TABLE Employee ( 
  id RAW(16) PRIMARY KEY, 
  first_name VARCHAR2(100) NOT NULL, 
  last_name VARCHAR2(100) NOT NULL, 
  d_o_b TIMESTAMP NOT NULL, 
  ssn CHAR(9) NOT NULL UNIQUE, 
  phone_number VARCHAR2(20) NOT NULL UNIQUE  CONSTRAINT invalid_employee_phone_number CHECK (REGEXP_LIKE(phone_number, '^\(\d{3}\) \d{3}-\d{4}$')), 
  email VARCHAR2(255) NOT NULL UNIQUE CONSTRAINT invalid_employee_email CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')), 
  pharmacy_id RAW(16) NOT NULL, 
  FOREIGN KEY (pharmacy_id) REFERENCES Pharmacy (id), 
  address_id RAW(16) NOT NULL, 
  FOREIGN KEY (address_id) REFERENCES Address (id) 
);

ALTER TABLE Pharmacy ADD FOREIGN KEY (manager_id) REFERENCES Employee(id);

CREATE TABLE Prescription ( 
  id RAW(16) PRIMARY KEY, 
  prescription_date TIMESTAMP NOT NULL, 
  follow_up_date TIMESTAMP NOT NULL, 
  advice VARCHAR2(255), 
  extra_notes VARCHAR2(255), 
  patient_id RAW(16) NOT NULL, 
  pharmacy_id RAW(16) NOT NULL, 
  clinic_id RAW(16) NOT NULL, 
  doctor_id RAW(16) NOT NULL, 
  FOREIGN KEY (patient_id) REFERENCES Patient(id), 
  FOREIGN KEY (pharmacy_id) REFERENCES Pharmacy(id), 
  FOREIGN KEY (clinic_id) REFERENCES Clinic(id), 
  FOREIGN KEY (doctor_id) REFERENCES Doctor(id) 
);

CREATE TABLE Complaint ( 
    id RAW(16) PRIMARY KEY, 
    prescription_id RAW(16) NOT NULL, 
    description VARCHAR2(255) NOT NULL, 
    FOREIGN KEY (prescription_id) REFERENCES Prescription(id) 
);

CREATE TABLE Medicine ( 
    id RAW(16) PRIMARY KEY, 
    name VARCHAR2(100) NOT NULL, 
    strength VARCHAR2(10) NOT NULL, 
    duration VARCHAR2(50) NOT NULL, 
    dosage VARCHAR2(100) NOT NULL, 
    drug_type VARCHAR2(20) NOT NULL CONSTRAINT invalid_drug_type CHECK (drug_type IN ('Tablet', 'Syrup', 'Injection')), 
    number_of_refills INTEGER NOT NULL, 
    route VARCHAR2(12) NOT NULL  CONSTRAINT invalid_route CHECK (route IN ('Oral', 'Nasal', 'Intravenous', 'Intramuscular')), 
    purpose VARCHAR2(255) NOT NULL, 
    prescription_id RAW(16) NOT NULL, 
    FOREIGN KEY (prescription_id) REFERENCES Prescription(id) 
);

CREATE TABLE Bill ( 
  id RAW(16) PRIMARY KEY, 
  bill_date TIMESTAMP NOT NULL, 
  mode_of_payment CHAR(4) NOT NULL constraint invalid_mode_of_payment CHECK (mode_of_payment IN ('CARD', 'CASH')), 
  insurance_id RAW(16) NOT NULL, 
  patient_id RAW(16) NOT NULL, 
  prescription_id RAW(16) NOT NULL, 
  employee_id RAW(16) NOT NULL, 
  FOREIGN KEY (insurance_id) REFERENCES Insurance(id), 
  FOREIGN KEY (patient_id) REFERENCES Patient(id), 
  FOREIGN KEY (prescription_id) REFERENCES Prescription(id), 
  FOREIGN KEY (employee_id) REFERENCES Employee(id) 
);

CREATE TABLE Employee_Payroll (   
  id RAW(16) PRIMARY KEY,   
  total_hours_worked NUMBER NOT NULL,   
  start_date TIMESTAMP NOT NULL,   
  end_date TIMESTAMP NOT NULL ,   
  gross_pay NUMBER(8,2) NOT NULL,   
  tax_deduction_percentage INTEGER NOT NULL CONSTRAINT invalid_tax_deduction_percentage CHECK (tax_deduction_percentage BETWEEN 0 AND 100),    
  bonus NUMBER(8,2) NOT NULL,   
  employee_id RAW(16) NOT NULL, 
  FOREIGN KEY (employee_id) REFERENCES Employee(id),
  CONSTRAINT invalid_start_or_end_date CHECK (start_date < end_date) 
);

CREATE TABLE Doctor_Clinic (
    doctor_id RAW(16) NOT NULL,
    clinic_id RAW(16) NOT NULL, 
    doctor_availability VARCHAR2(20) NOT NULL,
    PRIMARY KEY (doctor_id, clinic_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(id),
    FOREIGN KEY (clinic_id) REFERENCES Clinic(id)
);

CREATE TABLE Billed_Drugs (
    bill_id RAW(16) NOT NULL,
    ndc_code RAW(16) NOT NULL,
    quantity INTEGER NOT NULL,
    PRIMARY KEY (bill_id, ndc_code),
    FOREIGN KEY (bill_id) REFERENCES Bill(id),
    FOREIGN KEY (ndc_code) REFERENCES Drug_Inventory(ndc_code)
);

CREATE TABLE Patient_Doctor (
    patient_id RAW(16) NOT NULL,
    doctor_id RAW(16) NOT NULL,
    PRIMARY KEY (patient_id, doctor_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(id)
);

CREATE TABLE Vaccination_Patient (
    vaccination_id RAW(16) NOT NULL ,
    patient_id RAW(16) NOT NULL ,
    dose_number INTEGER NOT NULL,
    vaccine_date TIMESTAMP NOT NULL,
    PRIMARY KEY (vaccination_id, patient_id),
    FOREIGN KEY (vaccination_id) REFERENCES Vaccination(id),
    FOREIGN KEY (patient_id) REFERENCES Patient(id)
);

CREATE TABLE Patient_Allergy (
    patient_id RAW(16) NOT NULL,
    allergy_id RAW(16) NOT NULL ,
   PRIMARY KEY(patient_id , allergy_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(id),
   FOREIGN KEY (allergy_id) REFERENCES Allergy(id)
);

CREATE TABLE Patient_Insurance (
    patient_id RAW(16) NOT NULL ,
    insurance_id RAW(16) NOT NULL ,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    status CHAR(8) NOT NULL,
    PRIMARY KEY(patient_id, insurance_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(id),
    FOREIGN KEY (insurance_id) REFERENCES Insurance(id),
    Constraint invalid_status check (status IN ('ACTIVE', 'INACTIVE')),
    Constraint invalid_patient_insurance_dates check (start_date < end_date)
);