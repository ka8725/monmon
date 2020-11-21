# Monmon

## Use
---

Run tests: `ruby -I lib test/process_test.rb`

Ruby CLI: `./bin/cli`

Use to run with database: `./bin/cli -a DB`

Use to run with CSV file: `./bin/cli -a CSV`

Use to change main currency. Where main currency is global standard ISO 4217: `./bin/cli -m USD`

## How DATABASE_URL should be specified
---

URI is formed as follows:
    `postgresql://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]`
For examples:
    `postgresql://`
    `postgresql://localhost`
    `postgresql://localhost:5432`
    `postgresql://localhost/mydb`
    `postgresql://user@localhost`
    `postgresql://user:secret@localhost`
    `postgresql://other@localhost/otherdb?connect_timeout=10&application_name=myapp`
    `postgresql://localhost/mydb?user=other&password=secret`

## Create DataBase
---
Run this command in your terminal to create database: `psql commands.sql`
