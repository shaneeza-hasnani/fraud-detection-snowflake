-- =============================================
-- 01_setup.sql
-- Creates the database and schema structure
-- =============================================

CREATE DATABASE fraud_project;
USE DATABASE fraud_project;

-- three-layer architecture: raw > staging > mart
CREATE SCHEMA raw;
CREATE SCHEMA staging;
CREATE SCHEMA mart;
